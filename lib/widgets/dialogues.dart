import 'dart:typed_data';

import 'package:flutter/cupertino.dart' hide Form;
import 'package:flutter/material.dart' hide Form;
import 'package:flutter_svg/svg.dart';
import 'package:formbuilder/data/fakedata.dart';
import 'package:formbuilder/services/themeService.dart';
import 'package:formbuilder/widgets/form.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../backend/models/collection/collection.dart';
import '../screens/auth/intro.dart';
import '../screens/auth/verifyEmail.dart';
import '../services/provider.dart';
import '../tools/tools.dart';
import 'complex.dart';
import 'messages.dart';
import '../../backend/models/form/form.dart';

// --------------------------------------------------------------------------
// Notifications settings DIALOG
// --------------------------------------------------------------------------
Future showDialogNotificationSettings(BuildContext context, theme t) async {
  final Provider provider = Get.find<Provider>();
  return dialogBuilder(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      title: const Text(
        "Notification Settings",
        style: TextStyle(fontSize: 22),
      ),
      body: StatefulBuilder(
        builder: (context, setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            FSidebarItem(
              label: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Push Notifications"),
                        SizedBox(height: 5),
                        Text(
                          "Receive alerts directly on your device.",
                          style: TextStyle(
                            fontSize: 13,
                            color: t.secondaryTextColor,
                          ),
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    height: 5,
                    child: Transform.scale(
                      scale: 0.7,
                      child: FSwitch(
                        value: provider.pushNotifications.value,
                        onChange: (value) async {
                          provider.pushNotifications.value =
                              !provider.pushNotifications.value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              onPress: () async {},
            ),
            SizedBox(height: 10),
            FSidebarItem(
              label: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email Notifications"),
                        SizedBox(height: 5),
                        Text(
                          "Tell us what type of emails you want to receive.",
                          style: TextStyle(
                            fontSize: 13,
                            color: t.secondaryTextColor,
                          ),
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    HugeIconsStroke.arrowRight01,
                    color: t.secondaryTextColor,
                    size: 22,
                  ),
                ],
              ),
              onPress: () async {},
            ),
            /*
            FSwitchListTile(
              title: const Text(""),
              subtitle: const Text(""),
              value: emailNotifications,
              onChanged: (val) => setState(() => emailNotifications = val),
            ),
            const Divider(height: 25),
            FSwitchListTile(
              title: const Text("Reminders"),
              subtitle: const Text("Get notified for scheduled reminders."),
              value: reminderNotifications,
              onChanged: (val) => setState(() => reminderNotifications = val),
            ),

             */
          ],
        ),
      ),
      actions: [
        FButton(
          onPress: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

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
// RENAME DIALOG
// --------------------------------------------------------------------------
Future showDialogRenameCollection(
  BuildContext context,
  theme t,
  Collection collection,
) async {
  final TextEditingController inputController = TextEditingController();
  return dialogBuilder(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      title: Text("Rename Collection", style: const TextStyle(fontSize: 22)),
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
            //rename collection
            showMsg("collection renamed!", context, t);
            Navigator.pop(context);
          },
          child: const Text('Rename'),
        ),
      ],
    ),
  );
}

// --------------------------------------------------------------------------
// SEARCH DIALOG
// --------------------------------------------------------------------------
Future showDialogSearch(BuildContext context, theme t) async {
  final TextEditingController inputController = TextEditingController();
  final ValueNotifier<bool> isSearching = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hasSearched = ValueNotifier<bool>(false);

  // Fake lists for results
  List<Collection> collections = [];
  List<Form> forms = [];

  // 🔍 Listen to input changes
  inputController.addListener(() async {
    final text = inputController.text.trim();
    if (text.isEmpty) {
      hasSearched.value = false;
      return;
    }

    // Start fake search
    isSearching.value = true;
    hasSearched.value = false;

    //search for forms
    collections = fakeCollections
        .where((f) => f.name.toLowerCase().contains(text.toLowerCase()))
        .toList();

    //search for collections
    forms = getFakeForms()
        .where((f) => f.title.toLowerCase().contains(text.toLowerCase()))
        .toList();

    // End fake search
    isSearching.value = false;
    hasSearched.value = true;
  });

  return dialogBuilder(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      title: Row(
        children: [
          Icon(
            HugeIconsStroke.search01,
            color: t.secondaryTextColor,
            size: 18,
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: customInput(
                backgroundColor: t.brightness == Brightness.light
                    ? FThemes.zinc.light.colors.background
                    : FThemes.zinc.dark.colors.background,
                t,
                inputController,
                "Search for Forms & Folders",
                "",
                context,
                haveBorder: false,
                isFocusable: false,
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: isSearching,
        builder: (context, searching, _) {
          if (searching) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: t.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Searching...",
                    style: TextStyle(color: t.secondaryTextColor),
                  ),
                ],
              ),
            );
          }

          return ValueListenableBuilder<bool>(
            valueListenable: hasSearched,
            builder: (context, searched, _) {
              if (!searched) return const SizedBox.shrink();

              // When no results found
              if (collections.isEmpty && forms.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(
                        HugeIconsStroke.folderOff,
                        size: 40,
                        color: t.secondaryTextColor.withOpacity(0.6),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "No results found",
                        style: TextStyle(
                          color: t.secondaryTextColor.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Otherwise show results
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (collections.isNotEmpty) ...[
                      Text(
                        "Collections",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: t.textColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...buildCollectionCards(collections, t, context),
                      const SizedBox(height: 20),
                    ],
                    if (forms.isNotEmpty) ...[
                      Text(
                        "Forms",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: t.textColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...buildFormCards(forms, t, context),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
      actions: [],
    ),
  );
}

List<Widget> buildCollectionCards(
    List<Collection> collections, theme t, BuildContext context) {
  return collections.map((collection) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // example: close dialog or open page
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: t.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: t.border.withOpacity(0.6), width: 1),
        ),
        child: Row(
          children: [
            Icon(
              HugeIconsStroke.folder01,
              color: t.textColor.withOpacity(0.9),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                collection.name,
                style: TextStyle(
                  color: t.textColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,

              ),
            ),
            Icon(
              Icons.chevron_right,
              color: t.secondaryTextColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }).toList();
}

List<Widget> buildFormCards(
    List<Form> forms, theme t, BuildContext context) {
  return forms.map((form) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: t.cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: t.border.withOpacity(0.6), width: 1),
        ),
        child: Row(
          children: [
            Icon(
              HugeIconsStroke.file01,
              color: t.textColor.withOpacity(0.9),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                form.title,
                style: TextStyle(
                  color: t.textColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: t.secondaryTextColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }).toList();
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
          _buildEmailPasswordCard("Edit Email", verifyEmailType.updateEmail),
          const SizedBox(height: 10),
          _buildEmailPasswordCard(
            "Edit Password",
            verifyEmailType.updatePassword,
          ),
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
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
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

  Widget _buildEmailPasswordCard(String text, verifyEmailType type) {
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
                child: Icon(
                  HugeIconsStroke.edit04,
                  color: widget.t.secondaryTextColor,
                  size: 18,
                ),
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
            showSuccess("Account deleted!", context);
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

// --------------------------------------------------------------------------
// DELETE form screen DIALOG
// --------------------------------------------------------------------------
Future showDialogDeleteScreen(
    BuildContext context,
    theme t,
    Function f,
    ) async {
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
            "This action will permanently delete this screen.",
          ),
          SizedBox(height: 20),
        ],
      ),
      actions: [
        FButton(
          onPress: () {
            Navigator.of(context).pop();
            f();
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
          child: const Text('Delete Screen'),
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
// --------------------------------------------------------------------------
// DELETE collection DIALOG
// --------------------------------------------------------------------------
Future showDialogDeleteCollection(
  BuildContext context,
  theme t,
  Collection c,
) async {
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
            "This action will permanently delete this collection, including all forms and subcollections inside it.",
          ),
          SizedBox(height: 20),
        ],
      ),
      actions: [
        FButton(
          onPress: () {
            Navigator.of(context).pop();
            showSuccess("collection deleted!", context);
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
          child: const Text('Delete Collection'),
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

// --------------------------------------------------------------------------
// DELETE form DIALOG
// --------------------------------------------------------------------------
Future showDialogDeleteForm(BuildContext context, theme t, Form f) async {
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
            'This action is permanent and will delete this form, you can restore it from the trash section.',
          ),
          SizedBox(height: 20),
        ],
      ),
      actions: [
        FButton(
          onPress: () {
            Navigator.of(context).pop();
            showSuccess("Form deleted!", context);
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
          child: const Text('Delete Form'),
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
