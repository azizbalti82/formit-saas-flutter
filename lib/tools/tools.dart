import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../services/provider.dart';
import '../services/themeService.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';

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
  final bool landscapeMode = MediaQuery.of(context).orientation == Orientation.landscape;
  final double width = MediaQuery.of(context).size.width;
  return landscapeMode && width>800;
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



Future<String> getDefaultLocation() async {
  if (Platform.isAndroid) {
    final dir = Directory('/storage/emulated/0/vaulto');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  } else if (Platform.isWindows) {
    // Use the actual Documents folder from USERPROFILE
    final userProfile = Platform.environment['USERPROFILE'];
    if (userProfile == null) {
      throw Exception("USERPROFILE environment variable not found");
    }
    final dir = Directory(p.join(userProfile, "Documents", "vaulto"));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  } else {
    throw UnsupportedError("Platform not supported");
  }
}

double getRatio(num x, num y) {
  if (y == 0) return 0; // avoid division by zero
  return x / y;
}

Future<Map<String, int>> getStorageInfo(String path) async {
  final total = await _getTotalDiskSpace(path);
  final free = await _getFreeDiskSpace(path);
  final occupied = total - free;

  return {
    "occupied": occupied,
    "total": total,
  };
}
Future<int> _getTotalDiskSpace(String path) async {
  if (Platform.isWindows) {
    final driveLetter = path[0]; // e.g. "C"
    final result = await Process.run("wmic", [
      "logicaldisk",
      "where",
      "DeviceID='${driveLetter}:'",
      "get",
      "Size"
    ]);
    final output = result.stdout.toString().trim().split("\n");
    if (output.length > 1) {
      final sizeStr = output[1].trim();
      return int.tryParse(sizeStr) ?? 0;
    }
    return 0;
  } else if (Platform.isAndroid) {
    final stat = await _getStatvfs(path);
    return stat["total"] ?? 0;
  } else {
    throw UnsupportedError("Platform not supported");
  }
}
Future<int> _getFreeDiskSpace(String path) async {
  if (Platform.isWindows) {
    final driveLetter = path[0]; // e.g. "C"
    final result = await Process.run("wmic", [
      "logicaldisk",
      "where",
      "DeviceID='${driveLetter}:'",
      "get",
      "FreeSpace"
    ]);
    final output = result.stdout.toString().trim().split("\n");
    if (output.length > 1) {
      final freeStr = output[1].trim();
      return int.tryParse(freeStr) ?? 0;
    }
    return 0;
  } else if (Platform.isAndroid) {
    final result = await Process.run("stat", ["-f", "-c", "%S %a", path]);
    final output = result.stdout.toString().trim().split(" ");
    if (output.length == 2) {
      final blockSize = int.tryParse(output[0]) ?? 0;
      final freeBlocks = int.tryParse(output[1]) ?? 0;
      return blockSize * freeBlocks;
    }
    return 0;
  } else {
    throw UnsupportedError("Platform not supported");
  }
}
Future<Map<String, int>> _getStatvfs(String path) async {
  final result = await Process.run("stat", ["-f", "-c", "%S %b %a", path]);
  final output = result.stdout.toString().trim().split(" ");
  if (output.length == 3) {
    final blockSize = int.tryParse(output[0]) ?? 0;
    final totalBlocks = int.tryParse(output[1]) ?? 0;
    final freeBlocks = int.tryParse(output[2]) ?? 0;
    return {
      "total": blockSize * totalBlocks,
      "free": blockSize * freeBlocks,
    };
  }
  return {"total": 0, "free": 0};
}
String formatBytes(int bytes, [int decimals = 2]) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB"];
  int i = (bytes > 0) ? (bytes.logBase(1024)).floor() : 0;
  double size = bytes / (1 << (10 * i));
  return "${size.toStringAsFixed(decimals)} ${suffixes[i]}";
}
extension NumExtensions on num {
  double logBase(num base) => (this > 0 ? (log(this) / log(base)) : 0);
}

Future<String?> pickDirectory() async {
  try {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      return result; // folder path chosen
    }
    return null; // user cancelled
  } catch (e) {
    print("Error picking directory: $e");
    return null;
  }
}
