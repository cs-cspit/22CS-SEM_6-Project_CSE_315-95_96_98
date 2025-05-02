import 'dart:convert';
import 'dart:io';
import 'package:driver_app/state_classes/Authentication/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driver_app/utils/app_constant.dart';
import 'package:http/http.dart' as http;

class DriverBasic {
  static Future<http.Response> toggleDuty(bool isOnDuty) async {
    final url = AppConstants.toggleDutyUrl;
    final body = {"on_duty": isOnDuty ? 1 : 0};

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString("auth_token") ?? "";

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode(body),
      );

      print(response.body);

      return response;
    } catch (e) {
      throw Exception("Failed to toggle duty: $e");
    }
  }

  Future<void> getProfileAndStore(context) async {
    final url = AppConstants.getProfileUrl;
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString("auth_token") ?? "";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          final driver = json['driver'];

          final authState = Provider.of<AuthState>(context, listen: false);
          authState.updateFullName(driver['full_name']);
          authState.updatePhoneNumber(driver['phone_no']);
          authState.updatePlateNumber(driver['plate_number']);
          authState.updateImagePath(driver['driver_photo'] ?? '');
          authState.updateOnDuty(driver['on_duty']);
          authState.updateIsAvailable(driver['is_available']);
          authState.updateWalletAmount(driver['wallet_amount']);
        } else {
          throw Exception("Failed to fetch profile.");
        }
      } else {
        throw Exception("Failed to fetch profile: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to get profile: $e");
    }
  }

  static Future<http.Response> updateDriverProfile({
    required String? name,
    required String? plateNumber,
    required File? profileImage,
    required BuildContext context,
  }) async {
    final url = AppConstants.updateProfileUrl;

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString("auth_token") ?? "";

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Authorization'] = 'Bearer $authToken';

    if (name != null && name.isNotEmpty) {
      request.fields['full_name'] = name;
    }
    if (plateNumber != null && plateNumber.isNotEmpty) {
      request.fields['plate_number'] = plateNumber;
    }
    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'driver_photo',
        profileImage.path,
      ));
    }

    final authState = Provider.of<AuthState>(context, listen: false);

    if (profileImage != null) {
      authState.updateImagePath(profileImage.path);
    }

    final response = await request.send();
    return http.Response.fromStream(response);
  }
}
