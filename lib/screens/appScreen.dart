// ignore_for_file: file_names

import 'dart:ui';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:formbuilder/backend/models/userMeta.dart';
import 'package:formbuilder/screens/startScreen/startScreen.dart';

import '../main.dart';
import '../services/provider.dart';
import '../services/secureSharedPreferencesService.dart';
import '../services/sharedPreferencesService.dart';
import '../services/themeService.dart';
import '../tools/tools.dart';
import '../widgets/complex.dart';
import '../widgets/form.dart';
import '../widgets/messages.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, required this.t});
  final theme t;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late int _currentIndex;
  late List<Widget> _screens;
  late String selectedSection;
  final Provider provider = Get.find<Provider>();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController bandwidthLimitDownloadController =
      TextEditingController();
  final TextEditingController bandwidthLimitUploadController =
      TextEditingController();
  late theme t;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool isDark = await SharedPrefService.getIsDark();
      provider.setIsDark(isDark);
      t = getTheme();
    });
    _screens = [];
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    bool landscape = isLandscape(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      _currentIndex = provider.currentIndex.value;
      t = getTheme();

      return SystemUiStyleWrapper(
        t: t,
        child: FScaffold(
          sidebar: provider.isSideBarOpen.value
              ? FSidebar(
                  footer: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FButton.icon(
                      onPress: () {
                        showDialogProfile();
                      },
                      style: FButtonStyle.outline(),
                      child: Row(
                        spacing: 8,
                        children: [
                          userProfileImage(provider.user.value),
                          Expanded(
                            child: Text(
                              provider.user.value.name,
                              style: TextStyle(
                                color: t.textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            HugeIconsStroke.arrowRight01,
                            color: t.secondaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  children: [
                    FSidebarGroup(
                      label: Row(
                        children: [
                          const Text('Overview'),
                          Spacer(),
                          collapseWidget()
                        ],
                      ),
                      children: [
                        SizedBox(height: 5),
                        menuItem(title:'Home',icon:HugeIconsStroke.home04,onClick:(){
                        }),
                        menuItem(title:'Search',icon:HugeIconsStroke.search01,onClick:(){
                        }),
                        menuItem(title:'Templates',icon:HugeIconsStroke.layoutGrid,onClick:(){
                        }),
                        menuItem(title:'Trash',icon:HugeIconsStroke.delete02,onClick:(){
                        }),
                        menuItem(title:'Upgrade plan',icon:HugeIconsStroke.starAward01,weight:FontWeight.w600,color: t.accentColor,onClick:(){
                        })
                      ],
                    ),
                    FSidebarGroup(
                      label: const Text('Settings'),
                      children: [
                        SizedBox(height: 5),
                        FSidebarItem(
                          icon: const Icon(HugeIconsStroke.moonCloud),
                          label: Row(
                            children: [
                              const Text(
                                'Dark mode',
                                style: TextStyle(fontSize: 13.2,fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 20,
                                height: 5,
                                child: Transform.scale(
                                  scale: 0.7,
                                  child: FSwitch(
                                    value: provider.isDark.value,
                                    onChange: (value) async {
                                      await SharedPrefService.saveIsDark(
                                        !provider.isDark.value,
                                      );
                                      provider.setIsDark(!provider.isDark.value);

                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPress: () async {
                            await SharedPrefService.saveIsDark(
                              !provider.isDark.value,
                            );
                            provider.setIsDark(!provider.isDark.value);
                          },
                        ),
                        menuItem(title:'Language',icon:HugeIconsStroke.translate,onClick:(){
                          showMsg(
                            "We Support Only English For Now",
                            context,
                            t,
                          );
                        }),
                        menuItem(title:'Domains',icon:HugeIconsStroke.internet,onClick:(){
                        }),
                        menuItem(title:'Notifications',icon:HugeIconsStroke.notification01,onClick:(){
                        }),
                        menuItem(title:'Billing & usage',icon:HugeIconsStroke.masterCard,onClick:(){
                        }),
                        menuItem(title:'Log out',icon:HugeIconsStroke.login02,color: t.errorColor,onClick:(){
                          showDialogCloseVault();
                        }),
                      ],
                    ),

                    FSidebarGroup(
                      label: const Text('Help'),
                      children: [
                        SizedBox(height: 5),
                        menuItem(title:'Contact support',icon:HugeIconsStroke.message01,onClick:(){
                        }),
                        menuItem(title:'Change log',icon:HugeIconsStroke.sparkles,onClick:(){
                        }),
                        menuItem(title:'Privacy policy',icon:HugeIconsStroke.lockPassword,onClick:(){
                        }),
                        menuItem(title:'Terms of service',icon:HugeIconsStroke.service,onClick:(){
                        }),
                        menuItem(title:'Our Website',icon:HugeIconsStroke.globe02,onClick:(){
                          EasyLauncher.url(
                            url:
                            "https://azizbalti.netlify.app/projects/web/formbuilder/",
                          );
                        }),
                      ],
                    ),
                  ],
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Row(
                  children: [
                    if(!provider.isSideBarOpen.value)
                    collapseWidget(),
                    if(!provider.isSideBarOpen.value)
                      SizedBox(width: 10,),
                    FBreadcrumb(
                      children: [
                        FBreadcrumbItem(
                          onPress: () {},
                          child: const Text('Root'),
                        ),
                        FBreadcrumbItem.collapsed(
                          menu: [
                            FItemGroup(
                              children: [
                                FItem(
                                  title: const Text('Documentation'),
                                  onPress: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        FBreadcrumbItem(
                          onPress: () {},
                          child: const Text('Overview'),
                        ),
                        const FBreadcrumbItem(
                          current: true,
                          child: Text('Installation'),
                        ),
                      ],
                    ),
                    Spacer(),
                    FButton.icon(
                      onPress: () {
                        showDialogNewFolder();
                      },
                      style: FButtonStyle.outline(),
                      child: Row(
                        children: [
                          Icon(
                            HugeIconsStroke.folderAdd,
                            color: t.textColor,
                            size: 16,
                          ),
                          SizedBox(width: 10),
                          Text("New collection", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    FButton.icon(
                      onPress: () {},
                      style: FButtonStyle.primary(),
                      child: Row(
                        children: [
                          Icon(
                            HugeIconsStroke.add01,
                            color: t.bgColor,
                            size: 16,
                            weight: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Create form",
                            style: TextStyle(
                              fontSize: 13,
                              color: t.bgColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/vectors/vision.svg",
                      height: isLandscape(context) ? screenHeight * 0.6 : null,
                      width: isLandscape(context) ? null : screenWidth * 0.9,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future showDialogBandwidthLimit() async {
    var download = provider.downloadLimit.value;
    var upload = provider.uploadLimit.value;

    bandwidthLimitDownloadController.text = (download == -1)
        ? ""
        : download.toString();
    bandwidthLimitUploadController.text = (upload == -1)
        ? ""
        : upload.toString();

    return dialogBuilder(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text('Bandwidth Limit', style: TextStyle(fontSize: 22)),
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    HugeIconsStroke.download02,
                    color: t.secondaryTextColor,
                    size: 14,
                  ),
                  SizedBox(width: 8),
                  const Text(
                    'Download',
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 10),
                  Spacer(),
                  IntrinsicWidth(
                    child: FSidebarItem(
                      label: Row(
                        mainAxisSize: MainAxisSize
                            .min, // <-- important to shrink row to content
                        children: [
                          const Text(
                            'Unlimited',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 20,
                            height: 5,
                            child: Transform.scale(
                              scale: 0.7, // Scale down to 70% of original size
                              child: FSwitch(
                                value: provider.downloadLimit.value == -1,
                                onChange: (value) {
                                  provider.setDownloadLimit(value ? -1 : 512);
                                  SharedPrefService.saveDownloadLimit(
                                    value ? -1 : 512,
                                  );
                                  bandwidthLimitDownloadController.text = value
                                      ? ''
                                      : '512';
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPress: () {
                        provider.setDownloadLimit(
                          provider.downloadLimit.value != -1 ? -1 : 512,
                        );
                        SharedPrefService.saveDownloadLimit(
                          provider.downloadLimit.value == -1 ? -1 : 512,
                        );
                        bandwidthLimitDownloadController.text =
                            provider.downloadLimit.value == -1 ? '' : '512';
                      },
                    ),
                  ),

                  if (provider.downloadLimit.value != -1)
                    SizedBox(
                      width: 100,
                      child: FTextField(
                        controller: bandwidthLimitDownloadController,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // allow digits only
                          LengthLimitingTextInputFormatter(
                            4,
                          ), // optional: max 4 digits
                          // custom formatter to prevent numbers >= 1024
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            if (newValue.text.isEmpty) return newValue;
                            final intValue = int.tryParse(newValue.text);
                            if (intValue == null || intValue >= 1024) {
                              return oldValue; // reject input
                            }
                            return newValue;
                          }),
                        ],
                      ),
                    ),
                  if (provider.downloadLimit.value != -1) SizedBox(width: 5),
                  if (provider.downloadLimit.value != -1)
                    SizedBox(
                      width: 100,
                      child: BandwidthSelect(
                        hint: provider.downloadLimitUnit.value,
                        function: (String? newValue) {
                          provider.setDownloadLimitUnit(newValue ?? "KB");
                          SharedPrefService.saveDownloadLimitUnit(
                            newValue ?? "KB",
                          );
                        },
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    HugeIconsStroke.upload02,
                    color: t.secondaryTextColor,
                    size: 14,
                  ),
                  SizedBox(width: 8),
                  const Text(
                    'Upload',
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 10),
                  Spacer(),
                  IntrinsicWidth(
                    child: FSidebarItem(
                      label: Row(
                        mainAxisSize: MainAxisSize
                            .min, // <-- important to shrink row to content
                        children: [
                          const Text(
                            'Unlimited',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 20,
                            height: 5,
                            child: Transform.scale(
                              scale: 0.7, // Scale down to 70% of original size
                              child: FSwitch(
                                value: provider.uploadLimit.value == -1,
                                onChange: (value) {
                                  provider.setUploadLimit(value ? -1 : 512);
                                  SharedPrefService.saveUploadLimit(
                                    value ? -1 : 512,
                                  );
                                  bandwidthLimitUploadController.text = value
                                      ? ''
                                      : '512';
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPress: () {
                        provider.setUploadLimit(
                          provider.uploadLimit.value != -1 ? -1 : 512,
                        );
                        SharedPrefService.saveUploadLimit(
                          provider.uploadLimit.value == -1 ? -1 : 512,
                        );
                        bandwidthLimitUploadController.text =
                            provider.uploadLimit.value == -1 ? '' : '512';
                      },
                    ),
                  ),
                  if (provider.uploadLimit.value != -1)
                    SizedBox(
                      width: 100,
                      child: FTextField(
                        controller: bandwidthLimitUploadController,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // allow digits only
                          LengthLimitingTextInputFormatter(
                            4,
                          ), // optional: max 4 digits
                          // custom formatter to prevent numbers >= 1024
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            if (newValue.text.isEmpty) return newValue;
                            final intValue = int.tryParse(newValue.text);
                            if (intValue == null || intValue >= 1024) {
                              return oldValue; // reject input
                            }
                            return newValue;
                          }),
                        ],
                      ),
                    ),
                  if (provider.uploadLimit.value != -1) SizedBox(width: 5),
                  if (provider.uploadLimit.value != -1)
                    SizedBox(
                      width: 100,
                      child: BandwidthSelect(
                        hint: provider.uploadLimitUnit.value,
                        function: (String? newValue) {
                          provider.setUploadLimitUnit(newValue ?? "KB");
                          SharedPrefService.saveUploadLimitUnit(
                            newValue ?? "KB",
                          );
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),

        actions: [
          FButton(
            onPress: () {
              int download = provider.downloadLimit.value;
              int upload = provider.uploadLimit.value;
              if (download != -1) {
                download = int.parse(bandwidthLimitDownloadController.text);
                provider.setDownloadLimit(download);
                SharedPrefService.saveDownloadLimit(download);
              }
              if (upload != -1) {
                upload = int.parse(bandwidthLimitUploadController.text);
                provider.setUploadLimit(upload);
                SharedPrefService.saveUploadLimit(upload);
              }

              bandwidthLimitUploadController.text = "";
              bandwidthLimitDownloadController.text = "";
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () {
              provider.setDownloadLimit(-1);
              SharedPrefService.saveDownloadLimit(-1);
              provider.setUploadLimit(-1);
              SharedPrefService.saveUploadLimit(-1);
            },
            child: const Text('Restore Default'),
          ),
        ],
      ),
    );
  }

  Future showDialogCloseVault() async {
    return dialogBuilder(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text(
          'Are you absolutely sure?',
          style: TextStyle(fontSize: 22),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  HugeIconsStroke.informationCircle,
                  color: t.secondaryTextColor,
                  size: 14,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: const Text(
                    'If you are the admin, closing the vault limits others to read-only access, Consider giving extra permissions or transferring ownership to another member.',
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  HugeIconsStroke.informationCircle,
                  color: t.secondaryTextColor,
                  size: 14,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: const Text(
                    'If you are not an admin, be careful: closing the vault will block your access until the admin re-invites you.',
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),

        actions: [
          FButton(
            onPress: () async {
              //delete current key
              await SecureStorageService().removeCurrentKey();
              //navigate to start screen
              Navigator.pop(context);
              navigateTo(context, StartScreen(canBack: false), true);
              showSuccess("Vault Closed Successfully!", context);
            },
            style: FButtonStyle(
              decoration: FWidgetStateMap.all(
                BoxDecoration(
                  color: t.accentColor,
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
              tappableStyle: FTappableStyle(), // default interactions
              focusedOutlineStyle: FFocusedOutlineStyle(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            ).call,
            child: const Text('Close Vault'),
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

  Future showDialogDeleteVault() async {
    return dialogBuilder(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text(
          'Are you absolutely sure?',
          style: TextStyle(fontSize: 22),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            const Text(
              'This action is permanent and will delete this vault with its data.',
            ),
            const Text('Export your files first if you want to keep them.'),
            SizedBox(height: 20),
          ],
        ),
        actions: [
          FButton(
            onPress: () => Navigator.of(context).pop(),
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
              tappableStyle: FTappableStyle(), // default interactions
              focusedOutlineStyle: FFocusedOutlineStyle(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            ).call,
            child: const Text('Delete Vault'),
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

  Future showDialogNewFolder() async {
    final TextEditingController inputController = TextEditingController();
    return dialogBuilder(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text("Create New Folder", style: TextStyle(fontSize: 22)),
        body: Column(
          children: [
            SizedBox(height: 40),
            FTextField(
              controller: inputController, // TextEditingController
              hint: 'Enter Folder Name',
              maxLines: 1,
              clearable: (value) => value.text.isNotEmpty,
            ),
          ],
        ),
        actions: [
          FButton(
            onPress: () {
              showMsg("Folder ${inputController.text} added!", context, t);
              Navigator.pop(context);
            },
            child: const Text('Create Folder'),
          ),
        ],
      ),
    );
  }

  Future showDialogProfile() async {
    final TextEditingController inputController = TextEditingController();
    return dialogBuilder(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text("Edit Profile", style: TextStyle(fontSize: 22)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            FTextField(
              controller: inputController, // TextEditingController
              hint: 'Enter Your Name',
              maxLines: 1,
              clearable: (value) => value.text.isNotEmpty,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Choose Color"),
            ),
            SizedBox(height: 40),
          ],
        ),
        actions: [
          FButton(
            onPress: () {
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future showDialogStorage() async {
    try {
      final TextEditingController inputController = TextEditingController();
      var storageInfo = await getStorageInfo(provider.storageLocation.value);
      int occupied = storageInfo['occupied'] ?? 0;
      int total = storageInfo['total'] ?? 0;

      return await dialogBuilder(
        context: context,
        builder: (context, style, animation) => FDialog(
          style: style,
          animation: animation,
          title: const Text("Templates", style: TextStyle(fontSize: 22)),
          body: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                FButton.icon(
                  onPress: () async {
                    String path =
                        await pickDirectory() ?? provider.storageLocation.value;
                    if (path == provider.storageLocation.value) {
                      showError("Invalid path", context);
                    } else {
                      // check if the directory has enough space
                      int vaultDataSpaceInBytes =
                          100; // todo: calculate real value
                      var info = await getStorageInfo(path);
                      int availableSpace =
                          (info['total'] ?? 0) - (info['occupied'] ?? 0);

                      if (vaultDataSpaceInBytes >= availableSpace) {
                        showError("Storage Space Insufficient", context);
                      } else {
                        showMsg(
                          "Click 'Save' to complete storage transition",
                          context,
                          t,
                        );
                        provider.newSelectedStoragePath.value = path;
                        print(provider.newSelectedStoragePath.value);
                        print(provider.storageLocation.value);
                      }
                    }
                  },
                  style: FButtonStyle.primary(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        HugeIconsStroke.creditCardChange,
                        color: t.bgColor,
                        size: 16,
                        weight: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Select Another Directory",
                        style: TextStyle(
                          fontSize: 14,
                          color: t.bgColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FTooltip(
                  tipBuilder: (context, controller) =>
                      const Text('Click To Copy Path'),
                  child: TextButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: provider.storageLocation.value),
                      );
                      showSuccess("Path copied to clipboard", context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            provider.storageLocation.value,
                            style: TextStyle(
                              color: t.textColor,
                              fontSize: 13,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 10,
                  child: FProgress(
                    value: getRatio(occupied, total),
                    duration: const Duration(milliseconds: 500),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      HugeIconsStroke.informationCircle,
                      color: t.secondaryTextColor,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${formatBytes(total - occupied)} of ${formatBytes(total)} is Free",
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          actions: [
            Obx(() {
              if (provider.newSelectedStoragePath.value != '' &&
                  provider.newSelectedStoragePath.value !=
                      provider.storageLocation.value) {
                return FButton(
                  style: FButtonStyle.primary(),
                  onPress: () async {
                    /// TODO: move all the files before saving
                    // await SharedPrefService.saveStorageLocation(_newSelectedStoragePath!);
                    // provider.setStorageLocation(_newSelectedStoragePath!);
                    Navigator.pop(context);
                    showMsg("Storage Directory Updated", context, t);
                  },
                  child: const Text('Save'),
                );
              } else {
                return SizedBox();
              }
            }),
            FButton(
              style: FButtonStyle.outline(),
              onPress: () async {
                String defaultD = await getDefaultLocation();
                provider.newSelectedStoragePath.value = defaultD;
              },
              child: const Text('Restore Default'),
            ),
          ],
        ),
      );
    } finally {
      provider.newSelectedStoragePath.value = '';
    }
  }

  userProfileImage(UserMeta value) {
    return FAvatar.raw(
      size: 25,
      style: FAvatarStyle(
        backgroundColor: provider.user.value.color,
        foregroundColor: t.textColor,
        textStyle: TextStyle(),
      ),
      child: Text(provider.user.value.name.substring(0, 1)),
    );
  }
  collapseWidget(){
    return FButton.icon(
      onPress: () async {
        provider.toggleSideBar();
        //update settings:
        await SharedPrefService.saveIsSideBarOpen(
          provider.isSideBarOpen.value,
        );
      },
      style: FButtonStyle.ghost(),
      child: Icon(
        provider.isSideBarOpen.value
            ? HugeIconsStroke.sidebarLeft01
            : HugeIconsStroke.sidebarRight01,
        color: t.textColor,
      ),
    );
  }

  menuItem({required String title, required IconData icon, required Function() onClick,Color? color,FontWeight? weight}) {
    return FSidebarItem(
      icon: Icon(icon,color: color,),
      label: Text(
        title,
        style: TextStyle(fontSize: 13.2,fontWeight: weight ?? FontWeight.w500,color: color),
      ),
      onPress: onClick
    );
  }
}

class BandwidthSelect extends StatelessWidget {
  BandwidthSelect({super.key, required this.function, required this.hint});

  final Provider provider = Get.find<Provider>();
  final sizeUnits = ['KB', 'MB', 'GB'];
  final FormFieldSetter<String>? function;
  final String hint;

  @override
  Widget build(BuildContext context) => FSelect<String>(
    hint: hint,
    format: (s) => s,
    onSaved: function,
    children: [for (final unit in sizeUnits) FSelectItem(unit, unit)],
    onChange: function,
  );
}

class BottomNavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final double size;
  final theme t;

  const BottomNavItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.size,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: size,
                height: size,
                color: isActive ? t.accentColor : t.border,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? t.accentColor : t.border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
