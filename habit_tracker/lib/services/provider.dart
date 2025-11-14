import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_storage.dart';


class DataProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();

  // Store all habits data: date -> {habitName: status}
  Map<String, Map<String, bool>> _habits = {};

  // Loading state
  bool _isLoading = false;

  // Getters
  Map<String, Map<String, bool>> get habits => _habits;
  bool get isLoading => _isLoading;
  
  // Get habits for a specific date
  Map<String, bool> getHabitsForDate(String date) {
    return _habits[date] ?? {};
  }
  
  // Get status of a specific habit on a specific date
  bool getHabitStatus(String date, String habitName) {
    return _habits[date]?[habitName] ?? false;
  }

  // Load all habits from storage
  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _habits = await _storage.getAllHabits();
    } catch (e) {
      _habits = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add or update a single habit
  Future<bool> updateHabit(String date, String habitName, bool status) async {
    try {
      // Update in storage
      final success = await _storage.updateHabit(date, habitName, status);
      
      if (success) {
        // Update local state
        if (!_habits.containsKey(date)) {
          _habits[date] = {};
        }
        _habits[date]![habitName] = status;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // Toggle habit status
  Future<bool> toggleHabit(String date, String habitName) async {
    final currentStatus = getHabitStatus(date, habitName);
    return await updateHabit(date, habitName, !currentStatus);
  }
  
  // Delete a habit from a specific date
  Future<bool> deleteHabit(String date, String habitName) async {
    try {
      final success = await _storage.deleteHabit(date, habitName);
      
      if (success) {
        _habits[date]?.remove(habitName);
        if (_habits[date]?.isEmpty ?? true) {
          _habits.remove(date);
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // Clear all habits
  Future<bool> clearAllHabits() async {
    try {
      final success = await _storage.clearAllHabits();
      
      if (success) {
        _habits.clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
    // Get all unique habit names
  Set<String> getAllHabitNames() {
    final Set<String> habitNames = {};
    for (var dateHabits in _habits.values) {
      habitNames.addAll(dateHabits.keys);
    }
    return habitNames;
  }

  // Get completion rate for a date
  double getCompletionRate(String date) {
    final dateHabits = getHabitsForDate(date);
    if (dateHabits.isEmpty) return 0.0;
    
    final completed = dateHabits.values.where((status) => status).length;
    return completed / dateHabits.length;
  }

  // Get streak for a specific habit
  int getHabitStreak(String habitName, List<String> sortedDates) {
    int streak = 0;
    
    for (var date in sortedDates.reversed) {
      if (getHabitStatus(date, habitName)) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }
  
}