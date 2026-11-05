<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('role')->default('intern')->index();
            $table->string('department')->nullable();
            $table->string('position')->nullable();
            $table->string('employee_code')->nullable()->unique();
            $table->date('internship_start')->nullable();
            $table->date('internship_end')->nullable();
            $table->boolean('is_active')->default(true);
        });
        Schema::create('work_settings', function (Blueprint $table) {
            $table->id();
            $table->json('workdays');
            $table->string('start_time', 5)->default('08:00');
            $table->string('end_time', 5)->default('17:00');
            $table->unsignedSmallInteger('grace_minutes')->default(15);
            $table->string('default_mode')->default('WFO');
            $table->boolean('national_holidays_off')->default(true);
            $table->boolean('collective_leave_off')->default(false);
            $table->timestamps();
        });
        Schema::create('holidays', function (Blueprint $table) {
            $table->id();
            $table->date('date')->index();
            $table->string('name');
            $table->string('type');
            $table->string('source', 500);
            $table->timestamps();
            $table->unique(['date', 'type']);
        });
        Schema::create('schedule_overrides', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->nullable()->constrained()->restrictOnDelete();
            $table->date('date')->index();
            $table->boolean('is_workday');
            $table->string('mode')->default('WFO');
            $table->string('start_time', 5)->default('08:00');
            $table->string('end_time', 5)->default('17:00');
            $table->text('reason');
            $table->foreignId('created_by')->constrained('users');
            $table->timestamps();
        });
        Schema::create('attendances', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->date('date')->index();
            $table->dateTime('clock_in');
            $table->dateTime('clock_out')->nullable();
            $table->string('in_photo')->nullable();
            $table->string('out_photo')->nullable();
            $table->string('mode');
            $table->json('schedule_snapshot');
            $table->text('work_note')->nullable();
            $table->string('work_status')->nullable();
            $table->boolean('manual')->default(false);
            $table->boolean('photo_flagged')->default(false);
            $table->text('photo_flag_reason')->nullable();
            $table->timestamps();
            $table->unique(['user_id', 'date']);
        });
        Schema::create('attendance_requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->string('type')->index();
            $table->date('start_date')->index();
            $table->date('end_date')->index();
            $table->text('reason');
            $table->json('payload')->nullable();
            $table->string('status')->default('pending')->index();
            $table->text('review_note')->nullable();
            $table->foreignId('reviewed_by')->nullable()->constrained('users');
            $table->dateTime('reviewed_at')->nullable();
            $table->timestamps();
        });
        Schema::create('support_tickets', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained();
            $table->foreignId('attendance_id')->unique()->constrained();
            $table->text('message');
            $table->string('status')->default('open')->index();
            $table->json('responses')->nullable();
            $table->timestamps();
        });
        Schema::create('audit_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('actor_id')->nullable()->constrained('users');
            $table->string('action');
            $table->string('subject_type');
            $table->unsignedBigInteger('subject_id')->nullable();
            $table->json('before')->nullable();
            $table->json('after')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        foreach (['audit_logs', 'support_tickets', 'attendance_requests', 'attendances', 'schedule_overrides', 'holidays', 'work_settings'] as $table) {
            Schema::dropIfExists($table);
        }
        Schema::table('users', fn (Blueprint $table) => $table->dropColumn(['role', 'department', 'position', 'employee_code', 'internship_start', 'internship_end', 'is_active']));
    }
};
