<?php

namespace App\Services;

use App\Models\Holiday;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class HolidayService
{
    public function import(int $year): int
    {
        $file = database_path('data/holidays-'.$year.'.json');
        if (! is_file($file)) {
            throw ValidationException::withMessages(['year' => 'Data resmi untuk tahun ini belum tersedia. Tahun yang tersedia: 2026 dan 2027.']);
        }
        $data = json_decode(file_get_contents($file), true, 512, JSON_THROW_ON_ERROR);

        return DB::transaction(function () use ($data) {
            foreach ($data['holidays'] as $holiday) {
                Holiday::updateOrCreate(['date' => $holiday['date'], 'type' => $holiday['type']], ['name' => $holiday['name'], 'source' => $data['source']]);
            }

            return count($data['holidays']);
        });
    }
}
