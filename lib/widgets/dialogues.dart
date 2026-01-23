import 'dart:typed_data';

import 'package:flutter/cupertino.dart' hide Form;
import 'package:flutter/material.dart' hide Form;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formbuilder/data/fakedata.dart';
import 'package:formbuilder/services/themeService.dart';
import 'package:formbuilder/widgets/form.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../backend/models/collection/collection.dart';
import '../backend/models/form/screen.dart';
import '../screens/auth/intro.dart';
import '../screens/auth/verifyEmail.dart';
import '../screens/home/widgets/dropList.dart';
import '../services/provider.dart';
import '../services/tools.dart';
import 'complex.dart';
import 'messages.dart';
import '../../backend/models/form/form.dart';

// --------------------------------------------------------------------------
// Notifications settings DIALOG
// --------------------------------------------------------------------------
/*
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
            /*
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
              onPresssync {},
            ),

             */
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

 */

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
// notifications DIALOG
// --------------------------------------------------------------------------
Future<void> showNotifications(BuildContext context, theme t) async {
  return dialogBuilder(
    context: context,
    builder: (context, style,animation) => NotificationsDialog(
      style: style,
      t: t,
    ),
  );
}

class NotificationsDialog extends StatefulWidget {
  final FDialogStyle style;
  final theme t;

  const NotificationsDialog({
    super.key,
    required this.style,
    required this.t,
  });

  @override
  State<NotificationsDialog> createState() => _NotificationsDialogState();
}

class _NotificationsDialogState extends State<NotificationsDialog> {
  bool isRefreshingNotifications = false;

