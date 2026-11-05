@extends('layouts.workspace')

@section('title','Profil saya')

@section('content')

<div class="page-heading"><div><h1>Profil saya<span class="heading-dot">.</span></h1><p>Atur foto profil, periksa informasi akun, dan perbarui kata sandimu.</p></div></div>
<section class="panel profile-photo-panel" x-data="profilePhoto" aria-labelledby="photo-heading">
    <div class="panel-heading"><div><h2 id="photo-heading">Foto profil</h2><p>Avatar untuk mengenali akunmu di workspace dan daftar peserta.</p></div></div>
    <div class="panel-body photo-editor">
        <div class="photo-editor-visual">
            <x-avatar :user="auth()->user()" size="large" x-show="!preview" />
            <img class="photo-upload-preview" x-show="preview" x-cloak :src="preview || undefined" alt="Pratinjau foto profil baru">
            <p class="photo-preview-label" x-text="preview?'Pratinjau foto baru':@js(auth()->user()->profile_photo_path?'Foto saat ini':'Inisial nama')"></p>
        </div>
        <div class="photo-editor-controls">
            <form method="POST" action="{{ route('profile.photo.store') }}" enctype="multipart/form-data" class="form-stack" x-on:submit="submit($event)">@csrf
                <label class="field">Pilih foto profil<input type="file" name="photo" accept="image/jpeg,image/png,image/webp" required x-ref="photo" x-on:change="select($event)" aria-describedby="photo-hint photo-instructions" aria-invalid="{{ $errors->has('photo')?'true':'false' }}"><span class="field-hint" id="photo-hint">JPG, PNG, atau WebP, maksimal 2 MB. Ukuran 80–4096 piksel pada setiap sisi.</span></label>
                <p class="photo-instructions" id="photo-instructions">Pilih foto dengan wajah terlihat jelas di tengah. Bagian tengah gambar dipotong persegi dan ditampilkan sebagai lingkaran. Periksa pratinjau, lalu klik <strong>Simpan foto</strong>.</p>
                <p class="field-error" role="alert" x-show="error" x-cloak x-text="error"></p>
                @error('photo')<p class="field-error" role="alert">{{ $message }}</p>@enderror
                <p class="photo-pending" x-show="preview || checking" x-cloak role="status" x-text="checking?'Memeriksa foto…':'Foto baru belum tersimpan.'"></p>
                <div class="photo-editor-actions"><button type="submit" class="button button-primary" :disabled="!preview || checking || saving" x-text="saving?'Menyimpan foto…':'Simpan foto'"></button><button type="button" class="button button-secondary" x-show="preview || checking" x-cloak x-on:click="reset(true)" :disabled="saving">Batal mengganti</button></div>
            </form>
            @if(auth()->user()->profile_photo_path)
            <form method="POST" action="{{ route('profile.photo.destroy') }}" class="photo-remove-form" x-show="!preview && !checking" x-on:submit="saving=true">@csrf @method('DELETE')
                <button type="button" class="text-link" x-show="!confirmRemove" x-on:click="confirmRemove=true">Hapus foto profil</button>
                <div x-show="confirmRemove" x-cloak><p class="note-text">Hapus foto ini dan gunakan inisial namamu?</p><div class="photo-editor-actions"><button type="submit" class="button button-danger button-sm" :disabled="saving">Ya, hapus foto</button><button type="button" class="button button-secondary button-sm" x-on:click="confirmRemove=false">Batal</button></div></div>
            </form>
            @endif
            <p class="photo-privacy"><x-icon name="info" size="16" /><span>Foto profil dapat dilihat oleh kamu dan admin. Foto ini tidak menggantikan selfie saat clock-in atau clock-out.</span></p>
        </div>
    </div>
</section>
<div class="two-column section-space"><section class="panel"><div class="panel-heading"><div class="person-cell"><x-avatar :user="auth()->user()" /><div><h2>{{ auth()->user()->name }}</h2><p>{{ auth()->user()->email }}</p></div></div></div><div class="panel-body" style="padding-top:0"><dl class="meta-grid" style="grid-template-columns:1fr 1fr"><div><dt>Peran</dt><dd>{{ auth()->user()->role==='admin'?'Administrator':'Peserta magang' }}</dd></div><div><dt>Divisi</dt><dd>{{ auth()->user()->department ?? '—' }}</dd></div><div><dt>Posisi</dt><dd>{{ auth()->user()->position ?? '—' }}</dd></div><div><dt>Kode peserta</dt><dd>{{ auth()->user()->employee_code ?? '—' }}</dd></div>@if(auth()->user()->role==='intern')<div><dt>Mulai magang</dt><dd>{{ auth()->user()->internship_start?->translatedFormat('d M Y') }}</dd></div><div><dt>Selesai magang</dt><dd>{{ auth()->user()->internship_end?->translatedFormat('d M Y') }}</dd></div>@endif</dl><x-guide title="Perlu mengubah informasi profil?">Hubungi admin magang untuk memperbarui nama, email, divisi, atau masa magang. Kamu dapat mengganti foto profil dan kata sandi sendiri di halaman ini.</x-guide></div></section><section class="panel"><div class="panel-heading"><div><h2>Ubah kata sandi</h2><p>Gunakan kata sandi yang mudah kamu ingat dan sulit ditebak.</p></div></div><div class="panel-body" style="padding-top:0"><form method="POST" action="{{ route('profile.password') }}" class="form-stack">@csrf @method('PUT')<label class="field">Kata sandi saat ini<input type="password" name="current_password" required autocomplete="current-password"></label><label class="field">Kata sandi baru<input type="password" name="password" required minlength="8" autocomplete="new-password" maxlength="72" pattern="(?=.*[A-Z])(?=.*[0-9]).{8,72}" title="Minimal 8 karakter, setidaknya 1 huruf besar dan 1 angka"><span class="field-hint">Minimal 8 karakter dengan 1 huruf besar dan 1 angka. Contoh: Magang2026.</span></label><label class="field">Ulangi kata sandi baru<input type="password" name="password_confirmation" required minlength="8" autocomplete="new-password" maxlength="72" pattern="(?=.*[A-Z])(?=.*[0-9]).{8,72}" title="Minimal 8 karakter, setidaknya 1 huruf besar dan 1 angka"></label><button type="submit" class="button button-primary">Simpan kata sandi</button></form></div></section></div>

@endsection

