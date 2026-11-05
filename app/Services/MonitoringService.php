<?php

namespace App\Services;

use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Collection;

class MonitoringService
{
    public function __construct(private ScheduleService $schedules) {}

    public function rows(string $date): Collection
    {
        $users = User::where('role', 'intern')->with(['attendances' => fn ($q) => $q->whereDate('date', $date), 'attendanceRequests' => fn ($q) => $q->where('start_date', '<=', $date)->where('end_date', '>=', $date)->whereIn('status', ['pending', 'approved']), 'tickets' => fn ($q) => $q->where('status', '!=', 'resolved')])->orderBy('name')->get();
        $this->schedules->prime($users, $date, $date);

        return $users->map(fn ($user) => ['user' => $user, 'help_count' => $user->tickets->count()] + $this->schedules->state($user, $date, $user->attendances->first(), $user->attendanceRequests));
    }

    public function report(string $from, string $to, ?int $userId = null): Collection
    {
        $users = User::where('role', 'intern')->when($userId, fn ($q) => $q->whereKey($userId))->with(['attendances' => fn ($q) => $q->whereBetween('date', [$from, $to]), 'attendanceRequests' => fn ($q) => $q->where('start_date', '<=', $to)->where('end_date', '>=', $from)->whereIn('status', ['approved', 'pending'])])->orderBy('name')->get();
        $this->schedules->prime($users, $from, $to);

        return $users->map(function ($user) use ($from, $to) {
            $summary = ['user' => $user, 'workdays' => 0, 'present' => 0, 'incomplete' => 0, 'absent' => 0, 'leave' => 0, 'sick' => 0, 'pending' => 0, 'late' => 0, 'duration' => 0, 'flagged' => 0];
            $records = $user->attendances->keyBy(fn ($a) => $a->date->toDateString());
            for ($day = Carbon::parse($from); $day->lte(Carbon::parse($to)); $day->addDay()) {
                $date = $day->toDateString();
                $record = $records->get($date);
                $requests = $user->attendanceRequests->filter(fn ($r) => $r->start_date->toDateString() <= $date && $r->end_date->toDateString() >= $date);
                $state = $this->schedules->state($user, $date, $record, $requests);
                if ($state['schedule']['is_workday']) {
                    $summary['workdays']++;
                }
                if (array_key_exists($state['status'], $summary)) {
                    $summary[$state['status']]++;
                }
                if ($record) {
                    $summary['late'] += $record->late_minutes > 0 ? 1 : 0;
                    if (! $record->photo_flagged) {
                        $summary['duration'] += $record->duration_minutes;
                    }
                }
            }

            return $summary;
        });
    }
}
