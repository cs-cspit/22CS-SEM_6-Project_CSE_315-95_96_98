import 'dart:convert';
import 'package:driver_app/utils/app_constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// API URL (replace with your actual URL)
const String apiUrl = AppConstants.registerDriverUrl;

class Auth {
  // Function to handle the signup API request
  static Future<Map<String, dynamic>> signup({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String plateNumber,
    String? imagePath, // Now nullable
  }) async {
    try {
      // Create a multipart request to send the image and data
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Adding data to the request body
      request.fields['full_name'] = fullName;
      request.fields['phone_no'] = phoneNumber;
      request.fields['password'] = password;
      request.fields['plate_number'] = plateNumber;

      // Adding the image file if imagePath is provided
      if (imagePath != null) {
        var imageFile =
            await http.MultipartFile.fromPath('driver_photo', imagePath);
        request.files.add(imageFile);
      }

      // Send the request
      var response = await request.send();

      var responseData = await http.Response.fromStream(response);
      var json = jsonDecode(responseData.body);
      return json;
    } catch (e) {
      // Catch any error during the request
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.loginDriverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_no': phoneNumber,
          'password': password,
        }),
      );

      // Directly use the response.body as it is already a http.Response
      var json = jsonDecode(response.body);
      return json;
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
