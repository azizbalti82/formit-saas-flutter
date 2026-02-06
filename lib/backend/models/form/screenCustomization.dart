import 'dart:typed_data';
import 'dart:ui';

class ScreenCustomization {
  String backgroundColor;
  String textColor;
  String accentColor;
  String borderColor;
  String buttonBackgroundColor;
  String buttonTextColor;
  bool logoHasBorder;
  String fontFamily;
  int fontSize;
  int pageWidth;
  Uint8List? logoImageBytes;
  int logoWidth;
  int logoHeight;
  int logoRound;
  Uint8List? coverImageBytes;
  int coverHeight; // now INT (50 instead of "50%")
  String inputTextColor;

  // ─── NEW FIELD ───
  bool isButtonFilled;

  ScreenCustomization({
    this.backgroundColor = "ffffffff",
    this.textColor = "ff000000",
    this.accentColor = "ff2196f3",
    this.borderColor = "ffcccccc",
    this.buttonBackgroundColor = "ff4caf50",
    this.buttonTextColor = "ffffffff",
    this.fontFamily = "Roboto",
    this.fontSize = 20,
    this.pageWidth = 800,
    this.logoImageBytes,
    this.logoWidth = 100,
    this.logoHeight = 100,
    this.logoRound = 100,
    this.coverImageBytes,
    this.coverHeight = 25,
    this.logoHasBorder = true,
    this.inputTextColor = "ff000000",
    // Default: true (filled buttons – most common style)
    this.isButtonFilled = true,
  });

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
      'logoHasBorder': logoHasBorder,
      'inputTextColor': inputTextColor,
      'isButtonFilled': isButtonFilled, // ← added
    };
  }

  factory ScreenCustomization.fromJson(Map<String, dynamic> json) {
    return ScreenCustomization(
      backgroundColor: json['backgroundColor'] ?? "ffffffff",
      textColor: json['textColor'] ?? "ff000000",
      accentColor: json['accentColor'] ?? "ff2196f3",
      borderColor: json['borderColor'] ?? "ffcccccc",
      buttonBackgroundColor: json['buttonBackgroundColor'] ?? "ff4caf50",
      buttonTextColor: json['buttonTextColor'] ?? "ffffffff",
      fontFamily: json['fontFamily'] ?? "Arial",
      fontSize: (json['fontSize'] ?? 20) as int,
      pageWidth: (json['pageWidth'] ?? 800) as int,
      logoWidth: (json['logoWidth'] ?? 100) as int,
      logoHeight: (json['logoHeight'] ?? 100) as int,
      logoRound: (json['logoRound'] ?? 100) as int,
      coverHeight: (json['coverHeight'] ?? 25) as int,
      logoHasBorder: (json['logoHasBorder'] ?? true) as bool,
      inputTextColor: json['inputTextColor'] ?? "ff000000",
      isButtonFilled: json['isButtonFilled'] ?? true, // ← added
    );
  }

  ScreenCustomization copyWith({
    String? backgroundColor,
    String? textColor,
    String? accentColor,
    String? borderColor,
    String? buttonBackgroundColor,
    String? buttonTextColor,
    String? fontFamily,
    int? fontSize,
    int? pageWidth,
    Uint8List? logoImageBytes,
    int? logoWidth,
    int? logoHeight,
    int? logoRound,
    Uint8List? coverImageBytes,
    int? coverHeight,
    bool? logoHasBorder,
    String? inputTextColor,
    bool? isButtonFilled, // ← added
  }) {
    return ScreenCustomization(
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
      logoHasBorder: logoHasBorder ?? this.logoHasBorder,
      inputTextColor: inputTextColor ?? this.inputTextColor,
      isButtonFilled: isButtonFilled ?? this.isButtonFilled, // ← added
    );
  }

  Color get backgroundColorValue => _hexToColor(backgroundColor);
  Color get textColorValue => _hexToColor(textColor);
  Color get accentColorValue => _hexToColor(accentColor);
  Color get borderColorValue => _hexToColor(borderColor);
  Color get buttonBackgroundColorValue => _hexToColor(buttonBackgroundColor);
  Color get buttonTextColorValue => _hexToColor(buttonTextColor);
  Color get inputTextColorValue => _hexToColor(inputTextColor);

  static Color _hexToColor(String hexString) {
    final clean = hexString.replaceFirst('#', '');
    return Color(int.parse(clean, radix: 16));
  }
}