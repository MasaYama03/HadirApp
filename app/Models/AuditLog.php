<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AuditLog extends Model
{
    protected $guarded = ['id'];

    protected function casts(): array
    {
        return ['before' => 'array', 'after' => 'array'];
    }

    public function actor()
    {
        return $this->belongsTo(User::class, 'actor_id');
    }

    public static function record(string $action, Model $subject, ?array $before = null, ?array $after = null): self
    {
        return static::create(['actor_id' => auth()->id(), 'action' => $action, 'subject_type' => class_basename($subject), 'subject_id' => $subject->getKey(), 'before' => $before, 'after' => $after]);
    }
}
