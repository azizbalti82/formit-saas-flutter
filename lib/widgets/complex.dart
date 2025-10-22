import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

dialogBuilder({required BuildContext context,required Widget Function(BuildContext, FDialogStyle, Animation<double>) builder}){
  return showFDialog(
    context: context,
    style: (style) => style.copyWith(
      barrierFilter: (animation) => ImageFilter.compose(
        outer: ImageFilter.blur(
          sigmaX: animation * 5,
          sigmaY: animation * 5,
        ),
        inner: ColorFilter.mode(
          Theme.of(context).colorScheme.surface.withOpacity(0.5),
          BlendMode.srcOver,
        ),
      ),
    ),
    builder: builder,
  );
}
