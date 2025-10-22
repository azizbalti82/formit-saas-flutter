import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

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
  final double? size;
  final bool isFullRow;
  final double height;
  final double borderSize;
  final theme t;

  const CustomButtonOutline({
    Key? key,
    this.text = "",
    this.icon,
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
                if (widget.icon != null)
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
            return "Please enter your email (optional)";
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


Widget customWordInput(
    theme theme,
    TextEditingController controller,
    String? placeholder,
    String? text,
    BuildContext context,
    bool isShown,
    theme t
    ) {
  final ValueNotifier<bool> obscure = ValueNotifier<bool>(true);
  final GlobalKey textFieldKey = GlobalKey();

  return ValueListenableBuilder(
      valueListenable: obscure,
      builder: (context, value, child) {
        return RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
                final text = controller.text;
                final selection = controller.selection;

                if (selection.start == selection.end) {
                  // No selection, just caret
                  final cursorPos = selection.start;
                  if (cursorPos > 0) {
                    // Find the word boundaries around cursor
                    final beforeCursor = text.substring(0, cursorPos);
                    final afterCursor = text.substring(cursorPos);

                    // Find start of current word (last space before cursor or beginning)
                    int wordStart = beforeCursor.lastIndexOf(' ');
                    if (wordStart == -1) {
                      wordStart = 0; // Beginning of text
                    } else {
                      wordStart += 1; // After the space
                    }

                    // Check if cursor is at the end of a word or in the middle
                    if (cursorPos > wordStart) {
                      // We're in a word, delete the entire word
                      String newText = text.substring(0, wordStart) + afterCursor;

                      // Remove any double spaces that might result
                      newText = newText.replaceAll(RegExp(r'\s+'), ' ');

                      controller.text = newText;
                      controller.selection = TextSelection.collapsed(offset: wordStart);
                    } else if (cursorPos > 0 && text[cursorPos - 1] == ' ') {
                      // We're right after a space, just delete the space
                      String newText = text.substring(0, cursorPos - 1) + afterCursor;
                      controller.text = newText;
                      controller.selection = TextSelection.collapsed(offset: cursorPos - 1);
                    }
                  }
                } else {
                  // If user selected text → delete selection normally
                  final newText = text.replaceRange(selection.start, selection.end, '');
                  controller.text = newText;
                  controller.selection = TextSelection.collapsed(offset: selection.start);
                }
              }
            },
            child: Stack(
              children: [
                TextFormField(
                  key: textFieldKey,
                  controller: controller,
                  obscureText: false,
                  maxLines: 4,
                  minLines: 1,
                  style: TextStyle(color: theme.textColor),
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    // Ensure only single spaces between words
                    String processedText = text.replaceAll(RegExp(r'\s+'), ' ');

                    // Only update if the text actually changed
                    if (processedText != text) {
                      final cursorPos = controller.selection.baseOffset;
                      controller.text = processedText;

                      // Adjust cursor position if text was shortened
                      final newCursorPos = cursorPos > processedText.length
                          ? processedText.length
                          : cursorPos;

                      controller.selection = TextSelection.collapsed(offset: newCursorPos);
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: isShown
                        ? IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: theme.secondaryTextColor,
                      ),
                      onPressed: (){

                      },
                    )
                        : const SizedBox.shrink(),
                    hintText: placeholder ?? 'Write something...',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: theme.secondaryTextColor,
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
                ),
                if(!isShown)
                  Positioned.fill(
                    child: BlurryContainer(
                      blur: 4,
                      elevation: 0,
                      color: t.cardColor.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: const SizedBox.expand(),
                    ),
                  ),
              ],
            )
        );
      });
}