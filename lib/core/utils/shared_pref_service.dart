import 'dart:convert';

import 'package:leave_management/core/constants/storage_constants.dart';
import 'package:leave_management/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  // Save a string value to SharedPreferences
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Retrieve a string value from SharedPreferences
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  // Remove a value from SharedPreferences
  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Clear all values from SharedPreferences
  Future<void> clear(String appToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Save User Object
  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString(StorageConstants.userKey, userJson);
  }

  // Get User Object
  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(StorageConstants.userKey);

    if (userJson != null) {
      print('.................User fetched from Shared Preferences: $userJson');
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }
}
