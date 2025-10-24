// ignore_for_file: file_names

import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formbuilder/backend/models/userMeta.dart';
import 'package:formbuilder/screens/startScreen/startScreen.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../data/constants.dart';
import '../main.dart';
import '../services/provider.dart';
import '../services/sharedPreferencesService.dart';
import '../services/themeService.dart';
import '../tools/tools.dart';
import '../widgets/complex.dart';
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

  List<String> currentPath = ["Home"];
  bool logoutLoading = false;

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
                          setState(() {
                            currentPath = ["Home"];
                          });
                        }),
                        menuItem(title:'Search',icon:HugeIconsStroke.search01,onClick:(){
                          showMsg(Constants.notReadyMsg, context, t);
                        }),
                        menuItem(title:'Templates',icon:HugeIconsStroke.layoutGrid,onClick:(){
                          showMsg(Constants.notReadyMsg, context, t);
                          setState(() {
                            currentPath = ["Templates"];
                          });
                        }),
                        menuItem(title:'Trash',icon:HugeIconsStroke.delete02,onClick:(){
                          showMsg(Constants.notReadyMsg, context, t);
                        }),
                        menuItem(title:'Upgrade plan',icon:HugeIconsStroke.starAward01,weight:FontWeight.w600,color: t.accentColor,onClick:(){
                          showMsg(Constants.notReadyMsg, context, t);
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
                          showMsg(Constants.notReadyMsg, context, t);
                        }),
                        menuItem(title:'Notifications',icon:HugeIconsStroke.notification01,onClick:(){
                          showMsg(Constants.notReadyMsg, context, t);
                        }),
                        menuItem(title:'Billing & usage',icon:HugeIconsStroke.masterCard,onClick:(){
                          showMsg(Constants.notReadyMsg, context, t);
                        }),
                        menuItem(title:'Log out',icon:HugeIconsStroke.login02,color: t.errorColor,isLoading:logoutLoading,onClick:(){
                          logout();
                        }),
                      ],
                    ),

                    FSidebarGroup(
                      label: const Text('Help'),
                      children: [
                        SizedBox(height: 5),
                        menuItem(title:'Contact support',icon:HugeIconsStroke.message01,onClick:(){
                          showMsg(Constants.notReadyMsg, context, t);
                        }),
                        menuItem(title:'Change log',icon:HugeIconsStroke.sparkles,onClick:(){
                          showMsg(Constants.notReadyMsg, context, t);
                        }),
                        menuItem(title:'Privacy policy',icon:HugeIconsStroke.lockPassword,onClick:(){
                          showMsg(Constants.notReadyMsg, context, t);
                        }),
                        menuItem(title:'Terms of service',icon:HugeIconsStroke.service,onClick:(){
                          showMsg(Constants.notReadyMsg, context, t);
                        }),
                        menuItem(title:'Website',icon:HugeIconsStroke.globe02,onClick:(){
                          EasyLauncher.url(
                            url:
                            "https://azizbalti.netlify.app/projects/web/formbuilder/",
                          );
                        }),
                        menuItem(title:'Developer Website',icon:HugeIconsSolid.developer,onClick:(){
                          EasyLauncher.url(
                            url:
                            "https://azizbalti.netlify.app",
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
                    pathWidgetBuilder(currentPath),
                    Spacer(),
                    FButton.icon(
                      onPress: () {
                        showDialogNewFolder();
                      },
                      style: FButtonStyle.outline(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          SizedBox(width: 4,),
                          Icon(
                            HugeIconsStroke.folderAdd,
                            color: t.textColor,
                            size: 16,
                          ),
                          SizedBox(width: 10),
                          Text("New collection", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500)),
                          SizedBox(width: 10,),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    FButton.icon(
                      onPress: () {},
                      style: FButtonStyle.primary(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 4,),
                          Icon(
                            HugeIconsStroke.add01,
                            color: t.bgColor,
                            size: 16,
                            weight: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Create form",
                            style: TextStyle(
                              fontSize: 14,
                              color: t.bgColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 10,),
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
        title: const Text("Create New Collection", style: TextStyle(fontSize: 22)),
        body: Column(
          children: [
            SizedBox(height: 40),
            FTextField(
              controller: inputController, // TextEditingController
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

  menuItem({required String title, required IconData icon, required Function() onClick,Color? color,FontWeight? weight, bool isLoading=false}) {
    return FSidebarItem(
      icon: Icon(icon,color: color,),
      label:Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13.2,fontWeight: weight ?? FontWeight.w500,color: color),
          ),
          Spacer(),
          if(isLoading)
            SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: color ?? t.textColor,
            ),
          ),
        ],
      ),
      onPress: onClick
    );
  }

  Widget pathWidgetBuilder(List<String> paths) {
    paths = paths.reversed.toList();
    paths.add("FormIt");
    paths = paths.reversed.toList();

    return FBreadcrumb(
      children: List.generate(paths.length, (index) {
        final isLast = index == paths.length - 1;
        final isFirst = index == 0;
        final segment = paths[index];

        return FBreadcrumbItem(
          current: isLast,
          onPress: isLast || isFirst ? null : () {
            // Handle navigation or logic when clicking breadcrumb
            debugPrint('Navigate to: ${paths.take(index + 1).join('/')}');
            setState(() {
              currentPath = paths.take(index + 1).toList().sublist(1);
            });
          },
          child: Text(segment),
        );
      }),
    );
  }


  Future<void> logout() async {
    setState(() {
      logoutLoading = true;
    });

    try{
      bool logoutSuccess = true;
      await Future.delayed(const Duration(seconds: 2)); //simulate a logout api call
      if(logoutSuccess){
        //remove token from shared preferences

        //navigate to login screen
        navigateTo(context, StartScreen(canBack: false), true);
        //show message
        showSuccess("Logout Succeed", context);
      } else{
        showError("Logout Failed", context);
      }
    }finally{
      setState(() {
        logoutLoading = false;
      });
    }
  }
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
