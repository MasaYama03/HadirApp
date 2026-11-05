# Hadir

Aplikasi absensi peserta magang berbasis Laravel. Peserta melakukan clock-in dan clock-out dengan selfie, menulis catatan pekerjaan, melihat kalender, serta mengajukan izin, sakit, koreksi, dan klarifikasi foto. Admin memantau seluruh peserta, meninjau pengajuan dan bantuan, mengatur jadwal serta hari libur, dan mengunduh rekap Excel.

**Aplikasi:** [hadir.masayama.my.id](https://hadir.masayama.my.id/login). Akun demonstrasi tersedia pada bagian [Akun contoh](#akun-contoh).

## Kebutuhan

- PHP 8.3 64-bit. Dependensi ZIP untuk ekspor Excel pada `composer.lock` memerlukan PHP 64-bit versi 8.3 atau lebih baru dalam seri 8.x.
- Composer 2.
- MySQL atau MariaDB.
- Ekstensi PHP: PDO MySQL, GD, EXIF, mbstring, fileinfo, intl, ZIP, DOM, SimpleXML, XML, XMLReader, dan XMLWriter. Composer akan memeriksa persyaratan dependensi saat instalasi.
- Browser yang mendukung kamera. Gunakan HTTPS untuk domain `.test` atau hosting. `http://127.0.0.1` dapat dipakai untuk mencoba kamera di komputer sendiri.
- Node.js 22 dan npm hanya diperlukan jika ingin mengubah atau membangun ulang frontend. Aset hasil build sudah tersedia di `public/build`.

## Instalasi

Buka terminal pada direktori yang berisi file `artisan` ini.

1. Pasang dependensi aplikasi:

   ```powershell
   composer install --no-dev --optimize-autoloader
   ```

2. Salin konfigurasi contoh:

   ```powershell
   Copy-Item .env.example .env
   ```

   Pada macOS atau Linux, gunakan `cp .env.example .env`.

3. Buat database baru melalui klien MySQL/MariaDB atau aplikasi pengelola database:

   ```sql
   CREATE DATABASE hadir CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

4. Buka `.env` dan sesuaikan pengaturan berikut dengan database dan alamat aplikasi di komputer Anda:

   ```dotenv
   APP_NAME=Hadir
   APP_ENV=local
   APP_DEBUG=false
   APP_URL=https://hadir.test

   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=hadir
   DB_USERNAME=root
   DB_PASSWORD=

   SESSION_DRIVER=file
   SESSION_ENCRYPT=true
   SESSION_SECURE_COOKIE=true
   CACHE_STORE=file
   QUEUE_CONNECTION=sync
   FILESYSTEM_DISK=local
   ```

   `DB_USERNAME`, `DB_PASSWORD`, `DB_HOST`, dan `DB_PORT` mengikuti server database Anda. Jangan menyalin kredensial milik komputer lain. `APP_KEY` tidak perlu diisi manual; perintah berikut akan membuatnya.

5. Buat kunci aplikasi, lalu pilih salah satu cara mengisi database: migration dan seeder berikut, atau impor SQL pada bagian alternatif di bawah.

   ```powershell
   php artisan key:generate
   php artisan migrate --seed
   ```

   Migration membuat tabel aplikasi. Seeder membuat akun admin, 12 peserta, jadwal, data libur Indonesia 2026 dan 2027, serta contoh absensi dan pengajuan. Jalankan instalasi awal pada database khusus aplikasi yang baru. Untuk pembaruan struktur database berikutnya, gunakan `php artisan migrate`; tidak perlu menghapus data atau mengulang seeder.

6. Pastikan direktori `storage` dan `bootstrap/cache` dapat ditulis oleh PHP, kemudian pilih salah satu cara menjalankan di bawah.

## Alternatif: impor SQL dengan data dummy

Jika migration terkendala atau ingin memakai data demonstrasi yang sudah disiapkan, gunakan [`database/snapshots/hadir-demo.sql`](database/snapshots/hadir-demo.sql). File ini berisi struktur 18 tabel beserta datanya, termasuk tabel `migrations`. Snapshot diambil pada 5 November 2026 dan berisi 1 admin, 12 peserta, 107 catatan absensi, 25 pengajuan, jadwal, serta 51 tanggal libur. Tanggal dan status dalam snapshot mengikuti kondisi saat ekspor; seeder pada cara instalasi sebelumnya membuat data berdasarkan tanggal saat dijalankan.

Tetap lakukan langkah instalasi 1–4. Pada instalasi baru, buat kunci dengan `php artisan key:generate`. Jika hosting sudah memiliki `.env` yang dikonfigurasi, gunakan konfigurasi tersebut.

### Melalui phpMyAdmin atau cPanel

1. Buka phpMyAdmin dan pilih database aplikasi yang masih kosong. Pada cPanel, gunakan nama database lengkap beserta awalan akun hosting.
2. Pilih tab **Import**, pilih `database/snapshots/hadir-demo.sql`, gunakan format **SQL**, lalu jalankan impor.
3. Pastikan `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`, dan pengaturan koneksi pada `.env` sesuai database tujuan. Berkas SQL tidak membuat database baru atau mengganti pengguna database.
4. Salin isi [`database/snapshots/files/private`](database/snapshots/files/private) ke `storage/app/private`, dengan mempertahankan struktur folder `demo` dan `avatars`. Pada cPanel, lakukan melalui File Manager. Folder sumber ini menyertakan foto contoh yang dirujuk oleh data SQL; SQL sendiri hanya menyimpan lokasi berkasnya.
5. Setelah impor dan penyalinan berkas selesai, buka aplikasi dan masuk menggunakan akun contoh di bawah.

### Melalui terminal

Gunakan nama database yang sama dengan `.env` pada argumen terakhir. Contoh berikut memakai database `hadir` dan meminta kata sandi secara interaktif:

```bash
mysql --host=127.0.0.1 --port=3306 --user=root --password hadir
```

Di dalam klien MySQL/MariaDB, jalankan dari direktori proyek:

```sql
SOURCE database/snapshots/hadir-demo.sql;
EXIT;
```

Kemudian salin berkas foto. Pada Windows PowerShell:

```powershell
Copy-Item -Path database/snapshots/files/private/* -Destination storage/app/private -Recurse -Force
```

Pada macOS atau Linux:

```bash
cp -R database/snapshots/files/private/. storage/app/private/
```

Jika klien yang tersedia bernama `mariadb`, ganti perintah `mysql` dengan `mariadb`. Untuk versi proyek ini, pilih **migration + seeder** atau **impor SQL**, bukan keduanya. Setelah impor SQL, tidak perlu menjalankan `migrate --seed` lagi. Untuk perubahan struktur pada versi aplikasi berikutnya, gunakan `php artisan migrate` sesuai migration baru. Bila konfigurasi `.env` diubah, jalankan `php artisan config:clear`; pada hosting produksi, lanjutkan dengan `php artisan config:cache`.

## Menjalankan dengan Laravel Herd

1. Tambahkan direktori proyek ini sebagai situs di Herd. Direktori aplikasi adalah folder yang berisi `artisan`, bukan `public`.
2. Aktifkan HTTPS pada situs tersebut. Sesuaikan `APP_URL` dengan domain yang ditampilkan Herd, misalnya `https://hadir.test`.
3. Gunakan `SESSION_SECURE_COOKIE=true` untuk HTTPS.
4. Buka alamat situs di browser dan izinkan akses kamera ketika diminta.

Jika memakai web server selain Herd, document root harus mengarah ke direktori `public`. Direktori aplikasi dan `.env` tidak boleh menjadi document root.

## Menjalankan tanpa Herd

Ubah dua nilai berikut di `.env`:

```dotenv
APP_URL=http://127.0.0.1:8000
SESSION_SECURE_COOKIE=false
```

Kemudian jalankan:

```powershell
php artisan optimize:clear
php artisan serve --host=127.0.0.1 --port=8000
```

Buka `http://127.0.0.1:8000/login` dan biarkan terminal server tetap berjalan. Tautan `.test` pada panduan Word menggunakan Herd; pada cara ini gunakan alamat localhost di atas.

## Akun contoh

| Peran | Email | Kata sandi |
| --- | --- | --- |
| Admin | admin.hadir@gmail.com | Detikcom98 |
| Peserta Masahiro | peserta.hadir@gmail.com | Detikcom98 |

Email akun menggunakan format Gmail. Kata sandi minimal 8 karakter, mengandung sedikitnya 1 huruf besar dan 1 angka. Admin dapat membuat akun tambahan dan mengatur ulang kata sandi melalui Data peserta.

Data seeder dan snapshot SQL digunakan untuk demonstrasi. Akun Masahiro menggunakan dua foto contoh dari pemilik akun; akun peserta lain memakai ilustrasi bertanda DATA DEMO. Snapshot SQL juga menyertakan aktivitas demonstrasi yang tersimpan saat ekspor. Ubah kredensial akun contoh sebelum penggunaan di lingkungan publik.

## Mencoba fitur

- **Peserta:** pilih Mulai clock-in, buka kamera, ambil selfie, periksa, lalu simpan. Saat pulang, lakukan clock-out dengan selfie baru dan catatan pekerjaan.
- **Kalender:** pilih bulan dan tanggal untuk melihat status hadir, alpa, izin, sakit, libur, atau sesi belum lengkap.
- **Pengajuan dan bantuan:** kirim izin, sakit, koreksi, atau absensi manual; baca keputusan dan tanggapan admin pada tab terkait.
- **Klarifikasi foto:** peserta membaca catatan admin pada detail absensi dan mengirim penjelasan. Admin dapat menyelesaikan pemeriksaan atau meminta penjelasan lanjutan.
- **Admin:** gunakan Pantau peserta untuk melihat tim dalam satu daftar, serta Tindak lanjut untuk meninjau pengajuan dan bantuan.
- **Jadwal:** atur hari kerja, jam, toleransi, WFH/WFO, ketentuan libur nasional/cuti bersama, dan pengecualian tanggal.
- **Laporan:** pilih rentang tanggal dan peserta, lalu klik Ekspor Excel. Berkas `.xlsx` berisi tabel sederhana dengan header kuning dan mengikuti seluruh hasil filter.

Panduan fitur dan penggunaan tersedia dalam [Panduan Demo App Hadir.pdf](Panduan%20Demo%20App%20Hadir.pdf).

## Mengubah frontend

Langkah ini opsional karena hasil build sudah disertakan:

```powershell
npm ci
npm run build
```

Untuk pengembangan tampilan, jalankan `npm run dev` pada terminal terpisah. Hentikan server Vite setelah selesai, lalu jalankan `npm run build` agar aset siap dipakai kembali tanpa server Vite.

## Penyimpanan dan konfigurasi tambahan

- Waktu aplikasi menggunakan Asia/Jakarta atau WIB.
- Foto selfie dan foto profil disimpan privat dalam `storage/app/private`, diakses melalui rute yang memeriksa hak akses peserta/admin.
- Upload selfie maksimal 5 MB; foto profil maksimal 2 MB. Sesuaikan batas upload PHP dan web server agar tidak lebih kecil dari kebutuhan tersebut.
- Cache dan sesi menggunakan file; fitur utama tidak memerlukan Redis atau queue worker terpisah.
- Kalender libur menyertakan data 2026 dan 2027. Data tahun lain perlu ditambahkan setelah jadwal resminya tersedia.
- Pengaturan `MAIL_MAILER=log` sesuai contoh tidak memerlukan SMTP. Pembuatan akun dan bantuan reset kata sandi dilakukan admin.

## Jika ada kendala

- **Koneksi database gagal:** pastikan MySQL/MariaDB aktif, database sudah dibuat, dan nilai `DB_*` benar. Port contoh adalah 3306; ubah bila server memakai port lain.
- **No application encryption key:** jalankan `php artisan key:generate`.
- **Tabel belum tersedia atau migration terkendala:** pada database baru yang kosong, pilih `php artisan migrate --seed` atau impor `database/snapshots/hadir-demo.sql` sesuai panduan alternatif di atas. Jika instalasi sempat membuat sebagian tabel, gunakan database baru yang kosong untuk impor SQL agar tabel tidak bentrok.
- **Foto contoh tidak tampil setelah impor SQL:** salin isi `database/snapshots/files/private` ke `storage/app/private`, dengan mempertahankan struktur subfoldernya.
- **Login kembali ke halaman masuk:** samakan `APP_URL` dengan alamat yang dibuka dan gunakan `SESSION_SECURE_COOKIE=false` untuk HTTP localhost. Jalankan `php artisan optimize:clear` setelah mengubah konfigurasi.
- **Kamera tidak dapat digunakan:** izinkan akses kamera dan gunakan HTTPS atau localhost. Jika perangkat tidak mendukung kamera, peserta dapat mengajukan absensi manual untuk ditinjau admin.
- **Tampilan tidak termuat:** pastikan file pada `public/build` tersedia. Jika frontend diubah, jalankan `npm ci` dan `npm run build`.
- **Error izin tulis:** periksa akses tulis `storage` dan `bootstrap/cache`.
