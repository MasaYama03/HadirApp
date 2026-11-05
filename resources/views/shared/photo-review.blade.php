@if($attendance->photo_flagged || $clarifications->total() || $attendance->photo_flag_reason)
<section class="panel" id="klarifikasi-foto">
    <div class="panel-heading"><div><h2>Klarifikasi foto</h2><p>{{ !$attendance->photo_flagged?'Pemeriksaan telah selesai.':($attendance->awaiting_photo_review?'Penjelasan peserta menunggu pemeriksaan admin.':'Peserta perlu menjawab catatan pemeriksaan admin.') }}</p></div><x-status-pill :tone="$attendance->photo_flagged?'yellow':'green'" :label="$attendance->photo_flagged?($attendance->awaiting_photo_review?'Menunggu admin':'Menunggu peserta'):'Selesai'" /></div>
    <div class="panel-body" style="padding-top:0">
        <div class="review-note"><strong>{{ $attendance->photo_flagged?'Catatan admin':'Hasil pemeriksaan admin' }}</strong><p>{{ $attendance->photo_flag_reason }}</p></div>
        @if($clarifications->total())
        <div class="clarification-thread">
            @foreach($clarifications as $reply)
            <article class="clarification-reply"><strong>{{ $reply->user->name }}</strong><small>{{ $reply->created_at->translatedFormat('d M Y, H:i') }} WIB{{ $reply->review_version!==$attendance->photo_review_version?' · Jawaban sebelumnya':'' }}</small><p class="reply-context">Menanggapi: {{ $reply->request_reason }}</p><p>{{ $reply->message }}</p></article>
            @endforeach
        </div>
        @endif
        @if(auth()->user()->role==='intern' && $attendance->photo_flagged)
            @if($attendance->awaiting_photo_review)
                <p class="review-next-step" role="status">Penjelasanmu sudah terkirim. Admin akan memeriksa dan memberikan hasil di halaman ini. Durasi masih menunggu pemeriksaan.</p>
            @else
                <form method="POST" action="{{ route('attendance.clarify',$attendance) }}" class="form-stack clarification-form">@csrf
                    <input type="hidden" name="review_version" value="{{ $attendance->photo_review_version }}">
                    <label class="field">Penjelasan untuk admin<textarea name="message" aria-label="Penjelasan untuk admin" aria-describedby="photo-clarification-hint" rows="4" required minlength="10" maxlength="2000" placeholder="Contoh: Foto gelap karena pencahayaan ruangan kurang. Saat itu saya bekerja bersama pembimbing Rina dan menyelesaikan halaman login.">{{ old('message') }}</textarea><span class="field-hint" id="photo-clarification-hint">Jelaskan penyebab foto kurang jelas, kegiatan saat itu, dan siapa yang bisa mengonfirmasi kehadiranmu. Minimal 10 karakter. Jawaban tersimpan setelah dikirim.</span></label>
                    <button class="button button-primary" type="submit">Kirim penjelasan</button>
                </form>
            @endif
        @endif
        @if($attendance->photo_flagged)<p class="review-next-step">{{ auth()->user()->role==='admin'?'Periksa penjelasan dan konfirmasikan kehadiran kepada pembimbing bila perlu. Pilih bukti sesuai untuk menyelesaikan, atau minta penjelasan lanjutan dengan catatan yang jelas.':'Foto dan waktu absensi asli tetap tersimpan. Admin dapat meminta penjelasan lanjutan. Setelah dikonfirmasi, tanda klarifikasi akan selesai dan durasi dihitung kembali.' }}</p>@endif
    </div>
    @if($clarifications->hasPages()){{ $clarifications->links() }}@endif
</section>
@endif
@if(auth()->user()->role==='admin')
<section class="panel">
    <div class="panel-heading"><div><h2>Pemeriksaan bukti foto</h2><p>Sampaikan apa yang perlu dijelaskan peserta atau tulis hasil pemeriksaan.</p></div></div>
    <div class="panel-body" style="padding-top:0"><form method="POST" action="{{ route('admin.attendance.flag',$attendance) }}" class="form-stack">@csrf
        <input type="hidden" name="review_version" value="{{ $attendance->photo_review_version }}">
        <label class="field">Hasil pemeriksaan<select name="flagged" aria-label="Hasil pemeriksaan"><option value="1" @selected($attendance->photo_flagged)>{{ $attendance->photo_flagged?'Minta penjelasan lanjutan':'Minta klarifikasi peserta' }}</option><option value="0" @selected(!$attendance->photo_flagged)>Bukti sesuai / selesaikan klarifikasi</option></select></label>
        <label class="field">Catatan pemeriksaan<textarea name="reason" aria-label="Catatan pemeriksaan" aria-describedby="photo-review-hint" required minlength="5" maxlength="1000" rows="3" placeholder="Contoh: Wajah pada foto clock-in terlalu gelap. Jelaskan kegiatan dan pembimbing yang dapat mengonfirmasi kehadiranmu.">{{ old('reason') }}</textarea><span class="field-hint" id="photo-review-hint">Catatan dibaca peserta. Meminta penjelasan lanjutan membuka kesempatan menjawab kembali. Durasi yang ditandai belum masuk total laporan.</span></label>
        <button type="submit" class="button button-secondary">Simpan pemeriksaan</button>
    </form></div>
</section>
@endif
