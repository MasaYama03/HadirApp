@props(['responses'=>[]])
@if(count($responses))
    @if(count($responses)>1)
        <details class="thread-history"><summary>{{ count($responses)-1 }} tanggapan sebelumnya</summary>
            @foreach(array_slice($responses,0,-1) as $response)<div class="ticket-response"><strong>{{ $response['name'] }}</strong><p>{{ $response['message'] }}</p><small>{{ \Carbon\Carbon::parse($response['at'])->translatedFormat('d M Y, H:i') }} WIB</small></div>@endforeach
        </details>
    @endif
    @php($response=$responses[count($responses)-1])
    <div class="ticket-response"><strong>{{ $response['name'] }} · Tanggapan terbaru</strong><p>{{ $response['message'] }}</p><small>{{ \Carbon\Carbon::parse($response['at'])->translatedFormat('d M Y, H:i') }} WIB</small></div>
@endif
