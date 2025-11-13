// ignore_for_file: file_names
import 'package:flutter/cupertino.dart' hide Form;
import 'package:flutter/material.dart' hide Form;
import 'package:formbuilder/data/integrations.dart';
import 'package:formbuilder/screens/home/appScreen.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../../backend/models/form/form.dart';
import '../../main.dart';
import '../../services/provider.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/cards.dart';
import '../../widgets/form.dart';
import '../../widgets/menu.dart';
import '../../widgets/table.dart';

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
  late int _selectedSubmissionsTypeIndex;
  TextEditingController aiAnalyticsController = TextEditingController();
  late TextEditingController formUrlController;
  late List<List<dynamic>> submissions;
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
    _selectedSubmissionsTypeIndex = 0;

    formUrlController = TextEditingController(
      text: "https://tally.so/r/mRp86j",
    );

    submissions = [
      [
        "Name",
        "Email",
        "Message",
        "Country",
        "Date",
        "Status",
        "Device",
        "IP",
        "Browser",
        "Referrer",
        "Language",
        "Plan",
        "Response Time",
        "Feedback",
        "Rating",
      ],
      [
        "Aziz",
        "aziz@mail.com",
        "Hello!",
        "Tunisia",
        "2025-11-12",
        "Approved",
        "Android",
        "192.168.0.1",
        "Chrome",
        "Google",
        "en",
        "Pro",
        "1.2s",
        "Great UX",
        "5★",
      ],
      [
        "Lina",
        "lina@mail.com",
        "Nice form!",
        "Italy",
        "2025-11-11",
        "Pending",
        "iPhone",
        "172.0.0.2",
        "Safari",
        "Twitter",
        "it",
        "Free",
        "2.1s",
        "Smooth process",
        "4★",
      ],
      [
        "Marco",
        "marco@mail.com",
        "Love the design!",
        "Germany",
        "2025-11-10",
        "Rejected",
        "Windows",
        "10.0.0.3",
        "Edge",
        "LinkedIn",
        "de",
        "Business",
        "3.5s",
        "Needs dark mode",
        "3★",
      ],
      [
        "Sofia",
        "sofia@mail.com",
        "Quick and easy!",
        "Spain",
        "2025-11-09",
        "Approved",
        "MacOS",
        "192.168.0.5",
        "Firefox",
        "Instagram",
        "es",
        "Pro",
        "1.0s",
        "Very intuitive",
        "5★",
      ],
      [
        "Omar",
        "omar@mail.com",
        "Thanks!",
        "Morocco",
        "2025-11-08",
        "Pending",
        "Android",
        "192.168.0.9",
        "Chrome",
        "Facebook",
        "fr",
        "Free",
        "2.8s",
        "Good design",
        "4★",
      ],
      [
        "Hana",
        "hana@mail.com",
        "Useful app!",
        "France",
        "2025-11-07",
        "Approved",
        "iPad",
        "172.0.0.4",
        "Safari",
        "YouTube",
        "fr",
        "Pro",
        "1.7s",
        "Love it!",
        "5★",
      ],
      [
        "Ali",
        "ali@mail.com",
        "Could be faster",
        "Turkey",
        "2025-11-06",
        "Rejected",
        "Android",
        "10.0.0.10",
        "Chrome",
        "Reddit",
        "tr",
        "Free",
        "3.9s",
        "Slow load",
        "3★",
      ],
      [
        "Emma",
        "emma@mail.com",
        "Looks beautiful",
        "UK",
        "2025-11-05",
        "Approved",
        "Windows",
        "172.16.1.5",
        "Edge",
        "LinkedIn",
        "en",
        "Business",
        "1.3s",
        "Professional",
        "5★",
      ],
      [
        "Yuki",
        "yuki@mail.com",
        "Arigato!",
        "Japan",
        "2025-11-04",
        "Approved",
        "iPhone",
        "192.168.1.1",
        "Safari",
        "Twitter",
        "ja",
        "Pro",
        "1.5s",
        "Simple UI",
        "5★",
      ],
      [
        "Fatima",
        "fatima@mail.com",
        "Merci!",
        "Algeria",
        "2025-11-03",
        "Pending",
        "Android",
        "192.168.2.2",
        "Chrome",
        "Google",
        "ar",
        "Free",
        "2.2s",
        "Nice colors",
        "4★",
      ],
      [
        "John",
        "john@mail.com",
        "Smooth experience",
        "USA",
        "2025-11-02",
        "Approved",
        "MacBook",
        "10.10.1.1",
        "Safari",
        "Facebook",
        "en",
        "Pro",
        "1.1s",
        "Fast and clear",
        "5★",
      ],
      [
        "Nina",
        "nina@mail.com",
        "Pretty solid",
        "Sweden",
        "2025-11-01",
        "Approved",
        "Windows",
        "172.19.2.9",
        "Edge",
        "Instagram",
        "sv",
        "Business",
        "2.0s",
        "Elegant layout",
        "5★",
      ],
      [
        "Hassan",
        "hassan@mail.com",
        "Can be improved",
        "Egypt",
        "2025-10-31",
        "Rejected",
        "Android",
        "192.168.10.5",
        "Chrome",
        "Google",
        "ar",
        "Free",
        "3.8s",
        "Too simple",
        "3★",
      ],
      [
        "Laura",
        "laura@mail.com",
        "Looks nice",
        "Portugal",
        "2025-10-30",
        "Approved",
        "MacOS",
        "10.10.0.8",
        "Firefox",
        "Twitter",
        "pt",
        "Pro",
        "1.4s",
        "User friendly",
        "5★",
      ],
      [
        "Igor",
        "igor@mail.com",
        "Добро!",
        "Russia",
        "2025-10-29",
        "Pending",
        "Windows",
        "172.20.0.1",
        "Edge",
        "Google",
        "ru",
        "Free",
        "2.9s",
        "Good structure",
        "4★",
      ],
      [
        "Mina",
        "mina@mail.com",
        "Perfect",
        "South Korea",
        "2025-10-28",
        "Approved",
        "Android",
        "192.168.3.4",
        "Chrome",
        "YouTube",
        "ko",
        "Pro",
        "1.2s",
        "Sleek look",
        "5★",
      ],
      [
        "Carlos",
        "carlos@mail.com",
        "Excelente!",
        "Mexico",
        "2025-10-27",
        "Approved",
        "Windows",
        "192.168.4.4",
        "Edge",
        "Instagram",
        "es",
        "Business",
        "1.6s",
        "Very polished",
        "5★",
      ],
      [
        "Amira",
        "amira@mail.com",
        "Good!",
        "UAE",
        "2025-10-26",
        "Pending",
        "iPhone",
        "192.168.5.2",
        "Safari",
        "LinkedIn",
        "ar",
        "Free",
        "2.7s",
        "Looks professional",
        "4★",
      ],
      [
        "Tomas",
        "tomas@mail.com",
        "Really good",
        "Poland",
        "2025-10-25",
        "Approved",
        "Android",
        "10.0.0.2",
        "Chrome",
        "Google",
        "pl",
        "Pro",
        "1.8s",
        "Fast navigation",
        "5★",
      ],
      [
        "Eva",
        "eva@mail.com",
        "Awesome work",
        "Austria",
        "2025-10-24",
        "Approved",
        "MacOS",
        "172.16.1.2",
        "Safari",
        "Twitter",
        "de",
        "Business",
        "1.1s",
        "Love design",
        "5★",
      ],
      [
        "Mehdi",
        "mehdi@mail.com",
        "So clean!",
        "Morocco",
        "2025-10-23",
        "Approved",
        "Windows",
        "192.168.10.10",
        "Edge",
        "Google",
        "fr",
        "Pro",
        "1.9s",
        "Simple and neat",
        "5★",
      ],
      [
        "Giulia",
        "giulia@mail.com",
        "Molto bello!",
        "Italy",
        "2025-10-22",
        "Approved",
        "iPad",
        "172.19.10.9",
        "Safari",
        "Instagram",
        "it",
        "Free",
        "2.5s",
        "Modern",
        "4★",
      ],
      [
        "Andrej",
        "andrej@mail.com",
        "Nice features",
        "Slovakia",
        "2025-10-21",
        "Pending",
        "Windows",
        "192.168.2.5",
        "Edge",
        "Reddit",
        "sk",
        "Free",
        "2.6s",
        "Nice details",
        "4★",
      ],
      [
        "Lea",
        "lea@mail.com",
        "Beautiful UI",
        "Croatia",
        "2025-10-20",
        "Approved",
        "MacOS",
        "10.1.1.9",
        "Firefox",
        "LinkedIn",
        "hr",
        "Pro",
        "1.3s",
        "Love simplicity",
        "5★",
      ],
    ];

    //submissions = [];
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
          (isLandscape(context)) ? "Submissions" : "Entries",
          style: TextStyle(
            color: (_selectedSectionIndex == 0)
                ? t.bgColor
                : t.secondaryTextColor,
          ),
        ),
      ),
      1: Text(
        (isLandscape(context)) ? 'Statistics' : 'Stats',
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
      3: Text(
        (isLandscape(context)) ? 'Integrations' : 'Apps',
        style: TextStyle(
          color: (_selectedSectionIndex == 3)
              ? t.bgColor
              : t.secondaryTextColor,
        ),
      ),
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 30),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: (_selectedSectionIndex == 0) ? 800 : 600,
                      ),
                      width: screenWidth,
                      child: getSection(screenWidth),
                    ),
                  ),
                ),
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
                    FTooltip(
                      tipBuilder: (context, controller) =>
                          const Text('Copy Form URL'),
                      child: IconButton(
                        onPressed: _copyLinkOnClick,
                        icon: Icon(
                          HugeIconsStroke.link02,
                          color: t.textColor,
                          size: 20,
                          weight: 30,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    FTooltip(
                      tipBuilder: (context, controller) =>
                          const Text('Settings'),
                      child: IconButton(
                        onPressed: _settingsFormOnClick,
                        icon: Icon(
                          HugeIconsStroke.settings01,
                          color: t.textColor,
                          size: 20,
                          weight: 30,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    FTooltip(
                      tipBuilder: (context, controller) =>
                          const Text('Enable or Disable Form'),
                      child: CollectionPopupMenu(
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

  _customizeFormLinkPreviewOnClick() {
    showSuccess("customize", context);
  }

  _makeFormTemplateOnClick() {
    showSuccess("make template", context);
  }

  _exportSubmissionsOnClick() {
    showSuccess("download", context);
  }

  getSection(double screenWidth) {
    if (_selectedSectionIndex == 0) {
      final Map<int, Widget> segments = {
        0: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape(context) ? 10 : 5,
            vertical: 5,
          ),
          child: Text(
            'All',
            style: TextStyle(
              color: (_selectedSubmissionsTypeIndex == 0)
                  ? t.bgColor
                  : t.secondaryTextColor,
            ),
          ),
        ),
        1: Text(
          'Sent',
          style: TextStyle(
            color: (_selectedSubmissionsTypeIndex == 1)
                ? t.bgColor
                : t.secondaryTextColor,
          ),
        ),
        2: Text(
          'Draft',
          style: TextStyle(
            color: (_selectedSubmissionsTypeIndex == 2)
                ? t.bgColor
                : t.secondaryTextColor,
          ),
        ),
      };
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (submissions.isNotEmpty)
            Row(
              children: [
                CupertinoSlidingSegmentedControl<int>(
                  groupValue: _selectedSubmissionsTypeIndex,
                  thumbColor: t.textColor,
                  backgroundColor: t.cardColor,
                  children: segments,
                  onValueChanged: (value) {
                    setState(() => _selectedSubmissionsTypeIndex = value!);
                  },
                ),
                Spacer(),
                isLandscape(context)
                    ? FButton.icon(
                        onPress: _exportSubmissionsOnClick,
                        style: FButtonStyle.ghost(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(FIcons.download),
                            SizedBox(width: 5),
                            Text(
                              "Download CSV",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: t.brightness == Brightness.light
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: t.textColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : IconButton(
                        onPressed: _exportSubmissionsOnClick,
                        icon: Icon(FIcons.download),
                      ),
              ],
            ),
          if (submissions.isNotEmpty) SizedBox(height: 5),
          SubmissionsTableWidget(t: t, data: submissions),
        ],
      );
    } else if (_selectedSectionIndex == 1) {
      if (submissions.isNotEmpty) {
        return SingleChildScrollView(
          child: Column(
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
              (isLandscape(context))
                  ? Row(
                      children: [
                        Expanded(
                          child: customInput(
                            t,
                            aiAnalyticsController,
                            "Eg. When do users submit the most?",
                            "",
                            context,
                          ),
                        ),
                        SizedBox(width: 5),
                        CustomButton(
                          text: "Analyse",
                          onPressed: () {},
                          isLoading: false,
                          t: t,
                          isFullRow: false,
                          backgroundColor: t.textColor,
                          icon: HugeIconsStroke.aiSearch02,
                          height: 48,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        customInput(
                          t,
                          aiAnalyticsController,
                          "Eg. When do users submit the most?",
                          "",
                          context,
                        ),
                        SizedBox(height: 5),
                        CustomButton(
                          text: "Analyse",
                          onPressed: () {},
                          isLoading: false,
                          t: t,
                          backgroundColor: t.textColor,
                          icon: HugeIconsStroke.aiSearch02,
                          height: 48,
                        ),
                      ],
                    ),
              SizedBox(height: 30),
            ],
          ),
        );
      } else {
        return Column(
          children: [
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  "No submissions yet.",
                  style: TextStyle(color: t.secondaryTextColor),
                ),
              ),
            ),
          ],
        );
      }
    } else if (_selectedSectionIndex == 2) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Row(
              children: [
                Icon(HugeIconsStroke.share01, color: t.textColor, size: 20),
                const SizedBox(width: 10),
                Text(
                  "Share Form Link",
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
              "Easily share this form with others using a public link.",
              style: TextStyle(color: t.secondaryTextColor),
            ),
            SizedBox(height: 30),
            (isLandscape(context))
                ? Row(
                    children: [
                      Expanded(
                        child: customInput(
                          t,
                          formUrlController,
                          "",
                          "",
                          context,
                          isEnabled: false,
                        ),
                      ),
                      SizedBox(width: 5),
                      CustomButton(
                        text: "Copy",
                        onPressed: _copyLinkOnClick,
                        isLoading: false,
                        t: t,
                        isFullRow: false,
                        backgroundColor: t.textColor,
                        icon: HugeIconsStroke.copyLink,
                        height: 48,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      customInput(
                        t,
                        formUrlController,
                        "",
                        "",
                        context,
                        isEnabled: false,
                      ),
                      SizedBox(height: 5),
                      CustomButton(
                        text: "Copy",
                        onPressed: _copyLinkOnClick,
                        isLoading: false,
                        t: t,
                        isFullRow: true,
                        backgroundColor: t.textColor,
                        icon: HugeIconsStroke.copyLink,
                        height: 48,
                      ),
                    ],
                  ),
            SizedBox(height: 50),
            linkPreviewWidget(),
            SizedBox(height: 50),
            Row(
              children: [
                Icon(HugeIconsStroke.connect, color: t.textColor, size: 20),
                const SizedBox(width: 10),
                Text(
                  "Embed Form (soon)",
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
              "Easily integrate this form into your website or app using the embed code below.",
              style: TextStyle(color: t.secondaryTextColor),
            ),
            SizedBox(height: 30),
            comingSoonImage(context, sizePercentage: 0.5),
            SizedBox(height: 50),
            makeTemplateWidget(),
            SizedBox(height: 30),
          ],
        ),
      );
    } else if (_selectedSectionIndex == 3) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Row(
              children: [
                Icon(HugeIconsStroke.grid, color: t.textColor, size: 20),
                SizedBox(width: 10),
                Text(
                  "Connect Integrations",
                  style: TextStyle(
                    color: t.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
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
        ),
      );
    } else {
      return SizedBox();
    }
  }

  linkPreviewWidget() {
    if (isLandscape(context)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(HugeIconsStroke.eye, color: t.textColor, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Link Preview",
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
                  "When someone shares your link, it will automatically generate a preview with your content’s title, image, and short description.",
                  style: TextStyle(color: t.secondaryTextColor),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Align(
            alignment: Alignment.center,
            child: CustomButton(
              text: "Customize",
              onPressed: _customizeFormLinkPreviewOnClick,
              isLoading: false,
              t: t,
              isFullRow: false,
              backgroundColor: t.textColor,
              icon: HugeIconsStroke.edit04,
              height: 48,
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(HugeIconsStroke.eye, color: t.textColor, size: 20),
              const SizedBox(width: 10),
              Text(
                "Link Preview",
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
            "When someone shares your link, it will automatically generate a preview with your content’s title, image, and short description.",
            style: TextStyle(color: t.secondaryTextColor),
          ),
          const SizedBox(height: 15),
          CustomButton(
            text: "Customize",
            onPressed: _customizeFormLinkPreviewOnClick,
            isLoading: false,
            t: t,
            isFullRow: true,
            backgroundColor: t.textColor,
            icon: HugeIconsStroke.copyLink,
            height: 48,
          ),
        ],
      );
    }
  }

  makeTemplateWidget() {
    if (isLandscape(context)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(HugeIconsStroke.globe02, color: t.textColor, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Make a Template",
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
                  "Turn your form into a reusable template that others can duplicate and customize for their own use.",
                  style: TextStyle(color: t.secondaryTextColor),
                  softWrap: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Align(
            alignment: Alignment.center,
            child: CustomButton(
              text: "Create Template",
              onPressed: _makeFormTemplateOnClick,
              isLoading: false,
              t: t,
              isFullRow: false,
              backgroundColor: t.textColor,
              height: 48,
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(HugeIconsStroke.globe02, color: t.textColor, size: 20),
              const SizedBox(width: 10),
              Text(
                "Make a Template",
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
            "Turn your form into a reusable template that others can duplicate and customize for their own use.",
            style: TextStyle(color: t.secondaryTextColor),
          ),
          const SizedBox(height: 15),
          CustomButton(
            text: "Create Template",
            onPressed: _makeFormTemplateOnClick,
            isLoading: false,
            t: t,
            isFullRow: true,
            backgroundColor: t.textColor,
            height: 48,
          ),
        ],
      );
    }
  }
}
