import 'package:driver_app/api_helper/Authentication/auth.dart';
import 'package:driver_app/api_helper/Driver_basic/driver_basic.dart';
import 'package:driver_app/screens/Home/home_page.dart';
import 'package:driver_app/state_classes/Authentication/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sign_in/login_page.dart';
import '../../state_classes/localization_provider.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false; // Toggle password visibility

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Function to pick the photo
  Future<void> pickPhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        context.read<AuthState>().updateImagePath(pickedFile.path);
      });
    }
  }

  // Function to make API call for signup
  Future<void> _signUp() async {
    final authState = context.read<AuthState>();

    // Call the API function
    final response = await Auth.signup(
      fullName: authState.fullName,
      phoneNumber: authState.phoneNumber,
      password: authState.walletAmount,  // assuming password is stored in walletAmount, update accordingly
      plateNumber: authState.plateNumber,
      imagePath: authState.imagePath, // This is the path of the uploaded photo
    );

    if (response['success'] == true) {
      // Successfully signed up
      final token = response['token'];
      _storeToken(token);
      DriverBasic driverBasic = DriverBasic();
      await driverBasic.getProfileAndStore(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Handle errors from the API response
      if (response.containsKey('errors')) {
        // Check for specific field errors like plate_number
        if (response['errors'].containsKey('plate_number')) {
          String plateNumberError = response['errors']['plate_number'][0];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(plateNumberError)),
          );
        } else if (response['errors'].containsKey('phone_no')) {
          String plateNumberError = response['errors']['phone_no'][0];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(plateNumberError)),
          );
        } else {
          // Show a generic error message if any other error exists
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'An error occurred')),
          );
        }
      } else {
        // Fallback error handling if the error is not related to validation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'An error occurred')),
        );
      }
    }
  }

  // Store token in SharedPreferences
  Future<void> _storeToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationProvider>(context);
    final authState = context.watch<AuthState>();

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.translate('earn_more_with_rickmate'),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      localization.translate('grow_your_business_with_us'),
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      initialValue: authState.fullName,
                      decoration: InputDecoration(
                        hintText: localization.translate('full_name'),
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.translate('field_required');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        context.read<AuthState>().updateFullName(value);
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: authState.phoneNumber,
                      decoration: InputDecoration(
                        hintText: localization.translate('phone_no'),
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.translate('field_required');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        context.read<AuthState>().updatePhoneNumber(value);
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: authState.walletAmount, // Assuming password is stored in walletAmount
                      obscureText: !_passwordVisible, // Toggle password visibility
                      decoration: InputDecoration(
                        hintText: localization.translate('password'),
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible; // Toggle visibility
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.translate('field_required');
                        }
                        if (value.length < 6) {
                          return localization.translate('password_too_short');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        context.read<AuthState>().updateWalletAmount(value);
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: authState.plateNumber,
                      decoration: InputDecoration(
                        hintText: localization.translate('rickmate_plate_number'),
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.translate('field_required');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        context.read<AuthState>().updatePlateNumber(value);
                      },
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: pickPhoto,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          authState.imagePath.isEmpty
                              ? localization.translate('upload_driver_photo')
                              : localization.translate('photo_uploaded'),
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signUp();
                        }
                      },
                      child: Text(
                        localization.translate('sign_up'),
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
                        localization.translate('or_signup_with'),
                        style: TextStyle(fontSize: 16, color: Colors.black54),
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
                        // Handle Google signup
                      },
                      icon: Icon(Icons.account_circle, color: Colors.black),
                      label: Text(
                        localization.translate('sign_up_with_google'),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          localization.translate('already_have_account'),
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
    );
  }
}
