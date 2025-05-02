import 'package:driver_app/api_helper/Driver_basic/driver_basic.dart';
import 'package:driver_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLoadingBar = false;

  @override
  void initState() {
    super.initState();
    _checkTokenAndFetchProfile();
    setState(() {
      _showLoadingBar = true;
    });
  }

  // Check token and fetch profile
  void _checkTokenAndFetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Retrieve token from shared preferences

    if (token != null && token.isNotEmpty) {
      try {
        DriverBasic driverBasic = DriverBasic();
        await driverBasic.getProfileAndStore(context);
        Navigator.pushReplacementNamed(context, '/home'); // Token and profile fetched, go to Home
      } catch (e) {
        Navigator.pushReplacementNamed(context, '/login'); // Error, go to Login
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login'); // No token, go to Login
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellowGreen,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/driver_captain.jpg',
              width: 180, // Adjust the width
              height: 180, // Adjust the height
            ),
          ),
          if (_showLoadingBar)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
