import 'package:shared_preferences/shared_preferences.dart';

import '../backend/models/account/user.dart';
import 'tools.dart';

class SharedPrefService {
  static final Future<SharedPreferences> _prefs = SharedPreferences
      .getInstance();


  static Future<void> saveIsGrid(bool value) async {
    (await _prefs).setBool('is_grid', value);
  }
  static Future<bool> getIsGrid() async {
    return (await _prefs).getBool('is_grid') ?? true;
  }

  static Future<void> saveIsDark(bool value) async {
    (await _prefs).setBool('is_dark_mode', value);
  }

  static Future<bool> getIsDark() async {
    return (await _prefs).getBool('is_dark_mode') ?? true;
  }

  static Future<void> saveIsSideBarOpen(bool value) async {
    (await _prefs).setBool('is_side_bar_open', value);
  }
  static Future<bool> getIsSideBarOpen() async {
    return (await _prefs).getBool('is_side_bar_open') ?? true;
  }

  // ----------------- language -----------------
  static Future<void> saveLanguage(String value) async {
    (await _prefs).setString('language', value);
  }
  static Future<String> getLanguage() async {
    return (await _prefs).getString('language') ?? 'en';
  }

  // ----------------- user -----------------
  static Future<void> saveUser(User user) async {
    (await _prefs).setString('user', user.toJson()); // JSON encoding
  }

  static Future<User> getUser() async {
    final str = (await _prefs).getString('user');
    if (str == null) {
      return User(name: "Guest", color: getRandomHighContrastColor()); // default
    }
    return User.fromJson(str);
  }
}