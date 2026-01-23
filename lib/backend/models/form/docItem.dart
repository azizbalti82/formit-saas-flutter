import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

abstract class FormItem {
  final String id;
  final DocItemType type;
  Map<String, dynamic> parameters;

  FormItem({
    required this.id,
    required this.type,
    required this.parameters,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'parameters': parameters,
  };

  factory FormItem.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = DocItemType.values.firstWhere(
          (e) => e.toString() == typeString,
    );

    switch (type) {
      case DocItemType.Text:
        return TextFormItem.fromJson(json);
      case DocItemType.Input:
        return InputFormItem.fromJson(json);
      case DocItemType.Checklist:
        return ChecklistFormItem.fromJson(json);
      case DocItemType.EmptyLine:
        return EmptyLineFormItem.fromJson(json);
      default:
        throw Exception('Unknown form item type: $type');
    }
  }

  FormItem copy();
  String getDisplayText();
}

/// Enum for form item types (using existing DocItemType)
enum DocItemType {
  Text,
  Input,
  Checklist,
  EmptyLine, // 👈 Added EmptyLine type
}

class TextFormItem extends FormItem {
  String get content => parameters['content'] ?? '';
  set content(String value) => parameters['content'] = value;

  TextAlign get alignment => _parseTextAlign(parameters['alignment']);
  set alignment(TextAlign value) => parameters['alignment'] = value.toString();

  TextFormItem({
    required String id,
    required String content,
    TextAlign? alignment,
  }) : super(
    id: id,
    type: DocItemType.Text,
    parameters: {
      'content': content,
      'alignment': alignment?.toString() ?? TextAlign.left.toString(),
    },
  );

  factory TextFormItem.fromJson(Map<String, dynamic> json) => TextFormItem(
    id: json['id'],
    content: json['parameters']['content'] ?? '',
    alignment: _parseTextAlign(json['parameters']['alignment']),
  );

  static TextAlign _parseTextAlign(dynamic value) {
    if (value == null) return TextAlign.left;
    if (value is TextAlign) return value;
    return TextAlign.values.firstWhere(
          (e) => e.toString() == value,
      orElse: () => TextAlign.left,
    );
  }

  @override
  TextFormItem copy() => TextFormItem(
    id: id,
    content: content,
    alignment: alignment,
  );

  @override
  String getDisplayText() {
    final displayContent = content.isEmpty ? '(Empty text)' : content;
    return displayContent.length > 100
        ? '${displayContent.substring(0, 100)}...'
        : displayContent;
  }
}

class InputFormItem extends FormItem {
  String get label => parameters['label'] ?? '';
  set label(String value) => parameters['label'] = value;

  String get value => parameters['value'] ?? '';
  set value(String val) => parameters['value'] = val;

  String? get placeholder => parameters['placeholder'];
  set placeholder(String? value) => parameters['placeholder'] = value;

  bool get isRequired => parameters['isRequired'] ?? false;
  set isRequired(bool value) => parameters['isRequired'] = value;

  int? get maxLength => parameters['maxLength'];
  set maxLength(int? value) => parameters['maxLength'] = value;

  InputFormItem({
    required String id,
    required String label,
    String? value,
    String? placeholder,
    bool isRequired = false,
    int? maxLength,
  }) : super(
    id: id,
    type: DocItemType.Input,
    parameters: {
      'label': label,
      'value': value ?? '',
      'placeholder': placeholder,
      'isRequired': isRequired,
      'maxLength': maxLength,
    },
  );

  factory InputFormItem.fromJson(Map<String, dynamic> json) => InputFormItem(
    id: json['id'],
    label: json['parameters']['label'] ?? '',
    value: json['parameters']['value'],
    placeholder: json['parameters']['placeholder'],
    isRequired: json['parameters']['isRequired'] ?? false,
    maxLength: json['parameters']['maxLength'],
  );

  @override
  InputFormItem copy() => InputFormItem(
    id: id,
    label: label,
    value: value,
    placeholder: placeholder,
    isRequired: isRequired,
    maxLength: maxLength,
  );

  @override
  String getDisplayText() => '$label${isRequired ? " *" : ""}';
}

class ChecklistFormItem extends FormItem {
  String? get title => parameters['title'];
  set title(String? value) => parameters['title'] = value;

  List<ChecklistItem> get items {
    final itemsData = parameters['items'] as List<dynamic>? ?? [];
    return itemsData.map((item) => ChecklistItem.fromMap(item as Map<String, dynamic>)).toList();
  }

  set items(List<ChecklistItem> value) {
    parameters['items'] = value.map((item) => item.toMap()).toList();
  }

