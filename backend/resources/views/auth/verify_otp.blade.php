@extends('layouts.app')

@section('title', 'Verify OTP')

@section('content')
    <form method="POST" action="{{ route('verify.otp') }}">
        @csrf
        <label for="otp">Enter OTP:</label>
        <input type="text" name="otp" required>
        <button type="submit">Verify</button>
    </form>
@endsection
