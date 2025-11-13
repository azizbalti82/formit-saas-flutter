import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../services/provider.dart';
import '../services/themeService.dart';
import '../tools/tools.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor; // ✅ text + icon + loader color
  final bool isLoading;
  final IconData? icon;
  final bool isFullRow;
  final double? iconSize;
  final double? maxWidth;
  final theme t;
  final double? height;
  final EdgeInsetsGeometry? padding; // ✅ optional padding

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
    this.isFullRow = true,
    this.padding,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconSize,
    this.maxWidth,
    required this.t,
    this.height,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;
  final Provider provider = Get.find<Provider>();
  late theme t;

  @override
  void initState() {
    super.initState();
    t = widget.t;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      t = getTheme();

      // ✅ Determine colors
      final Color bgColor = widget.backgroundColor ?? t.accentColor;
      final Color fgColor = widget.textColor ?? t.bgColor;

      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: widget.isFullRow ? double.infinity : null,
          height: widget.height ?? 50,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: widget.maxWidth ?? double.infinity,
            ),
            child: FilledButton(
              onPressed: widget.onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: fgColor, // ✅ applies to text/icons
                padding: widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: _isHovered
                      ? BorderSide(color: bgColor, width: 1)
                      : BorderSide.none,
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null)
                    Icon(widget.icon, color: fgColor, size: widget.iconSize),
                  if (widget.isLoading) const SizedBox(width: 8),
                  if (widget.isLoading)
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: fgColor, // ✅ match text color
                      ),
                    ),
                  if (widget.icon != null || widget.isLoading)
                    const SizedBox(width: 8),
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: fgColor, // ✅ match text color
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class CustomButtonOutline extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final IconData? icon;
  final String? iconSvg;
  final double? size;
  final bool isFullRow;
  final double height;
  final double borderSize;
  final theme t;

  const CustomButtonOutline({
    Key? key,
    this.text = "",
    this.icon,
    this.iconSvg,
    this.isFullRow = true,
    this.size,
    required this.onPressed,
    required this.isLoading,
    this.backgroundColor,
    this.textColor,
    this.height = 55,
    this.borderSize = 1, required this.t,
  }) : super(key: key);

  @override
  State<CustomButtonOutline> createState() => _CustomButtonOutlineState();
}
class _CustomButtonOutlineState extends State<CustomButtonOutline> {
  bool _isHovered = false;
  late theme t;
  final Provider provider = Get.find<Provider>();

  @override
  void initState() {
    super.initState();
    t = widget.t;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      t = getTheme();
      Color borderColor = widget.backgroundColor?.withOpacity(0.7) ??
          t.accentColor.withOpacity(0.7);
      Color textColor = _isHovered ? (widget.backgroundColor?.withOpacity(0.8) ??
          t.accentColor.withOpacity(0.8)) : (widget.backgroundColor ??
          t.accentColor);

      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: widget.isFullRow ? double.infinity : null,
          height: widget.height,
          child: FilledButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    width: widget.borderSize, color: borderColor),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon == null && widget.iconSvg!=null)
                  SvgPicture.asset(
                  "assets/icons/${widget.iconSvg}.svg",
                  width: 22.0,
                  color: textColor,
                ),
                if (widget.icon != null && widget.iconSvg==null)
                  Icon(widget.icon,color: textColor,),
                if (widget.isLoading) const SizedBox(width: 8),
                if (widget.isLoading)
                  SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor,
                    ),
                  ),
                if(widget.text.isNotEmpty)
                  const SizedBox(width: 12),
                if(widget.text.isNotEmpty)
                  Flexible(child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.size ?? 16,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),)
              ],
            ),
          ),
        ),
      );
    });
  }
}

Widget customInput(
    theme theme,
    TextEditingController controller,
    String? placeholder,
    String? text,
    BuildContext context, {
      bool isPassword = false,
      bool isEmail = false,
      int? maxLines,
      Color? backgroundColor,
      bool? haveBorder = true,
      bool isEnabled=true, bool isFocusable=true,
    }) {
  final ValueNotifier<bool> obscure = ValueNotifier<bool>(isPassword);

  return ValueListenableBuilder(
    valueListenable: obscure,
    builder: (context, value, child) {
      return TextFormField(
        enabled: isEnabled,
        controller: controller,
        obscureText: isPassword ? value : false,
        maxLines: isPassword
            ? 1
            : (maxLines ?? 2),
        minLines: 1,
        style: TextStyle(color: theme.textColor),
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        autovalidateMode: isEmail ? AutovalidateMode.onUserInteraction : null,
        validator: isEmail
            ? (val) {
          if (val == null || val.isEmpty) {
            return "Please enter your email";
          }
          final emailRegex =
          RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"); // basic email validation
          if (!emailRegex.hasMatch(val)) {
            return "Enter a valid email";
          }
          return null;
        }
            : null,

        decoration: InputDecoration(
          // 👇 remove hover/focus glow when not focusable
          hoverColor: isFocusable ? null : Colors.transparent,
          focusColor: isFocusable ? null : Colors.transparent,
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              value ? Icons.visibility_off : Icons.visibility,
              color: theme.secondaryTextColor,
            ),
            onPressed: () => obscure.value = !value,
          )
              : const SizedBox.shrink(),
          hintText: placeholder ?? 'Write something...',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w300,
            color: theme.secondaryTextColor.withOpacity(0.4),
          ),
          filled: true,
          fillColor: backgroundColor?? theme.cardColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          border: haveBorder!=null&&haveBorder? OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.border, width: 1),
          ) : InputBorder.none, // Set to InputBorder.none when no border
          enabledBorder: haveBorder!=null&&haveBorder? OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.border, width: 1),
          ) : InputBorder.none, // Set to InputBorder.none when no border
          focusedBorder: haveBorder!=null&&haveBorder? OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.border, width: 1),
          ) : InputBorder.none, // Set to InputBorder.none when no border
          errorBorder: haveBorder!=null&&haveBorder? OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ) : InputBorder.none, // Add this for error state
          focusedErrorBorder: haveBorder!=null&&haveBorder? OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ) : InputBorder.none, // Add this for focused error state
          disabledBorder: haveBorder!=null&&haveBorder? OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.border, width: 1),
          ) : InputBorder.none, // Add this for disabled state
        ),
        textAlignVertical: TextAlignVertical.center,
      );
    },
  );
}