<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WorkSetting extends Model
{
    protected $guarded = [];

    protected function casts(): array
    {
        return ['workdays' => 'array', 'national_holidays_off' => 'boolean', 'collective_leave_off' => 'boolean'];
    }

    public static function current(): self
    {
        return static::firstOrCreate(['id' => 1], ['workdays' => [1, 2, 3, 4, 5], 'start_time' => '08:00', 'end_time' => '17:00', 'grace_minutes' => 15, 'default_mode' => 'WFO']);
    }
}
