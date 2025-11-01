import 'package:flutter/material.dart';
import 'package:formbuilder/tools/tools.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../services/themeService.dart';

Widget simpleAppBar(BuildContext context, {required String text,Widget? child,required theme t, bool? isX}) {
  final colorScheme = Theme.of(context).colorScheme;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      buildCancelIconButton(t,context,isX: isX),
      Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: child ?? Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: t.secondaryTextColor,
              fontSize: 18
            ),
            softWrap: true,
          ),
        ),
      ),
      const SizedBox(width: 45),
    ],
  );
}

Widget buildCancelIconButton(
    theme t,
    BuildContext context, {
      bool? isX,
      double? iconSized,
      void Function()? onclick,
    }) {
  return Container(
    width: iconSized != null ? iconSized * 1.5 : 45,
    height: iconSized != null ? iconSized * 1.5 : 45,
    decoration: BoxDecoration(
      color: isLandscape(context)
          ? t.cardColor
          : t.bgColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center( // Center is simpler than Align here
      child: IconButton(
        onPressed: () => onclick!=null ? onclick() : Navigator.pop(context),
        padding: EdgeInsets.zero, // 👈 remove default padding
        constraints: const BoxConstraints(), // 👈 remove min size constraints
        icon: Icon(
          isX == true
              ? Icons.close_rounded
              : HugeIconsStroke.arrowLeft01,
          size: iconSized ?? 24,
          color: t.textColor,
          fill: 1,
        ),
      ),
    ),
  );
}


