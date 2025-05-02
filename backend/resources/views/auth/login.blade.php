@extends('layouts.app')

@section('title', 'Login')

@section('content')
@include('layouts.navbar')

<div class="container login-container">
    <div class="login-header">
        <h2>Login to your account.</h2>
    </div>
    <form method="POST" action="{{ route('login') }}">
        @csrf
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" class="form-control" id="email" name="email" placeholder="Email address" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
        </div>
        <div class="form-group text-right">
            <a href="#" class="forgot-password">Forgot Password?</a>
        </div>
        <button type="submit" class="btn btn-login">Login to your account.</button>
    </form>
    <div class="text-center mt-3">
        <p>Don't have an account? <a href="{{ route('register') }}" class="text-primary">Create an account</a></p>
    </div>
</div>

@include('layouts.footer')
@endsection
