import 'dart:convert';

class FormCustomizations {
  // General
  final String theme;
  final String font;

  // Colors
  final String background;
  final String text;
  final String buttonBackground;
  final String buttonText;
  final String accent;

  // Layout
  final String pageWidth;
  final String baseFontSize;

  // Logo
  final String logoWidth;
  final String logoHeight;
  final String logoCornerRadius;

  // Cover
  final String coverHeight;

  // Inputs
  final String inputWidth;
  final String inputHeight;
  final String inputBackground;
  final String inputPlaceholder;
  final String inputBorderColor;
  final String inputBorderWidth;
  final String inputBorderRadius;
  final String inputMarginBottom;
  final String inputHorizontalPadding;

  // Buttons
  final String buttonWidth;
  final String buttonHeight;
  final String buttonAlignment;
  final String buttonFontSize;
  final String buttonCornerRadius;
  final String buttonVerticalMargin;
  final String buttonHorizontalPadding;

  const FormCustomizations({
    this.theme = 'Light',
    this.font = 'Inter',
    this.background = '#FFFFFF',
    this.text = '#37352F',
    this.buttonBackground = '#000000',
    this.buttonText = '#FFFFFF',
    this.accent = '#0070D7',
    this.pageWidth = '700px',
    this.baseFontSize = '16px',
    this.logoWidth = '100px',
    this.logoHeight = '100px',
    this.logoCornerRadius = '50px',
    this.coverHeight = '25%',
    this.inputWidth = '320px',
    this.inputHeight = '36px',
    this.inputBackground = '#FFFFFF',
    this.inputPlaceholder = '#BBBAB8',
    this.inputBorderColor = '#3D3B3B',
    this.inputBorderWidth = '1px',
    this.inputBorderRadius = '8px',
    this.inputMarginBottom = '10px',
    this.inputHorizontalPadding = '10px',
    this.buttonWidth = 'auto',
    this.buttonHeight = '36px',
    this.buttonAlignment = 'center',
    this.buttonFontSize = '16px',
    this.buttonCornerRadius = '8px',
    this.buttonVerticalMargin = '10px',
    this.buttonHorizontalPadding = '14px',
  });

  Map<String, dynamic> toJson() => {
    'theme': theme,
    'font': font,
    'background': background,
    'text': text,
    'buttonBackground': buttonBackground,
    'buttonText': buttonText,
    'accent': accent,
    'pageWidth': pageWidth,
    'baseFontSize': baseFontSize,
    'logoWidth': logoWidth,
    'logoHeight': logoHeight,
    'logoCornerRadius': logoCornerRadius,
    'coverHeight': coverHeight,
    'inputWidth': inputWidth,
    'inputHeight': inputHeight,
    'inputBackground': inputBackground,
    'inputPlaceholder': inputPlaceholder,
    'inputBorderColor': inputBorderColor,
    'inputBorderWidth': inputBorderWidth,
    'inputBorderRadius': inputBorderRadius,
    'inputMarginBottom': inputMarginBottom,
    'inputHorizontalPadding': inputHorizontalPadding,
    'buttonWidth': buttonWidth,
    'buttonHeight': buttonHeight,
    'buttonAlignment': buttonAlignment,
    'buttonFontSize': buttonFontSize,
    'buttonCornerRadius': buttonCornerRadius,
    'buttonVerticalMargin': buttonVerticalMargin,
    'buttonHorizontalPadding': buttonHorizontalPadding,
  };

  factory FormCustomizations.fromJson(Map<String, dynamic> json) => FormCustomizations(
    theme: json['theme'] ?? 'Light',
    font: json['font'] ?? 'Inter',
    background: json['background'] ?? '#FFFFFF',
    text: json['text'] ?? '#37352F',
    buttonBackground: json['buttonBackground'] ?? '#000000',
    buttonText: json['buttonText'] ?? '#FFFFFF',
    accent: json['accent'] ?? '#0070D7',
    pageWidth: json['pageWidth'] ?? '700px',
    baseFontSize: json['baseFontSize'] ?? '16px',
    logoWidth: json['logoWidth'] ?? '100px',
    logoHeight: json['logoHeight'] ?? '100px',
    logoCornerRadius: json['logoCornerRadius'] ?? '50px',
    coverHeight: json['coverHeight'] ?? '25%',
    inputWidth: json['inputWidth'] ?? '320px',
    inputHeight: json['inputHeight'] ?? '36px',
    inputBackground: json['inputBackground'] ?? '#FFFFFF',
    inputPlaceholder: json['inputPlaceholder'] ?? '#BBBAB8',
    inputBorderColor: json['inputBorderColor'] ?? '#3D3B3B',
    inputBorderWidth: json['inputBorderWidth'] ?? '1px',
    inputBorderRadius: json['inputBorderRadius'] ?? '8px',
    inputMarginBottom: json['inputMarginBottom'] ?? '10px',
    inputHorizontalPadding: json['inputHorizontalPadding'] ?? '10px',
    buttonWidth: json['buttonWidth'] ?? 'auto',
    buttonHeight: json['buttonHeight'] ?? '36px',
    buttonAlignment: json['buttonAlignment'] ?? 'center',
    buttonFontSize: json['buttonFontSize'] ?? '16px',
    buttonCornerRadius: json['buttonCornerRadius'] ?? '8px',
    buttonVerticalMargin: json['buttonVerticalMargin'] ?? '10px',
    buttonHorizontalPadding: json['buttonHorizontalPadding'] ?? '14px',
  );

  @override
  String toString() => jsonEncode(toJson());
}
