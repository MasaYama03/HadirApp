<!DOCTYPE html>
<html lang="id"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="csrf-token" content="{{ csrf_token() }}"><meta name="theme-color" content="#21409A"><title>Masuk · Hadir</title><link rel="icon" type="image/svg+xml" href="{{ asset('favicon.svg') }}">@vite(['resources/css/app.css','resources/js/app.js'])@livewireStyles</head>
<body class="login-body">
<main class="login-shell">
    <section class="login-story" aria-label="Tentang Hadir">
        <x-brand />
        <div class="story-content"><h1>Setiap kehadiran,<br>ada <span>progres.</span></h1><p>Mulai harimu, catat perjalananmu, dan dapatkan dukungan untuk langkah berikutnya.</p>
        <div class="story-visual" aria-hidden="true"><div class="orbit orbit-one"></div><div class="orbit orbit-two"></div><div class="visual-date"><span>{{ mb_strtoupper(now()->translatedFormat('F')) }}</span><strong>{{ now()->format('d') }}</strong><div class="visual-week"><i></i><i></i><i></i><i></i><i></i></div></div><div class="visual-check"><x-icon name="check" size="28" /></div><span class="visual-note">Langkah kecil. Progres nyata.</span></div>
        <div class="story-features"><span><x-icon name="camera" size="17" />Absensi dengan selfie</span><span><x-icon name="calendar-days" size="17" />Kalender personal</span></div></div>
        <div class="story-footer">Assignment untuk <strong>detikcom</strong><span>2026</span></div>
    </section>
    <section class="login-form-side"><div class="login-form-wrap">
        <h2>Siap memulai hari?</h2><p class="muted login-intro">Masuk ke workspace magangmu.</p>
        @if($errors->any())<div class="error-summary" role="alert">{{ $errors->first() }}</div>@endif
        @if(session('status'))<div class="flash-message" role="status">{{ session('status') }}</div>@endif
        <form method="POST" action="{{ route('login') }}" class="form-stack" x-data="{showPassword:false,submitting:false}" @submit="submitting=true">@csrf
            <label class="field">Email akun<input aria-label="Email akun" aria-describedby="email-hint @error('email') email-error @enderror" aria-invalid="{{ $errors->has('email')?'true':'false' }}" name="email" type="email" value="{{ old('email') }}" placeholder="nama@gmail.com" pattern="[^@\s]+@[gG][mM][aA][iI][lL]\.[cC][oO][mM]" title="Gunakan email dengan format nama@gmail.com" @blur="$el.value=$el.value.trim().toLowerCase()" required autofocus autocomplete="username"><span class="field-hint" id="email-hint">Gunakan email Gmail yang didaftarkan admin, contoh: nama@gmail.com.</span>@error('email')<span class="field-error" id="email-error">{{ $message }}</span>@enderror</label>
            <label class="field">Kata sandi<div class="password-field"><input aria-label="Kata sandi" aria-describedby="password-hint @error('password') password-error @enderror" aria-invalid="{{ $errors->has('password')?'true':'false' }}" name="password" :type="showPassword?'text':'password'" required minlength="8" maxlength="72" pattern="(?=.*[A-Z])(?=.*[0-9]).{8,72}" title="Minimal 8 karakter, setidaknya 1 huruf besar dan 1 angka" autocomplete="current-password" placeholder="Masukkan kata sandimu"><button type="button" @click="showPassword=!showPassword" :aria-label="showPassword?'Sembunyikan kata sandi':'Tampilkan kata sandi'" x-text="showPassword?'Sembunyikan':'Tampilkan'"></button></div><span class="field-hint" id="password-hint">Minimal 8 karakter dengan 1 huruf besar dan 1 angka. Contoh: Magang2026.</span>@error('password')<span class="field-error" id="password-error">{{ $message }}</span>@enderror</label>
            <label class="checkbox-label"><input type="checkbox" name="remember">Ingat saya di perangkat ini</label>
            <button class="button button-primary button-full" type="submit" :disabled="submitting"><span x-text="submitting?'Memeriksa akun…':'Masuk ke workspace'"></span><x-icon name="chevron-right" size="18" /></button>
        </form>
        <aside class="login-notes" aria-label="Bantuan akun dan privasi">
            <div class="login-note"><x-icon name="circle-help" size="18" /><div><h3>Butuh bantuan akun?</h3><p>Belum punya akun atau lupa kata sandi? Hubungi admin magang untuk membuat akun atau mengatur ulang kata sandi.</p></div></div>
            <div class="login-note"><x-icon name="camera" size="18" /><div><h3>Privasi bukti selfie</h3><p>Bukti selfie hanya dapat dilihat oleh kamu dan admin magang.</p></div></div>
        </aside>
    </div><span class="login-footnote">Hadir — Internship Workspace</span></section>
</main>
@livewireScriptConfig
</body></html>
