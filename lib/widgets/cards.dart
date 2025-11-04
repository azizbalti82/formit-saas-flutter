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
