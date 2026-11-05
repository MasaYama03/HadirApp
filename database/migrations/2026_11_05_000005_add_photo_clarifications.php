<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('attendances', function (Blueprint $table) {
            $table->unsignedInteger('photo_review_version')->default(0);
        });
        Schema::create('photo_clarifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('attendance_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained();
            $table->unsignedInteger('review_version');
            $table->text('request_reason');
            $table->text('message');
            $table->timestamps();
            $table->unique(['attendance_id', 'review_version']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('photo_clarifications');
        Schema::table('attendances', fn (Blueprint $table) => $table->dropColumn('photo_review_version'));
    }
};
