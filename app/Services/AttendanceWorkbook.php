<?php

namespace App\Services;

use Illuminate\Support\Collection;
use PhpOffice\PhpSpreadsheet\Cell\DataType;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;

class AttendanceWorkbook
{
    public function make(Collection $rows, array $filters, string $creator): Spreadsheet
    {
        $book = new Spreadsheet;
        $book->getProperties()->setCreator($creator)->setTitle('Rekap absensi')->setSubject('Periode '.$filters['from'].' sampai '.$filters['to']);
        $book->getDefaultStyle()->getFont()->setName('Calibri')->setSize(11)->getColor()->setRGB('000000');
        $sheet = $book->getActiveSheet();
        $sheet->setTitle('Rekap absensi');
        $headers = ['Kode peserta', 'Nama peserta', 'Divisi', 'Terjadwal (hari)', 'Hadir lengkap (hari)', 'Belum lengkap (hari)', 'Alpa (hari)', 'Izin (hari)', 'Sakit (hari)', 'Menunggu (hari)', 'Klarifikasi (hari)', 'Terlambat (hari)', 'Durasi (jam)'];
        $sheet->fromArray($headers, null, 'A1');
        $sheet->getStyle('A1:M1')->applyFromArray([
            'fill' => ['fillType' => Fill::FILL_SOLID, 'startColor' => ['rgb' => 'FFFF00']],
            'font' => ['bold' => true],
            'alignment' => ['vertical' => Alignment::VERTICAL_CENTER, 'wrapText' => true],
        ]);
        $sheet->getRowDimension(1)->setRowHeight(32);
        $line = 2;
        foreach ($rows as $row) {
            // Identifiers and user-controlled text stay text, including leading zeros.
            foreach (['A' => $row['user']->employee_code, 'B' => $row['user']->name, 'C' => $row['user']->department] as $column => $value) {
                $sheet->setCellValueExplicit($column.$line, (string) $value, DataType::TYPE_STRING);
            }
            $sheet->fromArray([$row['workdays'], $row['present'], $row['incomplete'], $row['absent'], $row['leave'], $row['sick'], $row['pending'], $row['flagged'], $row['late'], $row['duration'] / 60], null, 'D'.$line, true);
            $sheet->getStyle('B'.$line.':C'.$line)->getAlignment()->setWrapText(true);
            $sheet->getRowDimension($line)->setRowHeight(max(20, (int) ceil(mb_strlen($row['user']->name) / 32) * 15, (int) ceil(mb_strlen($row['user']->department ?? '') / 24) * 15));
            $line++;
        }
        $last = max(1, $line - 1);
        $sheet->getStyle('A1:M'.$last)->getBorders()->getAllBorders()->setBorderStyle(Border::BORDER_THIN)->getColor()->setRGB('000000');
        if ($last >= 2) {
            $sheet->getStyle('A2:M'.$last)->getAlignment()->setVertical(Alignment::VERTICAL_CENTER);
            $sheet->getStyle('D2:L'.$last)->getNumberFormat()->setFormatCode('0');
            $sheet->getStyle('M2:M'.$last)->getNumberFormat()->setFormatCode('0.0');
        }
        foreach (['A' => 20, 'B' => 36, 'C' => 26, 'D' => 18, 'E' => 20, 'F' => 21, 'G' => 14, 'H' => 14, 'I' => 14, 'J' => 18, 'K' => 18, 'L' => 18, 'M' => 17] as $column => $width) {
            $sheet->getColumnDimension($column)->setWidth($width);
        }
        $sheet->setAutoFilter('A1:M'.$last);
        $sheet->freezePane('A2');
        $sheet->setSelectedCell('A1');

        return $book;
    }
}
