import 'dart:convert';

import 'package:flutter/material.dart';

class UserMeta {
  //final String id;
  final String name;
  final Color color;

  const UserMeta({
    required this.name,
    required this.color,
  });

  /// Copy the object with some changed values
  UserMeta copyWith({
    String? name,
    Color? color,
  }) {
    return UserMeta(
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  /// Convert object to Map (Color stored as int)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color.value, // store as int
    };
  }

  /// Convert Map to object
  factory UserMeta.fromMap(Map<String, dynamic> map) {
    return UserMeta(
      name: map['name'] ?? '',
      color: Color(map['color'] ?? 0xFF000000), // default black
    );
  }

  /// Convert object to JSON string
  String toJson() => json.encode(toMap());

  /// Convert JSON string to object
  factory UserMeta.fromJson(String source) =>
      UserMeta.fromMap(json.decode(source));

  @override
  String toString() => 'UserMeta(name: $name, color: $color)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserMeta &&
        other.name == name &&
        other.color == color;
  }

  @override
  int get hashCode => name.hashCode ^ color.hashCode;
}
