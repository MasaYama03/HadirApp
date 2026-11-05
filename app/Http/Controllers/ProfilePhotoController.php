<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Services\ProfilePhotoService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProfilePhotoController extends Controller
{
    public function store(Request $request, ProfilePhotoService $service)
    {
        $request->validate(['photo' => ['bail', 'required', 'file', 'image', 'mimes:jpg,jpeg,png,webp', 'extensions:jpg,jpeg,png,webp', 'max:2048', 'dimensions:min_width=80,min_height=80,max_width=4096,max_height=4096']], [
            'photo.required' => 'Pilih foto profil terlebih dahulu.',
            'photo.file' => 'Pilih berkas JPG, PNG, atau WebP untuk foto profil.',
            'photo.image' => 'Pilih gambar JPG, PNG, atau WebP yang valid.',
            'photo.mimes' => 'Foto profil harus berformat JPG, PNG, atau WebP.',
            'photo.extensions' => 'Nama berkas foto harus berakhiran .jpg, .jpeg, .png, atau .webp.',
            'photo.max' => 'Ukuran foto profil maksimal 2 MB. Pilih foto yang lebih kecil.',
            'photo.dimensions' => 'Ukuran foto harus 80–4096 piksel pada setiap sisi.',
        ]);
        $service->update($request->user(), $request->file('photo'));

        return redirect()->route('profile.edit')->with('status', 'Foto profil berhasil diperbarui.');
    }

    public function destroy(Request $request, ProfilePhotoService $service)
    {
        $service->remove($request->user());

        return redirect()->route('profile.edit')->with('status', 'Foto profil dihapus. Inisial namamu ditampilkan kembali.');
    }

    public function show(Request $request, User $user)
    {
        abort_unless($request->user()->role === 'admin' || $request->user()->id === $user->id, 403);
        abort_unless($user->profile_photo_path && Storage::disk('local')->exists($user->profile_photo_path), 404);
        $response = response()->file(Storage::disk('local')->path($user->profile_photo_path), ['Content-Type' => 'image/jpeg', 'X-Content-Type-Options' => 'nosniff']);
        $response->headers->set('Cache-Control', 'private, no-store');

        return $response;
    }
}
