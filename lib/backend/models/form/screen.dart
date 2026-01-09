import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:formbuilder/backend/models/form/screenCustomization.dart';
import 'package:uuid/uuid.dart';

import 'docItem.dart';

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
  bool isInitial;
  EndingSettings? endingSettings;
  ScreenCustomization screenCustomization;
  Workflow workflow;
  List<DocItem> content;

  Screen({
    required this.id,
    this.isEnding = false,
    this.isInitial = false,
    this.endingSettings,
    ScreenCustomization? screenCustomization,
    required this.workflow,

  }) : content =  [DocItem()],screenCustomization = screenCustomization ?? ScreenCustomization() {
    if (isEnding && endingSettings == null) {
      endingSettings = EndingSettings();
    }
  }

  // Convert to JSON for storage/API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isEnding': isEnding,
      'isInitial': isInitial,
      'endingSettings': endingSettings?.toJson(),
      'ScreenCustomization': screenCustomization.toJson(),
      'workflow': workflow.toJson(),
    };
  }

  // Create from JSON
  factory Screen.fromJson(Map<String, dynamic> json) {
    return Screen(
      id: json['id'],
      isEnding: json['isEnding'] ?? false,
      isInitial:json['isInitial']??false,
      endingSettings: json['endingSettings'] != null
          ? EndingSettings.fromJson(json['endingSettings'])
          : null,
      screenCustomization: json['ScreenCustomization'] != null
          ? ScreenCustomization.fromJson(json['ScreenCustomization'])
          : null,

      /// NEW FIELD ↓↓↓
      workflow: Workflow.fromJson(json['workflow']),
    );
  }

  // Create a copy with modifications
  Screen copyWith({
    String? id,
    bool? isEnding,
    bool? isInitial,
    EndingSettings? endingSettings,
    ScreenCustomization? screenCustomization,

    /// NEW FIELD ↓↓↓
    Workflow? workflow,
  }) {
    return Screen(
      id: id ?? this.id,
      isEnding: isEnding ?? this.isEnding,
      isInitial:isInitial??this.isInitial,
      endingSettings: endingSettings ?? this.endingSettings,
      screenCustomization: screenCustomization ?? this.screenCustomization,

      /// NEW FIELD ↓↓↓
      workflow: workflow ?? this.workflow,
    );
  }

  bool isValid() {
    if (isEnding && endingSettings == null) {
      return false;
    }
    return true;
  }
  static Screen createRegularScreen(String id, int index,{bool isInitial=false}) {
    return Screen(
      id: id,
      isEnding: false,
      isInitial:isInitial,
      screenCustomization: ScreenCustomization(),
      workflow: Workflow(position: Offset(200.0 * index, 0), connects: null),
    );
  }

  static Screen createEndingScreen(
    String id, {
    bool isRedirect = false,
    required int index,
  }) {
    return Screen(
      id: id,
      isEnding: true,
      endingSettings: EndingSettings(isRedirect: isRedirect),
      screenCustomization: ScreenCustomization(),
      workflow: Workflow(position: Offset(200.0 * index, 200), connects: null),
    );
  }
}

class Connect {
  final String screenId;
  final List<Rule> rules;

  Connect({
    required this.screenId,
    this.rules = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'screenId': screenId,
      'rules': rules.map((rule) => rule.toMap()).toList(),
    };
  }

  factory Connect.fromMap(Map<String, dynamic> map) {
    return Connect(
      screenId: map['screenId'],
      rules: map['rules'] != null
          ? (map['rules'] as List).map((r) => Rule.fromMap(r)).toList()
          : [],
    );
  }
}

class Rule {
  static final _uuid = Uuid();

  final String ruleId;
  final String widgetId;
  final String logic;
  final dynamic value;

  Rule({
    required this.widgetId,
    required this.logic,
    this.value,
  }) : ruleId = _uuid.v4();

  // Check if this logic requires a value
  bool get requiresValue {
    return ![
      'Is Empty',
      'Is Not Empty',
      'isEmpty',
      'isNotEmpty',
    ].contains(logic);
  }

  Map<String, dynamic> toMap() {
    return {
      'widgetId': widgetId,
      'logic': logic,
      'value': value,
    };
  }

  factory Rule.fromMap(Map<String, dynamic> map) {
    return Rule(
      widgetId: map['widgetId'],
      logic: map['logic'],
      value: map['value'],
    );
  }

  @override
  String toString() {
    if (value != null) {
      return '$widgetId $logic $value';
    }
    return '$widgetId $logic';
  }
}

class Workflow {
  Offset position;
  List<Connect> connects;

  Workflow({required this.position, List<Connect>? connects})
    : connects = connects ?? [];

  Map<String, dynamic> toJson() {
    return {
      'position': {'dx': position.dx, 'dy': position.dy},
      'connects': connects.map((c) => c.toMap()).toList(),
    };
  }

  factory Workflow.fromJson(Map<String, dynamic> json) {
    return Workflow(
      position: Offset(json['position']['dx'], json['position']['dy']),
      connects:
          (json['connects'] as List<dynamic>?)
              ?.map((e) => Connect.fromMap(e))
              .toList() ??
          [],
    );
  }
}
