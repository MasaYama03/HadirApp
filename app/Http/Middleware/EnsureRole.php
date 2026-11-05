<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class EnsureRole
{
    public function handle(Request $request, Closure $next, string $role)
    {
        abort_unless($request->user() && $request->user()->is_active, 403, 'Akun tidak aktif. Hubungi admin.');
        abort_unless($request->user()->role === $role, 403, 'Kamu tidak memiliki akses ke halaman ini.');

        return $next($request);
    }
}
