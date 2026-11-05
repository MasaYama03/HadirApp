<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
    protected $guarded = ['id'];

    protected function casts(): array
    {
        return ['date' => 'date', 'clock_in' => 'datetime', 'clock_out' => 'datetime', 'schedule_snapshot' => 'array', 'manual' => 'boolean', 'photo_flagged' => 'boolean', 'photo_review_version' => 'integer'];
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function ticket()
    {
        return $this->hasOne(SupportTicket::class);
    }

    public function clarifications()
    {
        return $this->hasMany(PhotoClarification::class);
    }

    public function currentClarification()
    {
        return $this->hasOne(PhotoClarification::class)->latestOfMany();
    }

    public function getAwaitingPhotoReviewAttribute(): bool
    {
        return $this->photo_flagged && $this->currentClarification?->review_version === $this->photo_review_version;
    }

    public function getDurationMinutesAttribute(): int
    {
        return $this->clock_out ? max(0, (int) $this->clock_in->diffInMinutes($this->clock_out)) : 0;
    }

    public function getUsesSuppliedPhotosAttribute(): bool
    {
        return str_starts_with((string) $this->in_photo, 'demo/masahiro/') || str_starts_with((string) $this->out_photo, 'demo/masahiro/');
    }

    public function getLateMinutesAttribute(): int
    {
        $start = Carbon::parse($this->date->toDateString().' '.($this->schedule_snapshot['start_time'] ?? '08:00'));
        $threshold = $start->copy()->addMinutes($this->schedule_snapshot['grace_minutes'] ?? 15);

        return $this->clock_in->gt($threshold) ? (int) $start->diffInMinutes($this->clock_in) : 0;
    }
}
