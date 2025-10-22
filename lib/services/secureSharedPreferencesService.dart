import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/models/userMeta.dart';
import '../tools/tools.dart';

class SecureStorageService {
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  final String constVaultKey = "vault_keys";
  final String constCurrentKey = "current_key";

  /// Add a key to the vault list
  Future<void> addVaultKeyToList(String newValue) async {
    String? stored = await storage.read(key: constVaultKey);
    List<String> list = stored != null ? List<String>.from(json.decode(stored)) : [];

    // remove if it already exists
    list.remove(newValue);

    // always insert at front
    list.insert(0, newValue);

    await storage.write(key: constVaultKey, value: json.encode(list));
  }


  /// Remove a key from the vault list
  Future<void> removeVaultKeyFromList(String value) async {
    String? stored = await storage.read(key: constVaultKey);
    if (stored == null) return;

    List<String> list = List<String>.from(json.decode(stored));
    list.remove(value);
    await storage.write(key: constVaultKey, value: json.encode(list));
  }

  /// Check if a key exists in the vault list
  Future<bool> isKeyExist(String value) async {
    String? stored = await storage.read(key: constVaultKey);
    if (stored == null) return false;

    List<String> list = List<String>.from(json.decode(stored));
    return list.contains(value);
  }

  /// Save the current key
  Future<void> saveCurrentKey(String value) async {
    await storage.write(key: constCurrentKey, value: value);
    addVaultKeyToList(value);
  }

  /// Get the current key
  Future<String?> getCurrentKey() async {
    //null means not logged in
    String? result =  await storage.read(key: constCurrentKey);
    if(result!=null && result==""){
      return null;
    }
    return result;
  }

  /// Get the current key
  Future<void> removeCurrentKey() async {
    String? current = await getCurrentKey();
    if(current!=null){
      await storage.delete(key: constCurrentKey);
    }
  }

  /// Get the full vault list
  Future<List<String>> getVaultKeys() async {
    String? stored = await storage.read(key: constVaultKey);
    if (stored == null) return [];
    return List<String>.from(json.decode(stored));
  }
}