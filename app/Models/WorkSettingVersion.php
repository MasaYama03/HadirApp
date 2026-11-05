<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WorkSettingVersion extends Model
{
    protected $guarded = ['id'];

    protected function casts(): array
    {
        return ['effective_from' => 'date', 'snapshot' => 'array'];
    }
}
