import 'package:flutter/material.dart';

class theme {
  final Color bgColor; // Background color
  final Color accentColor; // Accent color
  final Color textColor; // Primary text color
  final Color secondaryTextColor; // Secondary text color
  final Color cardColor; // Card color
  final Color border;
  final Color errorColor; // Error color
  final Color surfaceColor; // Surface color
  final ThemeMode themeMode; // Theme mode (light/dark)
  final Brightness brightness;
  final Color goldColor;

  theme({
    required this.bgColor,
    required this.accentColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.errorColor,
    required this.surfaceColor,
    required this.border,
    required this.themeMode,
    required this.brightness,
    required this.goldColor,
  });

  // Helper method to copy the theme with new values
  theme copyWith({
    Color? bgColor,
    Color? accentColor,
    Color? textColor,
    Color? secondaryTextColor,
    Color? cardColor,
    Color? errorColor,
    Color? surfaceColor,
    Color? border,
    ThemeMode? themeMode,
    Brightness? brightness,
    Color? goldColor,
  }) {
    return theme(
      bgColor: bgColor ?? this.bgColor,
      accentColor: accentColor ?? this.accentColor,
      textColor: textColor ?? this.textColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      cardColor: cardColor ?? this.cardColor,
      errorColor: errorColor ?? this.errorColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      border: border ?? this.border,
      themeMode: themeMode ?? this.themeMode,
      brightness: brightness ?? this.brightness,
      goldColor: this.goldColor,
    );
  }
}

final darkTheme = theme(
  bgColor: const Color(0xFF000000),
  accentColor: const Color(0xFF9661EF),
  textColor: Colors.white,
  secondaryTextColor: Colors.grey[300]!,
  cardColor: const Color(0xFF181818),
  // Neutral dark card
  errorColor: const Color(0xFFE57373),
  // Soft red
  surfaceColor: const Color(0xFF2C2C2C),
  // Slightly lighter than bg
  themeMode: ThemeMode.dark,
  border: const Color(0xFF222222),
  // Subtle border color
  goldColor: const Color(0xFFFFD54F),
  // Gold remains unchanged
  brightness: Brightness.dark,
);

// 🌕 Normal Light Mode (White Background)
final lightTheme = theme(
  bgColor: const Color(0xFFEEF3F4),
  // Pure white background
  accentColor: const Color(0xFF6F46D5),
  textColor: Colors.black,
  secondaryTextColor: Colors.grey[700]!,
  cardColor: Color.fromRGBO(245, 245, 250, 1),
  errorColor: Colors.red[700]!,
  surfaceColor: Color.fromRGBO(215, 215, 215, 1.0),
  themeMode: ThemeMode.light,
  border: Color.fromRGBO(200, 200, 200, 1),
  goldColor: Colors.amber.shade700,
  brightness: Brightness.light,
);
