import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  final SharedPreferences prefs;
  UserPreference(this.prefs);

  Future<void> setToken(String newToken) async {
    debugPrint("SAVED TOKEN => $newToken");
    await prefs.setString("token", newToken);
  }

  String? getToken() {
    return prefs.getString("token");
  }

  Future<void> setUserId(String uid) async {
    await prefs.setString("user_id", uid);
  }

  String? getUserId() {
    return prefs.getString("user_id");
  }

  Future<void> setUserName(String name) async {
    await prefs.setString("user_name", name);
  }

  String? getUserName() {
    return prefs.getString("user_name");
  }

  Future<void> setUserEmail(String email) async {
    await prefs.setString("user_email", email);
  }

  String? getUserEmail() {
    return prefs.getString("user_email");
  }

  Future<void> setLastLoginTime(DateTime time) async {
    await prefs.setString("last_login_time", time.toIso8601String());
  }

  DateTime? getLastLoginTime() {
    final str = prefs.getString("last_login_time");
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  Future<void> clearData() async {
    await prefs.clear();
  }
}
