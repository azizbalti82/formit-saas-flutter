import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Color? textColor;
  final bool isLoading;
  final IconData? icon;
  final bool isFullRow;
  final double? iconSize;
  final theme t;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isLoading,
    this.isFullRow = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconSize, required this.t,
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
    // TODO: implement initState
    super.initState();
    t = widget.t;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      t = getTheme();
    Color bgColor = widget.backgroundColor ?? t.accentColor;
    Color fgColor = widget.textColor ?? t.bgColor ;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        width: widget.isFullRow ? double.infinity : null,
        height: 50,
        child: FilledButton(
          onPressed: widget.onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: fgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: _isHovered ? BorderSide(color: bgColor, width: 1) : BorderSide.none,
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null)
                Icon(widget.icon,color: fgColor,),
              if (widget.isLoading) const SizedBox(width: 8),
              if (widget.isLoading)
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: fgColor,
                  ),
                ),
              const SizedBox(width: 12),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16,
                  color: fgColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  });}
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
              mainAxisSize: MainAxisSize.min,
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
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.size ?? 16,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
    }) {
  final ValueNotifier<bool> obscure = ValueNotifier<bool>(isPassword);

  return ValueListenableBuilder(
    valueListenable: obscure,
    builder: (context, value, child) {
      return TextFormField(
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
          fillColor: theme.cardColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.border, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.border, width: 1),
          ),
        ),
        textAlignVertical: TextAlignVertical.center,
      );
    },
  );
}