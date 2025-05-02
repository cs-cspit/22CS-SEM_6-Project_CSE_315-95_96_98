<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;

class AuthController extends Controller
{
    public function showRegistrationForm()
    {
        return view('auth.register');
    }

    public function showLoginForm()
    {
        return view('auth.login');
    }

    public function register(Request $request)
    {
        $name = $request->input('name');
        $email = $request->input('email');
        $phone_no = $request->input('phone_no');
        $password = $request->input('password');
        $password_confirmation = $request->input('password_confirmation');

        if (empty($name) || empty($email) || empty($password) || empty($password_confirmation)) {
            return redirect()->back()->with('error', 'All fields are required');
        }

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return redirect()->back()->with('error', 'Invalid email format');
        }

        if (User::where('email', $email)->exists()) {
            return redirect()->back()->with('error', 'Email already exists');
        }

        if (!empty($phone_no) && User::where('phone_no', $phone_no)->exists()) {
            return redirect()->back()->with('error', 'Phone number already exists');
        }

        if ($password !== $password_confirmation) {
            return redirect()->back()->with('error', 'Passwords do not match');
        }

        if (strlen($password) < 8) {
            return redirect()->back()->with('error', 'Password must be at least 8 characters long');
        }

        // Generate OTP and send it to the user
        $otp = rand(100000, 999999);
        $request->session()->put('otp', $otp);
        $request->session()->put('name', $name);
        $request->session()->put('email', $email);
        $request->session()->put('phone_no', $phone_no);
        $request->session()->put('password', $password);

        // Send OTP email (implement the Mailable class for OTP email)
        Mail::to($email)->send(new \App\Mail\OtpMail($otp));

        return redirect()->route('verify.otp')->with('success', 'OTP sent to your email');
    }

    public function verifyOtp(Request $request)
    {
        $otp = $request->input('otp');

        if ($otp == $request->session()->get('otp')) {
            // Save user to the database
            $user = User::create([
                'name' => $request->session()->get('name'),
                'email' => $request->session()->get('email'),
                'phone_no' => $request->session()->get('phone_no'),
                'password' => Hash::make($request->session()->get('password')),
            ]);

            Auth::login($user);
            return redirect()->route('home')->with('success', 'Registration successful');
        }

        return redirect()->back()->with('error', 'Invalid OTP');
    }

    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        if (Auth::attempt($credentials)) {
            return redirect()->intended('home')->with('success', 'Login successful');
        }

        return redirect()->back()->with('error', 'Invalid credentials');
    }

    public function logout()
    {
        Auth::logout();
        return redirect()->route('login')->with('success', 'Logged out successfully');
    }
}
