import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formbuilder/services/themeService.dart';
import 'package:forui/forui.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../screens/auth/intro.dart';
import '../screens/auth/verifyEmail.dart';
import '../tools/tools.dart';
import 'complex.dart';
import 'messages.dart';

// --------------------------------------------------------------------------
// NEW FOLDER DIALOG
// --------------------------------------------------------------------------
Future showDialogNewFolder(BuildContext context, theme t) async {
  final TextEditingController inputController = TextEditingController();
  return dialogBuilder(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      title: const Text(
        "Create New Collection",
        style: TextStyle(fontSize: 22),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          FTextField(
            controller: inputController,
            hint: 'Enter Collection Name',
            maxLines: 1,
            clearable: (value) => value.text.isNotEmpty,
          ),
        ],
      ),
      actions: [
        FButton(
          onPress: () {
            showMsg("Collection ${inputController.text} created!", context, t);
            Navigator.pop(context);
          },
          child: const Text('Create Collection'),
        ),
      ],
    ),
  );
}

// --------------------------------------------------------------------------
// PROFILE DIALOG
// --------------------------------------------------------------------------
Future showDialogProfile(BuildContext context, theme t) async {
  return dialogBuilder(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      title: const Text("Edit Profile", style: TextStyle(fontSize: 22)),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: ProfileTabsWidget(t: t),
        ),
      ),
      actions: const [],
    ),
  );
}

// --------------------------------------------------------------------------
// PROFILE TABS WIDGET (STATEFUL)
// --------------------------------------------------------------------------
class ProfileTabsWidget extends StatefulWidget {
  const ProfileTabsWidget({super.key, required this.t});
  final theme t;

  @override
  State<ProfileTabsWidget> createState() => _ProfileTabsWidgetState();
}
class _ProfileTabsWidgetState extends State<ProfileTabsWidget> {
  // --------------------------------------------------------------------------
  // STATE VARIABLES
  // --------------------------------------------------------------------------
  Uint8List? imageBytes;

