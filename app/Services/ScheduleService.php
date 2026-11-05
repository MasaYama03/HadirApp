<?php

namespace App\Services;

use App\Models\Attendance;
use App\Models\AttendanceRequest;
use App\Models\Holiday;
use App\Models\ScheduleOverride;
use App\Models\User;
use App\Models\WorkSetting;
use App\Models\WorkSettingVersion;
use Carbon\Carbon;
use Illuminate\Support\Collection;

class ScheduleService
{
    private ?WorkSetting $setting = null;

    private array $holidayCache = [];

    private array $overrideCache = [];

    private ?Collection $settingVersions = null;

    public function prime(Collection $users, string $from, string $to): void
    {
        $this->setting ??= WorkSetting::current();
        $holidays = Holiday::whereBetween('date', [$from, $to])->get()->groupBy(fn ($h) => $h->date->toDateString());
        $overrides = ScheduleOverride::whereBetween('date', [$from, $to])->where(fn ($q) => $q->whereNull('user_id')->orWhereIn('user_id', $users->pluck('id')))->orderBy('id')->get();
        for ($day = Carbon::parse($from); $day->lte(Carbon::parse($to)); $day->addDay()) {
            $date = $day->toDateString();
            $this->holidayCache[$date] = $holidays->get($date, collect());
            $dateOverrides = $overrides->filter(fn ($o) => $o->date->toDateString() === $date);
            foreach ($users as $user) {
                $this->overrideCache[$user->id.':'.$date] = $dateOverrides->last(fn ($o) => $o->user_id === $user->id) ?? $dateOverrides->last(fn ($o) => $o->user_id === null);
            }
        }
    }

    public function for(User $user, string $date, ?Attendance $attendance = null): array
    {
        if ($attendance) {
            return $attendance->schedule_snapshot;
        }
        $day = Carbon::parse($date)->startOfDay();
        $setting = $this->setting ??= WorkSetting::current();
        $versions = $this->settingVersions ??= WorkSettingVersion::orderByDesc('effective_from')->get();
        $version = $versions->first(fn ($version) => $version->effective_from->toDateString() <= $date);
        if ($version) {
            $setting = (new WorkSetting)->forceFill($version->snapshot);
        }
        $holiday = $this->holidayCache[$date] ??= Holiday::whereDate('date', $date)->get();
        $key = $user->id.':'.$date;
        $override = array_key_exists($key, $this->overrideCache) ? $this->overrideCache[$key] : ($this->overrideCache[$key] = ScheduleOverride::whereDate('date', $date)
            ->where(fn ($q) => $q->whereNull('user_id')->orWhere('user_id', $user->id))
            ->orderByRaw('user_id IS NULL ASC')->latest('id')->first());
        $inPeriod = (! $user->internship_start || $day->gte($user->internship_start)) && (! $user->internship_end || $day->lte($user->internship_end));
        $offNational = $setting->national_holidays_off && $holiday->contains('type', 'national');
        $offCollective = $setting->collective_leave_off && $holiday->contains('type', 'collective');
        $isWorkday = $inPeriod && ($override ? $override->is_workday : (in_array($day->isoWeekday(), $setting->workdays) && ! $offNational && ! $offCollective));

        return [
            'is_workday' => $isWorkday, 'in_period' => $inPeriod,
            'mode' => $override?->mode ?? $setting->default_mode,
            'start_time' => $override?->start_time ?? $setting->start_time,
            'end_time' => $override?->end_time ?? $setting->end_time,
            'grace_minutes' => $setting->grace_minutes,
            'reason' => ! $inPeriod ? 'Di luar masa magang' : ($override?->reason ?? ($holiday->isNotEmpty() && ($offNational || $offCollective) ? $holiday->pluck('name')->join(', ') : (! $isWorkday ? 'Libur mingguan' : 'Jadwal kerja perusahaan'))),
            'holiday' => $holiday->pluck('name')->join(', '),
            'is_national_holiday' => $holiday->contains('type', 'national'),
        ];
    }

