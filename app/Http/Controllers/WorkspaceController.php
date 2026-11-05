<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Models\AttendanceRequest;
use App\Models\AuditLog;
use App\Models\Holiday;
use App\Models\ScheduleOverride;
use App\Models\SupportTicket;
use App\Models\User;
use App\Models\WorkSetting;
use App\Models\WorkSettingVersion;
use App\Services\AttendanceService;
use App\Services\RequestService;
use App\Services\ScheduleService;
use App\Support\AccountRules;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

class WorkspaceController extends Controller
{
    public function dashboard(Request $request, ScheduleService $schedules)
    {
        if ($request->user()->role === 'admin') {
            return view('admin.dashboard');
        }
        $user = $request->user();
        $attendance = $user->attendances()->whereDate('date', today())->first();
        $state = $schedules->state($user, today()->toDateString(), $attendance);
        $month = $schedules->month($user, today()->format('Y-m'));
        $stats = collect($month['days'])->countBy('status');
        $flaggedCount = $user->attendances()->where('photo_flagged', true)->count();
        $flaggedRecords = $user->attendances()->with('currentClarification')->where('photo_flagged', true)->latest('date')->limit(3)->get();

        return view('intern.dashboard', compact('attendance', 'state', 'month', 'stats', 'flaggedCount', 'flaggedRecords') + ['pending' => $user->attendanceRequests()->where('status', 'pending')->count(), 'tickets' => $user->tickets()->latest()->take(3)->get(), 'previousIncomplete' => $user->attendances()->whereDate('date', '<', today())->whereNull('clock_out')->first(), 'recent' => $user->attendances()->latest('date')->take(4)->get()]);
    }

    public function capture(Request $request, string $action, ScheduleService $schedules)
    {
        abort_unless(in_array($action, ['in', 'out']), 404);
        $attendance = $request->user()->attendances()->whereDate('date', today())->first();
        if ($action === 'in' && $attendance) {
            return redirect()->route('dashboard')->with('status', 'Clock-in hari ini sudah tersimpan.');
        }
        if ($action === 'out' && (! $attendance || $attendance->clock_out)) {
            return redirect()->route('dashboard')->with('status', 'Tidak ada sesi hari ini yang perlu di-clock-out.');
        }
        $schedule = $schedules->for($request->user(), today()->toDateString(), $attendance);

        return view('intern.capture', compact('action', 'attendance', 'schedule'));
    }

    public function saveAttendance(Request $request, string $action, AttendanceService $service)
    {
        abort_unless(in_array($action, ['in', 'out']), 404);
        $rules = ['photo' => ['required', 'file', 'image', 'mimes:jpeg,jpg,png', 'max:5120', 'dimensions:min_width=120,min_height=120,max_width=6000,max_height=6000']];
        if ($action === 'out') {
            $rules += ['work_note' => ['required', 'string', 'min:10', 'max:2000'], 'work_status' => ['required', Rule::in(['done', 'ongoing', 'blocked'])], 'need_help' => ['nullable', 'boolean'], 'help_message' => ['required_if:need_help,1', 'nullable', 'string', 'min:10', 'max:2000']];
        }
        $data = $request->validate($rules);
        if ($action === 'in') {
            $service->clockIn($request->user(), $request->file('photo'));
        } else {
            $service->clockOut($request->user(), $request->file('photo'), $data);
        }

        return redirect()->route('dashboard')->with('status', $action === 'in' ? 'Clock-in berhasil dicatat. Selamat berkarya hari ini!' : 'Clock-out berhasil. Terima kasih untuk progresmu hari ini.');
    }

    public function calendar(Request $request, ScheduleService $schedules)
    {
        $data = $request->validate(['month' => ['nullable', 'date_format:Y-m']]);
        $monthValue = $data['month'] ?? today()->format('Y-m');
        $month = $schedules->month($request->user(), $monthValue);

        return view('intern.calendar', compact('month', 'monthValue') + ['holidayYears' => Holiday::selectRaw('YEAR(date) as year')->distinct()->pluck('year')->toArray()]);
    }

    public function history(Request $request)
    {
        $filter = $request->validate(['month' => ['nullable', 'date_format:Y-m'], 'status' => ['nullable', Rule::in(['flagged'])]]);
        $onlyFlagged = ($filter['status'] ?? null) === 'flagged';
        $month = $filter['month'] ?? today()->format('Y-m');
        $start = Carbon::createFromFormat('!Y-m', $month);
        $records = $request->user()->attendances()->when($onlyFlagged, fn ($q) => $q->where('photo_flagged', true), fn ($q) => $q->whereBetween('date', [$start->toDateString(), $start->copy()->endOfMonth()->toDateString()]))->with('ticket', 'currentClarification')->latest('date')->paginate(15)->withQueryString();

        return view('intern.history', compact('records', 'month', 'onlyFlagged'));
    }

