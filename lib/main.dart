import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:formbuilder/screens/auth/intro.dart';
import 'package:formbuilder/screens/home/appScreen.dart';
import 'package:formbuilder/screens/home/createForm.dart';
import 'package:formbuilder/services/provider.dart';
import 'package:formbuilder/services/sharedPreferencesService.dart';
import 'package:formbuilder/services/themeService.dart';
import 'package:formbuilder/services/tools.dart';
import 'package:formbuilder/widgets/dialogues.dart';
import 'package:formbuilder/widgets/menu.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:window_manager/window_manager.dart';

import 'backend/models/account/user.dart';
import 'backend/models/path.dart';

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

  // FIXED: Check kIsWeb before using Platform
  bool isSideBarOpen = kIsWeb
      ? true // Default for web
      : (Platform.isAndroid || Platform.isIOS)
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
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
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
      floatingActionButton: Obx(() {
        final provider = Get.find<Provider>();
        // Access .value directly inside Obx - this is what makes it reactive!
        final currentPath = provider.currentPath.lastOrNull ?? AppPath.home.data();

        final isInTemplates = currentPath == AppPath.templates.data();
        final isInHomeOrCollection = currentPath == AppPath.home.data() ||
            currentPath.type == PathType.collection;

        return (!isLandscape(context) && (isInHomeOrCollection))
            ? CollectionPopupMenu(
          iconSize: 25,
          iconColor: t.textColor,
          cardColor: t.cardColor,
          items: [
            PopupMenuItemData(
              onTap: () {
                navigateTo(
                    context,
                    CreatForm(t: t, type: FormType.form),
                    false,
                );
              },
              label: "Create new form",
              color: t.textColor,
              icon: Icons.description_outlined,
            ),
            PopupMenuItemData(
              onTap: () {
                showDialogNewFolder(context, t);
              },
              label: "Create new collection",
              color: t.textColor,
              icon: Icons.folder_outlined,
            ),
          ],
          customTrigger: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: null,
            backgroundColor: t.textColor,
            child: Icon(Icons.add_rounded, color: t.bgColor),
          ),
        )
        :(!isLandscape(context) && (isInTemplates))?
        FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: (){
            navigateTo(context, CreatForm(t: t, type: FormType.template), false);
          },
          backgroundColor: t.textColor,
          child: Icon(Icons.add_rounded, color: t.bgColor),
        )
            : const SizedBox.shrink();
      }),
      body: AppScreen(t: t),
    );
  }
}

// --------------------------------------------------------------------------
// SYSTEM UI STYLE WRAPPER
// --------------------------------------------------------------------------

class SystemUiStyleWrapper extends StatelessWidget {
  final Widget child;
  final theme t;
  final Color? customColor;

  const SystemUiStyleWrapper({
    super.key,
    required this.child,
    required this.t,
    this.customColor
  });

  @override
  Widget build(BuildContext context) {
    final isDark = t.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? FThemes.zinc.dark.colors.background
        : FThemes.zinc.light.colors.background;

    // Force it on every frame (not ideal but works on stubborn Samsung)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarContrastEnforced: false,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Container(
        color: customColor ?? backgroundColor,
        child: SafeArea(child: child),
      ),
    );
  }
}
