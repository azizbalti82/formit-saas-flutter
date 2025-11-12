import 'dart:ui';

class Integration {
  final String iconPath; // Path or URL to SVG
  final String title;
  final String description;
  final VoidCallback? onConnect;

  const Integration({
    required this.iconPath,
    required this.title,
    required this.description,
    this.onConnect,
  });
}