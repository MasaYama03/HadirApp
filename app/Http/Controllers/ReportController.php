<?php

namespace App\Http\Controllers;

use App\Models\AuditLog;
use App\Models\User;
use App\Models\WorkSetting;
use App\Services\AttendanceWorkbook;
use App\Services\HolidayService;
use App\Services\MonitoringService;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Validation\ValidationException;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

class ReportController extends Controller
{
    private function filters(Request $request): array
    {
        $data = $request->validate(['from' => 'nullable|date_format:Y-m-d', 'to' => 'nullable|date_format:Y-m-d', 'user_id' => 'nullable|integer|exists:users,id']);
        $from = $data['from'] ?? today()->startOfMonth()->toDateString();
        $to = $data['to'] ?? today()->toDateString();
        if ($to < $from || Carbon::parse($from)->diffInDays(Carbon::parse($to)) > 92) {
            throw ValidationException::withMessages(['from' => 'Pilih rentang berurutan, maksimal 93 hari.']);
        }

        return ['from' => $from, 'to' => $to, 'user_id' => isset($data['user_id']) ? (int) $data['user_id'] : null];
    }

    public function index(Request $request, MonitoringService $service)
    {
        $filters = $this->filters($request);
        $rows = $service->report($filters['from'], $filters['to'], $filters['user_id']);
        $totals = ['participants' => $rows->count(), 'present' => $rows->sum('present'), 'absent' => $rows->sum('absent'), 'excused' => $rows->sum('leave') + $rows->sum('sick'), 'duration' => $rows->sum('duration')];
        $page = LengthAwarePaginator::resolveCurrentPage();
        $rows = new LengthAwarePaginator($rows->forPage($page, 15)->values(), $rows->count(), 15, $page, ['path' => $request->url(), 'query' => $request->query()]);

        return view('admin.reports', compact('filters', 'rows', 'totals') + ['participants' => User::where('role', 'intern')->orderBy('name')->get()]);
    }

    public function export(Request $request, MonitoringService $service, AttendanceWorkbook $exporter)
    {
        $filters = $this->filters($request);
        $rows = $service->report($filters['from'], $filters['to'], $filters['user_id']);

        return response()->streamDownload(function () use ($rows, $filters, $request, $exporter) {
            $book = $exporter->make($rows, $filters, $request->user()->name);
            try {
                (new Xlsx($book))->save('php://output');
            } finally {
                $book->disconnectWorksheets();
            }
        }, 'hadir-report-'.$filters['from'].'-'.$filters['to'].'.xlsx', ['Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'Cache-Control' => 'private, no-store']);
    }

    public function importHolidays(Request $request, HolidayService $service)
    {
        $data = $request->validate(['year' => 'required|integer|between:2020,2100']);
        $count = $service->import($data['year']);
        AuditLog::record('Kalender libur dimuat', WorkSetting::current(), null, ['year' => $data['year'], 'count' => $count]);

        return redirect()->route('admin.settings', ['tab' => 'holidays', 'year' => $data['year']])->with('status', $count.' tanggal libur/cuti bersama berhasil dimuat. Pengecualian perusahaan tetap dipertahankan.');
    }
}
