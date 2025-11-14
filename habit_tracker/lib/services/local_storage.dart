import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // Storage keys
  static const String _habitsKey = 'habits_data';
  static const String _themeModeKey = 'theme_data';

  // Get all habits data
  Future<Map<String, Map<String, bool>>> getAllHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_habitsKey);
    
    if (jsonString == null || jsonString.isEmpty) {
      return {};
    }
    
    try {
      final Map<String, dynamic> decoded = json.decode(jsonString);
      return decoded.map((date, habits) => 
        MapEntry(date, Map<String, bool>.from(habits as Map))
      );
    } catch (e) {
      return {};
    }
  }
  
  // Get habits for a specific date
  Future<Map<String, bool>> getHabitsForDate(String date) async {
    final allHabits = await getAllHabits();
    return allHabits[date] ?? {};
  }

  // Add or update a single habit for a specific date
  Future<bool> updateHabit(String date, String habitName, bool status) async {
    try {
      final allHabits = await getAllHabits();
      
      // Get existing habits for this date or create new map
      final dateHabits = allHabits[date] ?? {};
      
      // Update the specific habit
      dateHabits[habitName] = status;
      
      // Update the date entry
      allHabits[date] = dateHabits;
      
      // Save back to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(allHabits);
      return await prefs.setString(_habitsKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  // Delete a habit from a specific date
  Future<bool> deleteHabit(String date, String habitName) async {
    try {
      final allHabits = await getAllHabits();
      
      if (allHabits.containsKey(date)) {
        allHabits[date]?.remove(habitName);
        
        // Remove date entry if no habits left
        if (allHabits[date]?.isEmpty ?? true) {
          allHabits.remove(date);
        }
        
        final prefs = await SharedPreferences.getInstance();
        final jsonString = json.encode(allHabits);
        return await prefs.setString(_habitsKey, jsonString);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Clear all habits data
  Future<bool> clearAllHabits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_habitsKey);
    } catch (e) {
      return false;
    }
  }

  // Get all unique habit names
  Future<Set<String>> getAllHabitNames() async {
    final allHabits = await getAllHabits();
    final Set<String> habitNames = {};
    
    for (var dateHabits in allHabits.values) {
      habitNames.addAll(dateHabits.keys);
    }
    
    return habitNames;
  }




  /// Save the current theme mode
  static Future<void> saveThemeData({required ThemeMode currentTheme}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, currentTheme.toString());
  }

  /// Get the previously saved theme mode
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