<?php

namespace App\Services;

use App\Models\AuditLog;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class ProfilePhotoService
{
    public function update(User $user, UploadedFile $file): void
    {
        $bytes = $this->thumbnail($file);
        $newPath = 'avatars/'.$user->id.'/'.Str::uuid().'.jpg';
        $oldPath = null;
        try {
            DB::transaction(function () use ($user, $bytes, $newPath, &$oldPath) {
                $locked = User::whereKey($user->id)->lockForUpdate()->firstOrFail();
                abort_unless($locked->is_active, 403);
                $oldPath = $locked->profile_photo_path;
                if (! Storage::disk('local')->put($newPath, $bytes)) {
                    throw ValidationException::withMessages(['photo' => 'Foto belum berhasil disimpan. Silakan coba lagi.']);
                }
                $locked->forceFill(['profile_photo_path' => $newPath])->save();
                AuditLog::record('Foto profil diperbarui', $locked, ['has_photo' => (bool) $oldPath], ['has_photo' => true]);
            });
        } catch (\Throwable $error) {
            Storage::disk('local')->delete($newPath);
            throw $error;
        }
        if ($oldPath) {
            Storage::disk('local')->delete($oldPath);
        }
    }

    public function remove(User $user): void
    {
        $oldPath = null;
        DB::transaction(function () use ($user, &$oldPath) {
            $locked = User::whereKey($user->id)->lockForUpdate()->firstOrFail();
            abort_unless($locked->is_active, 403);
            $oldPath = $locked->profile_photo_path;
            if ($oldPath) {
                $locked->forceFill(['profile_photo_path' => null])->save();
                AuditLog::record('Foto profil dihapus', $locked, ['has_photo' => true], ['has_photo' => false]);
            }
        });
        if ($oldPath) {
            Storage::disk('local')->delete($oldPath);
        }
    }

    private function thumbnail(UploadedFile $file): string
    {
        $source = @imagecreatefromstring($file->getContent());
        if (! $source) {
            throw ValidationException::withMessages(['photo' => 'Foto tidak dapat dibaca. Pilih gambar JPG, PNG, atau WebP yang valid.']);
        }
        $image = imagecreatetruecolor(512, 512);
        imagefill($image, 0, 0, imagecolorallocate($image, 255, 255, 255));
        $side = min(imagesx($source), imagesy($source));
        imagecopyresampled($image, $source, 0, 0, (int) ((imagesx($source) - $side) / 2), (int) ((imagesy($source) - $side) / 2), 512, 512, $side, $side);
        imagedestroy($source);
        // Orient the small square after cropping to avoid rotating a full-size upload in memory.
        $exif = $file->getMimeType() === 'image/jpeg' && function_exists('exif_read_data') ? @exif_read_data($file->getRealPath()) : false;
        $orientation = (int) ($exif['Orientation'] ?? 1);
        if (in_array($orientation, [2, 5, 7])) {
            imageflip($image, IMG_FLIP_HORIZONTAL);
        } elseif ($orientation === 4) {
            imageflip($image, IMG_FLIP_VERTICAL);
        }
        $angle = [3 => 180, 5 => 90, 6 => -90, 7 => -90, 8 => 90][$orientation] ?? 0;
        if ($angle) {
            $rotated = imagerotate($image, $angle, 0);
            imagedestroy($image);
            $image = $rotated;
        }
        ob_start();
        imagejpeg($image, null, 85);
        $bytes = ob_get_clean();
        imagedestroy($image);

        return $bytes;
    }
}
