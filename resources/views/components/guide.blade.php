@props(['title'=>'Panduan singkat'])
<section class="guide" aria-label="Petunjuk penggunaan">
    <span class="guide-icon"><x-icon name="info" /></span>
    <div><strong>{{ $title }}</strong><div class="guide-copy">{{ $slot }}</div></div>
</section>
