import 'dart:convert';

import '../form/screenCustomization.dart';

class AccountSettings {
  final List<String> customDomains;
  final ScreenCustomization? defaultFormCustomization;
  final String plan; // e.g. "free", "pro", "Enterprise"
  final String language; // e.g. "English", "German", "French"

  const AccountSettings({
    this.customDomains = const [],
    this.defaultFormCustomization,
    this.plan = 'free',
    this.language = 'en',
  });

  Map<String, dynamic> toJson() => {
    'customDomains': customDomains,
    'defaultFormCustomization': defaultFormCustomization?.toJson(),
    'plan': plan,
    'language': language,
  };

  factory AccountSettings.fromJson(Map<String, dynamic> json) => AccountSettings(
    customDomains:
    (json['customDomains'] as List?)?.cast<String>() ?? const [],
    defaultFormCustomization: json['defaultFormCustomization'] != null
        ? ScreenCustomization.fromJson(json['defaultFormCustomization'])
        : null,
    plan: json['plan'] ?? 'Free',
    language: json['language'] ?? 'en',
  );

  @override
  String toString() => jsonEncode(toJson());
}