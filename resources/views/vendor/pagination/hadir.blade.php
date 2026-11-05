<nav class="list-pagination" aria-label="Navigasi halaman daftar">
    <p class="pagination-summary">@if($paginator->total())Menampilkan <strong>{{ $paginator->firstItem() ?? 0 }}–{{ $paginator->lastItem() ?? 0 }}</strong> dari <strong>{{ $paginator->total() }}</strong> data @else Belum ada data @endif <span>· {{ $paginator->perPage() }} per halaman</span></p>
    @if($paginator->hasPages())
    <div class="pagination-controls">
        @if($paginator->onFirstPage())<span class="pagination-button disabled" aria-disabled="true">Sebelumnya</span>@else<a class="pagination-button" rel="prev" href="{{ $paginator->previousPageUrl() }}">Sebelumnya</a>@endif
        <span class="pagination-position">{{ $paginator->currentPage() }} / {{ $paginator->lastPage() }}</span>
        @if($paginator->hasMorePages())<a class="pagination-button" rel="next" href="{{ $paginator->nextPageUrl() }}">Berikutnya</a>@else<span class="pagination-button disabled" aria-disabled="true">Berikutnya</span>@endif
    </div>
    @endif
</nav>
