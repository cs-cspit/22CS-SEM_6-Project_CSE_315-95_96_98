<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;

Route::get('/', function () {
    return view('welcome');
});

Route::get('register', [AuthController::class, 'showRegistrationForm'])->name('register');
Route::get('verify-otp', function () {
    return view('auth.verify_otp');
})->name('verify.otp');
Route::get('login', [AuthController::class, 'showLoginForm'])->name('login');

Route::post('verify-otp', [AuthController::class, 'verifyOtp']);
Route::post('login', [AuthController::class, 'login']);
Route::post('logout', [AuthController::class, 'logout'])->name('logout');
Route::post('register', [AuthController::class, 'register']);

Route::middleware(['auth'])->group(function () {
    Route::get('home', function () {
        return view('home');
    })->name('home');

});