<?php

namespace Database\Seeders;

use App\Models\Attendance;
use App\Models\AttendanceRequest;
use App\Models\SupportTicket;
use App\Models\User;
use App\Models\WorkSetting;
use App\Services\HolidayService;
use App\Services\ScheduleService;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        WorkSetting::current();
        app(HolidayService::class)->import(2026);
        app(HolidayService::class)->import(2027);
        $admin = User::firstOrCreate(['email' => 'admin.hadir@gmail.com'], ['name' => 'Aditya Pratama', 'role' => 'admin', 'department' => 'People & Culture', 'position' => 'Internship Administrator', 'password' => Hash::make('Detikcom98'), 'email_verified_at' => now(), 'is_active' => true]);
        $names = ['Masahiro Gerarudo Yamazaki', 'Raka Mahendra', 'Alya Safitri', 'Dimas Prakoso', 'Salsabila Zahra', 'Fajar Ramadhan', 'Tiara Anindya', 'Rizky Saputra', 'Nadia Maharani', 'Bagas Wiratama', 'Citra Lestari', 'Ardiansyah Putra'];
        $departments = ['Technology', 'Editorial', 'Product & Design', 'Technology', 'People & Culture', 'Editorial', 'Product & Design', 'Technology', 'Marketing', 'Marketing', 'Editorial', 'Technology'];
        $positions = ['Full Stack Developer Intern', 'Content Writer Intern', 'UI/UX Designer Intern', 'Backend Developer Intern', 'People Operations Intern', 'Reporter Intern', 'Product Designer Intern', 'Frontend Developer Intern', 'Digital Marketing Intern', 'Social Media Intern', 'Editor Intern', 'QA Engineer Intern'];
        foreach ($names as $index => $name) {
            $user = User::firstOrCreate(['email' => $index === 0 ? 'peserta.hadir@gmail.com' : strtolower(explode(' ', $name)[0]).'.hadir@gmail.com'], ['name' => $name, 'role' => 'intern', 'employee_code' => 'INT-2026-'.str_pad($index + 1, 3, '0', STR_PAD_LEFT), 'department' => $departments[$index], 'position' => $positions[$index], 'password' => Hash::make($index === 0 ? 'Detikcom98' : 'HadirPeserta!2026'), 'internship_start' => today()->startOfMonth()->subMonth()->toDateString(), 'internship_end' => today()->addMonths(3)->endOfMonth()->toDateString(), 'email_verified_at' => now(), 'is_active' => true]);
            $photo = $this->demoPhoto($user);
            $outPhoto = $photo;
            if ($index === 0) {
                foreach (['in', 'out'] as $kind) {
                    $source = database_path('seeders/fixtures/masahiro-clock-'.$kind.'.jpg');
                    if (is_file($source)) {
                        $path = 'demo/masahiro/'.$kind.'-'.substr(hash_file('sha256', $source), 0, 12).'.jpg';
                        if (! Storage::disk('local')->exists($path)) {
                            Storage::disk('local')->put($path, file_get_contents($source));
                        }
                        if ($kind === 'in') {
                            $photo = $path;
                        } else {
                            $outPhoto = $path;
                        }
                    }
                }
            }
            $schedules = app(ScheduleService::class);
            for ($offset = 15; $offset >= 1; $offset--) {
                $day = today()->subDays($offset);
                $date = $day->toDateString();
                $schedule = $schedules->for($user, $date);
                if (! $schedule['is_workday']) {
                    continue;
                }
                $variant = ($index + $offset) % 13;
                if (in_array($variant, [8, 9])) {
                    AttendanceRequest::firstOrCreate(['user_id' => $user->id, 'type' => $variant === 8 ? 'leave' : 'sick', 'start_date' => $date, 'end_date' => $date], ['reason' => $variant === 8 ? 'Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.' : 'Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.', 'status' => 'approved', 'review_note' => 'Pengajuan sudah dikonfirmasi dengan pembimbing.', 'reviewed_by' => $admin->id, 'reviewed_at' => $day->copy()->setTime(8, 0)]);

                    continue;
                }
                if ($variant === 10) {
                    continue;
                }
                $in = $day->copy()->setTime(8, ($index + $offset) % 4 === 0 ? 25 : 3);
                $record = Attendance::firstOrCreate(['user_id' => $user->id, 'date' => $date], ['clock_in' => $in, 'clock_out' => $day->copy()->setTime(17, 5), 'in_photo' => $photo, 'out_photo' => $outPhoto, 'mode' => $index % 3 === 0 ? 'WFH' : 'WFO', 'schedule_snapshot' => array_merge($schedule, ['mode' => $index % 3 === 0 ? 'WFH' : 'WFO']), 'work_note' => ['Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.', 'Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.', 'Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.'][$index % 3], 'work_status' => $index % 2 === 0 ? 'done' : 'ongoing']);
                if ($offset === 1 && $index === 3 && $record->wasRecentlyCreated) {
                    $record->update(['clock_out' => null, 'out_photo' => null, 'work_note' => null, 'work_status' => null]);
                    AttendanceRequest::firstOrCreate(['user_id' => $user->id, 'type' => 'correction', 'start_date' => $date, 'end_date' => $date], ['reason' => 'Lupa clock-out setelah menyelesaikan pengujian pukul 17.05. Mohon koreksi waktu pulang.', 'payload' => ['clock_in' => $in->format('H:i'), 'clock_out' => '17:05', 'work_note' => 'Menyelesaikan pengujian integrasi dan mendokumentasikan hasilnya.'], 'status' => 'pending']);
                }
            }
            $date = today()->toDateString();
            $schedule = $schedules->for($user, $date);
            if (! $schedule['is_workday'] || $index === 0 || $index >= 10) {
                continue;
            }
            if (in_array($index, [6, 7, 8])) {
                AttendanceRequest::firstOrCreate(['user_id' => $user->id, 'type' => $index === 7 ? 'sick' : 'leave', 'start_date' => $date, 'end_date' => $date], ['reason' => $index === 7 ? 'Demam dan perlu beristirahat sesuai arahan pemeriksaan kesehatan.' : 'Mengikuti kegiatan akademik kampus yang berlangsung pada hari kerja.', 'status' => $index === 8 ? 'pending' : 'approved', 'review_note' => $index === 8 ? null : 'Pengajuan sudah dikonfirmasi. Silakan beristirahat atau mengikuti agenda kampus.', 'reviewed_by' => $index === 8 ? null : $admin->id, 'reviewed_at' => $index === 8 ? null : now()]);

                continue;
            }
            $in = today()->setTime(8, $index === 4 ? 27 : 3);
            if ($in->gt(now())) {
                continue;
            }
            $out = now()->gt(today()->setTime(17, 5)) && $index <= 3 ? today()->setTime(17, 5) : null;
            $record = Attendance::firstOrCreate(['user_id' => $user->id, 'date' => $date], ['clock_in' => $in, 'clock_out' => $out, 'in_photo' => $photo, 'out_photo' => $out ? $outPhoto : null, 'mode' => $index % 3 === 0 ? 'WFH' : 'WFO', 'schedule_snapshot' => array_merge($schedule, ['mode' => $index % 3 === 0 ? 'WFH' : 'WFO']), 'work_note' => $out ? 'Menyelesaikan bagian pekerjaan hari ini dan menyiapkan catatan untuk review pembimbing.' : null, 'work_status' => $out ? 'ongoing' : null]);
            if ($index === 2 && $out) {
                SupportTicket::firstOrCreate(['attendance_id' => $record->id], ['user_id' => $user->id, 'message' => 'Butuh akses file desain utama agar komponen dapat disesuaikan dengan pembaruan terbaru.', 'status' => 'open', 'responses' => []]);
            }
        }
    }

    private function demoPhoto(User $user): string
    {
        $path = 'demo/'.$user->id.'.jpg';
        if (Storage::disk('local')->exists($path)) {
            return $path;
        }
        $image = imagecreatetruecolor(640, 480);
        $bg = imagecolorallocate($image, 233, 239, 251);
        $blue = imagecolorallocate($image, 98, 126, 183);
        $ink = imagecolorallocate($image, 33, 64, 154);
        imagefill($image, 0, 0, $bg);
        imagefilledellipse($image, 320, 195, 115, 125, $blue);
        imagefilledellipse($image, 320, 380, 270, 225, $blue);
        imagestring($image, 5, 24, 23, 'BUKTI CONTOH - DATA DEMO', $ink);
        imagestring($image, 4, 24, 443, strtoupper($user->name), $ink);
        ob_start();
        imagejpeg($image, null, 85);
        $bytes = ob_get_clean();
        imagedestroy($image);
        Storage::disk('local')->put($path, $bytes);

        return $path;
    }
}
