import 'dart:typed_data';
import 'dart:ui';

class PageCustomization {
  // Colors
  String backgroundColor;
  String textColor;
  String accentColor;
  String borderColor;
  String buttonBackgroundColor;
  String buttonTextColor;

  // Page
  String fontFamily;
  String fontSize;
  String pageWidth;

  // Logo
  Uint8List? logoImageBytes;
  String logoWidth;
  String logoHeight;
  String logoRound;

  // Cover
  Uint8List? coverImageBytes;
  String coverHeight;

  PageCustomization({
    this.backgroundColor = "#ffffff",
    this.textColor = "#0000ff",
    this.accentColor = "#ff0000",
    this.borderColor = "#0000ff",
    this.buttonBackgroundColor = "#ff0000",
    this.buttonTextColor = "#0000ff",
    this.fontFamily = "Arial",
    this.fontSize = "20px",
    this.pageWidth = "800px",
    this.logoImageBytes,
    this.logoWidth = "300px",
    this.logoHeight = "200px",
    this.logoRound = "5px",
    this.coverImageBytes,
    this.coverHeight = "50%",
  });

  // Convert to JSON for storage/API
  Map<String, dynamic> toJson() {
    return {
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'accentColor': accentColor,
      'borderColor': borderColor,
      'buttonBackgroundColor': buttonBackgroundColor,
      'buttonTextColor': buttonTextColor,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'pageWidth': pageWidth,
      'logoWidth': logoWidth,
      'logoHeight': logoHeight,
      'logoRound': logoRound,
      'coverHeight': coverHeight,
      // Note: Images should be handled separately (uploaded to storage)
    };
  }

  // Create from JSON
  factory PageCustomization.fromJson(Map<String, dynamic> json) {
    return PageCustomization(
      backgroundColor: json['backgroundColor'] ?? "#ffffff",
      textColor: json['textColor'] ?? "#0000ff",
      accentColor: json['accentColor'] ?? "#ff0000",
      borderColor: json['borderColor'] ?? "#0000ff",
      buttonBackgroundColor: json['buttonBackgroundColor'] ?? "#ff0000",
      buttonTextColor: json['buttonTextColor'] ?? "#0000ff",
      fontFamily: json['fontFamily'] ?? "Arial",
      fontSize: json['fontSize'] ?? "20px",
      pageWidth: json['pageWidth'] ?? "800px",
      logoWidth: json['logoWidth'] ?? "300px",
      logoHeight: json['logoHeight'] ?? "200px",
      logoRound: json['logoRound'] ?? "5px",
      coverHeight: json['coverHeight'] ?? "50%",
    );
  }

  // Create a copy with modifications
  PageCustomization copyWith({
    String? backgroundColor,
    String? textColor,
    String? accentColor,
    String? borderColor,
    String? buttonBackgroundColor,
    String? buttonTextColor,
    String? fontFamily,
    String? fontSize,
    String? pageWidth,
    Uint8List? logoImageBytes,
    String? logoWidth,
    String? logoHeight,
    String? logoRound,
    Uint8List? coverImageBytes,
    String? coverHeight,
  }) {
    return PageCustomization(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      accentColor: accentColor ?? this.accentColor,
      borderColor: borderColor ?? this.borderColor,
      buttonBackgroundColor: buttonBackgroundColor ?? this.buttonBackgroundColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      pageWidth: pageWidth ?? this.pageWidth,
      logoImageBytes: logoImageBytes ?? this.logoImageBytes,
      logoWidth: logoWidth ?? this.logoWidth,
      logoHeight: logoHeight ?? this.logoHeight,
      logoRound: logoRound ?? this.logoRound,
      coverImageBytes: coverImageBytes ?? this.coverImageBytes,
      coverHeight: coverHeight ?? this.coverHeight,
    );
  }

  // Helper methods to convert string to Color
  Color get backgroundColorValue => _hexToColor(backgroundColor);
  Color get textColorValue => _hexToColor(textColor);
  Color get accentColorValue => _hexToColor(accentColor);
  Color get borderColorValue => _hexToColor(borderColor);
  Color get buttonBackgroundColorValue => _hexToColor(buttonBackgroundColor);
  Color get buttonTextColorValue => _hexToColor(buttonTextColor);

  static Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}