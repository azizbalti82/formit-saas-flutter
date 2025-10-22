import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:formbuilder/screens/startScreen/startScreen.dart';
import 'package:formbuilder/services/provider.dart';
import 'package:formbuilder/screens/appScreen.dart';
import 'package:formbuilder/services/secureSharedPreferencesService.dart';
import 'package:formbuilder/services/sharedPreferencesService.dart';
import 'package:formbuilder/services/themeService.dart';
import 'package:formbuilder/tools/tools.dart';
import 'package:web_splash/web_splash.dart';
import 'package:window_manager/window_manager.dart';

import 'backend/models/userMeta.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(Provider());

  // Must be added to run app.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(850, 600),           // Initial window size
    minimumSize: Size(850, 500),    // Minimum window size
    center: true,                   // Center the window
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });


  if (!kIsWeb) {
    await dotenv.load(fileName: "assets/.env");
  }
  //update values
  bool isDark = await SharedPrefService.getIsDark();
  bool isSideBarOpen = await SharedPrefService.getIsSideBarOpen();
  bool autoSync = await SharedPrefService.getIsAutoSync();
  bool offline = await SharedPrefService.getIsOfflineMode();
  int downloadLimit = await SharedPrefService.getDownloadLimit();
  int uploadLimit = await SharedPrefService.getDownloadLimit();
  String uploadLimitUnit = await SharedPrefService.getUploadLimitUnit();
  String downloadLimitUnit = await SharedPrefService.getDownloadLimitUnit();

  String storageLocation = await SharedPrefService.getStorageLocation();
  String lang = await SharedPrefService.getLanguage();
  UserMeta user = await SharedPrefService.getUser();

  final Provider provider = Get.find<Provider>();
  provider.setIsDark(isDark);
  provider.setIsSideBarOpen(isSideBarOpen);
  provider.setAutoSync(autoSync);
  provider.setOfflineMode(offline);
  provider.setDownloadLimit(downloadLimit);
  provider.setUploadLimit(uploadLimit);
  provider.setStorageLocation(storageLocation);
  provider.setLanguage(lang);
  provider.setUser(user);
  provider.setDownloadLimitUnit(downloadLimitUnit);
  provider.setUploadLimitUnit(uploadLimitUnit);


  //check if there is a logged in key (currentKey)
  bool logged = await SecureStorageService().getCurrentKey() != null;

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
      home: (widget.isLogged)? AppScreen(t: t,) : StartScreen(canBack:false,),
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
        statusBarColor: statusBarColor ?? t.bgColor,
        statusBarIconBrightness: t.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: navBarColor ?? t.bgColor,
        systemNavigationBarIconBrightness: t.brightness,
      ),
      child: child,
    );
  }
}
