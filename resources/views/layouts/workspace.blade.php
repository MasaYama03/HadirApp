<!DOCTYPE html>

<html lang="id">

<head>

    <meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="csrf-token" content="{{ csrf_token() }}">

    <meta name="theme-color" content="#21409A"><title>@yield('title','Workspace') · Hadir</title>

    <link rel="icon" type="image/svg+xml" href="{{ asset('favicon.svg') }}">

    @vite(['resources/css/app.css','resources/js/app.js'])

    @livewireStyles

</head>

<body x-data="{ menuOpen: false }" class="workspace-body">

<a href="#main-content" class="skip-link">Langsung ke konten</a>

<div class="mobile-scrim" x-show="menuOpen" x-cloak @click="menuOpen=false"></div>

<aside class="sidebar" :class="{ 'is-open': menuOpen }" aria-label="Navigasi utama">

    <div class="sidebar-brand"><x-brand /><button type="button" class="icon-button mobile-only" @click="menuOpen=false" aria-label="Tutup menu"><x-icon name="x" /></button></div>

    <div class="workspace-tag"><span class="live-dot"></span>{{ auth()->user()->role==='admin'?'ADMIN WORKSPACE':'PESERTA MAGANG' }}</div>

    <p class="nav-section-label">WORKSPACE</p>

    <nav>

    @php

        $links=auth()->user()->role==='admin' ? [

            ['dashboard','layout-dashboard','Pantau peserta'],['admin.participants','users','Data peserta'],['admin.inbox','clipboard-list','Tindak lanjut'],['admin.reports','download','Laporan absensi'],['admin.settings','calendar-days','Jadwal & kalender'],['admin.audit','clock','Riwayat aktivitas']

        ] : [['dashboard','layout-dashboard','Ringkasan hari ini'],['calendar','calendar-days','Kalender kehadiran'],['history','clock','Riwayat absensi'],['requests','clipboard-list','Pengajuan & bantuan']];

    @endphp

    @foreach($links as [$route,$icon,$label])

        <a href="{{ route($route) }}" class="nav-link {{ request()->routeIs($route)?'active':'' }}" @if(request()->routeIs($route)) aria-current="page" @endif><x-icon :name="$icon" /><span>{{ $label }}</span>@if(in_array($route,['admin.inbox','requests']) && $navPending)<span class="nav-count" title="Pengajuan absensi menunggu keputusan">{{ $navPending }}</span>@endif</a>

    @endforeach

    </nav>

    <div class="sidebar-bottom">

        <div class="sidebar-date"><x-icon name="calendar-days" size="17" /><div><time datetime="{{ today()->toDateString() }}">{{ now()->translatedFormat('l, d F Y') }}</time><span>Waktu Indonesia Barat</span></div></div>

        <div class="assignment-label"><span class="mini-rule"></span>Assignment untuk <strong>detikcom</strong></div>

        <form method="POST" action="{{ route('logout') }}">@csrf<button class="logout-button" type="submit"><x-icon name="log-out" size="17" />Keluar dari akun</button></form>

    </div>

</aside>

<div class="workspace-main">

    <header class="topbar"><div class="topbar-left"><button type="button" class="icon-button mobile-only" @click="menuOpen=true" :aria-expanded="menuOpen" aria-label="Buka menu"><x-icon name="layout-dashboard" /></button><span class="breadcrumb">Workspace <span>/</span> <strong>@yield('title','Ringkasan')</strong></span></div><div class="topbar-right"><a href="{{ route('profile.edit') }}" class="account-link profile-shortcut topbar-account" title="Buka profil saya"><span class="account-copy"><strong>{{ auth()->user()->name }}</strong><small>{{ auth()->user()->role==='admin'?'Administrator':auth()->user()->position }}</small></span><x-avatar :user="auth()->user()" /></a></div></header>

    <main id="main-content" class="page-content">

        @if(session('status'))<div class="flash-message" role="status"><x-icon name="check" />{{ session('status') }}</div>@endif

        @if($errors->any())<div class="error-summary" role="alert"><strong>Periksa kembali isianmu</strong><ul>@foreach($errors->all() as $error)<li>{{ $error }}</li>@endforeach</ul></div>@endif

        @yield('content')

    </main>

    <footer class="workspace-footer"><span>Hadir · Setiap kehadiran, ada progres.</span><span>Zona waktu Asia/Jakarta</span></footer>

</div>

@livewireScriptConfig

@stack('scripts')

</body></html>

