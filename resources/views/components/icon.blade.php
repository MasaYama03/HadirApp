@props(['name','size'=>20])
@php
    $safe=preg_match('/^[a-z0-9-]+$/',$name) ? $name : 'info';
    $path=resource_path('icons/'.$safe.'.svg');
    $svg=is_file($path)?file_get_contents($path):file_get_contents(resource_path('icons/info.svg'));
    $svg=preg_replace('/width="[^"]*"/','width="'.(int)$size.'"',$svg);
    $svg=preg_replace('/height="[^"]*"/','height="'.(int)$size.'"',$svg);
    $svg=str_replace('<svg','<svg aria-hidden="true" class="icon"',$svg);
@endphp
{!! $svg !!}
