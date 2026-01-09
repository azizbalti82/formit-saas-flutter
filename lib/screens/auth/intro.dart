// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../services/provider.dart';
import '../../services/themeService.dart';
import '../../services/tools.dart';
import '../../widgets/form.dart';
import 'login.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.canBack});
  final bool canBack;

  @override
  State<StartScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<StartScreen> {
  final Provider provider = Get.find<Provider>();
  late theme t;
  int selectedIntroPage = 0;
  Timer? _timer;
  List<Map<String, String>> introSlides = [
    {
      'title': 'Easy Form Creation',
      'text': 'Build forms quickly with just Drag and Drop.',
      'image': 'assets/vectors/easy.svg',
    },
    {
      'title': 'Realtime Updates',
      'text': 'View new submissions instantly as they happen.',
      'image': 'assets/vectors/secure.svg',
    },
    {
      'title': 'High Security',
      'text': 'All submissions are securely encrypted and protected.',
      'image': 'assets/vectors/encrypted.svg',
    },
    {
      'title': 'AI Form Design',
      'text': 'Generate form templates instantly with AI assistance.',
      'image': 'assets/vectors/ai.svg',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Start with the provided theme (fallback to dark if needed)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.setIsDark(true);
    });
    // Auto-advance the intro dots every 3s
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() {
        selectedIntroPage = selectedIntroPage == 3 ? 0 : selectedIntroPage + 1;
      });
    });
    t = darkTheme;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(darkTheme, context);
  }

  Widget _buildScaffold(theme currentTheme, BuildContext context) {
    return SystemUiStyleWrapper(
      customColor:t.brightness == Brightness.light
          ? Colors.white
          : t.bgColor ,
      t: currentTheme,
      child: Scaffold(
        backgroundColor: currentTheme.bgColor,
        body: isLandscape(context)
            ? Row(
                children: [
                  // Force children to layout with constraints inside Row
                  Expanded(child: introLeft(currentTheme)),
                  const SizedBox(width: 16),
                  Expanded(child: introRight()),
                ],
              )
            : introRight(),
      ),
    );
  }

  // LEFT PANE
  Widget introLeft(theme currentTheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // SVG Background
            SvgPicture.asset('assets/vectors/bg_auth2.svg', fit: BoxFit.cover),

            // Main Content
            Container(
              color: Colors.transparent,
              // Don't force width inside Row child
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    SvgPicture.asset(
                      introSlides[selectedIntroPage]["image"]!,
                      width: MediaQuery.of(context).size.height * 0.3,
                    ),
                    Spacer(),
                    Text(
                      introSlides[selectedIntroPage]["title"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: MediaQuery.of(context).size.height * 0.042,
                        color: t.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        introSlides[selectedIntroPage]["text"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          color: t.secondaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        circle(
                          isSelected: selectedIntroPage == 0,
                          currentTheme: currentTheme,
                        ),
                        const SizedBox(width: 8),
                        circle(
                          isSelected: selectedIntroPage == 1,
                          currentTheme: currentTheme,
                        ),
                        const SizedBox(width: 8),
                        circle(
                          isSelected: selectedIntroPage == 2,
                          currentTheme: currentTheme,
                        ),
                        const SizedBox(width: 8),
                        circle(
                          isSelected: selectedIntroPage == 3,
                          currentTheme: currentTheme,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget introRight() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main Content
        Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          // Don't force width inside Row child
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/logo/logo.svg",
                    width: MediaQuery.of(context).size.height * 0.15,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Build forms effortlessly",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                      color: t.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Design. Share. Collect responses, all in one place!",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                        color: t.secondaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 50),
                  (MediaQuery.of(context).size.width > 900)
                      ? Column(
                          children: [
                            IntrinsicWidth(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(child: signInButton()),
                                      SizedBox(width: 10),
                                      Expanded(child: loginButton()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              signInButton(),
                              SizedBox(height: 10),
                              loginButton(),
                            ],
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

  Widget circle({required bool isSelected, required theme currentTheme}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isSelected ? t.textColor : t.textColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
    );
  }

  void runEvery3Seconds(void Function() action) {
    Timer.periodic(const Duration(seconds: 3), (timer) => action());
  }

  signInButton() {
    return CustomButtonOutline(
      isLoading: false,
      height: 50,
      isFullRow: false,
      borderSize: 0.6,
      backgroundColor: t.secondaryTextColor,
      text: 'Create account',
      t: t,
      onPressed: () {
        navigateTo(context, Login(t: t, isLogin: false), false);
      },
    );
  }

  loginButton() {
    return CustomButton(
      isLoading: false,
      isFullRow: false,
      t: t,
      onPressed: () {
        navigateTo(context, Login(t: t, isLogin: true), false);
      },
      text: 'Log in',
    );
  }
}