    public function attendanceDetail(Request $request, Attendance $attendance)
    {
        abort_unless($request->user()->role === 'admin' || $attendance->user_id === $request->user()->id, 403);
        $attendance->load('user', 'ticket', 'currentClarification');
        $clarifications = $attendance->clarifications()->with('user')->latest('id')->paginate(5, ['*'], 'clarification_page')->withQueryString()->fragment('klarifikasi-foto');
        $requests = AttendanceRequest::with('reviewer')->where('user_id', $attendance->user_id)->where('start_date', '<=', $attendance->date)->where('end_date', '>=', $attendance->date)->latest()->orderByDesc('id')->paginate(5, ['*'], 'related_page')->withQueryString()->fragment('pengajuan-terkait');
        $logs = AuditLog::with('actor')->where('subject_type', 'Attendance')->where('subject_id', $attendance->id)->latest()->orderByDesc('id')->paginate(5, ['*'], 'audit_page')->withQueryString()->fragment('jejak-pencatatan');

        return view('shared.attendance-detail', compact('attendance', 'requests', 'logs', 'clarifications'));
    }

    public function photo(Request $request, Attendance $attendance, string $kind)
    {
        abort_unless($request->user()->is_active && ($request->user()->role === 'admin' || $attendance->user_id === $request->user()->id), 403);
        abort_unless(in_array($kind, ['in', 'out']), 404);
        $path = $kind === 'in' ? $attendance->in_photo : $attendance->out_photo;
        abort_unless($path && Storage::disk('local')->exists($path), 404);
        $response = response()->file(Storage::disk('local')->path($path), ['X-Content-Type-Options' => 'nosniff', 'Content-Type' => 'image/jpeg']);
        $response->setPrivate();
        $response->headers->set('Cache-Control', 'private, no-store');

        return $response;
    }

    public function requests(Request $request)
    {
        $tab = in_array($request->query('tab'), ['history', 'help']) ? $request->query('tab') : 'create';
        $status = $request->query('status', 'all');
        $allowed = $tab === 'help' ? ['all', 'open', 'in_progress', 'resolved'] : ['all', 'pending', 'approved', 'rejected'];
        $status = in_array($status, $allowed) ? $status : 'all';
        $user = $request->user();
        $requests = $tab === 'history' ? $user->attendanceRequests()->with('reviewer')->when($status !== 'all', fn ($q) => $q->where('status', $status))->latest()->orderByDesc('id')->paginate(6)->withQueryString() : null;
        $tickets = $tab === 'help' ? $user->tickets()->with('attendance')->when($status !== 'all', fn ($q) => $q->where('status', $status))->latest()->orderByDesc('id')->paginate(6)->withQueryString() : null;
        if ($redirect = $this->redirectPastLastPage($requests ?? $tickets)) {
            return $redirect;
        }

        return view('intern.requests', [
            'tab' => $tab, 'status' => $status,
            'pendingCount' => $user->attendanceRequests()->where('status', 'pending')->count(),
            'helpCount' => $user->tickets()->where('status', '!=', 'resolved')->count(),
            'requests' => $requests, 'tickets' => $tickets,
        ]);
    }

    public function submitRequest(Request $request, RequestService $service)
    {
        $data = $request->validate(['type' => ['required', Rule::in(['leave', 'sick', 'correction', 'manual'])], 'start_date' => ['required', 'date'], 'end_date' => ['required', 'date', 'after_or_equal:start_date'], 'reason' => ['required', 'string', 'min:10', 'max:2000'], 'clock_in' => ['nullable', 'required_if:type,manual,correction', 'date_format:H:i'], 'clock_out' => ['nullable', 'required_if:type,manual,correction', 'date_format:H:i'], 'work_note' => ['nullable', 'string', 'max:2000']]);
        if (Carbon::parse($data['start_date'])->diffInDays(Carbon::parse($data['end_date'])) > 30) {
            return back()->withErrors(['end_date' => 'Maksimal rentang pengajuan adalah 31 hari.'])->withInput();
        }
        $service->submit($request->user(), $data);

        return redirect()->route('requests', ['tab' => 'history'])->with('status', 'Pengajuan terkirim. Keputusan admin akan tampil di halaman ini.');
    }

