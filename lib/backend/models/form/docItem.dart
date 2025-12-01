import 'package:flutter/widgets.dart';

enum DocItemType {
  Text,
  Input,
  Image,
  Checklist,
  Divider,
}

class DocItem {
  final DocItemType type;
  final Map<String, dynamic>? parameters;
  final String? description;

  DocItem({
    this.type = DocItemType.Text,
    this.parameters,
    this.description,
  });
}
