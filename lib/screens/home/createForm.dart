// ignore_for_file: file_names
import 'dart:async';
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formbuilder/screens/home/appScreen.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../backend/models/form.dart';
import '../../data/constants.dart';
import '../../main.dart';
import '../../services/provider.dart';
import '../../services/secureSharedPreferencesService.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/form.dart';
import '../../widgets/menu.dart';

class CreatForm extends StatefulWidget {
  CreatForm({super.key, required this.t});
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
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            isLandscape(context)
                ? Expanded(
                    child: _buildLandscapeBody(screenWidth, screenHeight, t),
                  )
                : _buildPortraitBody(),
            SizedBox(width: 20),
            if (isCustomizeSideBarOpen) _buildCustomizeSidebar(t),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // LANDSCAPE BODY
  // --------------------------------------------------------------------------
  Widget _buildLandscapeBody(double screenWidth, double screenHeight, theme t) {
    return Center(
      child: Container(
        height: screenHeight * 0.7,
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: t.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: t.border.withOpacity(0.3)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(children: [_buildMainContent()]),
        ),
      ),
    );
  }

  Widget _buildPortraitBody() {
    return Center(child: _buildMainContent());
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
                    StatueBadgeWidget(FormStatus.draft, widget.t),
                    SizedBox(width: 10),
                    FButton.icon(
                      onPress: _settingsOnClick,
                      style: FButtonStyle.outline(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Settings",
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
                      onPress: _previewOnClick,
                      style: FButtonStyle.outline(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Preview",
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
                          (isCreatingLoading)?
                          SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: t.bgColor,
                            ),
                          )
                          :Icon(
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
                    StatueBadgeWidget(FormStatus.draft, widget.t),
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
                        PopupMenuItemData(
                          onTap: _previewOnClick,
                          label: "Preview",
                          color: theme.textColor,
                          icon: HugeIconsStroke.view,
                        ),
                        PopupMenuItemData(
                          onTap: _customizeOnClick,
                          label: "Customize",
                          color: theme.textColor,
                          icon: HugeIconsStroke.edit03,
                        ),
                        PopupMenuItemData(
                          onTap: _settingsOnClick,
                          label: "Settings",
                          color: theme.textColor,
                          icon: HugeIconsStroke.settings02,
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.only(right: 8, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: t.cardColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Customize",
                style: TextStyle(color: t.textColor, fontSize: 14,fontWeight: FontWeight.w500),
              ),
              Spacer(),
              buildCancelIconButton(t, context, isX: true, iconSized: 15,onclick: (){
                setState(() {
                  isCustomizeSideBarOpen = false;
                });
              }),
            ],
          ),
          SingleChildScrollView(child: Column(children: [])),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // ACTION HANDLERS
  // --------------------------------------------------------------------------
  _publishOnClick() async {
    //prevent clicking if its already trying to create your form
    if(isCreatingLoading) return;
    //start the loading
    setState(() {
      isCreatingLoading = true;
    });
    try{
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pop(context);
      showSuccess("Form created successfully", context);
    }catch(e) {
      showError("Error while creating form", context);
    } finally{
      setState(() {
        isCreatingLoading = true;
      });
    }
  }

  _previewOnClick() {
    EasyLauncher.url(url: "https://azizbalti.netlify.app");
  }

  _customizeOnClick() {
    setState(() {
      isCustomizeSideBarOpen = !isCustomizeSideBarOpen;
    });
  }

  _settingsOnClick() {
    showMsg(Constants.notReadyMsg, context, t);
  }
}
