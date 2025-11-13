// ignore_for_file: file_names
import 'dart:async';
import 'dart:typed_data';

import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formbuilder/screens/home/appScreen.dart';
import 'package:formbuilder/screens/home/widgets/dropList.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:split_view/split_view.dart';
import '../../backend/models/form/form.dart';
import '../../backend/models/form/formCustomization.dart';
import '../../data/constants.dart';
import '../../main.dart';
import '../../services/provider.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/cards.dart';
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
  Uint8List? logoImageBytes;
  Uint8List? coverImageBytes;
  PageCustomization pageCustomization = PageCustomization();
  int _selectedSectionIndex = 0;
  SplitViewController splitController = SplitViewController(
    limits: [WeightLimit(min: 0.3, max: 0.7), null],
    weights: [0.7, 0.3],
  );
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

  // --------------------------------------------------------------------------
  // LANDSCAPE BODY
  // --------------------------------------------------------------------------
  Widget _buildLandscapeBody(double screenWidth, double screenHeight, theme t) {
    // Define aspect ratios depending on the selected preview size
    double aspectRatio;
    switch (previewSize) {
      case PreviewSizes.phone:
        aspectRatio = 9 / 16; // taller, like a phone
        break;
      case PreviewSizes.tablet:
        aspectRatio = 3 / 4; // slightly wider
        break;
      case PreviewSizes.desktop:
        aspectRatio = 16 / 9; // wide screen
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
        if (_selectedSectionIndex == 0)
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Container(
                  height: screenHeight * 0.6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: pageCustomization.backgroundColorValue,
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
          ),
        if (_selectedSectionIndex == 1)
          sectionWorkflow(t: t),
      ],
    );
  }

  Widget sectionWorkflow({required theme t}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(),
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

  // --------------------------------------------------------------------------
  // UI COMPONENTS
  // --------------------------------------------------------------------------
  PreferredSizeWidget _buildAppBar(theme theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: LayoutBuilder(
        builder: (context, constraints) {
          return isLandscape(context)
              ? Row(
                  children: [
                    buildCancelIconButton(t, context, isX: true),
                    Spacer(),
                    SizedBox(width: 10),
                    FTooltip(
                      tipBuilder: (context, controller) =>
                          const Text('Preview'),
                      child: IconButton(
                        onPressed: _previewOnClick,
                        icon: Icon(
                          HugeIconsStroke.play,
                          size: 22,
                          color: t.textColor,
                        ),
                      ),
                    ),
                    FTooltip(
                      tipBuilder: (context, controller) =>
                          const Text('FormIt Ai'),
                      child: IconButton(
                        onPressed: _aiOnClick,
                        icon: Icon(
                          HugeIconsStroke.aiMagic,
                          size: 20,
                          color: t.textColor,
                        ),
                      ),
                    ),
                    if (_selectedSectionIndex == 0)
                      SizedBox(width: 8),
                    if (_selectedSectionIndex == 0)
                      FTooltip(
                      tipBuilder: (context, controller) =>
                          const Text('Screen Size'),
                      child: aspectRatioChanger(t),
                    ),
                    if (_selectedSectionIndex == 0)
                      SizedBox(width: 8),
                    FTooltip(
                      tipBuilder: (context, controller) =>
                          const Text('Translation'),
                      child: IconButton(
                        onPressed: _translateOnClick,
                        icon: Icon(
                          FIcons.languages,
                          size: 17,
                          color: t.textColor,
                        ),
                      ),
                    ),
                    FTooltip(
                      tipBuilder: (context, controller) =>
                          const Text('Edit History'),
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
                      tipBuilder: (context, controller) =>
                          const Text('Settings'),
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
                )
              : Row(
                  children: [
                    buildCancelIconButton(t, context, isX: true),
                    Spacer(),
                    SizedBox(width: 10),
                    if (_selectedSectionIndex == 0)
                      aspectRatioChanger(t),
                    if (_selectedSectionIndex == 0)
                      SizedBox(width: 20),
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
                        PopupMenuItemData(
                          onTap: _settingsOnClick,
                          label: "Translate",
                          color: theme.textColor,
                          icon: FIcons.languages,
                        ),
                        PopupMenuItemData(
                          onTap: _aiOnClick,
                          label: "Formit Ai",
                          color: theme.textColor,
                          icon: HugeIconsStroke.aiMagic,
                        ),
                        PopupMenuItemData(
                          onTap: _previewOnClick,
                          label: "Preview",
                          color: theme.textColor,
                          icon: HugeIconsStroke.play,
                        ),
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // SIDEBAR
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomizationSection("Colors", isFirst: true),
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomizationItemColorPicker(
                        "Background",
                        "#ffffff",
                        Colors.white,
                        t,
                        () {},
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItemColorPicker(
                        "Text",
                        "#0000ff",
                        Colors.blue,
                        t,
                        () {},
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
                        "#ff0000",
                        Colors.red,
                        t,
                        () {},
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItemColorPicker(
                        "Border",
                        "#0000ff",
                        Colors.blue,
                        t,
                        () {},
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
                        "#ff0000",
                        Colors.red,
                        t,
                        () {},
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItemColorPicker(
                        "Button Text",
                        "#0000ff",
                        Colors.blue,
                        t,
                        () {},
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
                        "20px",
                        t,
                        () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildCustomizationItem("Page Width", "800px", t, () {}),
                _buildCustomizationSection("Logo"),
                ProfileImagePicker(
                  t: t,
                  imageBytes: logoImageBytes,
                  size: 50,
                  onImagePick: () async {
                    final result = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (result != null) {
                      final bytes = await result.readAsBytes();
                      setState(() => logoImageBytes = bytes);
                    }
                  },
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomizationItem(
                        "Width",
                        "300px",
                        t,
                        () {},
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItem(
                        "Height",
                        "200px",
                        t,
                        () {},
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: _buildCustomizationItem("Round", "5px", t, () {}),
                    ),
                  ],
                ),
                _buildCustomizationSection("Cover"),
                ProfileImagePicker(
                  t: t,
                  imageBytes: coverImageBytes,
                  size: 50,
                  onImagePick: () async {
                    final result = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (result != null) {
                      final bytes = await result.readAsBytes();
                      setState(() => coverImageBytes = bytes);
                    }
                  },
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomizationItem("Height", "50%", t, () {}),
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

  Widget _buildScreensSidebar(theme t) {
    return Expanded(
      child: Container(
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
              child: Column(children: []),
              footer: FButton.icon(
                onPress: () {},
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
              child: Column(children: []),
              footer: SizedBox(),
            ),
          ],
          onWeightChanged: (weights) {
            print("Vertical Split Weights: $weights");
          },
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
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: t.textColor,
                        ),
                      ),
                      Spacer(),
                      if (title != "Screens")
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(HugeIconsSolid.addCircle, size: 24),
                            padding: EdgeInsets.zero,
                            alignment: Alignment
                                .center, // 👈 ensures perfect centering
                            splashRadius: 24, // optional: keeps ripple tight
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
    String buttonText,
    theme t,
    Function() onPick,
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
          style: FTappableStyle(),
          semanticsLabel: '$title customization',
          selected: false,
          autofocus: false,
          behavior: HitTestBehavior.translucent,
          onPress: () {},
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

  Widget _buildCustomizationItemColorPicker(
    String title,
    String buttonText,
    Color initColor,
    theme t,
    Function() onPick,
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
          onPress: () {},
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
        FontFamilySelector(),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // ACTION HANDLERS
  // --------------------------------------------------------------------------
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
    showMsg("ai", context, t);
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
    showMsg("translate", context, t);
  }

  _settingsOnClick() {
    showMsg(Constants.notReadyMsg, context, t);
  }

  _historyOnClick() {
    showMsg("history", context, t);
  }

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
}
