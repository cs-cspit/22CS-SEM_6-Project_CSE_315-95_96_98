@extends('layouts.app')

@section('title', 'Register')

@section('content')
@include('layouts.navbar')

<div class="container register-container">
    <div class="register-header">
        <h2>Create Your Account</h2>
        <p>Fill out the form to get started.</p>
    </div>
    <form method="POST" action="{{ route('register') }}">
        @csrf
        <div class="form-group">
            <label for="on_behalf">On Behalf</label>
            <select class="form-control" id="on_behalf" name="on_behalf">
                <option value="My Self">My Self</option>
                <option value="My Daughter">My Daughter</option>
                <option value="My Son">My Son</option>
            </select>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="first_name">First Name</label>
                <input type="text" class="form-control" id="first_name" name="first_name" placeholder="First Name">
            </div>
            <div class="form-group col-md-6">
                <label for="last_name">Last Name</label>
                <input type="text" class="form-control" id="last_name" name="last_name" placeholder="Last Name">
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="gender">Gender</label>
                <select class="form-control" id="gender" name="gender">
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <!-- Add other options here -->
                </select>
            </div>
            <div class="form-group col-md-6">
                <label for="dob">Date Of Birth</label>
                <input type="date" class="form-control" id="dob" name="dob" placeholder="Date Of Birth">
            </div>
        </div>
        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" class="form-control" id="email" name="email" placeholder="Email address">
        </div>
        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                <small class="form-text text-muted">Minimum 8 characters</small>
            </div>
            <div class="form-group col-md-6">
                <label for="password_confirmation">Confirm Password</label>
                <input type="password" class="form-control" id="password_confirmation" name="password_confirmation" placeholder="Confirm password" required>
                <small class="form-text text-muted">Minimum 8 characters</small>
            </div>
        </div>
        <div class="form-group form-check">
            <input type="checkbox" class="form-check-input" id="terms" name="terms" required>
            <label class="form-check-label" for="terms">By signing up you agree to our <a href="#" class="terms">terms and conditions.</a></label>
        </div>
        <button type="submit" class="btn btn-register">Create Account</button>
    </form>
    <div class="text-center mt-3">
        <p>Already have an account? <a href="{{ route('login') }}" class="text-primary">Login to your account</a></p>
    </div>
</div>

@include('layouts.footer')
@endsection
