import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FormItem {
  String id;
  final DocItemType type;
  int position;
  Map<String, dynamic> parameters;

  FormItem({
    String? id,
    required this.type,
    required this.position,
    Map<String, dynamic>? parameters,
  })  : id = id ?? const Uuid().v4(),
        parameters = parameters ?? {};

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name, // better than toString()
    'position': position,
    'parameters': parameters,
  };

  factory FormItem.fromJson(Map<String, dynamic> json) {
    return FormItem(
      id: json['id'] as String?,
      type: DocItemType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => DocItemType.Text, // fallback
      ),
      position: json['position'] as int? ?? 0,
      parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
    );
  }

  // Proper copyWith – essential for duplication & safe list operations
  FormItem copyWith({
    String? id,
    DocItemType? type,
    int? position,
    Map<String, dynamic>? parameters,
  }) {
    return FormItem(
      id: id ?? const Uuid().v4(), // always generate new ID if not provided
      type: type ?? this.type,
      position: position ?? this.position,
      parameters: parameters != null ? Map.from(parameters) : Map.from(this.parameters),
    );
  }

  // Legacy copy method – you can keep or remove it
  FormItem copy() => copyWith();

  String getDisplayText() {
    switch (type) {
      case DocItemType.Text:
        return parameters['text']?.toString() ?? 'Text Block';
      case DocItemType.Input:
        return parameters['label']?.toString() ?? 'Input Field';
      case DocItemType.button:
        return parameters['text']?.toString() ?? 'Button';
      case DocItemType.Checklist:
        return 'Checklist';
      case DocItemType.RadioList:
        return 'Empty Line';
      default:
        return 'Form Item';
    }
  }

  // Important for ValueKey to work correctly in ReorderableListView
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Enum for form item types
enum DocItemType {
  Text,
  Input,
  Checklist,
  RadioList,
  button,
}

/// Extension with better naming & icons
extension DocItemTypeExtension on DocItemType {
  String get displayName {
    switch (this) {
      case DocItemType.Text:
        return 'Text';
      case DocItemType.Input:
        return 'Input Field';
      case DocItemType.Checklist:
        return 'Checklist';
      case DocItemType.RadioList:
        return 'Empty Line';
      case DocItemType.button:
        return 'Button';
    }
  }

  String get description {
    switch (this) {
      case DocItemType.Text:
        return 'Add formatted text content';
      case DocItemType.Input:
        return 'Add an input field for user data';
      case DocItemType.Checklist:
        return 'Add a checklist with multiple items';
      case DocItemType.RadioList:
        return 'Add an empty line or spacer';
      case DocItemType.button:
        return 'Add a button';
    }
  }

  IconData get icon {
    switch (this) {
      case DocItemType.Text:
        return Icons.text_fields;
      case DocItemType.Input:
        return Icons.input;
      case DocItemType.Checklist:
        return Icons.checklist;
      case DocItemType.RadioList:
        return Icons.space_bar;
      case DocItemType.button:
        return Icons.smart_button;
    }
  }
}