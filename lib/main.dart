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
    // Must be added to run app.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      //size: Size(850, 600),
      // Initial window size
      //minimumSize: Size(850, 500),
      backgroundColor: Colors.transparent,
      // Minimum window size
      center: true,
      // Center the window
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
  //update values
  bool isDark = await SharedPrefService.getIsDark();
  bool isSideBarOpen = await SharedPrefService.getIsSideBarOpen();
  String lang = await SharedPrefService.getLanguage();
  User user = await SharedPrefService.getUser();
  bool isGrid = await SharedPrefService.getIsGrid();

  final Provider provider = Get.find<Provider>();
  provider.setIsDark(isDark);
  provider.setIsSideBarOpen(isSideBarOpen);
  provider.setLanguage(lang);
  provider.setUser(user);
  provider.setIsGrid(isGrid);

  //check if there is a logged in key (currentKey)
  bool logged = true;//await SecureStorageService().getCurrentKey() != null;

  runApp(ToastificationWrapper( child: Main(isLogged : logged)));
}


// main screen -----------------------------------------------------------------
class Main extends StatefulWidget {
  const Main({super.key, required this.isLogged});
  final bool isLogged;
  @override
  State<Main> createState() => _MainState();
}
class _MainState extends State<Main>{
  final Provider provider = Get.find<Provider>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      theme t = getTheme();
      if(!isLandscape(context)){
        provider.setIsGrid(false);
      }else{
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

      home: (widget.isLogged)? Scaffold(
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
              icon: Icons.description_outlined, // or your preferred icon
            ),
            PopupMenuItemData(
              onTap: () {
                print("Create new collection");
                // Add your create folder logic here
              },
              label: "Create new collection",
              color: t.textColor,
              icon: Icons.folder_outlined, // or your preferred icon
            ),
          ],
          customTrigger: FloatingActionButton(
            shape: CircleBorder(),
            onPressed: null, // Set to null, the menu handles the tap
            backgroundColor: t.textColor,
            child: Icon(Icons.add_rounded, color: t.bgColor),
          ),
        )
            : null,
        body: AppScreen(t: t,),
      ): StartScreen(canBack:false,)
    );});
  }
}

class SystemUiStyleWrapper extends StatelessWidget {
  final Widget child;
  final Color? statusBarColor;
  final Color? navBarColor;
  final theme t;

  const SystemUiStyleWrapper({
    super.key,
    required this.child,
    this.statusBarColor,
    this.navBarColor, required this.t,
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
        systemNavigationBarColor: navBarColor ?? (t.brightness == Brightness.light
            ? FThemes.zinc.light.colors.background
            : FThemes.zinc.dark.colors.background),
        systemNavigationBarIconBrightness: t.brightness,
      ),
      child: SafeArea(child: child),
    );
  }
}
