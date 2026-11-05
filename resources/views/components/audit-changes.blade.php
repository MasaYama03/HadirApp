@props(['log'])
@php($changes = \App\Support\AuditPresentation::changes($log))
@if(count($changes))
<dl class="audit-changes">
    @foreach($changes as $change)
    <div><dt>{{ $change['label'] }}</dt><dd>@if($change['before'] !== null)<span class="audit-before">Sebelumnya: {{ $change['before'] }}</span>@endif<span>{{ $change['after'] }}</span></dd></div>
    @endforeach
</dl>
@else<p class="audit-description">Aktivitas telah dicatat.</p>@endif