  ChecklistFormItem({
    required String id,
    String? title,
    required List<ChecklistItem> items,
  }) : super(
    id: id,
    type: DocItemType.Checklist,
    parameters: {
      'title': title,
      'items': items.map((item) => item.toMap()).toList(),
    },
  );

  factory ChecklistFormItem.fromJson(Map<String, dynamic> json) {
    final itemsData = json['parameters']['items'] as List<dynamic>? ?? [];
    return ChecklistFormItem(
      id: json['id'],
      title: json['parameters']['title'],
      items: itemsData
          .map((item) => ChecklistItem.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  ChecklistFormItem copy() => ChecklistFormItem(
    id: id,
    title: title,
    items: items.map((item) => item.copy()).toList(),
  );

  @override
  String getDisplayText() {
    final checkedCount = items.where((item) => item.isChecked).length;
    return '${title ?? "Checklist"} ($checkedCount/${items.length})';
  }
}

class EmptyLineFormItem extends FormItem {
  double get height => parameters['height'] ?? 40.0;
  set height(double value) => parameters['height'] = value;

  EmptyLineFormItem({
    required String id,
    double? height,
  }) : super(
    id: id,
    type: DocItemType.EmptyLine,
    parameters: {
      'height': height ?? 40.0,
    },
  );

  factory EmptyLineFormItem.fromJson(Map<String, dynamic> json) =>
      EmptyLineFormItem(
        id: json['id'],
        height: json['parameters']['height']?.toDouble() ?? 40.0,
      );

  @override
  EmptyLineFormItem copy() => EmptyLineFormItem(
    id: id,
    height: height,
  );

  @override
  String getDisplayText() => '(Empty line)';
}

class ChecklistItem {
  final String id;
  String text;
  bool isChecked;

  ChecklistItem({
    required this.id,
    required this.text,
    this.isChecked = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'text': text,
    'isChecked': isChecked,
  };

  factory ChecklistItem.fromMap(Map<String, dynamic> map) => ChecklistItem(
    id: map['id'],
    text: map['text'],
    isChecked: map['isChecked'] ?? false,
  );

  ChecklistItem copy() => ChecklistItem(
    id: id,
    text: text,
    isChecked: isChecked,
  );
}



/// Helper class to create FormItem instances from DocItemType
class FormItemFactory {
  static const _uuid = Uuid();

  /// Create a FormItem from a DocItemType
  static FormItem createFromDocItemType(DocItemType type) {
    final id = _uuid.v4();

    switch (type) {
      case DocItemType.Text:
        return TextFormItem(
          id: id,
          content: '',
        );

      case DocItemType.Input:
        return InputFormItem(
          id: id,
          label: 'New Input',
          placeholder: 'Enter value...',
        );

      case DocItemType.Checklist:
        return ChecklistFormItem(
          id: id,
          title: 'New Checklist',
          items: [
            ChecklistItem(
              id: _uuid.v4(),
              text: 'Item 1',
            ),
          ],
        );

      case DocItemType.EmptyLine:
        return EmptyLineFormItem(
          id: id,
          height: 40.0,
        );

      default:
        return TextFormItem(
          id: id,
          content: '',
        );
    }
  }

  /// Create a FormItem with custom configuration
  static FormItem createCustom({
    required DocItemType type,
    Map<String, dynamic>? config,
  }) {
    final id = config?['id'] ?? _uuid.v4();

    switch (type) {
      case DocItemType.Text:
        return TextFormItem(
          id: id,
          content: config?['content'] ?? '',
        );

      case DocItemType.Input:
        return InputFormItem(
          id: id,
          label: config?['label'] ?? 'New Input',
          placeholder: config?['placeholder'] ?? 'Enter value...',
          isRequired: config?['isRequired'] ?? false,
          maxLength: config?['maxLength'],
        );

      case DocItemType.Checklist:
        final itemTexts = config?['items'] as List<String>? ?? ['Item 1'];
        return ChecklistFormItem(
          id: id,
          title: config?['title'] ?? 'New Checklist',
          items: itemTexts
              .map((text) => ChecklistItem(
            id: _uuid.v4(),
            text: text,
          ))
              .toList(),
        );

      case DocItemType.EmptyLine:
        return EmptyLineFormItem(
          id: id,
          height: config?['height']?.toDouble() ?? 40.0,
        );

      default:
        return TextFormItem(
          id: id,
          content: '',
        );
    }
  }
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
      case DocItemType.EmptyLine:
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
      case DocItemType.EmptyLine:
        return 'Add an empty line or spacer';
      default:
        return '';
    }
  }
}