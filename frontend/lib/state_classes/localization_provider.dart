import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  Map<String, String> _localizedStrings = {};

  Locale get currentLocale => _currentLocale;

  Future<void> loadLocale(Locale locale) async {
    _currentLocale = locale;
    try {
      final jsonString = await rootBundle
          .loadString('assets/language/${locale.languageCode}.json');
      _localizedStrings = Map<String, String>.from(json.decode(jsonString));
    } catch (e) {
      print('Error loading locale for ${locale.languageCode}: $e');
      _localizedStrings = {}; // Default to an empty map or fallback logic
    }
    notifyListeners();
    _saveLocale(locale.languageCode);
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  void toggleLocale() {
    if (_currentLocale.languageCode == 'en') {
      loadLocale(const Locale('hi'));
    } else {
      loadLocale(const Locale('en'));
    }
  }

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    if (['en', 'hi'].contains(languageCode)) {
      await loadLocale(Locale(languageCode));
    } else {
      await loadLocale(Locale('en')); // Fallback to English
    }
  }

  Future<void> _saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }

  static LocalizationProvider of(BuildContext context) {
    return Provider.of<LocalizationProvider>(context, listen: false);
  }
}
