import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A fully customizable input widget with extensive styling and behavior options
class CustomizableInputWidget extends StatefulWidget {
  // ============================================================================
  // CONTAINER/LAYOUT PROPERTIES
  // ============================================================================
  final double? width;
  final double? height;
  final double? maxWidth;
  final double? minWidth;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;

  // ============================================================================
  // BORDER PROPERTIES
  // ============================================================================
  final bool hasBorder;
  final double borderWidth;
  final BorderStyle borderStyle;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double? borderTopLeftRadius;
  final double? borderTopRightRadius;
  final double? borderBottomLeftRadius;
  final double? borderBottomRightRadius;

  // BORDER STATES (Interactive)
  final Color? borderColorFocus;
  final Color? borderColorHover;
  final Color? borderColorDisabled;
  final Color? borderColorError;
  final double? borderWidthFocus;

  // ============================================================================
  // BACKGROUND PROPERTIES
  // ============================================================================
  final Color? backgroundColor;
  final Color? backgroundColorFocus;
  final Color? backgroundColorHover;
  final Color? backgroundColorDisabled;
  final Gradient? backgroundGradient;
  final DecorationImage? backgroundImage;

  // ============================================================================
  // TEXT/CONTENT PROPERTIES
  // ============================================================================
  final String? placeholder;
  final Color? placeholderColor;
  final double? placeholderOpacity;
  final String? value;
  final String? initialValue;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? minLength;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;

  // ============================================================================
  // TYPOGRAPHY PROPERTIES
  // ============================================================================
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? textColor;
  final double? lineHeight;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDecoration? textDecoration;
  final Color? textDecorationColor;
  final TextDecorationStyle? textDecorationStyle;

  // ============================================================================
  // SHADOW PROPERTIES
  // ============================================================================
  final List<BoxShadow>? boxShadow;
  final List<BoxShadow>? boxShadowFocus;
  final List<BoxShadow>? boxShadowHover;
  final List<Shadow>? textShadow;

  // ============================================================================
  // STATE PROPERTIES
  // ============================================================================
  final bool enabled;
  final bool readOnly;
  final bool required;
  final bool autoFocus;
  final AutovalidateMode? autoValidateMode;
  final bool expands;
  final bool showCursor;
  final TextEditingController? controller;

  // ============================================================================
  // ICON/PREFIX/SUFFIX PROPERTIES
  // ============================================================================
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final String? prefixText;
  final String? suffixText;
  final Color? iconColor;
  final double? iconSize;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;

  // ============================================================================
  // VALIDATION/ERROR PROPERTIES
  // ============================================================================
  final bool hasError;
  final String? errorMessage;
  final Color? errorColor;
  final double? errorFontSize;
  final FontWeight? errorFontWeight;
  final bool hasSuccess;
  final Color? successColor;
  final String? helperText;
  final Color? helperTextColor;
  final double? helperTextFontSize;
  final int? helperTextMaxLines;
  final int? errorMaxLines;

  // ============================================================================
  // LABEL PROPERTIES
  // ============================================================================
  final String? label;
  final bool floatingLabel;
  final Color? labelColor;
  final double? labelFontSize;
  final FontWeight? labelFontWeight;
  final bool labelRequired;
  final Color? labelRequiredColor;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;

  // ============================================================================
  // ANIMATION/TRANSITION PROPERTIES
  // ============================================================================
  final Duration transitionDuration;
  final Curve transitionCurve;
  final bool animateOnFocus;

  // ============================================================================
  // CURSOR PROPERTIES
  // ============================================================================
  final Color? cursorColor;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final MouseCursor? mouseCursor;

  // ============================================================================
  // EVENT HANDLERS
  // ============================================================================
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final GestureTapCallback? onTapOutside;

  // ============================================================================
  // ADVANCED STYLING
  // ============================================================================
  final double? elevation;
  final Color? shadowColor;
  final BoxShape shape;
  final Clip clipBehavior;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;

  // ============================================================================
  // ACCESSIBILITY PROPERTIES
  // ============================================================================
  final String? semanticLabel;
  final bool obscuringCharacter;
  final String obscuringCharacterString;
  final bool enableInteractiveSelection;
  final int? semanticCounterText;

