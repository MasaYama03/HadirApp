<?php

namespace App\Providers;

use App\Models\AttendanceRequest;
use Carbon\Carbon;
use Illuminate\Pagination\Paginator;
use Illuminate\Support\Facades\View;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        if ($this->app->environment('testing') && ! str_ends_with((string) config('database.connections.'.config('database.default').'.database'), '_test')) {
            throw new \RuntimeException('Pengujian hanya boleh memakai database berakhiran _test.');
        }
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Carbon::setLocale('id');
        Paginator::defaultView('vendor.pagination.hadir');
        View::composer('layouts.workspace', function ($view) {
            $user = auth()->user();
            $view->with('navPending', $user?->role === 'admin' ? AttendanceRequest::where('status', 'pending')->count() : ($user ? $user->attendanceRequests()->where('status', 'pending')->count() : 0));
        });
    }
}
