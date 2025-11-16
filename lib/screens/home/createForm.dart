// ignore_for_file: file_names
import 'dart:async';
import 'dart:typed_data';

import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' hide colorFromHex;
import 'package:formbuilder/screens/home/appScreen.dart';
import 'package:formbuilder/screens/home/widgets/dropList.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:split_view/split_view.dart';
import '../../backend/models/form/screen.dart';
import '../../backend/models/form/form.dart';
import '../../backend/models/form/screenCustomization.dart';
import '../../data/constants.dart';
import '../../main.dart';
import '../../services/provider.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/canva.dart';
import '../../widgets/cards.dart';
import '../../widgets/dialogues.dart';
import '../../widgets/form.dart';
import '../../widgets/menu.dart';

enum PreviewSizes { phone, tablet, desktop }

class CreatForm extends StatefulWidget {
  CreatForm({super.key, required this.t, required type});
  final theme t;

  @override
  State<CreatForm> createState() => _State();
}

class _State extends State<CreatForm> {
  // --------------------------------------------------------------------------
  // STATE VARIABLES
  // --------------------------------------------------------------------------
  late theme t;
  bool showKey = true;
  bool isCreatingLoading = false;
  bool isCustomizeSideBarOpen = false;
  bool isScreensSideBarOpen = true;
  PreviewSizes previewSize = PreviewSizes.desktop;
  ScreenCustomization pageCustomization = ScreenCustomization();
  int _selectedSectionIndex = 0;
  SplitViewController splitController = SplitViewController(
    limits: [WeightLimit(min: 0.3, max: 0.7), null],
    weights: [0.7, 0.3],
  );
  int maxInt = 9223372036854775807;
  bool isAutoConnect = false;

  late Screen selectedScreen;
  late List<Screen> screens;
  late List<Screen> endings;

  // --------------------------------------------------------------------------
  // SERVICES
  // --------------------------------------------------------------------------
  final Provider provider = Get.find<Provider>();

  // --------------------------------------------------------------------------
  // LIFECYCLE METHODS
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    t = widget.t;
    screens = [Screen.createRegularScreen("Screen_1", 0)];
    endings = [Screen.createEndingScreen("Ending_1", index: 0)];
    selectedScreen = screens.first;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // BUILD METHOD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return SystemUiStyleWrapper(
      t: t,
      child: Scaffold(
        backgroundColor: t.bgColor,
        appBar: _buildAppBar(t),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: isLandscape(context)
                  ? _buildLandscapeBody(screenWidth, screenHeight, t)
                  : _buildPortraitBody(screenWidth, screenHeight, t),
            ),
            if (isScreensSideBarOpen && _selectedSectionIndex == 0)
              Positioned(
                top: 0,
                bottom: 0,
                left: 5,
                child: _buildScreensSidebar(t),
              ),
            if (isCustomizeSideBarOpen && _selectedSectionIndex == 0)
              Positioned(
                top: 0,
                bottom: 0,
                right: 5,
                child: _buildCustomizeSidebar(t),
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // BODY LAYOUTS
  // ==========================================================================
  Widget _buildLandscapeBody(double screenWidth, double screenHeight, theme t) {
    // Define aspect ratios depending on the selected preview size
    double aspectRatio;
    switch (previewSize) {
      case PreviewSizes.phone:
        aspectRatio = 9 / 16;
        break;
      case PreviewSizes.tablet:
        aspectRatio = 3 / 4;
        break;
      case PreviewSizes.desktop:
        aspectRatio = 16 / 9;
        break;
    }

    final Map<int, Widget> segments = {
      0: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape(context) ? 10 : 5,
          vertical: 8,
        ),
        child: Text(
          "Content",
          style: TextStyle(
            color: (_selectedSectionIndex == 0)
                ? t.bgColor
                : t.secondaryTextColor,
          ),
        ),
      ),
      1: Text(
        'Workflow',
        style: TextStyle(
          color: (_selectedSectionIndex == 1)
              ? t.bgColor
              : t.secondaryTextColor,
        ),
      ),
    };

