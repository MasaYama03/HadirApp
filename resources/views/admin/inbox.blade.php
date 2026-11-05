@extends('layouts.workspace')
@section('title','Tindak lanjut')
@section('content')
@php
    $tabs=['requests'=>'Pengajuan absensi','help'=>'Bantuan kerja','incomplete'=>'Absensi belum lengkap','flagged'=>'Klarifikasi foto'];
    $descriptions=[
        'requests'=>'Izin, sakit, koreksi, dan absensi manual. Keputusan di sini dapat mengubah catatan absensi resmi.',
        'help'=>'Kendala pekerjaan yang dikirim saat clock-out. Tanggapan di sini membantu peserta melanjutkan tugasnya.',
        'incomplete'=>'Sesi hari sebelumnya yang belum memiliki waktu pulang. Minta peserta mengajukan koreksi setelah waktu pulang dikonfirmasi.',
        'flagged'=>'Baca jawaban peserta, konfirmasikan kehadiran bila perlu, lalu selesaikan pemeriksaan atau minta penjelasan lanjutan.',
    ];
    $statuses=$tab==='help'?['active'=>'Belum selesai','open'=>'Terbuka','in_progress'=>'Sedang ditangani','resolved'=>'Selesai','all'=>'Semua status']:['pending'=>'Menunggu keputusan','approved'=>'Disetujui','rejected'=>'Ditolak','all'=>'Semua status'];
@endphp
<div class="page-heading"><div><h1>Tindak lanjut peserta<span class="heading-dot">.</span></h1><p>Pilih jenis tindak lanjut, lalu cari peserta yang perlu kamu bantu. Angka pada tab menunjukkan yang belum selesai.</p></div></div>
<nav class="section-tabs" aria-label="Jenis tindak lanjut">
    @foreach($tabs as $value=>$label)<a href="{{ route('admin.inbox',['tab'=>$value]) }}" class="section-tab {{ $tab===$value?'active':'' }}" @if($tab===$value) aria-current="page" @endif><span>{{ $label }}</span><span class="tab-count">{{ $counts[$value] }}</span></a>@endforeach
