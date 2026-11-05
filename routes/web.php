<?php

use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\ProfilePhotoController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\WorkspaceController;
use Illuminate\Support\Facades\Route;

Route::get('/', fn () => redirect()->route(auth()->check() ? 'dashboard' : 'login'));
Route::middleware('guest')->group(function () {
    Route::get('/login', [AuthenticatedSessionController::class, 'create'])->name('login');
    Route::post('/login', [AuthenticatedSessionController::class, 'store']);
});
Route::middleware('auth')->group(function () {
    Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])->name('logout');
    Route::get('/dashboard', [WorkspaceController::class, 'dashboard'])->middleware('active')->name('dashboard');
    Route::get('/profile', [WorkspaceController::class, 'profile'])->middleware('active')->name('profile.edit');
    Route::post('/profile/photo', [ProfilePhotoController::class, 'store'])->middleware(['active', 'throttle:15,1'])->name('profile.photo.store');
    Route::delete('/profile/photo', [ProfilePhotoController::class, 'destroy'])->middleware('active')->name('profile.photo.destroy');
    Route::get('/profile-photos/{user}', [ProfilePhotoController::class, 'show'])->middleware('active')->name('profile.photo.show');
    Route::put('/profile/password', [WorkspaceController::class, 'updateProfile'])->middleware('active')->name('profile.password');
    Route::get('/attendance/{attendance}', [WorkspaceController::class, 'attendanceDetail'])->middleware('active')->name('attendance.detail');
    Route::get('/attendance/{attendance}/photo/{kind}', [WorkspaceController::class, 'photo'])->name('attendance.photo');
    Route::middleware('role:intern')->group(function () {
        Route::post('/attendance/{attendance}/clarification', [WorkspaceController::class, 'clarifyPhoto'])->middleware('throttle:15,1')->name('attendance.clarify');
        Route::get('/capture/{action}', [WorkspaceController::class, 'capture'])->name('attendance.capture');
        Route::post('/capture/{action}', [WorkspaceController::class, 'saveAttendance'])->middleware('throttle:15,1')->name('attendance.save');
        Route::get('/calendar', [WorkspaceController::class, 'calendar'])->name('calendar');
        Route::get('/history', [WorkspaceController::class, 'history'])->name('history');
        Route::get('/requests', [WorkspaceController::class, 'requests'])->name('requests');
        Route::post('/requests', [WorkspaceController::class, 'submitRequest'])->middleware('throttle:20,1')->name('requests.store');
    });
    Route::prefix('admin')->name('admin.')->middleware('role:admin')->group(function () {
        Route::get('/participants', [WorkspaceController::class, 'participants'])->name('participants');
        Route::get('/participants/create', [WorkspaceController::class, 'participantForm'])->name('participants.create');
        Route::post('/participants', [WorkspaceController::class, 'saveParticipant'])->name('participants.store');
        Route::get('/participants/{participant}/edit', [WorkspaceController::class, 'participantForm'])->name('participants.edit');
        Route::put('/participants/{participant}', [WorkspaceController::class, 'saveParticipant'])->name('participants.update');
        Route::get('/inbox', [WorkspaceController::class, 'inbox'])->name('inbox');
        Route::post('/requests/{submission}/review', [WorkspaceController::class, 'reviewRequest'])->name('requests.review');
        Route::post('/tickets/{ticket}', [WorkspaceController::class, 'respondTicket'])->name('tickets.respond');
        Route::post('/attendance/{attendance}/flag', [WorkspaceController::class, 'flagPhoto'])->name('attendance.flag');
        Route::get('/settings', [WorkspaceController::class, 'settings'])->name('settings');
        Route::put('/settings', [WorkspaceController::class, 'saveSettings'])->name('settings.update');
        Route::post('/settings/overrides', [WorkspaceController::class, 'saveOverride'])->name('overrides.store');
        Route::delete('/settings/overrides/{override}', [WorkspaceController::class, 'deleteOverride'])->name('overrides.destroy');
        Route::post('/settings/holidays', [ReportController::class, 'importHolidays'])->name('holidays.import');
        Route::get('/reports', [ReportController::class, 'index'])->name('reports');
        Route::get('/reports/export', [ReportController::class, 'export'])->name('reports.export');
        Route::get('/audit', [WorkspaceController::class, 'audit'])->name('audit');
    });
});
