import 'dart:convert';
import 'package:driver_app/api_helper/Authentication/auth.dart';
import 'package:driver_app/api_helper/Driver_basic/driver_basic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../state_classes/localization_provider.dart';
import 'package:driver_app/screens/Home/home_page.dart';
import 'package:driver_app/utils/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sign_up/signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  // Function to handle login API call
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    // Get phone and password values from the controllers
    String phone = phoneController.text;
    String password = passwordController.text;

    final response = await Auth.login(phoneNumber: phone, password: password);

    if (response['success'] == true) {
      final token = response['token'];
      _storeToken(token);
      DriverBasic driverBasic = DriverBasic();
      await driverBasic.getProfileAndStore(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Credentials')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          localization.translate('welcome_back'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          localization.translate('login_to_continue'),
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            hintText: localization.translate('phone_no'),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12)
                                .copyWith(left: 16), // Added left padding
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.translate('field_required');
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return localization.translate('invalid_phone');
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: localization.translate('password'),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12)
                                .copyWith(left: 16), // Added left padding
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.translate('field_required');
                            }
                            if (value.length < 6) {
                              return localization
                                  .translate('password_too_short');
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0E6E2F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _login();
                                  }
                                },
                          child: _isLoading
                              ? SizedBox(
                                  height: 25.0, // Set the height
                                  width: 25.0, // Set the width
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  localization.translate('login'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Text(
                            localization.translate('or_login_with'),
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            // Handle Google login
                          },
                          icon: Icon(Icons.account_circle, color: Colors.black),
                          label: Text(
                            localization.translate('login_with_google'),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 24),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()),
                              );
                            },
                            child: Text(
                              localization.translate('dont_have_an_account'),
                              style: TextStyle(
                                color: Color(0xFF0E6E2F),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 35,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.language),
              onPressed: () {
                _showLanguageSelectionSheet(context, localization);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelectionSheet(
      BuildContext context, LocalizationProvider localization) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('English'),
                onTap: () {
                  localization.loadLocale(Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('हिंदी'),
                onTap: () {
                  localization.loadLocale(Locale('hi'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('ગુજરાતી'),
                onTap: () {
                  localization.loadLocale(Locale('gu'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
