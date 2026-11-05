<?php

namespace App\Services;

use App\Models\Attendance;
use App\Models\AttendanceRequest;
use App\Models\AuditLog;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class RequestService
{
    private function fail(string $message): never
    {
        throw ValidationException::withMessages(['request' => $message]);
    }

    public function submit(User $user, array $data): AttendanceRequest
    {
        return DB::transaction(function () use ($user, $data) {
            User::whereKey($user->id)->lockForUpdate()->firstOrFail();
            $start = Carbon::parse($data['start_date']);
            $end = Carbon::parse($data['end_date'] ?? $data['start_date']);
            if (! $user->internship_start || ! $user->internship_end || $start->lt($user->internship_start) || $end->gt($user->internship_end)) {
                $this->fail('Tanggal harus berada dalam masa magangmu.');
            }
            $type = $data['type'];
            if (in_array($type, ['manual', 'correction'])) {
                if (! $start->isSameDay($end) || $start->isFuture()) {
                    $this->fail('Koreksi dan absensi manual hanya untuk satu tanggal yang sudah berlangsung.');
                }
                $this->validateTimes($start->toDateString(), $data['clock_in'] ?? null, $data['clock_out'] ?? null);
                $record = $user->attendances()->whereDate('date', $start)->first();
                if ($type === 'correction' && ! $record) {
                    $this->fail('Belum ada absensi pada tanggal ini. Pilih pengajuan absensi manual.');
                }
                if ($type === 'manual' && $record) {
                    $this->fail('Absensi sudah ada. Pilih pengajuan koreksi.');
                }
            } elseif ($user->attendances()->whereBetween('date', [$start->toDateString(), $end->toDateString()])->exists()) {
                $this->fail('Rentang izin/sakit bertabrakan dengan catatan kehadiran.');
            }
            if (AttendanceRequest::where('user_id', $user->id)->whereIn('status', ['pending', 'approved'])->where('start_date', '<=', $end->toDateString())->where('end_date', '>=', $start->toDateString())->where(function ($q) use ($type) {
                if (in_array($type, ['leave', 'sick'])) {
                    $q->whereIn('type', ['leave', 'sick', 'manual', 'correction']);
                } else {
                    $q->where(fn ($q) => $q->whereIn('type', ['leave', 'sick'])->orWhere('status', 'pending'));
                }
            })->exists()) {
                $this->fail('Sudah ada pengajuan aktif pada tanggal tersebut.');
            }
            $record = AttendanceRequest::create(['user_id' => $user->id, 'type' => $type, 'start_date' => $start, 'end_date' => $end, 'reason' => $data['reason'], 'payload' => in_array($type, ['manual', 'correction']) ? ['clock_in' => $data['clock_in'], 'clock_out' => $data['clock_out'], 'work_note' => $data['work_note'] ?? null] : null]);
            AuditLog::record('Pengajuan dibuat', $record, null, $record->only(['type', 'start_date', 'end_date', 'reason']));

            return $record;
        });
    }

    public function review(AttendanceRequest $request, User $admin, string $decision, string $note): void
    {
        DB::transaction(function () use ($request, $admin, $decision, $note) {
            $user = User::whereKey($request->user_id)->lockForUpdate()->firstOrFail();
            $request = AttendanceRequest::whereKey($request->id)->lockForUpdate()->firstOrFail();
            if ($request->status !== 'pending') {
                $this->fail('Pengajuan ini sudah diputuskan. Muat ulang halaman.');
            }
            if ($decision === 'approved') {
                if (in_array($request->type, ['leave', 'sick'])) {
                    if (Attendance::where('user_id', $user->id)->whereBetween('date', [$request->start_date, $request->end_date])->exists()) {
                        $this->fail('Tidak dapat menyetujui izin karena sudah ada kehadiran pada rentang ini.');
                    }
                } else {
                    $date = $request->start_date->toDateString();
                    $this->validateTimes($date, $request->payload['clock_in'], $request->payload['clock_out']);
                    $attendance = Attendance::where('user_id', $user->id)->whereDate('date', $date)->lockForUpdate()->first();
                    if ($request->type === 'manual' && $attendance) {
                        $this->fail('Absensi sudah dibuat. Pengajuan manual tidak dapat menimpanya.');
                    }
                    if ($request->type === 'correction' && ! $attendance) {
                        $this->fail('Catatan yang akan dikoreksi tidak tersedia.');
                    }
                    if (AttendanceRequest::where('user_id', $user->id)->whereIn('type', ['leave', 'sick'])->where('status', 'approved')->where('start_date', '<=', $date)->where('end_date', '>=', $date)->exists()) {
                        $this->fail('Tanggal ini sudah tercatat izin/sakit.');
                    }
                    $before = $attendance?->only(['clock_in', 'clock_out', 'work_note', 'manual']);
                    if (! $attendance) {
                        $schedule = app(ScheduleService::class)->for($user, $date);
                        if (! $schedule['is_workday']) {
                            $this->fail('Tanggal ini tidak terjadwal kerja. Atur pengecualian jadwal sebelum mencatat kehadiran.');
                        }
                        $attendance = new Attendance(['user_id' => $user->id, 'date' => $date, 'mode' => $schedule['mode'], 'schedule_snapshot' => $schedule, 'manual' => true]);
                    }
                    $attendance->clock_in = Carbon::parse($date.' '.$request->payload['clock_in']);
                    $attendance->clock_out = Carbon::parse($date.' '.$request->payload['clock_out']);
                    if (! empty($request->payload['work_note'])) {
                        $attendance->work_note = $request->payload['work_note'];
                    }
                    $attendance->save();
                    AuditLog::record('Koreksi absensi disetujui', $attendance, $before, $attendance->only(['clock_in', 'clock_out', 'work_note', 'manual']));
                }
            }
            $request->update(['status' => $decision, 'review_note' => $note, 'reviewed_by' => $admin->id, 'reviewed_at' => now()]);
            AuditLog::record($decision === 'approved' ? 'Pengajuan disetujui' : 'Pengajuan ditolak', $request, ['status' => 'pending'], ['status' => $decision, 'review_note' => $note]);
        });
    }

    private function validateTimes(string $date, ?string $in, ?string $out): void
    {
        if (! $in || ! $out) {
            $this->fail('Isi usulan waktu masuk dan pulang.');
        }
        $start = Carbon::parse($date.' '.$in);
        $end = Carbon::parse($date.' '.$out);
        if ($end->lte($start)) {
            $this->fail('Waktu pulang harus setelah waktu masuk pada hari yang sama.');
        }
        if ($end->gt(now()) || $start->gt(now())) {
            $this->fail('Usulan waktu tidak boleh berada di masa depan.');
        }
    }
}
