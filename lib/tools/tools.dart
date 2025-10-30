import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/provider.dart';
import '../services/themeService.dart';

void navigateTo(BuildContext context, Widget destination, isReplace) {
  PageRouteBuilder p = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destination,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;
      var tween = Tween<Offset>(
        begin: const Offset(0.0, 0.1),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));
      var fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
  if (isReplace) {
    Navigator.pushReplacement(context, p);
  } else {
    Navigator.push(context, p);
  }
}

navigate(BuildContext c, Widget screen, {bool? isReplace}) {
  //remove focus on all selected inputs
  FocusManager.instance.primaryFocus?.unfocus();
  if (isReplace != null && isReplace) {
    Navigator.pushReplacement(
      c,
      MaterialPageRoute(builder: (context) => screen),
    );
  } else {
    Navigator.push(c, MaterialPageRoute(builder: (context) => screen));
  }
}

theme getTheme() {
  Provider provider = Get.find<Provider>();
  return provider.isDark.value ? darkTheme:lightTheme;
}

DateTime getCurrentDate() {
  return DateTime.now();
}


bool isLandscape(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return MediaQuery.of(context).orientation == Orientation.landscape &&
      size.width > size.height && size.width > 600;
}

Color getRandomHighContrastColor() {
  final random = Random();
  final index = random.nextInt(100); // pick from 100 colors

  return HSLColor.fromAHSL(
    1.0,                        // solid color
    (index * 3.6) % 360,        // evenly spread hue
    0.85,                       // high saturation for vivid colors
    0.35,                       // darker lightness for better contrast with white text
  ).toColor();
}
double getRatio(num x, num y) {
  if (y == 0) return 0; // avoid division by zero
  return x / y;
}

/// Picks an image from the device and returns it.
/// On mobile/desktop → returns a [File].
/// On web → returns [Uint8List].
Future<Uint8List?> pickImage() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true, // ensures bytes are available
  );

  if (result == null) return null;

  if (kIsWeb) {
    return result.files.single.bytes;
  } else {
    final path = result.files.single.path!;
    return await File(path).readAsBytes();
  }
}

void runEvery3Seconds(void Function() action) {
  Timer.periodic(const Duration(seconds: 3), (timer) => action());
}