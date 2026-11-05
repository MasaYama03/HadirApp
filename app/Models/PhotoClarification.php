<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PhotoClarification extends Model
{
    protected $guarded = ['id'];

    protected function casts(): array
    {
        return ['review_version' => 'integer'];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
