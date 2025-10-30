import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:formbuilder/screens/home/appScreen.dart';
import 'package:formbuilder/screens/auth/intro.dart';
import 'package:formbuilder/services/provider.dart';
import 'package:formbuilder/services/sharedPreferencesService.dart';
import 'package:formbuilder/services/themeService.dart';
import 'package:formbuilder/tools/tools.dart';
import 'package:formbuilder/widgets/dialogues.dart';
import 'package:formbuilder/widgets/menu.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';

import 'backend/models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(Provider());

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      backgroundColor: Colors.transparent,
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  if (!kIsWeb) {
    await dotenv.load(fileName: "assets/.env");
  }

  // Update values
  bool isDark = await SharedPrefService.getIsDark();
  bool isSideBarOpen = (Platform.isAndroid || Platform.isIOS)
      ? false
      : await SharedPrefService.getIsSideBarOpen();
  String lang = await SharedPrefService.getLanguage();
  User user = await SharedPrefService.getUser();
  bool isGrid = await SharedPrefService.getIsGrid();

  final Provider provider = Get.find<Provider>();
  provider.setIsDark(isDark);
  provider.setIsSideBarOpen(isSideBarOpen);
  provider.setLanguage(lang);
  provider.setUser(user);
  provider.setIsGrid(isGrid);

  // Check if there is a logged in key
  bool logged = true; // await SecureStorageService().getCurrentKey() != null;

  runApp(ToastificationWrapper(child: Main(isLogged: logged)));
}

// --------------------------------------------------------------------------
// MAIN APP
// --------------------------------------------------------------------------
class Main extends StatefulWidget {
  const Main({super.key, required this.isLogged});
  final bool isLogged;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final Provider provider = Get.find<Provider>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      theme t = getTheme();
      if (!isLandscape(context)) {
        provider.setIsGrid(false);
      } else {
        provider.setIsGridFuture(SharedPrefService.getIsGrid());
      }

      return MaterialApp(
        title: 'FormIt',
        debugShowCheckedModeBanner: false,
        builder: (context, child) => FTheme(
          data: t.brightness == Brightness.light
              ? FThemes.zinc.light
              : FThemes.zinc.dark,
          child: child!,
        ),
        theme: ThemeData(
          scaffoldBackgroundColor: t.bgColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: t.accentColor,
            background: t.bgColor,
            surface: t.bgColor,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: t.bgColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            enableFeedback: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: t.bgColor,
          ),
          useMaterial3: true,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: t.accentColor,
            selectionColor: t.accentColor.withOpacity(0.5),
            selectionHandleColor: t.accentColor,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        // FIXED: Wrap home in a Builder to get proper context
        home: widget.isLogged
            ? HomeWrapper(t: t)
            : const StartScreen(canBack: false),
      );
    });
  }
}

// --------------------------------------------------------------------------
// HOME WRAPPER - Provides proper Navigator context
// --------------------------------------------------------------------------
class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key, required this.t});
  final theme t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !isLandscape(context)
          ? CollectionPopupMenu(
        iconSize: 25,
        iconColor: t.textColor,
        cardColor: t.cardColor,
        items: [
          PopupMenuItemData(
            onTap: () {
              print("Create new form");
              // Add your create form logic here
            },
            label: "Create new form",
            color: t.textColor,
            icon: Icons.description_outlined,
          ),
          PopupMenuItemData(
            onTap: () {
              // Now context has access to Navigator
              showDialogNewFolder(context, t);
            },
            label: "Create new collection",
            color: t.textColor,
            icon: Icons.folder_outlined,
          ),
        ],
        customTrigger: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: null, // Menu handles the tap
          backgroundColor: t.textColor,
          child: Icon(Icons.add_rounded, color: t.bgColor),
        ),
      )
          : null,
      body: AppScreen(t: t),
    );
  }
}

// --------------------------------------------------------------------------
// SYSTEM UI STYLE WRAPPER
// --------------------------------------------------------------------------
class SystemUiStyleWrapper extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;
  final Color? navBarColor;
  final theme t;

  const SystemUiStyleWrapper({
    super.key,
    required this.child,
    this.statusBarColor,
    this.navBarColor,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: t.brightness == Brightness.light
            ? FThemes.zinc.light.colors.background
            : FThemes.zinc.dark.colors.background,
        statusBarIconBrightness: t.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: navBarColor ??
            (t.brightness == Brightness.light
                ? FThemes.zinc.light.colors.background
                : FThemes.zinc.dark.colors.background),
        systemNavigationBarIconBrightness: t.brightness,
      ),
      child: SafeArea(child: child),
    );
  }
}