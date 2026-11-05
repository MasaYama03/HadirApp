<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ScheduleOverride extends Model
{
    protected $guarded = ['id'];

    protected function casts(): array
    {
        return ['date' => 'date', 'is_workday' => 'boolean'];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