  // ============================================================================
  // INPUT FORMATTERS & RESTRICTIONS
  // ============================================================================
  final List<TextInputFormatter>? inputFormatters;
  final bool enableIMEPersonalizedLearning;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;

  // ============================================================================
  // FOCUS PROPERTIES
  // ============================================================================
  final FocusNode? focusNode;
  final VoidCallback? onFocusChange;

  // ============================================================================
  // CUSTOM DECORATIONS
  // ============================================================================
  final BoxDecoration? customDecoration;
  final BoxDecoration? customDecorationFocus;
  final BoxDecoration? customDecorationHover;
  final BoxDecoration? customDecorationDisabled;
  final BoxDecoration? customDecorationError;

  // ============================================================================
  // COUNTER PROPERTIES
  // ============================================================================
  final Widget? counter;
  final String? counterText;
  final TextStyle? counterStyle;

  // ============================================================================
  // FILL PROPERTIES
  // ============================================================================
  final bool filled;
  final Color? fillColor;

  const CustomizableInputWidget({
    Key? key,
    // Container/Layout
    this.width,
    this.height,
    this.maxWidth,
    this.minWidth,
    this.margin,
    this.padding,
    this.contentPadding,
    // Border
    this.hasBorder = true,
    this.borderWidth = 1.0,
    this.borderStyle = BorderStyle.solid,
    this.borderColor,
    this.borderRadius,
    this.borderTopLeftRadius,
    this.borderTopRightRadius,
    this.borderBottomLeftRadius,
    this.borderBottomRightRadius,
    this.borderColorFocus,
    this.borderColorHover,
    this.borderColorDisabled,
    this.borderColorError,
    this.borderWidthFocus,
    // Background
    this.backgroundColor,
    this.backgroundColorFocus,
    this.backgroundColorHover,
    this.backgroundColorDisabled,
    this.backgroundGradient,
    this.backgroundImage,
    // Text/Content
    this.placeholder,
    this.placeholderColor,
    this.placeholderOpacity,
    this.value,
    this.initialValue,
    this.keyboardType,
    this.maxLength,
    this.minLength,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    // Typography
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.fontStyle,
    this.textColor,
    this.lineHeight,
    this.letterSpacing,
    this.wordSpacing,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDecoration,
    this.textDecorationColor,
    this.textDecorationStyle,
    // Shadow
    this.boxShadow,
    this.boxShadowFocus,
    this.boxShadowHover,
    this.textShadow,
    // State
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.autoFocus = false,
    this.autoValidateMode,
    this.expands = false,
    this.showCursor = true,
    this.controller,
    // Icons/Prefix/Suffix
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.prefixText,
    this.suffixText,
    this.iconColor,
    this.iconSize,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    // Validation/Error
    this.hasError = false,
    this.errorMessage,
    this.errorColor,
    this.errorFontSize,
    this.errorFontWeight,
    this.hasSuccess = false,
    this.successColor,
    this.helperText,
    this.helperTextColor,
    this.helperTextFontSize,
    this.helperTextMaxLines,
    this.errorMaxLines,
    // Label
    this.label,
    this.floatingLabel = false,
    this.labelColor,
    this.labelFontSize,
    this.labelFontWeight,
    this.labelRequired = false,
    this.labelRequiredColor,
    this.labelStyle,
    this.floatingLabelStyle,
    // Animation
    this.transitionDuration = const Duration(milliseconds: 200),
    this.transitionCurve = Curves.easeInOut,
    this.animateOnFocus = true,
    // Cursor
    this.cursorColor,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.mouseCursor,
    // Events
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.validator,
    this.onSaved,
    this.onTapOutside,
    // Advanced Styling
    this.elevation,
    this.shadowColor,
    this.shape = BoxShape.rectangle,
    this.clipBehavior = Clip.none,
    this.transform,
    this.transformAlignment,
    // Accessibility
    this.semanticLabel,
    this.obscuringCharacter = false,
    this.obscuringCharacterString = '•',
    this.enableInteractiveSelection = true,
    this.semanticCounterText,
    // Input Formatters
    this.inputFormatters,
    this.enableIMEPersonalizedLearning = true,
    this.smartDashesType,
    this.smartQuotesType,
    // Focus
    this.focusNode,
    this.onFocusChange,
    // Custom Decorations
    this.customDecoration,
    this.customDecorationFocus,
    this.customDecorationHover,
    this.customDecorationDisabled,
    this.customDecorationError,
    // Counter
    this.counter,
    this.counterText,
    this.counterStyle,
    // Fill
    this.filled = false,
    this.fillColor,
  }) : super(key: key);

