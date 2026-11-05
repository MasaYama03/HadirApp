@props(['user','size'=>'normal'])
<span {{ $attributes->class(['avatar', 'avatar-small'=>$size==='small', 'avatar-table'=>$size==='table', 'avatar-large'=>$size==='large']) }} x-data="{failed:false}">
    @if($user->profile_photo_url)
        <img src="{{ $user->profile_photo_url }}" alt="" decoding="async" x-show="!failed" x-on:load="failed=false" x-on:error="failed=true">
        <span x-show="failed" x-cloak>{{ $user->initials }}</span>
    @else{{ $user->initials }}@endif
</span>
