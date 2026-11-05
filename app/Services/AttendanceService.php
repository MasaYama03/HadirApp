<?php

namespace App\Services;

use App\Models\Attendance;
use App\Models\AttendanceRequest;
use App\Models\AuditLog;
use App\Models\SupportTicket;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class AttendanceService
{
    public function __construct(private ScheduleService $schedules) {}

    public function clockIn(User $user, UploadedFile $photo): Attendance
    {
        $path = null;
        try {
            return DB::transaction(function () use ($user, $photo, &$path) {
                $user = User::whereKey($user->id)->lockForUpdate()->firstOrFail();
                $this->eligible($user);
                $date = today()->toDateString();
                if ($user->attendances()->whereDate('date', $date)->exists()) {
                    $this->fail('Kamu sudah clock-in hari ini.');
                }
                if ($user->attendances()->whereNull('clock_out')->exists()) {
                    $this->fail('Selesaikan koreksi absensi sebelumnya sebelum clock-in kembali.');
                }
                $schedule = $this->schedules->for($user, $date);
                if (! $schedule['is_workday']) {
                    $this->fail('Hari ini tidak ada jadwal kerja. Hubungi admin jika ada penugasan.');
                }
                if (AttendanceRequest::where('user_id', $user->id)->whereIn('type', ['leave', 'sick'])->where('status', 'approved')->where('start_date', '<=', $date)->where('end_date', '>=', $date)->exists()) {
                    $this->fail('Hari ini tercatat izin/sakit. Hubungi admin sebelum melakukan absensi.');
                }
                $path = $this->savePhoto($photo, $user->id);
                $record = Attendance::create(['user_id' => $user->id, 'date' => $date, 'clock_in' => now(), 'in_photo' => $path, 'mode' => $schedule['mode'], 'schedule_snapshot' => $schedule]);
                AuditLog::record('Clock-in', $record, null, ['clock_in' => $record->clock_in->toDateTimeString(), 'mode' => $record->mode]);

                return $record;
            });
        } catch (\Throwable $e) {
            if ($path) {
                Storage::disk('local')->delete($path);
            } throw $e;
        }
    }

    public function clockOut(User $user, UploadedFile $photo, array $data): Attendance
    {
        $path = null;
        try {
            return DB::transaction(function () use ($user, $photo, $data, &$path) {
                User::whereKey($user->id)->lockForUpdate()->firstOrFail();
                $this->eligible($user);
                $record = Attendance::where('user_id', $user->id)->whereDate('date', today())->lockForUpdate()->first();
                if (! $record) {
                    $this->fail('Lakukan clock-in terlebih dahulu. Untuk tanggal sebelumnya, ajukan koreksi.');
                }
                if ($record->clock_out) {
                    $this->fail('Clock-out hari ini sudah tersimpan.');
                }
                $before = $record->only(['clock_in', 'clock_out', 'work_note']);
                $path = $this->savePhoto($photo, $user->id);
                $record->update(['clock_out' => now(), 'out_photo' => $path, 'work_note' => $data['work_note'], 'work_status' => $data['work_status']]);
                if (! empty($data['need_help'])) {
                    SupportTicket::create(['user_id' => $user->id, 'attendance_id' => $record->id, 'message' => $data['help_message'], 'status' => 'open', 'responses' => []]);
                }
                AuditLog::record('Clock-out', $record, $before, $record->only(['clock_in', 'clock_out', 'work_note']));

                return $record;
            });
        } catch (\Throwable $e) {
            if ($path) {
                Storage::disk('local')->delete($path);
            } throw $e;
        }
    }

    private function eligible(User $user): void
    {
        if (! $user->is_active || $user->role !== 'intern') {
            $this->fail('Akun tidak dapat melakukan absensi.');
        }
    }

    private function fail(string $message): never
    {
        throw ValidationException::withMessages(['attendance' => $message]);
    }

    private function savePhoto(UploadedFile $photo, int $userId): string
    {
        $dimensions = @getimagesize($photo->getRealPath());
        if (! $dimensions || $dimensions[0] * $dimensions[1] > 18000000) {
            $this->fail('Ukuran foto terlalu besar. Gunakan selfie maksimal 18 megapiksel.');
        }
        $image = @imagecreatefromstring(file_get_contents($photo->getRealPath()));
        if (! $image) {
            $this->fail('Foto tidak dapat dibaca. Ambil selfie kembali.');
        }
        $width = imagesx($image);
        $height = imagesy($image);
        if ($width < 120 || $height < 120 || $width * $height > 18000000) {
            imagedestroy($image);
            $this->fail('Gunakan foto yang jelas, minimal 120 × 120 piksel dan maksimal 18 megapiksel.');
        }
        $scale = min(1, 960 / max($width, $height));
        $resized = imagecreatetruecolor((int) ($width * $scale), (int) ($height * $scale));
        imagecopyresampled($resized, $image, 0, 0, 0, 0, imagesx($resized), imagesy($resized), $width, $height);
        ob_start();
        imagejpeg($resized, null, 82);
        $bytes = ob_get_clean();
        imagedestroy($image);
        imagedestroy($resized);
        $path = 'selfies/'.$userId.'/'.Str::uuid().'.jpg';
        if (! Storage::disk('local')->put($path,$bytes)) {
            $this->fail('Foto belum berhasil disimpan. Silakan coba lagi.');
        }

        return $path;
    }
}