    return Column(
      children: [
        CupertinoSlidingSegmentedControl<int>(
          groupValue: _selectedSectionIndex,
          thumbColor: t.textColor,
          backgroundColor: t.cardColor,
          children: segments,
          onValueChanged: (value) {
            setState(() => _selectedSectionIndex = value!);
          },
        ),
        SizedBox(height: 10),
        Expanded(
          child: IndexedStack(
            index: _selectedSectionIndex,
            children: [
              // Content tab
              Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Container(
                    height: screenHeight * 0.6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorFromHex(
                        selectedScreen.screenCustomization.backgroundColor,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 1,
                        color: t.border.withOpacity(0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _buildMainContent(),
                    ),
                  ),
                ),
              ),
              // Workflow tab (Canvas)
              sectionWorkflow(t: t),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitBody(double screenWidth, double screenHeight, theme t) {
    return _buildLandscapeBody(screenWidth, screenHeight, t);
  }

  Widget _buildMainContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }

  Widget sectionWorkflow({required theme t}) {
    print("aaasba");
    List<Screen> allScreens = screens.toList();
    allScreens.addAll(endings);
    return Stack(
      children: [
        InteractiveCanvas(
          isAutoConnect : isAutoConnect,
          screens: allScreens,
          t: t,
          onScreenMoved: (Offset position, String itemMovedId, bool isEnding) {
            if (isEnding) {
              endings.firstWhere((s) => s.id == itemMovedId).workflow.position =
                  position;
            } else {
              screens.firstWhere((s) => s.id == itemMovedId).workflow.position =
                  position;
            }
          },
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            decoration: BoxDecoration(
              color: t.cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                FTooltip(
                  tipBuilder: (context, controller) =>
                      const Text('Zoom In'),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(FIcons.zoomIn, color: t.textColor),
                  ),
                ),
                FTooltip(
                  tipBuilder: (context, controller) =>
                  const Text('Zoom Out'),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(FIcons.zoomOut, color: t.textColor),
                  ),
                ),
                FTooltip(
                  tipBuilder: (context, controller) =>
                  const Text('Center View'),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(FIcons.focus, color: t.textColor),
                  ),
                ),
                FTooltip(
                  tipBuilder: (context, controller) =>
                  const Text('Auto Connect'),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isAutoConnect = !isAutoConnect;
                      });
                    },
                    icon: Icon(FIcons.workflow, color: t.textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // APP BAR
  // ==========================================================================
  PreferredSizeWidget _buildAppBar(theme theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: LayoutBuilder(
        builder: (context, constraints) {
          return isLandscape(context)
              ? _buildLandscapeAppBarContent(theme)
              : _buildPortraitAppBarContent(theme);
        },
      ),
    );
  }

  Widget _buildLandscapeAppBarContent(theme theme) {
    return Row(
      children: [
        buildCancelIconButton(t, context, isX: true),
        Spacer(),
        SizedBox(width: 10),
        FTooltip(
          tipBuilder: (context, controller) => const Text('Preview'),
          child: IconButton(
            onPressed: _previewOnClick,
            icon: Icon(HugeIconsStroke.play, size: 22, color: t.textColor),
          ),
        ),
        FTooltip(
          tipBuilder: (context, controller) => const Text('FormIt Ai'),
          child: IconButton(
            onPressed: _aiOnClick,
            icon: Icon(HugeIconsStroke.aiMagic, size: 20, color: t.textColor),
          ),
        ),
        if (_selectedSectionIndex == 0) SizedBox(width: 8),
        if (_selectedSectionIndex == 0)
          FTooltip(
            tipBuilder: (context, controller) => const Text('Screen Size'),
            child: aspectRatioChanger(t),
          ),
        if (_selectedSectionIndex == 0) SizedBox(width: 8),
        if (_selectedSectionIndex == 0)
          FTooltip(
            tipBuilder: (context, controller) => const Text('Translation'),
            child: IconButton(
              onPressed: _translateOnClick,
              icon: Icon(FIcons.languages, size: 17, color: t.textColor),
            ),
          )
        else
          FTooltip(
            tipBuilder: (context, controller) => const Text('Messages'),
            child: IconButton(
              onPressed: _messagesOnClick,
              icon: Icon(FIcons.send, size: 17, color: t.textColor),
            ),
          ),
        FTooltip(
          tipBuilder: (context, controller) => const Text('Edit History'),
          child: IconButton(
            onPressed: _historyOnClick,
            icon: Icon(
              HugeIconsStroke.transactionHistory,
              size: 19,
              color: t.textColor,
            ),
          ),
        ),
        FTooltip(
          tipBuilder: (context, controller) => const Text('Settings'),
          child: IconButton(
            onPressed: _settingsOnClick,
            icon: Icon(
              HugeIconsStroke.settings01,
              size: 19,
              color: t.textColor,
            ),
          ),
        ),
        if (_selectedSectionIndex == 0) SizedBox(width: 10),
        if (_selectedSectionIndex == 0)
          FButton.icon(
            onPress: _screensOnClick,
            style: FButtonStyle.outline(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Screens",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: t.brightness == Brightness.light
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: t.textColor,
                  ),
                ),
              ],
            ),
          ),
        if (_selectedSectionIndex == 0) SizedBox(width: 10),
        if (_selectedSectionIndex == 0)
          FButton.icon(
            onPress: _customizeOnClick,
            style: FButtonStyle.outline(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Customize",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: t.brightness == Brightness.light
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: t.textColor,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(width: 10),
        FButton.icon(
          onPress: _publishOnClick,
          style: FButtonStyle.primary(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 4),
              (isCreatingLoading)
                  ? SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: t.bgColor,
                      ),
                    )
                  : Icon(
                      HugeIconsStroke.globe02,
                      color: t.bgColor,
                      size: 16,
                      weight: 30,
                    ),
              SizedBox(width: 10),
              Text(
                "Publish",
                style: TextStyle(
                  fontSize: 14,
                  color: t.bgColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitAppBarContent(theme theme) {
    return Row(
      children: [
        buildCancelIconButton(t, context, isX: true),
        Spacer(),
        SizedBox(width: 10),
        if (_selectedSectionIndex == 0) aspectRatioChanger(t),
        if (_selectedSectionIndex == 0) SizedBox(width: 20),
        IconButton(
          onPressed: _previewOnClick,
          icon: Icon(HugeIconsStroke.play),
        ),
        SizedBox(width: 10),
        CollectionPopupMenu(
          icon: HugeIconsStroke.menu01,
          iconColor: theme.textColor,
          cardColor: theme.cardColor,
          items: [
            PopupMenuItemData(
              onTap: _publishOnClick,
              label: "Publish",
              color: theme.accentColor,
              icon: Icons.check_rounded,
            ),
            if (_selectedSectionIndex == 0)
              PopupMenuItemData(
                onTap: _customizeOnClick,
                label: "Customize",
                color: theme.textColor,
                icon: HugeIconsStroke.edit03,
              ),
            if (_selectedSectionIndex == 0)
              PopupMenuItemData(
                onTap: _screensOnClick,
                label: "Screens",
                color: theme.textColor,
                icon: HugeIconsStroke.smartPhone02,
              ),
            PopupMenuItemData(
              onTap: _settingsOnClick,
              label: "Settings",
              color: theme.textColor,
              icon: HugeIconsStroke.settings02,
            ),
            PopupMenuItemData(
              onTap: _historyOnClick,
              label: "History",
              color: theme.textColor,
              icon: HugeIconsStroke.transactionHistory,
            ),
            if (_selectedSectionIndex == 0)
              PopupMenuItemData(
                onTap: _settingsOnClick,
                label: "Translate",
                color: theme.textColor,
                icon: FIcons.languages,
              )
            else
              PopupMenuItemData(
                onTap: _settingsOnClick,
                label: "Messages",
                color: theme.textColor,
                icon: FIcons.send,
              ),
            PopupMenuItemData(
              onTap: _aiOnClick,
              label: "Formit Ai",
              color: theme.textColor,
              icon: HugeIconsStroke.aiMagic,
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================================
  // SIDEBARS
  // ==========================================================================

  // --------------------------------------------------------------------------
  // SCREENS SIDEBAR
  // --------------------------------------------------------------------------
  Widget _buildScreensSidebar(theme t) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 8, bottom: 12),
      child: SplitView(
        viewMode: SplitViewMode.Vertical,
        controller: splitController,
        indicator: SplitIndicator(
          viewMode: SplitViewMode.Vertical,
          color: t.border.withOpacity(0.4),
        ),
        activeIndicator: SplitIndicator(
          viewMode: SplitViewMode.Vertical,
          color: t.border,
          isActive: true,
        ),
        gripColor: t.border.withOpacity(0),
        gripColorActive: t.accentColor.withOpacity(0),
        children: [
          _buildSidebarSection(
            title: "Screens",
            t: t,
            child: Column(
              children: screens.map((s) => screenItemWidget(s, t)).toList(),
            ),
            footer: FButton.icon(
              onPress: () {
                setState(() {
                  screens.add(
                    Screen.createRegularScreen(
                      "Screen_${screens.length + 1}",
                      screens.length,
                    ),
                  );
                });
              },
              style: FButtonStyle.outline(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 4),
                  Icon(HugeIconsStroke.add01, color: t.textColor, size: 16),
                  SizedBox(width: 10),
                  Text(
                    "Add Screen",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: t.textColor,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
          _buildSidebarSection(
            title: "Endings",
            t: t,
            child: Column(
              children: endings.map((s) => screenItemWidget(s, t)).toList(),
            ),
            footer: SizedBox(),
          ),
        ],
        onWeightChanged: (weights) {
          print("Vertical Split Weights: $weights");
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // CUSTOMIZE SIDEBAR
  // --------------------------------------------------------------------------
  Widget _buildCustomizeSidebar(theme t) {
    return Container(
      width: 300,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.only(right: 8, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: t.cardColor,
        border: Border.all(color: t.border.withOpacity(0.5)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Icon(
                  selectedScreen.isEnding
                      ? HugeIconsSolid.flag03
                      : HugeIconsStroke.changeScreenMode,
                  size: 20,
                  color: t.textColor,
                ),
                SizedBox(width: 5),
                Text(
                  selectedScreen.id,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: t.textColor,
                  ),
                ),
                Spacer(),
                buildCancelIconButton(
                  t,
                  context,
                  isX: true,
                  iconSized: 20,
                  onclick: () {
                    setState(() {
                      isCustomizeSideBarOpen = false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomizationSection("Colors", isFirst: true),
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomizationItemColorPicker(
                        "Background",
                        '#${selectedScreen.screenCustomization.backgroundColor}',
                        colorFromHex(
                          selectedScreen.screenCustomization.backgroundColor,
                        ),
                        t,
                        (selectedColor) {
                          selectedScreen.screenCustomization = selectedScreen
                              .screenCustomization
                              .copyWith(
                                backgroundColor: selectedColor.toHexString(),
                              );
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItemColorPicker(
                        "Text",
                        '#${selectedScreen.screenCustomization.textColor}',
                        colorFromHex(
                          selectedScreen.screenCustomization.textColor,
                        ),
                        t,
                        (selectedColor) {
                          selectedScreen.screenCustomization = selectedScreen
                              .screenCustomization
                              .copyWith(textColor: selectedColor.toHexString());
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomizationItemColorPicker(
                        "Accent",
                        '#${selectedScreen.screenCustomization.accentColor}',
                        colorFromHex(
                          selectedScreen.screenCustomization.accentColor,
                        ),
                        t,
                        (selectedColor) {
                          selectedScreen.screenCustomization = selectedScreen
                              .screenCustomization
                              .copyWith(
                                accentColor: selectedColor.toHexString(),
                              );
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItemColorPicker(
                        "Border",
                        '#${selectedScreen.screenCustomization.borderColor}',
                        colorFromHex(
                          selectedScreen.screenCustomization.borderColor,
                        ),
                        t,
                        (selectedColor) {
                          selectedScreen.screenCustomization = selectedScreen
                              .screenCustomization
                              .copyWith(
                                borderColor: selectedColor.toHexString(),
                              );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomizationItemColorPicker(
                        "Button Background",
                        '#${selectedScreen.screenCustomization.buttonBackgroundColor}',
                        colorFromHex(
                          selectedScreen
                              .screenCustomization
                              .buttonBackgroundColor,
                        ),
                        t,
                        (selectedColor) {
                          selectedScreen.screenCustomization = selectedScreen
                              .screenCustomization
                              .copyWith(
                                buttonBackgroundColor: selectedColor
                                    .toHexString(),
                              );
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItemColorPicker(
                        "Button Text",
                        '#${selectedScreen.screenCustomization.buttonTextColor}',
                        colorFromHex(
                          selectedScreen.screenCustomization.buttonTextColor,
                        ),
                        t,
                        (selectedColor) {
                          selectedScreen.screenCustomization = selectedScreen
                              .screenCustomization
                              .copyWith(
                                buttonTextColor: selectedColor.toHexString(),
                              );
                        },
                      ),
                    ),
                  ],
                ),
                _buildCustomizationSection("Page"),
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomizationItemFontPicker(
                        "Font",
                        "Arial",
                        t,
                        (font) {},
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItem(
                        "Font Size",
                        "px",
                        selectedScreen.screenCustomization.fontSize,
                        t,
                        1,
                        100,
                        (selectedValue) {
                          setState(() {
                            selectedScreen.screenCustomization = selectedScreen
                                .screenCustomization
                                .copyWith(fontSize: selectedValue);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildCustomizationItem(
                  "Page Width",
                  "px",
                  selectedScreen.screenCustomization.pageWidth,
                  t,
                  50,
                  maxInt,
                  (selectedValue) {
                    setState(() {
                      selectedScreen.screenCustomization = selectedScreen
                          .screenCustomization
                          .copyWith(pageWidth: selectedValue);
                    });
                  },
                ),
                _buildCustomizationSection("Logo"),
                ProfileImagePicker(
                  t: t,
                  imageBytes: selectedScreen.screenCustomization.logoImageBytes,
                  size: 50,
                  onImagePick: () async {
                    final result = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (result != null) {
                      final bytes = await result.readAsBytes();
                      setState(
                        () =>
                            selectedScreen.screenCustomization.logoImageBytes =
                                bytes,
                      );
                    }
                  },
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomizationItem(
                        "Width",
                        "px",
                        selectedScreen.screenCustomization.logoWidth,
                        t,
                        0,
                        maxInt,

                        (selectedValue) {
                          setState(() {
                            selectedScreen.screenCustomization = selectedScreen
                                .screenCustomization
                                .copyWith(logoWidth: selectedValue);
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItem(
                        "Height",
                        "px",
                        selectedScreen.screenCustomization.logoHeight,
                        t,
                        0,
                        maxInt,

                        (selectedValue) {
                          setState(() {
                            selectedScreen.screenCustomization = selectedScreen
                                .screenCustomization
                                .copyWith(logoHeight: selectedValue);
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItem(
                        "Round",
                        "px",
                        selectedScreen.screenCustomization.logoRound,
                        t,
                        0,
                        maxInt,
                        (selectedValue) {
                          setState(() {
                            selectedScreen.screenCustomization = selectedScreen
                                .screenCustomization
                                .copyWith(logoRound: selectedValue);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                _buildCustomizationSection("Cover"),
                ProfileImagePicker(
                  t: t,
                  imageBytes:
                      selectedScreen.screenCustomization.coverImageBytes,
                  size: 50,
                  onImagePick: () async {
                    final result = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (result != null) {
                      final bytes = await result.readAsBytes();
                      setState(
                        () =>
                            selectedScreen.screenCustomization.coverImageBytes =
                                bytes,
                      );
                    }
                  },
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomizationItem(
                        "Height",
                        "%",
                        selectedScreen.screenCustomization.coverHeight,
                        t,
                        0,
                        100,

                        (selectedValue) {
                          setState(() {
                            selectedScreen.screenCustomization = selectedScreen
                                .screenCustomization
                                .copyWith(coverHeight: selectedValue);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarSection({
    required String title,
    required theme t,
    required Widget child,
    required Widget footer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: t.cardColor,
        border: Border.all(color: t.border.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "$title (${(title != "Screens") ? endings.length : screens.length})",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: t.textColor,
                        ),
                      ),
                      Spacer(),
                      if (title != "Screens")
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                endings.add(
                                  Screen.createEndingScreen(
                                    "Ending_${endings.length + 1}",
                                    index: endings.length,
                                  ),
                                );
                              });
                            },
                            icon: Icon(
                              HugeIconsSolid.addCircle,
                              size: 24,
                              color: t.textColor,
                            ),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            splashRadius: 24,
                          ),
                        )
                      else
                        buildCancelIconButton(
                          t,
                          context,
                          isX: true,
                          iconSized: 20,
                          onclick: () {
                            setState(() {
                              isScreensSideBarOpen = false;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  child,
                ],
              ),
            ),
          ),
          footer,
        ],
      ),
    );
  }

  Widget screenItemWidget(Screen s, theme t) {
    return FTappable(
      style: FTappableStyle(),
      semanticsLabel: 'Forms Collection',
      selected: false,
      autofocus: false,
      behavior: HitTestBehavior.translucent,
      onPress: () {
        setState(() {
          selectedScreen = s;
        });
      },
      builder: (context, state, child) => child!,
      child: Container(
        decoration: BoxDecoration(
          color: (selectedScreen.id == s.id) ? t.textColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(bottom: 5),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
            Icon(
              s.isEnding
                  ? HugeIconsSolid.flag03
                  : HugeIconsStroke.changeScreenMode,
              size: 20,
              color: (selectedScreen.id == s.id) ? t.bgColor : t.textColor,
            ),
            SizedBox(width: 5),
            Text(
              s.id,
              style: TextStyle(
                color: (selectedScreen.id == s.id) ? t.bgColor : t.textColor,
              ),
            ),
            Spacer(),
            CollectionPopupMenu(
              iconColor: (selectedScreen.id == s.id) ? t.bgColor : t.textColor,
              cardColor: t.cardColor,
              iconSize: 18,
              items: [
                PopupMenuItemData(
                  onTap: () {
                    setState(() {
                      //create a new copy
                      if (s.isEnding) {
                        endings.add(
                          s.copyWith(id: "Ending_${endings.length + 1}"),
                        );
                      } else {
                        screens.add(
                          s.copyWith(id: "Screen_${screens.length + 1}"),
                        );
                      }
                    });
                  },
                  label: "Duplicate",
                  color: t.textColor,
                  icon: HugeIconsStroke.copy02,
                ),
                if (s.isEnding && endings.length > 1 ||
                    !s.isEnding && screens.length > 1)
                  PopupMenuItemData(
                    onTap: () {
                      if (s.isEnding) {
                        showDialogDeleteScreen(context, t, () {
                          setState(() {
                            endings.remove(s);
                            //check if nothing is selected select the first one
                            if (s.id == selectedScreen.id) {
                              selectedScreen = endings.first;
                            }
                          });
                        });
                      } else {
                        showDialogDeleteScreen(context, t, () {
                          setState(() {
                            screens.remove(s);
                            if (s.id == selectedScreen.id) {
                              selectedScreen = screens.first;
                            }
                          });
                        });
                      }
                    },
                    label: "Delete",
                    color: t.errorColor,
                    icon: HugeIconsStroke.delete01,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationSection(String title, {bool isFirst = false}) {
    return Padding(
      padding: EdgeInsets.only(top: isFirst ? 0 : 20, bottom: 20),
      child: Text(
        title,
        style: TextStyle(
          color: t.accentColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildCustomizationItem(
    String title,
    String ending,
    int value,
    theme t,
    int minNum,
    int maxNum,
    Function(int newValue) onPick,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: t.textColor.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 5),
        FTappable(
          semanticsLabel: '$title customization',
          selected: false,
          autofocus: false,
          behavior: HitTestBehavior.translucent,
          onPress: () {
            showDialogValuePicker(
              context,
              t,
              title,
              value,
              ending,
              minNum,
              maxNum,
              (value) {
                onPick(int.parse(value));
              },
            );
          },
          builder: (context, state, child) => child!,
          child: FCard.raw(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                bottom: 8,
                top: 8,
                right: 0,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "$value$ending",
                      style: TextStyle(
                        color: t.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomizationItemColorPicker(
    String title,
    String buttonText,
    Color initColor,
    theme t,
    Function(Color color) onPick,
  ) {
    Color color = initColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: t.textColor.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 5),
        FTappable(
          style: FTappableStyle(),
          semanticsLabel: '$title customization',
          selected: false,
          autofocus: false,
          behavior: HitTestBehavior.translucent,
          onPress: () {
            showDialogColorPicker(context, t, color, (color) {
              setState(() {
                onPick(color);
              });
            });
          },
          builder: (context, state, child) => child!,
          child: FCard.raw(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                bottom: 8,
                top: 8,
                right: 0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(1000),
                      border: Border.all(color: t.border.withOpacity(0.3)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: t.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomizationItemFontPicker(
    String title,
    String currentFont,
    theme t,
    Function(String) onFontSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            color: t.textColor.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 5),
        FontFamilySelector(
          key: ValueKey(selectedScreen.id),
          selectedValue: selectedScreen.screenCustomization.fontFamily,
          f: (v) {
            selectedScreen.screenCustomization = selectedScreen
                .screenCustomization
                .copyWith(fontFamily: v);
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // UTILITY WIDGETS
  // ==========================================================================

  // --------------------------------------------------------------------------
  // ASPECT RATIO CHANGER
  // --------------------------------------------------------------------------
  aspectRatioChanger(theme theme) {
    return CollectionPopupMenu(
      icon: (previewSize == PreviewSizes.phone)
          ? HugeIconsStroke.smartPhone01
          : (previewSize == PreviewSizes.tablet)
          ? HugeIconsStroke.tablet01
          : (previewSize == PreviewSizes.desktop)
          ? HugeIconsStroke.laptop
          : HugeIconsStroke.laptop,
      iconColor: theme.textColor,
      cardColor: theme.cardColor,
      iconSize: 18,
      items: [
        PopupMenuItemData(
          onTap: () {
            setState(() {
              previewSize = PreviewSizes.phone;
            });
          },
          label: "Phone",
          color: theme.textColor,
          icon: HugeIconsStroke.smartPhone01,
        ),
        PopupMenuItemData(
          onTap: () {
            setState(() {
              previewSize = PreviewSizes.tablet;
            });
          },
          label: "Tablet",
          color: theme.textColor,
          icon: HugeIconsStroke.tablet01,
        ),
        PopupMenuItemData(
          onTap: () {
            setState(() {
              previewSize = PreviewSizes.desktop;
            });
          },
          label: "Desktop",
          color: theme.textColor,
          icon: HugeIconsStroke.laptop,
        ),
      ],
    );
  }

  // ==========================================================================
  // ACTION HANDLERS
  // ==========================================================================
  _publishOnClick() async {
    //prevent clicking if its already trying to create your form
    if (isCreatingLoading) return;
    //start the loading
    setState(() {
      isCreatingLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pop(context);
      showSuccess("Form created successfully", context);
    } catch (e) {
      showError("Error while creating form", context);
    } finally {
      setState(() {
        isCreatingLoading = true;
      });
    }
  }

  _previewOnClick() {
    EasyLauncher.url(url: "https://azizbalti.netlify.app");
  }

  _aiOnClick() {
    showMsg(Constants.notReadyMsg, context, t);
  }

  _customizeOnClick() {
    setState(() {
      isCustomizeSideBarOpen = !isCustomizeSideBarOpen;
    });
  }

  _screensOnClick() {
    setState(() {
      isScreensSideBarOpen = !isScreensSideBarOpen;
    });
  }

  _translateOnClick() {
    showMsg(Constants.notReadyMsg, context, t);
  }

  _settingsOnClick() {
    showMsg(Constants.notReadyMsg, context, t);
  }

  _historyOnClick() {
    showMsg(Constants.notReadyMsg, context, t);
  }

  _messagesOnClick() {
    showMsg(Constants.notReadyMsg, context, t);
  }
}