  void _handleRefresh() {
    setState(() {
      isRefreshingNotifications = true;
    });

    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (mounted) {
        setState(() {
          isRefreshingNotifications = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FDialog(
      style: (s) => widget.style,
      title: const Text(
        "Notifications",
        style: TextStyle(fontSize: 22),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            "You don't have any notification yet",
            style: TextStyle(
              color: widget.t.secondaryTextColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
      actions: [
        FButton(
          style: FButtonStyle.outline(),
          onPress: _handleRefresh,
          child: isRefreshingNotifications
              ? SizedBox(
    width: 16,
    height: 16,
    child: CircularProgressIndicator(
            strokeWidth: 2,
            color:widget.t.textColor,
          ))
              : const Text('Refresh'),
        ),
        FButton(
          onPress: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
// --------------------------------------------------------------------------
// connection logic DIALOG
// --------------------------------------------------------------------------
Future showConnectionLogic(BuildContext context, theme t,Screen s,Function(String screenId, List<Connect> connects) updateScreenConnections) async {
  final Provider provider = Get.find<Provider>();
  provider.connects.value = s.workflow.connects;

  return dialogBuilder(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      title: const Text(
        "Connection rules",
        style: TextStyle(fontSize: 22),
      ),
      body: Expanded(child: SingleChildScrollView(child: Column(
        children: [
          const SizedBox(height: 40),
          if(s.workflow.connects.isEmpty)
            Text("You don't have any connections to this screen yet",style: TextStyle(color: t.secondaryTextColor,fontSize: 16),)
          else _buildConnections(s,t,provider),
          const SizedBox(height: 40),
        ],
      ),)),
      actions: [
        Row(
           children: [
             Expanded(child: FButton(
               onPress: () {
                 updateScreenConnections(s.id,provider.connects);
                 Navigator.pop(context);
               },
               child: const Text('Save'),
             ),),
             SizedBox(width: 10,),
             Expanded(child: FButton(style: FButtonStyle.outline(),
               onPress: () {
                 Navigator.pop(context);
               },
               child: const Text('Close'),
             ),)
           ],
        )
      ],
    ),
  );
}

_buildConnections(Screen s,theme t,Provider p) {
  return SingleChildScrollView(
    child: Column(
      children: p.connects.map((connect)=> Container(
        padding: EdgeInsets.symmetric(horizontal: 6,vertical: 6),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: t.cardColor,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("Go From   ",style: TextStyle(color: t.textColor),),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
              decoration: BoxDecoration(
                  color: t.accentColor,
                  borderRadius: BorderRadius.circular(4)
              ),
              child: Text(connect.screenId,style: TextStyle(color: t.textColor),),
            ),
            Text("To   ",style: TextStyle(color: t.textColor),),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
              decoration: BoxDecoration(
                  color: t.textColor,
                  borderRadius: BorderRadius.circular(4)
              ),
              child: Text(s.id,style: TextStyle(color: t.bgColor),),
            ),

            ...buildRules(s.id,connect,t,p)
          ],
        ),
      )).toList(),
    ),
  );
}

List<Widget> buildRules(String screenId,Connect c,theme t,Provider p) {
  List<Widget> result = [
    Text("If   ",style: TextStyle(color: t.textColor),),
    ScreenItems(
      key: ValueKey(screenId),
      screenId: screenId,
      f: (v) {
        Connect connect = c;
        //connect.rules.firstWhereOrNull((r)=>r.ruleId==)
        updateConnectRules(connect,p);
      },
    ),
  ];

  for(Rule r in c.rules){
    if(c.rules.length>1){
      result.add(Text("And   ",style: TextStyle(color: t.textColor),),);
    }
    result.addAll(
      [
        ScreenItems(
          key: ValueKey(screenId),
          screenId: screenId,
          f: (v) {

          },
        ),
        LogicItems(
          screenId: screenId,
          f: (v) {

          },
        ),
        (["Is Empty","Is Not Empty"].contains(r.logic))?
        SizedBox(): (["Not","Or"].contains(r.logic))?
          //the logic requires another logic
          LogicItems(
          screenId: screenId,
          f: (v) {

          },
          ): Text("'put your value here'")
      ]
    );


  }
//add the 'add rule' button
  result.addAll(
    [
      SizedBox(width: 10,),
      Material(
        color: t.cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: (){

          },
          child:  Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(HugeIconsStroke.add01,color:t.textColor ,size: 16,),
              SizedBox(width: 5,),
              Text('Add Rule',style: TextStyle(color: t.textColor,fontSize: 13),)
            ],
          ),
        ),
      ),
      SizedBox(width: 10,),
    ]
  );
  return result;
}
void updateConnectRules(Connect c, Provider p) {
  final index = p.connects.indexWhere((con) => con.screenId == c.screenId);

  if (index != -1) {
    p.connects[index] = c; // replace item
  }
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
// form items
// --------------------------------------------------------------------------
/*
Future showDialogAddOrReplaceFormItem(
    BuildContext context,
    theme t,
    int lineNumber,
    bool isNew, Null Function(selectedType) param4
    ) async {
  final TextEditingController inputController = TextEditingController();
  return dialogBuilder(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      title: Text("Form Items", style: const TextStyle(fontSize: 22)),
      body: Column(
        children: [
          const SizedBox(height: 40),
        ],
      ),
      actions: [
        FButton(
          onPress: () {
            //rename collection
            Navigator.pop(context);
          },
          child: Text(isNew?'Add':"Replace"),
        ),
      ],
    ),
  );
}

 */

// --------------------------------------------------------------------------
// SEARCH DIALOG
// --------------------------------------------------------------------------
Future showDialogSearch(BuildContext context, theme t) async {
  final TextEditingController inputController = TextEditingController();
  final ValueNotifier<bool> isSearching = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hasSearched = ValueNotifier<bool>(false);
  final FocusNode focusNode = FocusNode();

  // Fake lists for results
  List<Collection> collections = [];
  List<Form> forms = [];

  // Auto focus after 300ms
  Future.delayed(const Duration(milliseconds: 300), () {
    focusNode.requestFocus();
  });

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
                focusNode: focusNode,
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

Future showDialogColorPicker(
    BuildContext context,
    theme t,
    Color currentColor,
    Function(Color) onColorSelected,
    ) async {
  Color tempColor = currentColor;

  return dialogBuilder(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      body: Column(
        children: [
          const SizedBox(height: 20),
          // The Color Picker
          Material(
            color: Colors.transparent,
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (c) => tempColor = c,
              enableAlpha: false,
              labelTypes: const [],
              pickerAreaBorderRadius: BorderRadius.circular(10),
              portraitOnly: true,
              hexInputBar: true,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      actions: [
        // Confirm Button
        FButton(
          onPress: () {
            onColorSelected(tempColor);
            Navigator.of(context).pop();
          },
          style: FButtonStyle.primary(),
          child: const Text('Select Color'),
        ),

        // Cancel Button
        FButton(
          style: FButtonStyle.outline(),
          onPress: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}


Future<void> showDialogValuePicker(
    BuildContext context,
    theme t,
    String title,
    int currentValue,
    String ending,
    int minNum,
    int maxNum,
    Function(dynamic) onSelected,
    ) {
  TextEditingController value = TextEditingController(text: currentValue.toString());
  return dialogBuilder(
    context: context,
    builder: (context, style, animation) => FDialog(
      style: style,
      animation: animation,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Material(
                color: Colors.transparent,
                child: customInput(t,value,"new value", value.text, context,maxLines: 1,isNum:true,minNum:minNum,maxNum:maxNum),
              ),),
              SizedBox(width: 10,),
              Text(ending,style: TextStyle(fontSize: 18,color: t.textColor),)
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
      actions: [
        // Confirm Button
        FButton(
          onPress: () {
            onSelected(value.text);
            Navigator.of(context).pop();
          },
          style: FButtonStyle.primary(),
          child: const Text('Save'),
        ),

        // Cancel Button
        FButton(
          style: FButtonStyle.outline(),
          onPress: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
