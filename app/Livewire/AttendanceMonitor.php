<?php

namespace App\Livewire;

use App\Models\Attendance;
use App\Models\AttendanceRequest;
use App\Models\SupportTicket;
use App\Services\MonitoringService;
use Livewire\Attributes\Url;
use Livewire\Component;
use Livewire\WithPagination;

class AttendanceMonitor extends Component
{
    use WithPagination;

    #[Url]
    public string $date = '';

    #[Url]
    public string $search = '';

    #[Url]
    public string $status = '';

    #[Url]
    public string $department = '';

    #[Url]
    public string $mode = '';

    public function mount()
    {
        $this->date = $this->date ?: today()->toDateString();
    }

    public function updated($property)
    {
        $this->resetPage();
    }

    public function filterStatus(string $status)
    {
        $this->status = $this->status === $status ? '' : $status;
        $this->resetPage();
    }

    public function resetFilters()
    {
        $this->reset('search', 'status', 'department', 'mode');
        $this->resetPage();
    }

    public function render()
    {
        abort_unless(auth()->user()?->role === 'admin' && auth()->user()->is_active, 403);
        $this->validate(['date' => 'required|date_format:Y-m-d', 'search' => 'string|max:100', 'status' => 'string|max:30', 'mode' => 'string|max:10', 'department' => 'string|max:100']);
        $all = app(MonitoringService::class)->rows($this->date);
        $counts = $all->countBy('status');
        $rows = $all->filter(fn ($r) => (! $this->search || str_contains(mb_strtolower($r['user']->name.' '.$r['user']->email.' '.$r['user']->employee_code), mb_strtolower($this->search))) && (! $this->department || $r['user']->department === $this->department) && (! $this->mode || $r['schedule']['mode'] === $this->mode) && (! $this->status || ($this->status === 'needs_attention' ? ($r['help_count'] > 0 || in_array($r['status'], ['incomplete', 'flagged', 'pending', 'absent'])) : $r['status'] === $this->status)));
        $total = $rows->count();
        $page = $this->getPage();
        $visible = $rows->forPage($page, 12);
        $pendingCount = AttendanceRequest::where('status', 'pending')->count();
        $helpCount = SupportTicket::where('status', '!=', 'resolved')->count();
        $incompleteCount = Attendance::whereNull('clock_out')->whereDate('date', '<', today())->count();

        return view('livewire.attendance-monitor', compact('all', 'counts', 'visible', 'total', 'page', 'pendingCount', 'helpCount', 'incompleteCount') + ['departments' => $all->pluck('user.department')->unique()->filter()->sort(), 'maxPage' => max(1,(int) ceil($total / 12))]);
    }
}
