<?php

namespace App\Support;

use App\Models\AuditLog;
use Carbon\Carbon;

class AuditPresentation
{
    public static function changes(AuditLog $log): array
    {
        $before = $log->before ?? [];
        $after = $log->after ?? [];
        $labels = [
            'clock_in' => 'Waktu masuk', 'clock_out' => 'Waktu pulang', 'mode' => 'Mode kerja',
            'work_note' => 'Catatan pekerjaan', 'manual' => 'Pencatatan manual',
            'photo_flagged' => 'Pemeriksaan foto', 'photo_flag_reason' => 'Catatan admin',
            'message' => 'Penjelasan peserta', 'reason' => 'Keterangan', 'review_note' => 'Alasan keputusan',
            'status' => 'Status', 'type' => 'Jenis pengajuan', 'start_date' => 'Tanggal mulai',
            'end_date' => 'Tanggal selesai', 'name' => 'Nama', 'email' => 'Email',
            'department' => 'Divisi', 'is_active' => 'Status akun', 'internship_start' => 'Mulai magang',
            'internship_end' => 'Selesai magang', 'workdays' => 'Hari kerja', 'start_time' => 'Jam mulai',
            'end_time' => 'Jam selesai', 'grace_minutes' => 'Toleransi terlambat', 'default_mode' => 'Mode kerja',
            'national_holidays_off' => 'Libur nasional', 'collective_leave_off' => 'Cuti bersama',
            'date' => 'Tanggal', 'is_workday' => 'Jadwal hari ini', 'has_photo' => 'Foto profil',
            'year' => 'Tahun kalender', 'count' => 'Jumlah hari libur', 'responses' => 'Tanggapan admin',
        ];
        $rows = [];
        foreach ($labels as $key => $label) {
            if (!array_key_exists($key, $after) && !array_key_exists($key, $before)) continue;
            if (array_key_exists($key, $before) && array_key_exists($key, $after) && $before[$key] === $after[$key]) continue;
            $rows[] = ['label' => $label, 'before' => array_key_exists($key, $before) ? self::value($key, $before[$key]) : null, 'after' => self::value($key, $after[$key] ?? null)];
        }
        foreach (['in_photo' => 'Foto clock-in', 'out_photo' => 'Foto clock-out'] as $key => $label) {
            if (array_key_exists($key, $after) && ($before[$key] ?? null) !== $after[$key]) {
                $rows[] = ['label' => $label, 'before' => null, 'after' => $after[$key] ? 'Foto diperbarui' : 'Foto dihapus'];
            }
        }
        return $rows;
    }

    private static function value(string $key, mixed $value): string
    {
        if ($value === null || $value === '') return 'Belum diisi';
        if ($key === 'responses') {
            $last = is_array($value) ? end($value) : null;
            return is_array($last) ? (string) ($last['message'] ?? 'Tanggapan tersimpan') : 'Belum ada tanggapan';
        }
        if ($key === 'workdays' && is_array($value)) {
            $days = [1 => 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
            return implode(', ', array_map(fn ($day) => $days[(int) $day] ?? '', $value));
        }
        if (in_array($key, ['clock_in', 'clock_out', 'start_date', 'end_date', 'internship_start', 'internship_end', 'date'])) {
            try { return Carbon::parse($value)->timezone('Asia/Jakarta')->translatedFormat(in_array($key, ['clock_in', 'clock_out']) ? 'd M Y, H:i \W\I\B' : 'd M Y'); }
            catch (\Throwable) { return 'Tanggal tidak tersedia'; }
        }
        $boolean = [
            'photo_flagged' => ['Tanpa tanda klarifikasi', 'Perlu klarifikasi'], 'is_active' => ['Nonaktif', 'Aktif'],
            'manual' => ['Tidak', 'Ya'], 'is_workday' => ['Libur', 'Masuk'],
            'national_holidays_off' => ['Tetap masuk', 'Libur'], 'collective_leave_off' => ['Tetap masuk', 'Libur'],
            'has_photo' => ['Belum ada foto', 'Foto tersedia'],
        ];
        if (isset($boolean[$key])) return $boolean[$key][(int) (bool) $value];
        if ($key === 'status') return ['pending'=>'Menunggu keputusan','approved'=>'Disetujui','rejected'=>'Ditolak','open'=>'Terbuka','in_progress'=>'Sedang ditangani','resolved'=>'Selesai'][$value] ?? 'Status diperbarui';
        if ($key === 'type') return ['leave'=>'Izin','sick'=>'Sakit','correction'=>'Koreksi absensi','manual'=>'Absensi manual'][$value] ?? 'Pengajuan absensi';
        if ($key === 'grace_minutes') return $value.' menit';
        return is_scalar($value) ? (string) $value : 'Data diperbarui';
    }
}
