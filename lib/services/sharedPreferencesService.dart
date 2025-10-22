import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/models/userMeta.dart';
import '../tools/tools.dart';

class SharedPrefService {
  static final Future<SharedPreferences> _prefs = SharedPreferences
      .getInstance();

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

  // ----------------- isAutoSync -----------------
  static Future<void> saveIsAutoSync(bool value) async {
    (await _prefs).setBool('is_auto_sync', value);
  }

  static Future<bool> getIsAutoSync() async {
    return (await _prefs).getBool('is_auto_sync') ?? false;
  }

  // ----------------- isOfflineMode -----------------
  static Future<void> saveIsOfflineMode(bool value) async {
    (await _prefs).setBool('is_offline_mode', value);
  }
  static Future<bool> getIsOfflineMode() async {
    return (await _prefs).getBool('is_offline_mode') ?? false;
  }

  // ----------------- Download Limit -----------------
  static Future<void> saveDownloadLimit(int value) async {
    await (await _prefs).setInt('download_limit', value);
  }

  static Future<int> getDownloadLimit() async {
    return (await _prefs).getInt('download_limit') ?? -1; // -1 = unlimited
  }

// ----------------- Upload Limit -----------------
  static Future<void> saveUploadLimit(int value) async {
    await (await _prefs).setInt('upload_limit', value);
  }

  static Future<int> getUploadLimit() async {
    return (await _prefs).getInt('upload_limit') ?? -1; // -1 = unlimited
  }
  static Future<void> saveUploadLimitUnit(String value) async {
    (await _prefs).setString('upload_limit_unit', value);
  }
  static Future<String> getUploadLimitUnit() async {
    return (await _prefs).getString('upload_limit_unit') ?? 'KB';
  }
  // ----------------- storageLocation -----------------
  static Future<void> saveStorageLocation(String value) async {
    (await _prefs).setString('storage_location', value);
  }
  static Future<String> getStorageLocation() async {
    return (await _prefs).getString('storage_location') ?? await getDefaultLocation();
  }
  static Future<void> saveDownloadLimitUnit(String value) async {
    (await _prefs).setString('download_limit_unit', value);
  }
  static Future<String> getDownloadLimitUnit() async {
    return (await _prefs).getString('download_limit_unit') ?? 'KB';
  }

  // ----------------- language -----------------
  static Future<void> saveLanguage(String value) async {
    (await _prefs).setString('language', value);
  }
  static Future<String> getLanguage() async {
    return (await _prefs).getString('language') ?? 'en';
  }

  // ----------------- user -----------------
  static Future<void> saveUser(UserMeta user) async {
    (await _prefs).setString('user', user.toJson()); // JSON encoding
  }

  static Future<UserMeta> getUser() async {
    final str = (await _prefs).getString('user');
    if (str == null) {
      return UserMeta(name: "Guest", color: getRandomHighContrastColor()); // default
    }
    return UserMeta.fromJson(str);
  }
}