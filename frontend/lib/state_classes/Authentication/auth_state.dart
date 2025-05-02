import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  String fullName = '';
  String phoneNumber = '';
  String plateNumber = '';
  String imagePath = '';
  int onDuty = 0;
  int isAvailable = 0;
  String walletAmount = '';

  void updateFullName(String name) {
    fullName = name;
    notifyListeners();
  }

  void updatePhoneNumber(String phone) {
    phoneNumber = phone;
    notifyListeners();
  }

  void updatePlateNumber(String plate) {
    plateNumber = plate;
    notifyListeners();
  }

  void updateImagePath(String path) {
    imagePath = path;
    notifyListeners();
  }

  void updateOnDuty(int duty) {
    onDuty = duty;
    notifyListeners();
  }

  void updateIsAvailable(int available) {
    isAvailable = available;
    notifyListeners();
  }

  void updateWalletAmount(String amount) {
    walletAmount = amount;
    notifyListeners();
  }

  void logout() {
    fullName = '';
    phoneNumber = '';
    plateNumber = '';
    imagePath = '';
    onDuty = 0;
    isAvailable = 0;
    walletAmount = '';
    notifyListeners();

    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
  }
}