</nav>
<section class="panel" id="{{ $tab==='help'?'kendala':'daftar-tindak-lanjut' }}">
    <div class="panel-heading"><div><h2>{{ $tabs[$tab] }}</h2><p>{{ $descriptions[$tab] }}</p></div></div>
    <form method="GET" action="{{ route('admin.inbox') }}" class="list-filters">
        <input type="hidden" name="tab" value="{{ $tab }}">
        <label class="field list-search">Cari peserta<input name="q" type="search" value="{{ $q }}" maxlength="100" placeholder="Nama atau kode peserta"></label>
        @if(in_array($tab,['requests','help']))<label class="field">Status<select name="status" aria-label="Status">@foreach($statuses as $value=>$label)<option value="{{ $value }}" @selected($status===$value)>{{ $label }}</option>@endforeach</select></label>@endif
        <button class="button button-secondary" type="submit">Terapkan filter</button>
        @if($q!=='' || (in_array($tab,['requests','help']) && $status!==($tab==='help'?'active':'pending')))<a href="{{ route('admin.inbox',['tab'=>$tab]) }}" class="button button-reset"><x-icon name="rotate-ccw" size="15" />Reset filter</a>@endif
    </form>
    @forelse($items as $item)
        @if($tab==='requests')
        <article class="request-card compact-card" id="pengajuan-{{ $item->id }}">
            <div class="request-card-header"><div><h3>{{ $item->user->name }}</h3><small>{{ $item->type_label }} · {{ $item->start_date->translatedFormat('d M Y') }}{{ !$item->start_date->isSameDay($item->end_date)?' – '.$item->end_date->translatedFormat('d M Y'):'' }}</small></div><x-status-pill :tone="$item->status==='pending'?'yellow':($item->status==='approved'?'green':'red')" :label="['pending'=>'Menunggu','approved'=>'Disetujui','rejected'=>'Ditolak'][$item->status]" /></div>
            <p class="list-preview">{{ \Illuminate\Support\Str::limit($item->reason,160) }}</p>
            <details class="item-details" name="inbox-items" @if(old('_submission_id')==$item->id) open @endif><summary>{{ $item->status==='pending'?'Tinjau pengajuan':'Lihat keputusan' }}<x-icon name="chevron-right" size="16" /></summary>
                <div class="item-detail-body"><p class="note-text">{{ $item->reason }}</p>
                @if($item->payload)<div class="request-time">Usulan waktu: <strong>{{ $item->payload['clock_in'] }}–{{ $item->payload['clock_out'] }} WIB</strong>@if($item->payload['work_note'] ?? null)<p>{{ $item->payload['work_note'] }}</p>@endif</div>@endif
                @if($item->status==='pending')<form method="POST" action="{{ route('admin.requests.review',$item) }}" class="review-form">@csrf<input type="hidden" name="_submission_id" value="{{ $item->id }}"><label class="field">Alasan keputusan<textarea name="review_note" rows="2" minlength="5" maxlength="2000" required placeholder="Contoh: Waktu pulang telah dikonfirmasi dengan pembimbing.">{{ old('_submission_id')==$item->id?old('review_note'):'' }}</textarea><span class="field-hint">Peserta akan membaca alasan ini. Persetujuan akan memperbarui absensi; keputusan yang sudah disimpan tidak dapat dikirim ulang.</span></label><div class="review-actions"><button name="decision" value="rejected" type="submit" class="button button-danger button-sm">Tolak pengajuan</button><button name="decision" value="approved" type="submit" class="button button-primary button-sm">Setujui pengajuan<x-icon name="check" size="15" /></button></div></form>
                @else<div class="ticket-response"><strong>{{ $item->reviewer?->name }} · {{ $item->reviewed_at?->translatedFormat('d M Y, H:i') }} WIB</strong><p>{{ $item->review_note }}</p></div>@endif
                </div>
            </details>
        </article>
        @elseif($tab==='help')
        <article class="request-card compact-card" id="bantuan-{{ $item->id }}">
            <div class="request-card-header"><div><h3>{{ $item->user->name }}</h3><small>{{ $item->user->department }} · {{ $item->attendance->date->translatedFormat('d M Y') }}</small></div><x-status-pill :tone="$item->status==='resolved'?'green':'yellow'" :label="['open'=>'Terbuka','in_progress'=>'Ditangani','resolved'=>'Selesai'][$item->status]" /></div>
            <p class="list-preview">{{ \Illuminate\Support\Str::limit($item->message,160) }}</p>
            <details class="item-details" name="inbox-items" @if(old('_ticket_id')==$item->id) open @endif><summary>{{ $item->status==='resolved'?'Lihat percakapan':'Tanggapi kendala' }}<x-icon name="chevron-right" size="16" /></summary><div class="item-detail-body">
                <p class="note-text">{{ $item->message }}</p><x-ticket-thread :responses="$item->responses ?? []" />
                <form method="POST" action="{{ route('admin.tickets.respond',$item) }}" class="review-form">@csrf<input type="hidden" name="_ticket_id" value="{{ $item->id }}"><div class="review-grid"><label class="field">Tanggapan untuk peserta<textarea name="message" required minlength="5" maxlength="2000" rows="2" placeholder="Contoh: Akses repository sudah diberikan. Silakan cek undangan pada emailmu.">{{ old('_ticket_id')==$item->id?old('message'):'' }}</textarea><span class="field-hint">Berikan langkah berikutnya yang bisa dilakukan peserta.</span></label><label class="field">Status penanganan<select name="status" aria-label="Status penanganan"><option value="open" @selected(old('_ticket_id')==$item->id?old('status')==='open':$item->status==='open')>Terbuka</option><option value="in_progress" @selected(old('_ticket_id')==$item->id?old('status')==='in_progress':$item->status==='in_progress')>Sedang ditangani</option><option value="resolved" @selected(old('_ticket_id')==$item->id?old('status')==='resolved':$item->status==='resolved')>Selesai</option></select><span class="field-hint">Pilih Selesai jika bantuan sudah diberikan dan kendala teratasi.</span></label></div><div class="review-actions"><button class="button button-primary button-sm" type="submit">Kirim tanggapan</button></div></form>
            </div></details>
        </article>
        @else
        <article class="issue-card"><div>@if($tab==='flagged')<span class="clarification-state">{{ $item->awaiting_photo_review?'Sudah dijawab · Perlu ditinjau admin':'Menunggu penjelasan peserta' }}</span>@endif<h3>{{ $item->user->name }}</h3><p>{{ $item->date->translatedFormat('d M Y') }} · {{ $item->mode }} · masuk {{ $item->clock_in->format('H:i') }} WIB</p><p class="note-text">{{ $tab==='flagged'?$item->photo_flag_reason:'Waktu pulang belum tercatat. Periksa detail lalu arahkan peserta mengajukan koreksi.' }}</p></div><a class="button button-secondary button-sm" href="{{ route('attendance.detail',$item) }}">Periksa absensi<x-icon name="chevron-right" size="15" /></a></article>
        @endif
    @empty<div class="empty-state"><x-icon :name="$tab==='help'?'message-circle':'clipboard-list'" size="30" /><h3>{{ $q!==''?'Tidak ada peserta yang cocok':'Tidak ada data pada pilihan ini' }}</h3><p>{{ $q!==''?'Coba nama atau kode lain, atau reset filter.':'Data akan muncul saat ada tindak lanjut yang sesuai. Kamu dapat mengganti status atau membuka tab lain.' }}</p></div>@endforelse
    {{ $items->links() }}
</section>
@endsection
