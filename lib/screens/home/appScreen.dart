// ignore_for_file: file_names

import 'dart:io';

import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart' hide Form;
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

import '../../backend/models/collection/collection.dart';
import '../../backend/models/form/form.dart';
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
import 'createForm.dart';

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
  late theme t;
  List<Path> currentPath = [AppPath.home.data()];
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
          showDialogProfile(context, t);
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
            Icon(HugeIconsStroke.arrowRight01, color: t.secondaryTextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return FSidebarGroup(
      label: Row(
        children: [const Text('Overview'), Spacer(), collapseWidget()],
      ),
      children: [
        SizedBox(height: 5),
        menuItem(
          title: 'Home',
          icon: HugeIconsStroke.home04,
          onClick: () {
            setState(() {
              handleSideBarCloseMobile();
              currentPath = [AppPath.home.data()];
              provider.resetCurrentFolderId(fakeCollections);
            });
          },
        ),
        menuItem(
          title: 'Search',
          icon: HugeIconsStroke.search01,
          onClick: () {
            handleSideBarCloseMobile();
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Templates',
          icon: HugeIconsStroke.layoutGrid,
          onClick: () {
            handleSideBarCloseMobile();
            setState(() {
              currentPath = [AppPath.templates.data()];
            });
          },
        ),
        menuItem(
          title: 'Trash',
          icon: HugeIconsStroke.delete02,
          onClick: () {
            handleSideBarCloseMobile();
            setState(() {
              currentPath = [AppPath.trash.data()];
            });
          },
        ),
        menuItem(
          title: 'Upgrade plan',
          icon: HugeIconsStroke.starAward01,
          weight: FontWeight.w600,
          color: t.accentColor,
          onClick: () {
            handleSideBarCloseMobile();
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
                style: TextStyle(fontSize: 13.2, fontWeight: FontWeight.w500),
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
            await SharedPrefService.saveIsDark(!provider.isDark.value);
            provider.setIsDark(!provider.isDark.value);
          },
        ),
        menuItem(
          title: 'Language',
          icon: HugeIconsStroke.translate,
          onClick: () {
            handleSideBarCloseMobile();
            showMsg("We Support Only English For Now", context, t);
          },
        ),
        menuItem(
          title: 'Domains',
          icon: HugeIconsStroke.internet,
          onClick: () {
            handleSideBarCloseMobile();
            showMsg(Constants.notReadyMsg, context, t);
          },
        ),
        menuItem(
          title: 'Notifications',
          icon: HugeIconsStroke.notification01,
          onClick: () {
            handleSideBarCloseMobile();
            showDialogNotificationSettings(context,t);
          },
        ),
        menuItem(
          title: 'Billing & usage',
          icon: HugeIconsStroke.masterCard,
          onClick: () {
            handleSideBarCloseMobile();
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
            EasyLauncher.url(url: "https://azizbalti.netlify.app");
          },
        ),
        menuItem(
          title: 'Change log',
          icon: HugeIconsStroke.sparkles,
          onClick: () {
            EasyLauncher.url(url: "https://azizbalti.netlify.app");
          },
        ),
        menuItem(
          title: 'Privacy policy',
          icon: HugeIconsStroke.lockPassword,
          onClick: () {
            EasyLauncher.url(url: "https://azizbalti.netlify.app");
          },
        ),
        menuItem(
          title: 'Terms of service',
          icon: HugeIconsStroke.service,
          onClick: () {
            EasyLauncher.url(url: "https://azizbalti.netlify.app");
          },
        ),
        menuItem(
          title: 'Website',
          icon: HugeIconsStroke.globe02,
          onClick: () {
            EasyLauncher.url(url: "https://azizbalti.netlify.app");
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
  Widget _buildMainContent(
    bool landscape,
    double screenHeight,
    double screenWidth,
  ) {
    if (isLandscape(context) ||
        !isLandscape(context) && !provider.isSideBarOpen.value) {
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
        Expanded(child: pathWidgetBuilder()),
        Row(
          children: [
            if (isLandscape(context)) _buildNewCollectionButton(),
            if (isLandscape(context)) SizedBox(width: 10),
            if (isLandscape(context)) _buildCreateFormButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNewCollectionButton() {
    return FButton.icon(
      onPress: () {
        showDialogNewFolder(context, t);
      },
      style: FButtonStyle.outline(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 4),
          Icon(HugeIconsStroke.folderAdd, color: t.textColor, size: 16),
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
      onPress: () {
        navigateTo(context, CreatForm(t: t), false);
      },
      style: FButtonStyle.primary(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 4),
          Icon(HugeIconsStroke.add01, color: t.bgColor, size: 16, weight: 30),
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
    Path current = currentPath.lastOrNull ?? AppPath.home.data();
    print(current.title);

    if (current == AppPath.trash.data()) {
      //By default return the content of home
      if (countTrash(allFolders: fakeCollections) == 0) {
        return noResultsImage();
      }
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: (!provider.isGrid.value) ? 700 : double.infinity,
        ),
        child: Column(
          children: [
            if (isLandscape(context))
              Container(
                margin: EdgeInsets.only(left: 12),
                alignment: Alignment.centerLeft,
                child: ItemsViewType(),
              ),
            if (isLandscape(context)) SizedBox(height: 20),
            Expanded(
              child: ListCollections(
                collections: getCollectionsOf(
                  allFolders: fakeCollections,
                  currentFolderId: provider.currentFolderId.value,
                ),
                theme: t,
                isGrid: provider.isGrid.value,
                forms: getFormsOf(
                  allForms: getFakeForms(),
                  currentFolderId: provider.currentFolderId.value,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (current == AppPath.templates.data()) {
      return noResultsImage();
    } else if (current == AppPath.collections.data()) {
      return noResultsImage();
    } else {
      //if its home folder clean some things
      if (current == AppPath.home.data()) {
        currentPath = [AppPath.home.data()];
        provider.resetCurrentFolderId(fakeCollections);
      }
      //if its a folder (not home) load its children
      if (countFolderChildren(
            allFolders: fakeCollections,
            currentFolderId: provider.currentFolderId.value,
            allForms: getFakeForms(),
          ) ==
          0) {
        return noResultsImage();
      }
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: (!provider.isGrid.value) ? 700 : double.infinity,
        ),
        child: Column(
          children: [
            if (isLandscape(context))
              Container(
                margin: EdgeInsets.only(left: 12),
                alignment: Alignment.centerLeft,
                child: ItemsViewType(),
              ),
            if (isLandscape(context)) SizedBox(height: 20),
            Expanded(
              child: ListCollections(
                collections: getCollectionsOf(
                  allFolders: fakeCollections,
                  currentFolderId: provider.currentFolderId.value,
                ),
                theme: t,
                isGrid: provider.isGrid.value,
                forms: getFormsOf(
                  allForms: getFakeForms(),
                  currentFolderId: provider.currentFolderId.value,
                ),
              ),
            ),
          ],
        ),
      );
    }
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

  Widget pathWidgetBuilder() {
    var paths = currentPath.reversed.toList();
    paths.add(Path(title: 'FormIt', type: PathType.section));
    paths = paths.reversed.toList();

    double screenWidth = MediaQuery.of(context).size.width;
    final collapseThreshold =
        (screenWidth > 900 && !provider.isSideBarOpen.value) ? 4 : 3;

    // If paths are short, show all normally
    if (paths.length <= collapseThreshold) {
      return FBreadcrumb(
        children: List.generate(paths.length, (index) {
          final isLast = index == paths.length - 1;
          final isFirst = index == 0;
          final segment = paths[index];
          return FBreadcrumbItem(
            current: isLast,
            onPress: isLast || isFirst || segment.title == "FormIt"
                ? null
                : () {
                    debugPrint(
                      'Navigate to: ${paths.take(index + 1).join('/')}',
                    );
                    setState(() {
                      currentPath = paths.take(index + 1).toList().sublist(1);
                      provider.currentFolderId.value = segment.collectionId;
                    });
                  },
            child: Text(segment.title),
          );
        }),
      );
    }

    // Otherwise, collapse middle paths
    final first = paths.first;
    final last = paths.last;
    final middle = paths.sublist(1, paths.length - 1);

    return FBreadcrumb(
      children: [
        // First item
        FBreadcrumbItem(
          onPress: () {
            setState(() {
              currentPath = [];
              provider.currentFolderId.value = first.collectionId;
            });
          },
          child: Text(first.title),
        ),

        // Collapsed middle items
        FBreadcrumbItem.collapsed(
          menu: [
            FItemGroup(
              children: [
                for (final segment in middle)
                  FItem(
                    title: Text(segment.title),
                    onPress: () {
                      debugPrint('Navigate to: ${segment.title}');
                      setState(() {
                        // Navigate up to the selected segment
                        final targetIndex = paths.indexOf(segment);
                        currentPath = paths
                            .take(targetIndex + 1)
                            .toList()
                            .sublist(1);
                        provider.currentFolderId.value = segment.collectionId;
                      });
                    },
                  ),
              ],
            ),
          ],
        ),

        // Last item (current)
        FBreadcrumbItem(current: true, child: Text(last.title)),
      ],
    );
  }

  Widget ListCollections({
    required List<Collection> collections,
    required List<Form> forms,
    required theme theme,
    required bool isGrid,
  }) {
    Widget buildCollectionCard(Collection collection) {
      return FTappable(
        style: FTappableStyle(),
        semanticsLabel: 'Forms Collection',
        selected: false,
        autofocus: false,
        behavior: HitTestBehavior.translucent,
        onPress: () {
          if (collection.parentId == null) {
            provider.resetCurrentFolderId(collections);
          } else {
            provider.currentFolderId.value = collection.id;
          }
          currentPath.add(
            AppPath.collections.data(
              folderName: collection.name,
              collectionId: collection.id,
            ),
          );
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
                        "${countFolderChildren(allFolders: fakeCollections, currentFolderId: collection.id, allForms: getFakeForms())} items",
                        style: TextStyle(
                          color: theme.secondaryTextColor.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                popupForCollection(theme,collection),
              ],
            ),
          ),
        ),
      );
    }
    Widget buildFormCard(Form f) {
      return FTappable(
        style: FTappableStyle(),
        semanticsLabel: 'Form',
        selected: false,
        autofocus: false,
        behavior: HitTestBehavior.translucent,
        onPress: () {
          print("Open form: ${f.title}");
        },
        builder: (context, state, child) => child!,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: theme.brightness == Brightness.light
                ? Border.all(color: theme.border.withOpacity(0.3), width: 1)
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // Mesh gradient background
                Positioned.fill(
                  child: AnimatedMeshGradient(
                    colors: theme.brightness == Brightness.dark
                        ? [
                            Color(0xFF201829),
                            theme.cardColor.withOpacity(0.9),
                            theme.cardColor.withOpacity(0.8),
                            theme.cardColor.withOpacity(0.95),
                          ]
                        : [
                            Color(0xFFE4DEFA),
                            Color(0xFFDFDFDF),
                            Color(0xFFDFDFDF),
                            Color(0xFFDFDFDF),
                          ],
                    options: AnimatedMeshGradientOptions(
                      amplitude: 30,
                      grain: 0.5,
                      frequency: 3,
                      speed: 6,
                    ),
                  ),
                ),
                // Main content
                Padding(
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
                          mainAxisSize: MainAxisSize.min, // Add this
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    f.title,
                                    style: TextStyle(
                                      color: theme.textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            (isGrid)
                                ? Spacer()
                                : const SizedBox(
                                    height: 8,
                                  ), // Replace Spacer() with this
                            Row(
                              children: [
                                // Status badge
                                StatueBadgeWidget(f.status,t),
                                (isGrid)
                                    ? Spacer()
                                    : const SizedBox(width: 12),
                                // Submissions count
                                Icon(
                                  HugeIconsStroke.userMultiple,
                                  size: 14,
                                  color: theme.secondaryTextColor.withOpacity(
                                    0.7,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${f.submissionsCount}",
                                  style: TextStyle(
                                    color: theme.secondaryTextColor.withOpacity(
                                      0.8,
                                    ),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
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
                              print("Edit form");
                            },
                            label: "Edit",
                            color: theme.textColor,
                            icon: HugeIconsStroke.edit03,
                          ),
                          PopupMenuItemData(
                            onTap: () {
                              print("View responses");
                            },
                            label: "View Responses",
                            color: theme.textColor,
                            icon: HugeIconsStroke.analytics01,
                          ),
                          PopupMenuItemData(
                            onTap: () {
                              print("Duplicate");
                            },
                            label: "Duplicate",
                            color: theme.textColor,
                            icon: HugeIconsStroke.copy01,
                          ),
                          PopupMenuItemData(
                            onTap: () {
                              print("Share");
                            },
                            label: "Share",
                            color: theme.textColor,
                            icon: HugeIconsStroke.share08,
                          ),
                          PopupMenuItemData(
                            onTap: () {
                              showDialogDeleteForm(context,t,f);
                            },
                            label: "Delete Form",
                            color: theme.errorColor,
                            icon: HugeIconsStroke.delete01,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    // Combine collections and forms - collections first
    final totalItems = collections.length + forms.length;

    if (isGrid) {
      return LayoutBuilder(
        builder: (context, constraints) {
          const double minItemWidth = 250;
          final int crossAxisCount = (constraints.maxWidth / minItemWidth)
              .floor()
              .clamp(1, 6);
          final double childWidth =
              (constraints.maxWidth - (crossAxisCount - 1) * 12) /
              crossAxisCount;
          const double childHeight = 120;
          final double childAspectRatio = childWidth / childHeight;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: totalItems,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              // Show collections first, then forms
              if (index < collections.length) {
                return buildCollectionCard(collections[index]);
              } else {
                final formIndex = index - collections.length;
                return buildFormCard(forms[formIndex]);
              }
            },
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: totalItems,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        itemBuilder: (context, index) {
          // Show collections first, then forms
          if (index < collections.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 700),
                  child: buildCollectionCard(collections[index]),
                ),
              ),
            );
          } else {
            final formIndex = index - collections.length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 700),
                  child: buildFormCard(forms[formIndex]),
                ),
              ),
            );
          }
        },
      );
    }
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

  List<Collection> getCollectionsOf({
    required List<Collection> allFolders,
    String? currentFolderId,
  }) {
    return allFolders.where((f) => f.parentId == currentFolderId).toList();
  }

  List<Form> getFormsOf({
    required List<Form> allForms,
    String? currentFolderId,
  }) {
    return allForms.where((f) => f.collectionId == currentFolderId).toList();
  }

  int countFolderChildren({
    required List<Collection> allFolders,
    required List<Form> allForms,
    String? currentFolderId,
  }) {
    int collections = getCollectionsOf(
      allFolders: allFolders,
      currentFolderId: currentFolderId,
    ).length;

    int forms = getFormsOf(
      allForms: allForms,
      currentFolderId: currentFolderId,
    ).length;

    return collections + forms;
  }

  void handleSideBarCloseMobile() {
    if (!isLandscape(context)) {
      provider.setIsSideBarOpen(false);
    }
  }

  Widget noResultsImage() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SvgPicture.asset(
        "assets/vectors/vision.svg",
        height: isLandscape(context) ? screenHeight * 0.6 : null,
        width: isLandscape(context) ? null : screenWidth,
      ),
    );
  }

  countTrash({required allFolders}) {
    return 0;
  }

  popupForCollection(theme theme,Collection c) {
    return CollectionPopupMenu(
      iconColor: theme.textColor,
      cardColor: theme.cardColor,
      items: [
        PopupMenuItemData(
          onTap: () {
            showDialogRenameCollection(context,t,c);
          },
          label: "Rename",
          color: theme.textColor,
          icon: HugeIconsStroke.edit03,
        ),
        PopupMenuItemData(
          onTap: () {
            showDialogDeleteCollection(context,t,c);
          },
          label: "Delete Collection",
          color: theme.errorColor,
          icon: HugeIconsStroke.delete01,
        ),
      ],
    );
  }
}

Widget StatueBadgeWidget(FormStatus status,theme theme) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: getStatusColor(status,theme).withOpacity(0.15),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(getStatusIcon(status,theme), size: 12, color: getStatusColor(status,theme)),
        const SizedBox(width: 4),
        Text(
          status.name.toUpperCase(),
          style: TextStyle(
            color: getStatusColor(status,theme),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}

// Status color
Color getStatusColor(FormStatus status,theme theme) {
  switch (status) {
    case FormStatus.published:
      return Colors.green;
    case FormStatus.draft:
      return theme.secondaryTextColor;
    case FormStatus.closed:
      return theme.errorColor;
  }
}

// Status icon
IconData getStatusIcon(FormStatus status,theme theme) {
  switch (status) {
    case FormStatus.published:
      return HugeIconsStroke.checkmarkCircle02;
    case FormStatus.draft:
      return HugeIconsStroke.edit02;
    case FormStatus.closed:
      return HugeIconsStroke.cancelCircle;
  }
}
