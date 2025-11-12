import '../backend/models/collection/collection.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formbuilder/backend/models/account/user.dart';
import 'package:formbuilder/screens/home/widgets/dropList.dart';
import 'package:formbuilder/screens/auth/intro.dart';
import 'package:formbuilder/screens/auth/verifyEmail.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

import '../backend/models/collection/collection.dart';
import '../backend/models/form/form.dart';
import '../../data/constants.dart';
import '../../main.dart';
import '../../services/provider.dart';
import '../../services/sharedPreferencesService.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/complex.dart';
import '../../widgets/dialogues.dart';
import '../../widgets/menu.dart';
import '../../widgets/messages.dart';
import '../../backend/models/path.dart';

import 'dart:typed_data';
import 'package:flutter/material.dart';

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
            ClipOval(
              child: Image.memory(
                imageBytes!,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),

          // Edit icon overlay when image is present
          if (imageBytes != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(size * 0.07,),
                decoration: BoxDecoration(
                  color: t.accentColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: size * 0.2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


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

  const _IntegrationCard({
    required this.integration,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: t.cardColor,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              integration.iconPath,
              height: 40,
              width: 40,
            ),
            const SizedBox(height: 8),
            Text(
              integration.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: t.textColor
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


class Statistic {
  final String title;
  final String value;
  final String? iconPath;

  const Statistic({
    required this.title,
    required this.value,
    this.iconPath,
  });
}
class StatisticsGrid extends StatefulWidget {
  final theme t;

  const StatisticsGrid({
    super.key,
    required this.t,
  });

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
        const Statistic(
          title: "Total Submissions",
          value: "1,248",
        ),
        const Statistic(
          title: "Completions",
          value: "67",
        ),
        const Statistic(
          title: "Started Answering",
          value: "22",
        ),
        const Statistic(
          title: "Completion Rate",
          value: "92%",
        ),
        const Statistic(
          title: "Form Views",
          value: "67",
        ),
        const Statistic(
          title: "Unique Views",
          value: "18",
        ),
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

  const _StatisticCard({
    required this.stat,
    required this.t,
  });

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
              style: TextStyle(
                color: t.secondaryTextColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

