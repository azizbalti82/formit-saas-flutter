import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import '../services/themeService.dart';

Widget simpleAppBar(BuildContext context, {required String text,Widget? child,required theme t}) {
  final colorScheme = Theme.of(context).colorScheme;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: t.cardColor, // cardColor equivalent
          borderRadius: BorderRadius.circular(50),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(HugeIconsStroke.arrowLeft01, size: 24,color: t.textColor,),
        ),
      ),
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