  // --------------------------------------------------------------------------
  // CONTROLLERS
  // --------------------------------------------------------------------------
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  // --------------------------------------------------------------------------
  // LIFECYCLE METHODS
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: "aziz");
    lastNameController = TextEditingController(text: "balti");
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // BUILD METHOD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return FTabs(
      initialIndex: 0,
      onPress: (index) {},
      children: [
        FTabEntry(
          label: const Text('Info'),
          child: Expanded(child: _buildAccountInfoWidget()),
        ),
        FTabEntry(
          label: const Text('Advanced'),
          child: Expanded(child: _buildAccountAdvancedWidget()),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // INFO TAB
  // --------------------------------------------------------------------------
  Widget _buildAccountInfoWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildProfileImagePicker(),
          const SizedBox(height: 20),
          _buildNameFields(),
          const SizedBox(height: 10),
          _buildEmailPasswordCard("Edit Email",verifyEmailType.updateEmail),
          const SizedBox(height: 10),
          _buildEmailPasswordCard("Edit Password",verifyEmailType.updatePassword),
          const SizedBox(height: 20),
          FButton(
            onPress: () {
              showMsg("Profile updated!", context, widget.t);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  Widget _buildProfileImagePicker() {
    return InkWell(
      onTap: _handleImagePick,
      borderRadius: BorderRadius.circular(300),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.t.textColor.withOpacity(0.1),
              border: Border.all(
                width: 2,
                color: imageBytes != null
                    ? widget.t.accentColor.withOpacity(0.5)
                    : Colors.transparent,
              ),
            ),
          ),
          if (imageBytes == null)
            Icon(
              Icons.add_a_photo_outlined,
              size: 35,
              color: widget.t.textColor.withOpacity(0.3),
            )
          else
            ClipOval(
              child: Image.memory(
                imageBytes!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          if (imageBytes != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: widget.t.accentColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: FTextField(
            controller: firstNameController,
            hint: 'First name',
            maxLines: 1,
            clearable: (value) => value.text.isNotEmpty,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FTextField(
            controller: lastNameController,
            hint: 'Last name',
            maxLines: 1,
            clearable: (value) => value.text.isNotEmpty,
          ),
        ),
      ],
    );
  }
  Widget _buildEmailPasswordCard(String text,verifyEmailType type) {
    return GestureDetector(
      onTap: () => _navigateToVerifyEmail(type),
      child: FCard.raw(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              Text(text, textAlign: TextAlign.center),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                child: Icon(HugeIconsStroke.edit04,color: widget.t.secondaryTextColor,size: 18,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // ADVANCED TAB
  // --------------------------------------------------------------------------
  Widget _buildAccountAdvancedWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              SvgPicture.asset(
                "assets/icons/danger.svg",
                width: 22.0,
                color: widget.t.textColor,
              ),
              const SizedBox(width: 8),
              Text(
                "Danger zone",
                style: TextStyle(
                  color: widget.t.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "This will permanently delete your entire account. All your forms, submissions and workspaces will be deleted.",
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          FButton(
            onPress: () => _showDeleteAccountDialog(),
            style: FButtonStyle(
              decoration: FWidgetStateMap.all(
                BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              contentStyle: FButtonContentStyle(
                textStyle: FWidgetStateMap.all(
                  const TextStyle(color: Colors.white),
                ),
                iconStyle: FWidgetStateMap.all(
                  const IconThemeData(color: Colors.white),
                ),
              ),
              iconContentStyle: FButtonIconContentStyle(
                iconStyle: FWidgetStateMap.all(
                  const IconThemeData(color: Colors.white),
                ),
              ),
              tappableStyle: FTappableStyle(),
              focusedOutlineStyle: FFocusedOutlineStyle(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            ).call,
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
  // --------------------------------------------------------------------------
  // ACTION HANDLERS
  // --------------------------------------------------------------------------
  Future<void> _handleImagePick() async {
    try {
      var image = await pickImage();
      if (image == null) return;

      if (mounted) {
        setState(() {
          imageBytes = image;
        });
      }
    } catch (e) {
      if (mounted) {
        showError("Error while picking image", context);
      }
    }
  }
  void _navigateToVerifyEmail(verifyEmailType type) {
    navigateTo(
      context,
      VerifyEmail(
        t: darkTheme,
        type: type,
        email: "aziz@gmail.com", // Replace with actual email
      ),
      false,
    );
  }
  Future<void> _showDeleteAccountDialog() async {
    return showDialogDeleteAccount(context, widget.t);
  }
}

// --------------------------------------------------------------------------
// DELETE ACCOUNT DIALOG
// --------------------------------------------------------------------------
Future showDialogDeleteAccount(BuildContext context, theme t) async {
  return dialogBuilder(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      title: const Text(
        'Are you absolutely sure?',
        style: TextStyle(fontSize: 22),
      ),
      body: const Column(
        children: [
          SizedBox(height: 20),
          Text(
            'This action is permanent and will delete this account with its data.',
          ),
          SizedBox(height: 20),
        ],
      ),
      actions: [
        FButton(
          onPress: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            navigateTo(context, const StartScreen(canBack: false), true);
            showMsg("Account deleted!", context, t);
          },
          style: FButtonStyle(
            decoration: FWidgetStateMap.all(
              BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            contentStyle: FButtonContentStyle(
              textStyle: FWidgetStateMap.all(
                const TextStyle(color: Colors.white),
              ),
              iconStyle: FWidgetStateMap.all(
                const IconThemeData(color: Colors.white),
              ),
            ),
            iconContentStyle: FButtonIconContentStyle(
              iconStyle: FWidgetStateMap.all(
                const IconThemeData(color: Colors.white),
              ),
            ),
            tappableStyle: FTappableStyle(),
            focusedOutlineStyle: FFocusedOutlineStyle(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
          ).call,
          child: const Text('Delete Account'),
        ),
        FButton(
          style: FButtonStyle.outline(),
          onPress: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}