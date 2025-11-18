import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons_pro/hugeicons.dart';

enum ImageSourceType { network, file, bytes, asset }

class GeneralImageViewer extends StatelessWidget {
  final Uint8List? imageBytes;
  final File? imageFile;
  final String? imageUrl;
  final String? assetPath;
  final ImageSourceType? sourceType;

  final double? width;
  final double? height; // NEW: Direct height option
  final double? heightPercentage;
  final double? aspectRatio;
  final double borderRadius;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  // BORDER OPTIONS
  final double borderWidth;
  final Color borderColor;
  final bool showBorder;

  const GeneralImageViewer({
    Key? key,
    this.imageBytes,
    this.imageFile,
    this.imageUrl,
    this.assetPath,
    this.sourceType,
    this.width,
    this.height, // NEW
    this.heightPercentage,
    this.aspectRatio,
    this.borderRadius = 8.0,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderWidth = 0,
    this.borderColor = Colors.white,
    this.showBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? child;

    try {
      switch (sourceType) {
        case ImageSourceType.bytes:
          if (imageBytes != null) {
            final ext = _getExtensionFromBytes(imageBytes!);
            if (ext == 'svg') {
              child = SvgPicture.memory(
                imageBytes!,
                fit: fit,
                placeholderBuilder: (_) => placeholder ?? _defaultPlaceholder(),
              );
            } else {
              child = Image.memory(
                imageBytes!,
                fit: fit,
                errorBuilder: (_, __, ___) => errorWidget ?? _defaultError(),
              );
            }
          }
          break;

        case ImageSourceType.file:
          if (imageFile != null) {
            final ext = imageFile!.path.split('.').last.toLowerCase();
            if (ext == 'svg') {
              child = SvgPicture.file(
                imageFile!,
                fit: fit,
                placeholderBuilder: (_) => placeholder ?? _defaultPlaceholder(),
              );
            } else {
              child = Image.file(
                imageFile!,
                fit: fit,
                errorBuilder: (_, __, ___) => errorWidget ?? _defaultError(),
              );
            }
          }
          break;

        case ImageSourceType.network:
          if (imageUrl != null) {
            final ext = imageUrl!.split('.').last.toLowerCase();
            if (ext == 'svg') {
              child = SvgPicture.network(
                imageUrl!,
                fit: fit,
                placeholderBuilder: (_) => placeholder ?? _defaultPlaceholder(),
              );
            } else {
              child = Image.network(
                imageUrl!,
                fit: fit,
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return placeholder ?? _defaultPlaceholder();
                },
                errorBuilder: (_, __, ___) => errorWidget ?? _defaultError(),
              );
            }
          }
          break;

        case ImageSourceType.asset:
          if (assetPath != null) {
            final ext = assetPath!.split('.').last.toLowerCase();
            if (ext == 'svg') {
              child = SvgPicture.asset(
                assetPath!,
                fit: fit,
                placeholderBuilder: (_) => placeholder ?? _defaultPlaceholder(),
              );
            } else {
              child = Image.asset(
                assetPath!,
                fit: fit,
                errorBuilder: (_, __, ___) => errorWidget ?? _defaultError(),
              );
            }
          }
          break;

        default:
          child = placeholder ?? _defaultPlaceholder();
      }
    } catch (e) {
      child = errorWidget ?? _defaultError();
    }

    // * CLIPPING WITH BORDER *
    Widget clipped = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: child,
    );

    // * BORDER WRAPPER *
    Widget bordered = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
      child: clipped,
    );

    // Determine width
    final finalWidth = width ?? MediaQuery.of(context).size.width;

    // Determine height with priority: height > aspectRatio > heightPercentage > square fallback
    double? finalHeight;

    if (height != null) {
      // Direct height has highest priority
      finalHeight = height!;
      return SizedBox(
        width: finalWidth,
        height: finalHeight,
        child: bordered,
      );
    } else if (aspectRatio != null) {
      // Calculate from aspect ratio
      finalHeight = finalWidth / aspectRatio!;
      return SizedBox(
        width: finalWidth,
        height: finalHeight,
        child: bordered,
      );
    } else if (heightPercentage != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = width ?? constraints.maxWidth;

          return FutureBuilder<Size>(
            future: _getImageSize(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final imageSize = snapshot.data!;

                // aspect ratio = width / height
                final aspectRatio = imageSize.width / imageSize.height;

                // The real displayed height based on available width
                final realDisplayedHeight = availableWidth / aspectRatio;

                // Now apply your percentage
                final calculatedHeight = realDisplayedHeight * heightPercentage!;

                return SizedBox(
                  width: availableWidth,
                  height: calculatedHeight,
                  child: bordered,
                );
              }

              return SizedBox(
              );
            },
          );
        },
      );
    }

    else {
      // Fallback: square
      finalHeight = finalWidth;
      return SizedBox(
        width: finalWidth,
        height: finalHeight,
        child: bordered,
      );
    }
  }

  Future<Size> _getImageSize() async {
    if (sourceType == ImageSourceType.bytes && imageBytes != null) {
      final image = await decodeImageFromList(imageBytes!);
      return Size(image.width.toDouble(), image.height.toDouble());
    } else if (sourceType == ImageSourceType.file && imageFile != null) {
      final bytes = await imageFile!.readAsBytes();
      final image = await decodeImageFromList(bytes);
      return Size(image.width.toDouble(), image.height.toDouble());
    }
    // Default fallback
    return Size(100, 100);
  }

  Widget _defaultPlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(child: Icon(HugeIconsStroke.image01, size: 40, color: Colors.white)),
    );
  }

  Widget _defaultError() {
    return Container(
      color: Colors.red.shade200,
      child: const Center(child: Icon(Icons.error, size: 40, color: Colors.white)),
    );
  }

  String _getExtensionFromBytes(Uint8List bytes) {
    final header = String.fromCharCodes(bytes.take(100));
    if (header.contains('<svg')) return 'svg';
    return 'png';
  }
}