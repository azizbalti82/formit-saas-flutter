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
    required this.parameters,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'position': position,
    'parameters': parameters,
  };

  FormItem copy() => FormItem(
    id: id,
    type: type,
    position: position,
    parameters: Map<String, dynamic>.from(parameters),
  );

  String getDisplayText() => 'Form Item';
}

/// Enum for form item types (using existing DocItemType)
enum DocItemType {
  Text,
  Input,
  Checklist,
  RadioList,
}

/// Extension to get display name and icon for DocItemType
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
      default:
        return 'Unknown';
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
      }
  }
}