    public function participants(Request $request)
    {
        $q = trim((string) $request->query('q', ''));
        $participants = User::where('role', 'intern')->when($q, fn ($query) => $query->where(fn ($sub) => $sub->where('name', 'like', '%'.$q.'%')->orWhere('email', 'like', '%'.$q.'%')->orWhere('department', 'like', '%'.$q.'%')))->orderBy('name')->paginate(15)->withQueryString();

        return view('admin.participants', compact('participants', 'q'));
    }

    public function participantForm(?User $participant = null)
    {
        if ($participant) {
            abort_unless($participant->role === 'intern', 404);
        }

        return view('admin.participant-form', compact('participant'));
    }

    public function saveParticipant(Request $request, ?User $participant = null)
    {
        if (is_string($request->input('email'))) {
            $request->merge(['email' => mb_strtolower(trim($request->input('email')))]);
        }
        if ($participant) {
            abort_unless($participant->role === 'intern', 404);
        }
        $data = $request->validate(['name' => ['required', 'string', 'max:100'], 'email' => [...AccountRules::email(), Rule::unique('users')->ignore($participant?->id)], 'employee_code' => ['required', 'string', 'max:40', Rule::unique('users')->ignore($participant?->id)], 'department' => ['required', 'string', 'max:100'], 'position' => ['required', 'string', 'max:100'], 'internship_start' => ['required', 'date'], 'internship_end' => ['required', 'date', 'after_or_equal:internship_start'], 'is_active' => ['required', 'boolean'], 'password' => [...AccountRules::password(! $participant), 'confirmed']]);
        if (empty($data['password'])) {
            unset($data['password']);
        }$before = $participant?->only(['name', 'email', 'department', 'is_active', 'internship_start', 'internship_end']);
        DB::transaction(function () use (&$participant, $data, $before) {
            if ($participant) {
                $participant->update($data);
            } else {
                $participant = User::create($data + ['role' => 'intern', 'email_verified_at' => now()]);
            }AuditLog::record('Profil peserta disimpan', $participant, $before, $participant->only(['name', 'email', 'department', 'is_active', 'internship_start', 'internship_end']));
        });

        return redirect()->route('admin.participants')->with('status', 'Data peserta berhasil disimpan.');
    }

    public function inbox(Request $request)
    {
        $tab = in_array($request->query('tab'), ['help', 'incomplete', 'flagged']) ? $request->query('tab') : 'requests';
        $data = $request->validate(['q' => 'nullable|string|max:100']);
        $q = trim($data['q'] ?? '');
        $status = $request->query('status', $tab === 'help' ? 'active' : 'pending');
        $allowed = $tab === 'help' ? ['active', 'open', 'in_progress', 'resolved', 'all'] : ['pending', 'approved', 'rejected', 'all'];
        $status = in_array($status, $allowed) ? $status : $allowed[0];
        $query = match ($tab) {
            'help' => SupportTicket::with('user', 'attendance')->when($status === 'active', fn ($query) => $query->where('status', '!=', 'resolved'))->when(! in_array($status, ['active', 'all']), fn ($query) => $query->where('status', $status))->latest()->orderByDesc('id'),
            'incomplete' => Attendance::with('user')->whereNull('clock_out')->whereDate('date', '<', today())->orderBy('date')->orderBy('id'),
            'flagged' => Attendance::with('user', 'currentClarification')->where('photo_flagged', true)->latest('date')->orderByDesc('id'),
            default => AttendanceRequest::with('user', 'reviewer')->when($status !== 'all', fn ($query) => $query->where('status', $status))->latest()->orderByDesc('id'),
        };
        $query->when($q !== '', fn ($query) => $query->whereHas('user', fn ($user) => $user->where(fn ($user) => $user->where('name', 'like', '%'.$q.'%')->orWhere('employee_code', 'like', '%'.$q.'%'))));
        $items = $query->paginate(6)->withQueryString();
        if ($redirect = $this->redirectPastLastPage($items)) {
            return $redirect;
        }

        return view('admin.inbox', [
            'tab' => $tab, 'status' => $status, 'q' => $q,
            'items' => $items,
            'counts' => [
                'requests' => AttendanceRequest::where('status', 'pending')->count(),
                'help' => SupportTicket::where('status', '!=', 'resolved')->count(),
                'incomplete' => Attendance::whereNull('clock_out')->whereDate('date', '<', today())->count(),
                'flagged' => Attendance::where('photo_flagged', true)->count(),
            ],
        ]);
    }

