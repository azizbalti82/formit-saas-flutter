// ignore_for_file: file_names

import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formbuilder/backend/models/user.dart';
import 'package:formbuilder/screens/home/widgets/itemsViewType.dart';
import 'package:formbuilder/screens/auth/intro.dart';
import 'package:formbuilder/screens/auth/verifyEmail.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../../backend/models/collection.dart';
import '../../data/constants.dart';
import '../../main.dart';
import '../../services/provider.dart';
import '../../services/sharedPreferencesService.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/complex.dart';
import '../../widgets/menu.dart';
import '../../widgets/messages.dart';

// ============================================================================
// MAIN APP SCREEN
// ============================================================================

class AppScreen extends StatefulWidget {
  const AppScreen({super.key, required this.t});
  final theme t;

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  // --------------------------------------------------------------------------
  // STATE VARIABLES
  // --------------------------------------------------------------------------
  late int _currentIndex;
  late List<Widget> _screens;
  late String selectedSection;
  late theme t;
  List<String> currentPath = ["Home"];
  bool logoutLoading = false;
  Uint8List? imageBytes;

  // --------------------------------------------------------------------------
  // CONTROLLERS
  // --------------------------------------------------------------------------
  final TextEditingController searchController = TextEditingController();
  // --------------------------------------------------------------------------
  // SERVICES
  // --------------------------------------------------------------------------
  final Provider provider = Get.find<Provider>();
  // --------------------------------------------------------------------------
  // FAKE DATA
  // --------------------------------------------------------------------------
  final List<Collection> fakeCollections = [
    // 🌳 Root collection
    Collection(id: '1', name: 'Root', parentId: null),

    // 📁 Level 1 (children of Root)
    Collection(id: '2', name: 'Documents', parentId: '1'),
    Collection(id: '3', name: 'Images', parentId: '1'),
    Collection(id: '4', name: 'Videos', parentId: '1'),

    // 🗂 Level 2 (children of Documents)
    Collection(id: '5', name: 'Work', parentId: '2'),
    Collection(id: '6', name: 'Personal', parentId: '2'),

    // 🖼 Level 2 (children of Images)
    Collection(id: '7', name: 'Travel', parentId: '3'),
    Collection(id: '8', name: 'Family', parentId: '3'),

    // 🎬 Level 2 (children of Videos)
    Collection(id: '9', name: 'Projects', parentId: '4'),
    Collection(id: '10', name: 'Tutorials', parentId: '4'),

    // 📄 Level 3 (children of Work)
    Collection(id: '11', name: 'Reports', parentId: '5'),
    Collection(id: '12', name: 'Presentations', parentId: '5'),
  ];
  // --------------------------------------------------------------------------
  // LIFECYCLE METHODS
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    provider.resetCurrentFolderId(fakeCollections);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool isDark = await SharedPrefService.getIsDark();
      provider.setIsDark(isDark);
      t = getTheme();
    });
    _screens = [];
    _currentIndex = 0;
  }

  // --------------------------------------------------------------------------
  // BUILD METHOD
  // --------------------------------------------------------------------------
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
          sidebar: provider.isSideBarOpen.value ? _buildSidebar() : null,
          child: _buildMainContent(landscape, screenHeight, screenWidth),
        ),
      );
    });
  }

  // --------------------------------------------------------------------------
  // SIDEBAR
  // --------------------------------------------------------------------------
  Widget _buildSidebar() {
    return FSidebar(
      footer: _buildSidebarFooter(),
      children: [
        _buildOverviewSection(),
        _buildSettingsSection(),
        _buildHelpSection(),
      ],
    );
  }
  Widget _buildSidebarFooter() {
    return Padding(
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
    );
  }
  Widget _buildOverviewSection() {
    return FSidebarGroup(
      label: Row(
        children: [
          const Text('Overview'),
          Spacer(),
          collapseWidget(),
        ],
      ),
      children: [
        SizedBox(height: 5),
        menuItem(
          title: 'Home',
          icon: HugeIconsStroke.home04,
          onClick: () {
            setState(() {
              currentPath = ["Home"];
              provider.resetCurrentFolderId(fakeCollections);
            });
          },
        ),
        menuItem(
          title: 'Search',
          icon: HugeIconsStroke.search01,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Templates',
          icon: HugeIconsStroke.layoutGrid,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
            setState(() {
              currentPath = ["Templates"];
            });
          },
        ),
        menuItem(
          title: 'Trash',
          icon: HugeIconsStroke.delete02,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Upgrade plan',
          icon: HugeIconsStroke.starAward01,
          weight: FontWeight.w600,
          color: t.accentColor,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
      ],
    );
  }
  Widget _buildSettingsSection() {
    return FSidebarGroup(
      label: const Text('Settings'),
      children: [
        SizedBox(height: 5),
        FSidebarItem(
          icon: const Icon(HugeIconsStroke.moonCloud),
          label: Row(
            children: [
              const Text(
                'Dark mode',
                style: TextStyle(
                  fontSize: 13.2,
                  fontWeight: FontWeight.w500,
                ),
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
                      await SharedPrefService.saveIsDark(!provider.isDark.value);
                      provider.setIsDark(!provider.isDark.value);
                    },
                  ),
                ),
              ),
            ],
          ),
          onPress: () async {
            await SharedPrefService.saveIsDark(!provider.isDark.value);
            provider.setIsDark(!provider.isDark.value);
          },
        ),
        menuItem(
          title: 'Language',
          icon: HugeIconsStroke.translate,
          onClick: () {
            showMsg("We Support Only English For Now", context, t);
          },
        ),
        menuItem(
          title: 'Domains',
          icon: HugeIconsStroke.internet,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Notifications',
          icon: HugeIconsStroke.notification01,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Billing & usage',
          icon: HugeIconsStroke.masterCard,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Log out',
          icon: HugeIconsStroke.login02,
          color: t.errorColor,
          isLoading: logoutLoading,
          onClick: () {
            logout();
          },
        ),
      ],
    );
  }
  Widget _buildHelpSection() {
    return FSidebarGroup(
      label: const Text('Help'),
      children: [
        SizedBox(height: 5),
        menuItem(
          title: 'Contact support',
          icon: HugeIconsStroke.message01,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Change log',
          icon: HugeIconsStroke.sparkles,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Privacy policy',
          icon: HugeIconsStroke.lockPassword,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Terms of service',
          icon: HugeIconsStroke.service,
          onClick: () {
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Website',
          icon: HugeIconsStroke.globe02,
          onClick: () {
            EasyLauncher.url(
              url: "https://azizbalti.netlify.app/projects/web/formbuilder/",
            );
          },
        ),
        menuItem(
          title: 'Developer Website',
          icon: HugeIconsSolid.developer,
          onClick: () {
            EasyLauncher.url(url: "https://azizbalti.netlify.app");
          },
        ),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // MAIN CONTENT
  // --------------------------------------------------------------------------
  Widget _buildMainContent(bool landscape, double screenHeight, double screenWidth) {
    if (isLandscape(context) || !isLandscape(context) && !provider.isSideBarOpen.value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12,
          children: [
            _buildTopBar(landscape),
            Expanded(child: _buildContentArea(screenHeight, screenWidth)),
          ],
        ),
      );
    }
    return GestureDetector(
        onTap: () {
          provider.setIsSideBarOpen(false);
        },
    );
  }
  Widget _buildTopBar(bool landscape) {
    return Row(
      children: [
        if (!provider.isSideBarOpen.value) collapseWidget(),
        if (!provider.isSideBarOpen.value) SizedBox(width: 10),
        pathWidgetBuilder(currentPath),
        Spacer(),
        if (isLandscape(context)) _buildNewCollectionButton(),
        if (isLandscape(context)) SizedBox(width: 10),
        if (isLandscape(context)) _buildCreateFormButton(),
      ],
    );
  }
  Widget _buildNewCollectionButton() {
    return FButton.icon(
      onPress: () {
        showDialogNewFolder();
      },
      style: FButtonStyle.outline(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 4),
          Icon(
            HugeIconsStroke.folderAdd,
            color: t.textColor,
            size: 16,
          ),
          SizedBox(width: 10),
          Text(
            "New collection",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: t.textColor,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
  Widget _buildCreateFormButton() {
    return FButton.icon(
      onPress: () {},
      style: FButtonStyle.primary(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 4),
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
          SizedBox(width: 10),
        ],
      ),
    );
  }
  Widget _buildContentArea(double screenHeight, double screenWidth) {
    if (countFolderChildren(
      allFolders: fakeCollections,
      currentFolderId: provider.currentFolderId.value,
    ) == 0) {
      return Center(
        child: SvgPicture.asset(
          "assets/vectors/vision.svg",
          height: isLandscape(context) ? screenHeight * 0.6 : null,
          width: isLandscape(context) ? null : screenWidth * 0.9,
        ),
      );
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: (!provider.isGrid.value) ? 700 : double.infinity,
      ),
      child: Column(
        children: [
          if(isLandscape(context))
          Container(
            margin: EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child: ItemsViewType(),
          ),
          if(isLandscape(context))
          SizedBox(height: 20),
          Expanded(
            child: ListCollections(
              collections: getFoldersOf(
                allFolders: fakeCollections,
                currentFolderId: provider.currentFolderId.value,
              ),
              theme: t,
              isGrid: provider.isGrid.value,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // REUSABLE WIDGETS
  // --------------------------------------------------------------------------
  Widget collapseWidget() {
    return FButton.icon(
      onPress: () async {
        provider.toggleSideBar();
        await SharedPrefService.saveIsSideBarOpen(provider.isSideBarOpen.value);
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
  Widget menuItem({
    required String title,
    required IconData icon,
    required Function() onClick,
    Color? color,
    FontWeight? weight,
    bool isLoading = false,
  }) {
    return FSidebarItem(
      icon: Icon(icon, color: color),
      label: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.2,
              fontWeight: weight ?? FontWeight.w500,
              color: color,
            ),
          ),
          Spacer(),
          if (isLoading)
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
      onPress: onClick,
    );
  }
  Widget userProfileImage(User value) {
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
          onPress: isLast || isFirst
              ? null
              : () {
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
  Widget ListCollections({
    required List<Collection> collections,
    required theme theme,
    required bool isGrid,
  }) {
    Widget buildCard(Collection collection) {
      return FTappable(
        style: FTappableStyle(),
        semanticsLabel: 'Forms Collection',
        selected: false,
        autofocus: false,
        behavior: HitTestBehavior.translucent,
        onPress: () {
          provider.currentFolderId.value = collection.id;
          currentPath.add(collection.name);
        },
        builder: (context, state, child) => child!,
        child: FCard.raw(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              bottom: 16,
              top: 16,
              right: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            HugeIconsStroke.folder01,
                            color: theme.secondaryTextColor.withOpacity(0.8),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              collection.name,
                              style: TextStyle(
                                color: theme.textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${countFolderChildren(allFolders: fakeCollections, currentFolderId: collection.id)} items",
                        style: TextStyle(
                          color: theme.secondaryTextColor.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                CollectionPopupMenu(
                  iconColor: theme.textColor,
                  cardColor: theme.cardColor,
                  items: [
                    PopupMenuItemData(
                      onTap: () {
                        print("Open");
                      },
                      label: "Open",
                      color: theme.textColor,
                      icon: HugeIconsStroke.view,
                    ),
                    PopupMenuItemData(
                      onTap: () {
                        print("Rename");
                      },
                      label: "Rename",
                      color: theme.textColor,
                      icon: HugeIconsStroke.edit03,
                    ),
                    PopupMenuItemData(
                      onTap: () {
                        print("Delete");
                      },
                      label: "Delete Collection",
                      color: theme.errorColor,
                      icon: HugeIconsStroke.delete01,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (isGrid) {
      return LayoutBuilder(
        builder: (context, constraints) {
          const double minItemWidth = 250;
          final int crossAxisCount = (constraints.maxWidth / minItemWidth).floor().clamp(1, 6);
          final double childWidth = (constraints.maxWidth - (crossAxisCount - 1) * 12) / crossAxisCount;
          const double childHeight = 120;
          final double childAspectRatio = childWidth / childHeight;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: collections.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              return buildCard(collections[index]);
            },
          );
        },
      );
    }
    else {
      return ListView.builder(
        itemCount: collections.length,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 700),
                child: buildCard(collections[index]),
              ),
            ),
          );
        },
      );
    }
  }

  // --------------------------------------------------------------------------
  // DIALOGS
  // --------------------------------------------------------------------------
  Future showDialogNewFolder() async {
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
            SizedBox(height: 40),
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
  Future showDialogProfile() async {
    return dialogBuilder(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style,
        animation: animation,
        title: const Text("Edit Profile", style: TextStyle(fontSize: 22)),
        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: FTabs(
              initialIndex: 0,
              onPress: (index) {},
              children: [
                FTabEntry(
                  label: Text('Info'),
                  child: Expanded(child: accountInfoWidget()),
                ),
                FTabEntry(
                  label: Text('Advanced'),
                  child: Expanded(child: accountAdvancedWidget()),
                ),
              ],
            ),
          ),
        ),
        actions: [],
      ),
    );
  }
  Future showDialogDeleteAccount() async {
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
              navigateTo(context, StartScreen(canBack: false), true);
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

  // --------------------------------------------------------------------------
  // PROFILE WIDGETS
  // --------------------------------------------------------------------------
  Widget accountInfoWidget() {
    final firstNameController = TextEditingController(text: "aziz");
    final lastNameController = TextEditingController(text: "balti");

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          _buildProfileImagePicker(),
          SizedBox(height: 20),
          _buildNameFields(firstNameController, lastNameController),
          SizedBox(height: 10),
          _buildEmailCard(),
          SizedBox(height: 10),
          _buildPasswordCard(),
          SizedBox(height: 20),
          FButton(
            onPress: () {
              showMsg("Profile updated!", context, t);
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
      onTap: () async {
        var image = (await pickImage());
        if (image == null) return;
        setState(() {
          imageBytes = image;
        });
      },
      borderRadius: BorderRadius.circular(300),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: t.textColor.withOpacity(0.1),
            ),
          ),
          (imageBytes == null)
              ? Icon(
            Icons.add_rounded,
            size: 50,
            color: t.textColor.withOpacity(0.3),
          )
              : ClipOval(
            child: Image.memory(
              imageBytes!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildNameFields(
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      ) {
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
        SizedBox(width: 10),
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
  Widget _buildEmailCard() {
    return GestureDetector(
      onTap: () {
        navigateTo(
          context,
          VerifyEmail(
            t: darkTheme,
            type: verifyEmailType.updateEmail,
            email: "nigga@gmail.com",
          ),
          false,
        );
      },
      child: FCard.raw(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Text("aziz@gmail.com", textAlign: TextAlign.center),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                child: FButton.icon(
                  style: FButtonStyle.primary(),
                  onPress: () async {
                    navigateTo(
                      context,
                      VerifyEmail(
                        t: darkTheme,
                        type: verifyEmailType.updateEmail,
                        email: "nigga@gmail.com",
                      ),
                      false,
                    );
                  },
                  child: const Icon(HugeIconsStroke.edit04),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPasswordCard() {
    return GestureDetector(
      onTap: () {
        navigateTo(
          context,
          VerifyEmail(
            t: darkTheme,
            type: verifyEmailType.resetPassword,
            email: "nigga@gmail.com",
          ),
          false,
        );
      },
      child: FCard.raw(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Text("**************", textAlign: TextAlign.center),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                child: FButton.icon(
                  style: FButtonStyle.primary(),
                  onPress: () {
                    navigateTo(
                      context,
                      VerifyEmail(
                        t: darkTheme,
                        type: verifyEmailType.resetPassword,
                        email: "nigga@gmail.com",
                      ),
                      false,
                    );
                  },
                  child: const Icon(HugeIconsStroke.edit04),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget accountAdvancedWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              SvgPicture.asset(
                "assets/icons/danger.svg",
                width: 22.0,
                color: t.textColor,
              ),
              SizedBox(width: 8),
              Text(
                "Danger zone",
                style: TextStyle(
                  color: t.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "This will permanently delete your entire account. All your forms, submissions and workspaces will be deleted.",
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 20),
          FButton(
            onPress: () {
              showDialogDeleteAccount();
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
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // HELPER METHODS
  // --------------------------------------------------------------------------
  Future<void> logout() async {
    setState(() {
      logoutLoading = true;
    });

    try {
      bool logoutSuccess = true;
      await Future.delayed(const Duration(seconds: 2));
      if (logoutSuccess) {
        navigateTo(context, StartScreen(canBack: false), true);
        showSuccess("Logout Succeed", context);
      } else {
        showError("Logout Failed", context);
      }
    } finally {
      setState(() {
        logoutLoading = false;
      });
    }
  }
  List<Collection> getFoldersOf({
    required List<Collection> allFolders,
    String? currentFolderId,
  }) {
    return allFolders.where((f) => f.parentId == currentFolderId).toList();
  }

  int countFolderChildren({
    required List<Collection> allFolders,
    String? currentFolderId,
  }) {
    return getFoldersOf(
      allFolders: allFolders,
      currentFolderId: currentFolderId,
    ).length;
  }
}


