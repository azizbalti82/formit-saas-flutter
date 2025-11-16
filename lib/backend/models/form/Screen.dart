import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:formbuilder/backend/models/form/screenCustomization.dart';

// ============================================================================
// ENDING SETTINGS MODEL
// ============================================================================
class EndingSettings {
  String? redirectUrl;
  bool isRedirect;

  EndingSettings({this.redirectUrl, this.isRedirect = false});

  // Convert to JSON for storage/API
  Map<String, dynamic> toJson() {
    return {'redirectUrl': redirectUrl, 'isRedirect': isRedirect};
  }

  // Create from JSON
  factory EndingSettings.fromJson(Map<String, dynamic> json) {
    return EndingSettings(
      redirectUrl: json['redirectUrl'],
      isRedirect: json['isRedirect'] ?? false,
    );
  }

  // Create a copy with modifications
  EndingSettings copyWith({String? redirectUrl, bool? isRedirect}) {
    return EndingSettings(
      redirectUrl: redirectUrl ?? this.redirectUrl,
      isRedirect: isRedirect ?? this.isRedirect,
    );
  }
}

// ============================================================================
// SCREEN MODEL
// ============================================================================
class Screen {
  String id;
  bool isEnding;
  EndingSettings? endingSettings;
  ScreenCustomization screenCustomization;

  Screen({
    required this.id,
    this.isEnding = false,
    this.endingSettings,
    ScreenCustomization? screenCustomization,
  }) : screenCustomization = screenCustomization ?? ScreenCustomization() {
    // If this is an ending screen, ensure endingSettings exists
    if (isEnding && endingSettings == null) {
      endingSettings = EndingSettings();
    }
  }

  // Convert to JSON for storage/API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isEnding': isEnding,
      'endingSettings': endingSettings?.toJson(),
      'ScreenCustomization': screenCustomization.toJson(),
    };
  }

  // Create from JSON
  factory Screen.fromJson(Map<String, dynamic> json) {
    return Screen(
      id: json['id'],
      isEnding: json['isEnding'] ?? false,
      endingSettings: json['endingSettings'] != null
          ? EndingSettings.fromJson(json['endingSettings'])
          : null,
      screenCustomization: json['ScreenCustomization'] != null
          ? ScreenCustomization.fromJson(json['ScreenCustomization'])
          : null,
    );
  }

  // Create a copy with modifications
  Screen copyWith({
    String? id,
    bool? isEnding,
    EndingSettings? endingSettings,
    ScreenCustomization? screenCustomization,
  }) {
    return Screen(
      id: id ?? this.id,
      isEnding: isEnding ?? this.isEnding,
      endingSettings: endingSettings ?? this.endingSettings,
      screenCustomization: screenCustomization ?? this.screenCustomization,
    );
  }

  // Helper method to validate screen
  bool isValid() {
    // If it's an ending screen, endingSettings must be present
    if (isEnding && endingSettings == null) {
      return false;
    }
    return true;
  }

  // Helper method to create a default regular screen
  static Screen createRegularScreen(String id) {
    return Screen(
      id: id,
      isEnding: false,
      screenCustomization: ScreenCustomization(),
    );
  }

  // Helper method to create a default ending screen
  static Screen createEndingScreen(String id, {bool isRedirect = false}) {
    return Screen(
      id: id,
      isEnding: true,
      endingSettings: EndingSettings(isRedirect: isRedirect),
      screenCustomization: ScreenCustomization(),
    );
  }
}