    public function reviewRequest(Request $request, AttendanceRequest $submission, RequestService $service)
    {
        $data = $request->validate(['decision' => ['required', Rule::in(['approved', 'rejected'])], 'review_note' => ['required', 'string', 'min:5', 'max:2000']]);
        $service->review($submission, $request->user(), $data['decision'], $data['review_note']);

        return back()->with('status', 'Keputusan pengajuan berhasil disimpan.');
    }

    public function respondTicket(Request $request, SupportTicket $ticket)
    {
        $data = $request->validate(['status' => ['required', Rule::in(['open', 'in_progress', 'resolved'])], 'message' => ['required', 'string', 'min:5', 'max:2000']]);
        DB::transaction(function () use ($request, $ticket, $data) {
            $ticket = SupportTicket::whereKey($ticket->id)->lockForUpdate()->firstOrFail();
            $before = $ticket->only(['status', 'responses']);
            $responses = $ticket->responses ?? [];
            $responses[] = ['name' => $request->user()->name, 'message' => $data['message'], 'at' => now()->toDateTimeString()];
            $ticket->update(['status' => $data['status'], 'responses' => $responses]);
            AuditLog::record('Kendala ditanggapi', $ticket, $before, $ticket->only(['status', 'responses']));
        });

        return back()->with('status', 'Tanggapan tersimpan dan dapat dibaca peserta.');
    }

    public function flagPhoto(Request $request, Attendance $attendance)
    {
        $data = $request->validate(['flagged' => ['required', 'boolean'], 'reason' => ['required', 'string', 'min:5', 'max:1000'], 'review_version' => ['required', 'integer', 'min:0']]);
        DB::transaction(function () use ($attendance, $data) {
            $attendance = Attendance::whereKey($attendance->id)->lockForUpdate()->firstOrFail();
            if ($attendance->photo_review_version !== (int) $data['review_version']) {
                throw ValidationException::withMessages(['reason' => 'Pemeriksaan sudah berubah. Muat ulang halaman sebelum menyimpan keputusan.']);
            }
            $before = $attendance->only(['photo_flagged', 'photo_flag_reason']);
            $attendance->update(['photo_flagged' => $data['flagged'], 'photo_flag_reason' => $data['reason'], 'photo_review_version' => $attendance->photo_review_version + 1]);
            AuditLog::record('Pemeriksaan bukti foto', $attendance, $before, $attendance->only(['photo_flagged', 'photo_flag_reason']));
        });

        return back()->with('status', 'Hasil pemeriksaan foto disimpan.');
    }

    public function clarifyPhoto(Request $request, Attendance $attendance)
    {
        abort_unless($attendance->user_id === $request->user()->id, 403);
        $data = $request->validate(['message' => ['required', 'string', 'min:10', 'max:2000', 'regex:/\S/'], 'review_version' => ['required', 'integer', 'min:0']]);
        DB::transaction(function () use ($request, $attendance, $data) {
            $attendance = Attendance::whereKey($attendance->id)->lockForUpdate()->firstOrFail();
            if (! $attendance->photo_flagged || $attendance->photo_review_version !== (int) $data['review_version']) {
                throw ValidationException::withMessages(['message' => 'Permintaan klarifikasi sudah berubah atau selesai. Muat ulang halaman.']);
            }
            if ($attendance->clarifications()->where('review_version', $attendance->photo_review_version)->exists()) {
                throw ValidationException::withMessages(['message' => 'Penjelasanmu sudah terkirim. Tunggu pemeriksaan admin.']);
            }
            $attendance->clarifications()->create(['user_id' => $request->user()->id, 'review_version' => $attendance->photo_review_version, 'request_reason' => $attendance->photo_flag_reason, 'message' => $data['message']]);
            AuditLog::record('Klarifikasi foto dikirim', $attendance, null, ['message' => $data['message']]);
        });

        return redirect()->route('attendance.detail', $attendance)->with('status', 'Penjelasan terkirim. Tunggu hasil pemeriksaan admin di halaman ini.');
    }