  @override
  State<CustomizableInputWidget> createState() =>
      _CustomizableInputWidgetState();
}

class _CustomizableInputWidgetState extends State<CustomizableInputWidget> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    widget.onFocusChange?.call();
  }

  Color _getCurrentBackgroundColor() {
    if (!widget.enabled && widget.backgroundColorDisabled != null) {
      return widget.backgroundColorDisabled!;
    }
    if (_isFocused && widget.backgroundColorFocus != null) {
      return widget.backgroundColorFocus!;
    }
    if (_isHovered && widget.backgroundColorHover != null) {
      return widget.backgroundColorHover!;
    }
    return widget.backgroundColor ?? Colors.transparent;
  }

  Color _getCurrentBorderColor() {
    if (widget.hasError && widget.borderColorError != null) {
      return widget.borderColorError!;
    }
    if (!widget.enabled && widget.borderColorDisabled != null) {
      return widget.borderColorDisabled!;
    }
    if (_isFocused && widget.borderColorFocus != null) {
      return widget.borderColorFocus!;
    }
    if (_isHovered && widget.borderColorHover != null) {
      return widget.borderColorHover!;
    }
    return widget.borderColor ?? Colors.grey;
  }

  double _getCurrentBorderWidth() {
    if (_isFocused && widget.borderWidthFocus != null) {
      return widget.borderWidthFocus!;
    }
    return widget.borderWidth;
  }

  List<BoxShadow>? _getCurrentBoxShadow() {
    if (_isFocused && widget.boxShadowFocus != null) {
      return widget.boxShadowFocus;
    }
    if (_isHovered && widget.boxShadowHover != null) {
      return widget.boxShadowHover;
    }
    return widget.boxShadow;
  }

  BoxDecoration _getCurrentDecoration() {
    // Check for custom decorations first
    if (widget.hasError && widget.customDecorationError != null) {
      return widget.customDecorationError!;
    }
    if (!widget.enabled && widget.customDecorationDisabled != null) {
      return widget.customDecorationDisabled!;
    }
    if (_isFocused && widget.customDecorationFocus != null) {
      return widget.customDecorationFocus!;
    }
    if (_isHovered && widget.customDecorationHover != null) {
      return widget.customDecorationHover!;
    }
    if (widget.customDecoration != null) {
      return widget.customDecoration!;
    }

    // Build default decoration
    BorderRadius? borderRadius = widget.borderRadius;
    if (borderRadius == null &&
        (widget.borderTopLeftRadius != null ||
            widget.borderTopRightRadius != null ||
            widget.borderBottomLeftRadius != null ||
            widget.borderBottomRightRadius != null)) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(widget.borderTopLeftRadius ?? 0),
        topRight: Radius.circular(widget.borderTopRightRadius ?? 0),
        bottomLeft: Radius.circular(widget.borderBottomLeftRadius ?? 0),
        bottomRight: Radius.circular(widget.borderBottomRightRadius ?? 0),
      );
    }

    return BoxDecoration(
      color: _getCurrentBackgroundColor(),
      gradient: widget.backgroundGradient,
      image: widget.backgroundImage,
      border: widget.hasBorder
          ? Border.all(
        color: _getCurrentBorderColor(),
        width: _getCurrentBorderWidth(),
        style: widget.borderStyle,
      )
          : null,
      borderRadius: borderRadius,
      boxShadow: _getCurrentBoxShadow(),
      shape: widget.shape,
    );
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      fontSize: widget.fontSize,
      fontFamily: widget.fontFamily,
      fontWeight: widget.fontWeight,
      fontStyle: widget.fontStyle,
      color: widget.textColor,
      height: widget.lineHeight,
      letterSpacing: widget.letterSpacing,
      wordSpacing: widget.wordSpacing,
      decoration: widget.textDecoration,
      decorationColor: widget.textDecorationColor,
      decorationStyle: widget.textDecorationStyle,
      shadows: widget.textShadow,
    );
  }

  TextStyle _getPlaceholderStyle() {
    return TextStyle(
      fontSize: widget.fontSize,
      fontFamily: widget.fontFamily,
      fontWeight: widget.fontWeight,
      fontStyle: widget.fontStyle,
      color: (widget.placeholderColor ?? Colors.grey).withOpacity(
        widget.placeholderOpacity ?? 0.6,
      ),
      height: widget.lineHeight,
      letterSpacing: widget.letterSpacing,
      wordSpacing: widget.wordSpacing,
    );
  }

  Widget _buildLabel() {
    if (widget.label == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: widget.label,
          style: widget.labelStyle ??
              TextStyle(
                color: widget.labelColor ?? Colors.black87,
                fontSize: widget.labelFontSize ?? 14,
                fontWeight: widget.labelFontWeight ?? FontWeight.normal,
              ),
          children: [
            if (widget.labelRequired || widget.required)
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: widget.labelRequiredColor ?? Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelperOrError() {
    if (widget.hasError && widget.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Text(
          widget.errorMessage!,
          maxLines: widget.errorMaxLines,
          style: TextStyle(
            color: widget.errorColor ?? Colors.red,
            fontSize: widget.errorFontSize ?? 12,
            fontWeight: widget.errorFontWeight,
          ),
        ),
      );
    }

    if (widget.helperText != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Text(
          widget.helperText!,
          maxLines: widget.helperTextMaxLines,
          style: TextStyle(
            color: widget.helperTextColor ?? Colors.grey[600],
            fontSize: widget.helperTextFontSize ?? 12,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    Widget inputField = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.mouseCursor ?? SystemMouseCursors.text,
      child: AnimatedContainer(
        duration: widget.animateOnFocus ? widget.transitionDuration : Duration.zero,
        curve: widget.transitionCurve,
        decoration: _getCurrentDecoration(),
        transform: widget.transform,
        transformAlignment: widget.transformAlignment,
        clipBehavior: widget.clipBehavior,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autoFocus,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          style: _getTextStyle(),
          showCursor: widget.showCursor,
          cursorColor: widget.cursorColor,
          cursorWidth: widget.cursorWidth ?? 2.0,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          inputFormatters: widget.inputFormatters,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          obscuringCharacter: widget.obscuringCharacterString,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onTapOutside: widget.onTapOutside != null
              ? (_) => widget.onTapOutside!()
              : null,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: _getPlaceholderStyle(),
            labelText: widget.floatingLabel ? widget.label : null,
            labelStyle: widget.floatingLabelStyle,
            floatingLabelStyle: widget.floatingLabelStyle,
            prefixIcon: widget.prefixIcon != null
                ? IconTheme(
              data: IconThemeData(
                color: widget.iconColor,
                size: widget.iconSize,
              ),
              child: widget.prefixIcon!,
            )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? IconTheme(
              data: IconThemeData(
                color: widget.iconColor,
                size: widget.iconSize,
              ),
              child: widget.suffixIcon!,
            )
                : null,
            prefix: widget.prefix,
            suffix: widget.suffix,
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            prefixIconConstraints: widget.prefixIconConstraints,
            suffixIconConstraints: widget.suffixIconConstraints,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            filled: widget.filled,
            fillColor: widget.fillColor,
            counter: widget.counter,
            counterText: widget.counterText,
            counterStyle: widget.counterStyle,
          ),
        ),
      ),
    );

    // Wrap in container with width/height constraints
    if (widget.width != null || widget.height != null ||
        widget.maxWidth != null || widget.minWidth != null) {
      inputField = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth ?? double.infinity,
          minWidth: widget.minWidth ?? 0,
          maxHeight: widget.height ?? double.infinity,
          minHeight: widget.height ?? 0,
        ),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: inputField,
        ),
      );
    }

    // Apply margin and padding
    if (widget.margin != null || widget.padding != null) {
      inputField = Container(
        margin: widget.margin,
        padding: widget.padding,
        child: inputField,
      );
    }

    // Build the complete widget with label and helper/error text
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.floatingLabel) _buildLabel(),
        inputField,
        _buildHelperOrError(),
      ],
    );
  }
}