// ignore_for_file: file_names

import 'dart:async';
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formbuilder/screens/appScreen.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../services/provider.dart';
import '../../services/secureSharedPreferencesService.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/form.dart';
import 'verifyEmail.dart';

class Login extends StatefulWidget {
  Login({super.key, required this.t, required this.isLogin});
  final theme t;
  final bool isLogin;
  @override
  State<Login> createState() => _State();
}

class _State extends State<Login> {
  final Provider provider = Get.find<Provider>();
  late theme t;
  bool showKey = true;
  late bool isLogin;
  TextEditingController keyController = TextEditingController();

  bool isLoginLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void disposeController() {
    keyController.dispose();
  }

  @override
  void initState() {
    super.initState();
    t = widget.t;
    isLogin = widget.isLogin;
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(t, context);
  }

  Widget _buildScaffold(theme currentTheme, BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return SystemUiStyleWrapper(
      t: currentTheme,
      child: Scaffold(
        backgroundColor: currentTheme.bgColor,
        // AppBar
        appBar: isLandscape(context)
            ? AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                elevation: 0,
                scrolledUnderElevation: 0,
                title: LayoutBuilder(
                  builder: (context, constraints) {
                    return simpleAppBar(
                      context,
                      text: isLogin ? "Log in" : "Create new account",
                      t: t,
                    );
                  },
                ),
              )
            : null,
        body: isLandscape(context)
            ? Center(
                child: Container(
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.7,
                  constraints: BoxConstraints(
                    maxWidth: 500, // maximum width in pixels
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1,
                      color: Colors.white.withOpacity(0.1), // Add border color
                    ),
                  ),
                  child: ClipRRect(
                    // Use ClipRRect instead of clipBehavior
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -150,
                          left: -50,
                          right: -50,
                          child: Container(
                            height: 500,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0xFF8B5CF6).withOpacity(0.6),
                                  Color(0xFFA855F7).withOpacity(0.4),
                                  Color(0xFF9333EA).withOpacity(0.2),
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.3, 0.6, 1.0],
                              ),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 120,
                                sigmaY: 120,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Main content
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/logo/logo.svg",
                                    width:
                                        MediaQuery.of(context).size.height *
                                        0.1,
                                  ),

                                  SizedBox(height: 32),
                                  CustomButtonOutline(
                                    text: "Continue with Google",
                                    iconSvg: "google",
                                    t: t,
                                    onPressed: () async {},
                                    isLoading: false,
                                    height: 45,
                                  ),
                                  SizedBox(height: 32),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            "Or continue with email",
                                            style: TextStyle(
                                              color: t.secondaryTextColor
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  customInput(
                                    t,
                                    emailController,
                                    "Enter your email",
                                    "",
                                    context,
                                    isEmail: true,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 12),
                                  customInput(
                                    t,
                                    passwordController,
                                    "Enter your password",
                                    "",
                                    context,
                                    isPassword: true,
                                    maxLines: 1,
                                  ),
                                  if (isLogin) SizedBox(height: 8),
                                  if (isLogin)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            navigateTo(
                                              context,
                                              VerifyEmail(
                                                t: t,
                                                type: verifyEmailType.resetPassword,
                                                email: emailController.text,
                                              ),
                                              false
                                            );
                                          },
                                          child: const Text('Forgot password?'),
                                        ),
                                      ],
                                    ),

                                  SizedBox(height: 32),

                                  CustomButton(
                                    isLoading: isLoginLoading,
                                    t: t,
                                    onPressed: () async {
                                      String email = emailController.text;
                                      String password = passwordController.text;

                                      if (email.isEmpty) {
                                        showError(
                                          "Please enter your email",
                                          context,
                                        );
                                        return;
                                      }
                                      if (password.length < 8) {
                                        showError(
                                          "Password must be at least 8 characters",
                                          context,
                                        );
                                        return;
                                      }

                                      setState(() {
                                        isLoginLoading = true;
                                      });
                                      try {
                                        /// try to login
                                        bool loginSuccess = false;
                                        await Future.delayed(
                                          const Duration(seconds: 2),
                                        ); //simulate a logout api call
                                        if (loginSuccess) {
                                          //if its login or sign in and the account logged in: open app!
                                          await SecureStorageService()
                                              .saveCurrentKey(
                                                keyController.text.trim(),
                                              );
                                          Navigator.pop(context);
                                          navigateTo(
                                            context,
                                            AppScreen(t: getTheme()),
                                            true,
                                          );
                                        } else if (isLogin) {
                                          //show message for incorrect login email or password
                                          showError(
                                            "Incorrect login email or password",
                                            context,
                                          );
                                        } else {
                                          //its sign in screen so lets continue account creation
                                          navigateTo(
                                              context,
                                              VerifyEmail(
                                                t: t,
                                                type: verifyEmailType.createAccount,
                                                email: emailController.text,
                                              ),
                                              false
                                          );
                                        }
                                      } catch (e) {
                                        showError(e.toString(), context);
                                      } finally {
                                        setState(() {
                                          isLoginLoading = false;
                                        });
                                      }
                                    },
                                    text: isLogin ? 'Log in' : "Continue",
                                  ),

                                  if (!isLogin) const SizedBox(height: 30),
                                  if (!isLogin)
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "By registering you agree to",
                                            style: TextStyle(
                                              color: t.secondaryTextColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await EasyLauncher.url(
                                                url:
                                                    "https://azizbalti.netlify.app",
                                              );
                                            },
                                            child: Text(
                                              "Privacy Policy",
                                              style: TextStyle(
                                                color: t.accentColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (!isLogin) const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(child: Text("Welcome")),
      ),
    );
  }

  void runEvery3Seconds(void Function() action) {
    Timer.periodic(const Duration(seconds: 3), (timer) => action());
  }

  Widget keyElement({required String text, required bool isShown}) {
    if (!isShown) {
      return IntrinsicWidth(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                text,
                style: TextStyle(color: t.textColor, fontSize: 16),
              ),
            ),
            BlurryContainer(
              blur: 4,
              height: 40,
              elevation: 0,
              color: t.cardColor.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: const SizedBox.expand(), // no extra space
            ),
          ],
        ),
      );
    } else {
      return Text(
        text + '   ',
        style: TextStyle(color: t.textColor, fontSize: 16),
      );
    }
  }
}