    public function state(User $user, string $date, ?Attendance $attendance = null, ?Collection $requests = null): array
    {
        $schedule = $this->for($user, $date, $attendance);
        $requests ??= AttendanceRequest::where('user_id', $user->id)->whereDate('start_date', '<=', $date)->whereDate('end_date', '>=', $date)->whereIn('status', ['pending', 'approved'])->get();
        $leave = $requests->first(fn ($r) => $r->status === 'approved' && in_array($r->type, ['leave', 'sick']));
        $pending = $requests->firstWhere('status', 'pending');
        $status = 'upcoming';
        $label = 'Belum waktunya';
        $marker = '';
        $tone = 'neutral';
        if ($attendance) {
            $status = $attendance->clock_out ? 'present' : 'incomplete';
            $label = $attendance->clock_out ? 'Hadir' : 'Belum lengkap';
            $marker = $attendance->clock_out ? '✓' : '◷';
            $tone = $attendance->clock_out ? 'green' : 'yellow';
            if ($attendance->photo_flagged) {
                $status = 'flagged';
                $label = 'Perlu klarifikasi';
                $tone = 'yellow';
                $marker = '!';
            }
        } elseif (! $schedule['in_period']) {
            $status = 'outside';
            $label = 'Di luar masa magang';
        } elseif (! $schedule['is_workday']) {
            $status = 'holiday';
            $label = 'Libur';
            $tone = 'neutral';
        } elseif ($leave) {
            $status = $leave->type;
            $label = $leave->type === 'leave' ? 'Izin' : 'Sakit';
            $marker = $leave->type === 'leave' ? 'I' : 'S';
            $tone = 'red';
        } elseif ($pending) {
            $status = 'pending';
            $label = 'Menunggu';
            $marker = '◷';
            $tone = 'yellow';
        } elseif (Carbon::parse($date)->isFuture() && $date !== today()->toDateString()) { /* no attendance marker for future dates */
        } elseif (now()->gt(Carbon::parse($date.' '.$schedule['end_time']))) {
            $status = 'absent';
            $label = 'Alpa';
            $marker = '×';
            $tone = 'red';
        } else {
            $status = 'not_in';
            $label = 'Belum masuk';
        }
        if ($date > today()->toDateString()) {
            $status = 'upcoming';
            $label = $schedule['is_workday'] ? 'Terjadwal' : 'Libur';
            $marker = '';
            $tone = 'neutral';
        }

        return compact('status', 'label', 'marker', 'tone', 'schedule', 'attendance');
    }

    public function month(User $user, string $month): array
    {
        $start = Carbon::createFromFormat('!Y-m', $month)->startOfMonth();
        $end = $start->copy()->endOfMonth();
        $this->prime(collect([$user]), $start->toDateString(), $end->toDateString());
        $attendances = $user->attendances()->whereBetween('date', [$start->toDateString(), $end->toDateString()])->get()->keyBy(fn ($a) => $a->date->toDateString());
        $requests = $user->attendanceRequests()->where('start_date', '<=', $end->toDateString())->where('end_date', '>=', $start->toDateString())->whereIn('status', ['pending', 'approved'])->get();
        $days = [];
        for ($day = $start->copy(); $day->lte($end); $day->addDay()) {
            $date = $day->toDateString();
            $days[] = ['date' => $date, 'day' => $day->day, 'is_today' => $day->isToday(), 'weekday' => $day->isoWeekday()] + $this->state($user, $date, $attendances->get($date), $requests->filter(fn ($r) => $r->start_date->toDateString() <= $date && $r->end_date->toDateString() >= $date));
        }

        return ['days' => $days, 'padding' => $start->isoWeekday() - 1, 'label' => $start->translatedFormat('F Y'), 'previous' => $start->copy()->subMonth()->format('Y-m'), 'next' => $start->copy()->addMonth()->format('Y-m')];
    }
}
