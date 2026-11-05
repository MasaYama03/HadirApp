<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

return new class extends Migration
{
    private array $names = ['admin', 'peserta', 'raka', 'alya', 'dimas', 'salsabila', 'fajar', 'tiara', 'rizky', 'nadia', 'bagas', 'citra', 'ardiansyah', 'qa'];

    public function up(): void
    {
        DB::transaction(function () {
            foreach ($this->names as $name) {
                $user = DB::table('users')->where('email', $name.'@hadir.test')->first();
                if (! $user) {
                    continue;
                }
                $newEmail = $name.'.hadir@gmail.com';
                if (DB::table('users')->where('email', $newEmail)->where('id', '!=', $user->id)->exists()) {
                    throw new RuntimeException('Alamat email demo tujuan sudah digunakan. Perubahan dibatalkan.');
                }
                $changes = ['email' => $newEmail, 'updated_at' => now()];
                if (in_array($name, ['admin', 'peserta'])) {
                    $changes['password'] = Hash::make('Detikcom98');
                    $changes['remember_token'] = null;
                }
                DB::table('users')->where('id', $user->id)->update($changes);
            }
        });
    }

    public function down(): void
    {
        foreach ($this->names as $name) {
            DB::table('users')->where('email', $name.'.hadir@gmail.com')->update(['email' => $name.'@hadir.test']);
        }
    }
};
