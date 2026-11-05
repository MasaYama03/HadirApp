@props(['tone'=>'neutral','label','marker'=>null])
<span class="status-pill tone-{{ $tone }}">@if($marker)<span aria-hidden="true">{{ $marker }}</span>@else<span class="status-dot" aria-hidden="true"></span>@endif{{ $label }}</span>
