// ignore_for_file: file_names
import 'dart:async';
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart' hide Form;
import 'package:flutter/material.dart' hide Form;
import 'package:flutter_svg/svg.dart';
import 'package:formbuilder/data/integrations.dart';
import 'package:formbuilder/screens/home/appScreen.dart';
import 'package:formbuilder/screens/home/widgets/dropList.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

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
import 'dart:typed_data';

enum PreviewFormSections { responses, insights, share, settings }

class PreviewForm extends StatefulWidget {
  PreviewForm({super.key, required this.t, this.goTo, required this.f});
  final theme t;
  final PreviewFormSections? goTo;
  final Form f;

  @override
  State<PreviewForm> createState() => _State();
}

class _State extends State<PreviewForm> {
  // --------------------------------------------------------------------------
  // STATE VARIABLES
  // --------------------------------------------------------------------------
  late theme t;
  late Form f;
  late int _selectedSectionIndex;
  TextEditingController aiAnalyticsController = TextEditingController();
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
    f = widget.f;
    _selectedSectionIndex = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // BUILD METHOD
  // --------------------------------------------------------------------------
  @override
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // ✅ Build the map dynamically
    final Map<int, Widget> segments = {
      0: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape(context) ? 10 : 5,
          vertical: 8,
        ),
        child: Text(
          (isLandscape(context))?
          "Submissions":"Entries",
          style: TextStyle(
            color: (_selectedSectionIndex == 0)
                ? t.bgColor
                : t.secondaryTextColor,
          ),
        ),
      ),
      1: Text(
          (isLandscape(context))?'Statistics':'Stats',
        style: TextStyle(
          color: (_selectedSectionIndex == 1)
              ? t.bgColor
              : t.secondaryTextColor,
        ),
      ),
      2: Text(
        'Share',
        style: TextStyle(
          color: (_selectedSectionIndex == 2)
              ? t.bgColor
              : t.secondaryTextColor,
        ),
      ),
      3:Text(
        (isLandscape(context))?'Integrations':'Apps',
        style: TextStyle(
          color: (_selectedSectionIndex == 3)
              ? t.bgColor
              : t.secondaryTextColor,
        ),
      )
    };

    return SystemUiStyleWrapper(
      t: t,
      child: Scaffold(
        backgroundColor: t.brightness == Brightness.light
            ? Colors.white
            : t.bgColor,
        appBar: _buildAppBar(t),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  width: screenWidth,
                  child: CupertinoSlidingSegmentedControl<int>(
                    groupValue: _selectedSectionIndex,
                    thumbColor: t.textColor,
                    backgroundColor: t.cardColor,
                    children: segments,
                    onValueChanged: (value) {
                      setState(() => _selectedSectionIndex = value!);
                    },
                  ),
                ),
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 30,
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    width: screenWidth,
                    child: SingleChildScrollView(
                      child: getSection(),
                    ),
                  ),
                ),)
              ],
            ),
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
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        f.title,
                        style: TextStyle(color: t.textColor, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 15),
                    IconButton(
                      onPressed: _copyLinkOnClick,
                      icon: Icon(
                        HugeIconsStroke.link02,
                        color: t.textColor,
                        size: 20,
                        weight: 30,
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: _settingsFormOnClick,
                      icon: Icon(
                        HugeIconsStroke.settings01,
                        color: t.textColor,
                        size: 20,
                        weight: 30,
                      ),
                    ),
                    SizedBox(width: 10),
                    CollectionPopupMenu(
                      icon: HugeIconsStroke.menu01,
                      iconColor: theme.textColor,
                      cardColor: theme.cardColor,
                      customTrigger: StatueBadgeWidget(
                        FormStatus.draft,
                        widget.t,
                        height: 7,
                      ),
                      items: [
                        PopupMenuItemData(
                          onTap: _pauseFormOnClick,
                          label: "Pause",
                          color: theme.errorColor,
                          icon: HugeIconsStroke.pause,
                        ),
                        PopupMenuItemData(
                          onTap: _activateFormOnClick,
                          label: "Activate",
                          color: Colors.green,
                          icon: HugeIconsStroke.toggleOn,
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    FButton.icon(
                      onPress: _editOnClick,
                      style: FButtonStyle.primary(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 4),
                          Icon(
                            HugeIconsStroke.edit02,
                            color: t.bgColor,
                            size: 16,
                            weight: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Edit",
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
                    Expanded(
                      child: Text(
                        f.title,
                        style: TextStyle(color: t.textColor, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 15),
                    CollectionPopupMenu(
                      icon: HugeIconsStroke.menu01,
                      iconColor: theme.textColor,
                      cardColor: theme.cardColor,
                      customTrigger: StatueBadgeWidget(
                        FormStatus.draft,
                        widget.t,
                        height: 7,
                      ),
                      items: [
                        PopupMenuItemData(
                          onTap: _pauseFormOnClick,
                          label: "Pause",
                          color: theme.errorColor,
                          icon: HugeIconsStroke.pause,
                        ),
                        PopupMenuItemData(
                          onTap: _activateFormOnClick,
                          label: "Activate",
                          color: Colors.green,
                          icon: HugeIconsStroke.toggleOn,
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    CollectionPopupMenu(
                      icon: HugeIconsStroke.menu01,
                      iconColor: theme.textColor,
                      cardColor: theme.cardColor,
                      items: [
                        PopupMenuItemData(
                          onTap: _editOnClick,
                          label: "Edit",
                          color: theme.accentColor,
                          icon: HugeIconsStroke.edit02,
                        ),
                        PopupMenuItemData(
                          onTap: _settingsFormOnClick,
                          label: "Settings",
                          color: theme.textColor,
                          icon: HugeIconsStroke.settings01,
                        ),
                        PopupMenuItemData(
                          onTap: _copyLinkOnClick,
                          label: "Copy Link",
                          color: theme.textColor,
                          icon: HugeIconsStroke.copy02,
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
  // ACTION HANDLERS
  // --------------------------------------------------------------------------
  _editOnClick() async {
    showMsg("edit", context, t);
  }

  _copyLinkOnClick() {
    showSuccess("Form link copied successfully!", context);
  }

  _pauseFormOnClick() {
    showSuccess("Form paused", context);
  }

  _activateFormOnClick() {
    showSuccess("Form activated", context);
  }

  _settingsFormOnClick() {
    showSuccess("Settings", context);
  }

  getSection() {
    if (_selectedSectionIndex == 0) {
      return Column(children: []);
    } else if (_selectedSectionIndex == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          StatisticsGrid(t: t),
          const SizedBox(height: 50),
          Row(
            children: [
              Icon(HugeIconsStroke.aiBrain01, color: t.textColor, size: 20),
              const SizedBox(width: 10),
              Text(
                "AI Analytics",
                style: TextStyle(
                  color: t.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Get smart insights powered by AI. Understand your form data instantly.",
            style: TextStyle(color: t.secondaryTextColor),
          ),
          const SizedBox(height: 30),
          (isLandscape(context))?
          Row(
            children: [
              Expanded(child: customInput(t,aiAnalyticsController,  "Eg. When do users submit the most?","", context),),
              SizedBox(width: 5,),
              CustomButton(text: "Analyse", onPressed: (){}, isLoading: false, t: t,isFullRow: false,backgroundColor: t.textColor,icon: HugeIconsStroke.aiSearch02,height: 48,)
            ],
          ):Column(
            children: [
              customInput(t,aiAnalyticsController,  "Eg. When do users submit the most?","", context),
              SizedBox(height: 5,),
              CustomButton(text: "Analyse", onPressed: (){}, isLoading: false, t: t,backgroundColor: t.textColor,icon: HugeIconsStroke.aiSearch02,height: 48,)
            ],
          ),
          SizedBox(height: 30),
        ],
      );
    } else if (_selectedSectionIndex == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Row(
            children: [
              Icon(HugeIconsStroke.share01, color: t.textColor, size: 20),
              const SizedBox(width: 10),
               Text(
                "Share Form Link",
                style: TextStyle(color:t.textColor,fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Easily share this form with others using a public link.",
            style: TextStyle(color: t.secondaryTextColor),
          ),

          SizedBox(height: 30),
        ],
      );
    } else if (_selectedSectionIndex == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Row(
            children: [
              Icon(HugeIconsStroke.grid, color: t.textColor, size: 20),
              SizedBox(width: 10),
              Text(
                "Connect Integrations",
                style: TextStyle(color:t.textColor,fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Link this form with your favorite tools and apps to automate your workflow.",
            style: TextStyle(color: t.secondaryTextColor),

          ),
          SizedBox(height: 30),
          IntegrationsGrid(integrations: integrations, t: t),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
