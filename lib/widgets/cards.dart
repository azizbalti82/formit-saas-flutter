import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart' hide Svg;
import 'package:formbuilder/widgets/messages.dart';
import 'package:forui/forui.dart';
import 'package:image/image.dart' as img;

import '../../services/themeService.dart';
import '../backend/models/integration.dart';

class ProfileImagePicker extends StatelessWidget {
  final Uint8List? imageBytes;
  final VoidCallback onImagePick;
  final theme t; // your theme class (you can replace with your own type)
  final double size;

  const ProfileImagePicker({
    Key? key,
    required this.onImagePick,
    required this.t,
    this.imageBytes,
    this.size = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onImagePick,
      borderRadius: BorderRadius.circular(size / 2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular background container
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: t.textColor.withOpacity(0.1),
              border: Border.all(
                width: 2,
                color: imageBytes != null
                    ? t.accentColor.withOpacity(0.5)
                    : Colors.transparent,
              ),
            ),
          ),

          // If no image, show camera icon
          if (imageBytes == null)
            Icon(
              Icons.add_a_photo_outlined,
              size: size * 0.35,
              color: t.textColor.withOpacity(0.3),
            )
          else
          // If image exists, display it
            imageBytes != null
                ? _buildImageWidget(imageBytes!, size, context)
                : Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: Icon(Icons.image, size: size * 0.5),
            ),

          // Edit icon overlay when image is present
          if (imageBytes != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                    padding: EdgeInsets.all(size * 0.07),
                    decoration: BoxDecoration(
                      color: t.accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.edit, size: size * 0.2, color: Colors.white),
                  ),
            ),
        ],
      ),
    );
  }
  Widget _buildImageWidget(Uint8List imageBytes, double size,BuildContext context) {
    final format = _detectImageFormat(imageBytes);
    Widget imageWidget;
    if(format == 'svg'){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showMsg("Some SVG details may not display perfectly on desktop 😊", context, t);
      });
    }
    switch (format) {
      case 'svg':
        imageWidget = SvgPicture.memory(
          imageBytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          allowDrawingOutsideViewBox: true,
        );
        break;

      case 'ico':
        // Convert ICO to standard format
        try {
          final icoImage = img.decodeIco(imageBytes);
          if (icoImage != null) {
            final pngBytes = Uint8List.fromList(img.encodePng(icoImage));
            imageWidget = Image.memory(
              pngBytes,
              width: size,
              height: size,
              fit: BoxFit.cover,
            );
          } else {
            imageWidget = _errorWidget(size);
          }
        } catch (e) {
          imageWidget = _errorWidget(size);
        }
        break;

      default:
        // Handle standard formats (PNG, JPG, GIF, WebP, BMP, etc.)
        imageWidget = Image.memory(
          imageBytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _errorWidget(size);
          },
        );
    }

    return ClipOval(child: imageWidget);
  }
  String _detectImageFormat(Uint8List bytes) {
    // SVG detection (XML/text based)
    if (bytes.length > 5) {
      final header = String.fromCharCodes(bytes.take(100));
      if (header.contains('<svg') || header.contains('<?xml')) {
        return 'svg';
      }
    }

    // ICO detection
    if (bytes.length > 4 &&
        bytes[0] == 0x00 &&
        bytes[1] == 0x00 &&
        bytes[2] == 0x01 &&
        bytes[3] == 0x00) {
      return 'ico';
    }

    // PNG
    if (bytes.length > 8 && bytes[0] == 0x89 && bytes[1] == 0x50) {
      return 'png';
    }

    // JPEG
    if (bytes.length > 2 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return 'jpg';
    }

    // GIF
    if (bytes.length > 6 &&
        bytes[0] == 0x47 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46) {
      return 'gif';
    }

    // WebP
    if (bytes.length > 12 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return 'webp';
    }

    // BMP
    if (bytes.length > 2 && bytes[0] == 0x42 && bytes[1] == 0x4D) {
      return 'bmp';
    }

    // Default to standard image
    return 'standard';
  }
  Widget _errorWidget(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: Icon(
        Icons.broken_image,
        size: size * 0.5,
        color: Colors.grey[600],
      ),
    );
  }
}

// integration cards ------------------------------------------------------------
class IntegrationsGrid extends StatelessWidget {
  final List<Integration> integrations;
  final theme t;

  const IntegrationsGrid({
    super.key,
    required this.integrations,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxCrossAxisExtent = 600;
            if (constraints.maxWidth > 500) {
              maxCrossAxisExtent = 180; // ~3 columns
            } else if (constraints.maxWidth > 350) {
              maxCrossAxisExtent = 180; // ~2 columns
            } else {
              maxCrossAxisExtent = 600; // 1 column
            }
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: integrations.map((integration) {
                return SizedBox(
                  width: maxCrossAxisExtent,
                  child: _IntegrationCard(integration: integration, t: t),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _IntegrationCard extends StatelessWidget {
  final Integration integration;
  final theme t;

  const _IntegrationCard({required this.integration, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: t.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(integration.iconPath, height: 40, width: 40),
            const SizedBox(height: 8),
            Text(
              integration.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: t.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              integration.description,
              textAlign: TextAlign.center,
              style: TextStyle(color: t.secondaryTextColor),
            ),
            const SizedBox(height: 12),
            FButton.icon(
              onPress: integration.onConnect,
              style: FButtonStyle.ghost(),
              child: Text(
                "Connect",
                style: TextStyle(
                  color: t.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// statistics cards -------------------------------------------------------------
class Statistic {
  final String title;
  final String value;
  final String? iconPath;

  const Statistic({required this.title, required this.value, this.iconPath});
}

class StatisticsGrid extends StatefulWidget {
  final theme t;

  const StatisticsGrid({super.key, required this.t});

  @override
  State<StatisticsGrid> createState() => _StatisticsGridState();
}

class _StatisticsGridState extends State<StatisticsGrid> {
  List<Statistic> stats = [];

  @override
  void initState() {
    super.initState();

    // Simulate data loading (you can replace this with async loading later)
    _loadStats();
  }

  void _loadStats() {
    // Example: load stats here (can be from API, DB, etc.)
    setState(() {
      stats = [
        const Statistic(title: "Total Submissions", value: "1,248"),
        const Statistic(title: "Completions", value: "67"),
        const Statistic(title: "Started Answering", value: "22"),
        const Statistic(title: "Completion Rate", value: "92%"),
        const Statistic(title: "Form Views", value: "67"),
        const Statistic(title: "Unique Views", value: "18"),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: stats.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "Loading statistics...",
                  style: TextStyle(color: t.secondaryTextColor),
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  double maxCrossAxisExtent = 600;
                  if (constraints.maxWidth > 500) {
                    maxCrossAxisExtent = 180; // ~3 columns
                  } else if (constraints.maxWidth > 350) {
                    maxCrossAxisExtent = 180; // ~2 columns
                  } else {
                    maxCrossAxisExtent = 600; // 1 column
                  }

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: stats.map((stat) {
                      return SizedBox(
                        width: maxCrossAxisExtent,
                        child: _StatisticCard(stat: stat, t: t),
                      );
                    }).toList(),
                  );
                },
              ),
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final Statistic stat;
  final theme t;

  const _StatisticCard({required this.stat, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: t.bgColor,
        border: Border.all(color: t.border, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              stat.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: t.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stat.title,
              textAlign: TextAlign.center,
              style: TextStyle(color: t.secondaryTextColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