    public function settings(Request $request)
    {
        $data = $request->validate(['year' => 'nullable|integer|between:2020,2100', 'holiday_month' => 'nullable|integer|between:1,12']);
        $calendarYear = (int) ($data['year'] ?? today()->year);
        $holidayMonth = isset($data['holiday_month']) ? (int) $data['holiday_month'] : null;

        $tab = in_array($request->query('tab'), ['overrides', 'holidays']) ? $request->query('tab') : ($request->has('year') ? 'holidays' : 'schedule');

        return view('admin.settings', [
            'tab' => $tab, 'setting' => WorkSetting::current(), 'calendarYear' => $calendarYear, 'holidayMonth' => $holidayMonth,
            'overrides' => $tab === 'overrides' ? ScheduleOverride::with('user')->orderByDesc('date')->orderByDesc('id')->paginate(10)->withQueryString()->fragment('daftar-pengecualian') : null,
            'participants' => $tab === 'overrides' ? User::where('role', 'intern')->where('is_active', true)->orderBy('name')->get() : collect(),
            'holidays' => $tab === 'holidays' ? Holiday::whereYear('date', $calendarYear)->when($holidayMonth, fn ($q) => $q->whereMonth('date', $holidayMonth))->orderBy('date')->paginate(8)->withQueryString() : null,
        ]);
    }

    public function saveSettings(Request $request)
    {
        $data = $request->validate(['workdays' => ['required', 'array', 'min:1'], 'workdays.*' => ['required', 'integer', 'between:1,7', 'distinct'], 'start_time' => ['required', 'date_format:H:i'], 'end_time' => ['required', 'date_format:H:i', 'after:start_time'], 'grace_minutes' => ['required', 'integer', 'between:0,120'], 'default_mode' => ['required', Rule::in(['WFH', 'WFO'])], 'national_holidays_off' => ['required', 'boolean'], 'collective_leave_off' => ['required', 'boolean']]);
        $data['workdays'] = array_map('intval', $data['workdays']);
        DB::transaction(function () use ($data) {
            $setting = WorkSetting::current();
            $before = $setting->toArray();
            WorkSettingVersion::firstOrCreate(['effective_from' => '1900-01-01'], ['snapshot' => $before]);
            $setting->update($data);
            WorkSettingVersion::updateOrCreate(['effective_from' => today()->toDateString()], ['snapshot' => $setting->toArray()]);
            AuditLog::record('Jadwal dasar diperbarui', $setting, $before, $setting->toArray());
        });

        return back()->with('status', 'Jadwal dasar diperbarui. Acuan absensi yang sudah tercatat tetap tersimpan.');
    }

    public function saveOverride(Request $request)
    {
        $data = $request->validate(['user_id' => ['nullable', Rule::exists('users', 'id')->where('role', 'intern')], 'date' => ['required', 'date', 'after_or_equal:today'], 'is_workday' => ['required', 'boolean'], 'mode' => ['required', Rule::in(['WFH', 'WFO'])], 'start_time' => ['required', 'date_format:H:i'], 'end_time' => ['required', 'date_format:H:i', 'after:start_time'], 'reason' => ['required', 'string', 'min:10', 'max:1000']]);
        DB::transaction(function () use ($request, $data) {
            $record = ScheduleOverride::updateOrCreate(['user_id' => $data['user_id'] ?? null, 'date' => $data['date']], $data + ['created_by' => $request->user()->id]);
            AuditLog::record('Pengecualian jadwal disimpan', $record, null, $record->toArray());
        });

        return back()->with('status', 'Pengecualian jadwal berhasil disimpan.');
    }

    public function deleteOverride(ScheduleOverride $override)
    {
        abort_if($override->date->lt(today()), 422, 'Jadwal yang sudah berlalu tidak dapat dihapus.');
        DB::transaction(function () use ($override) {
            AuditLog::record('Pengecualian jadwal dihapus', $override, $override->toArray());
            $override->delete();
        });

        return back()->with('status', 'Pengecualian jadwal dihapus.');
    }

    public function profile()
    {
        return view('shared.profile');
    }

    public function updateProfile(Request $request)
    {
        $data = $request->validate(['current_password' => ['required', 'current_password'], 'password' => [...AccountRules::password(), 'confirmed']]);
        $request->user()->update(['password' => $data['password']]);
        $request->session()->regenerate();

        return back()->with('status', 'Kata sandi berhasil diperbarui.');
    }

    public function audit()
    {
        return view('admin.audit', ['logs' => AuditLog::with('actor')->latest()->paginate(25)]);
    }

    private function redirectPastLastPage($paginator)
    {
        if ($paginator && $paginator->currentPage() > $paginator->lastPage()) {
            session()->reflash();

            return redirect()->to($paginator->url($paginator->lastPage()));
        }

        return null;
    }
}
