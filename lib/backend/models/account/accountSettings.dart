import 'dart:convert';

import '../form/formCustomization.dart';

class AccountSettings {
  final List<String> customDomains;
  final NotificationSettings notificationSettings;
  final PageCustomization? defaultFormCustomization;
  final String plan; // e.g. "free", "pro", "Enterprise"
  final String language; // e.g. "English", "German", "French"

  const AccountSettings({
    this.customDomains = const [],
    this.notificationSettings = const NotificationSettings(),
    this.defaultFormCustomization,
    this.plan = 'free',
    this.language = 'en',
  });

  Map<String, dynamic> toJson() => {
    'customDomains': customDomains,
    'notificationSettings': notificationSettings.toJson(),
    'defaultFormCustomization': defaultFormCustomization?.toJson(),
    'plan': plan,
    'language': language,
  };

  factory AccountSettings.fromJson(Map<String, dynamic> json) => AccountSettings(
    customDomains:
    (json['customDomains'] as List?)?.cast<String>() ?? const [],
    notificationSettings: json['notificationSettings'] != null
        ? NotificationSettings.fromJson(json['notificationSettings'])
        : const NotificationSettings(),
    defaultFormCustomization: json['defaultFormCustomization'] != null
        ? PageCustomization.fromJson(json['defaultFormCustomization'])
        : null,
    plan: json['plan'] ?? 'Free',
    language: json['language'] ?? 'en',
  );

  @override
  String toString() => jsonEncode(toJson());
}

class NotificationSettings {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool webhookEnabled;
  final String? webhookUrl;

  const NotificationSettings({
    this.emailNotifications = true,
    this.pushNotifications = false,
    this.webhookEnabled = false,
    this.webhookUrl,
  });

  Map<String, dynamic> toJson() => {
    'emailNotifications': emailNotifications,
    'pushNotifications': pushNotifications,
    'webhookEnabled': webhookEnabled,
    'webhookUrl': webhookUrl,
  };

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        emailNotifications: json['emailNotifications'] ?? true,
        pushNotifications: json['pushNotifications'] ?? false,
        webhookEnabled: json['webhookEnabled'] ?? false,
        webhookUrl: json['webhookUrl'],
      );

  @override
  String toString() => jsonEncode(toJson());
}
