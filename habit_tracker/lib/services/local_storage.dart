import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
    // Storage keys
  static const String _dailyDataKey = 'daily_data';
  static const String _themeModeKey = 'theme_data';

  
  /// Save the current theme mode
  static Future<void> saveThemeData({required ThemeMode currentTheme}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, currentTheme.toString());
  }

  /// Get the previously saved theme mode
  /// Returns null if no theme has been saved
  static Future<ThemeMode?> getThemeData() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeModeKey);
    
    if (themeString == null) return null;
    
    // Convert string back to ThemeMode enum
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        return null;
    }
  }
}