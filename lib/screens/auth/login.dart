// ignore_for_file: file_names
import 'dart:async';
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formbuilder/screens/home/appScreen.dart';
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
  // --------------------------------------------------------------------------
  // STATE VARIABLES
  // --------------------------------------------------------------------------
  late theme t;
  bool showKey = true;
  late bool isLogin;
  bool isLoginLoading = false;

  // --------------------------------------------------------------------------
  // CONTROLLERS
  // --------------------------------------------------------------------------
  TextEditingController keyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
    isLogin = widget.isLogin;
  }

  void disposeController() {
    keyController.dispose();
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
        appBar: isLandscape(context)?_buildAppBar():null,
        body: isLandscape(context)
            ? _buildLandscapeBody(screenWidth, screenHeight)
            : _buildPortraitBody(),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // LANDSCAPE BODY
  // --------------------------------------------------------------------------
  Widget _buildLandscapeBody(double screenWidth, double screenHeight) {
    return Center(
      child: Container(
        width: screenWidth * 0.5,
        height: screenHeight * 0.7,
        constraints: BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1,
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              _buildGradientBackground(),
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildGradientBackground() {
    return Positioned(
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
          filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildMainContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              SizedBox(height: 32),
              _buildGoogleButton(),
              SizedBox(height: 32),
              _buildDivider(),
              SizedBox(height: 20),
              _buildEmailInput(),
              SizedBox(height: 12),
              _buildPasswordInput(),
              if (isLogin) ...[
                SizedBox(height: 8),
                _buildForgotPasswordButton(),
              ],
              SizedBox(height: 32),
              _buildSubmitButton(),
              if (!isLogin) ...[
                SizedBox(height: 30),
                _buildPrivacyPolicy(),
                SizedBox(height: 50),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // PORTRAIT BODY
  // --------------------------------------------------------------------------
  Widget _buildPortraitBody() {
    return Center(
      child: Stack(
            children: [
              _buildGradientBackground(),
              _buildMainContent(),
              _buildCancelButton()
            ],
          ),
    );
  }

  // --------------------------------------------------------------------------
  // UI COMPONENTS
  // --------------------------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
    );
  }
  Widget _buildLogo() {
    return SvgPicture.asset(
      "assets/logo/logo.svg",
      width: MediaQuery.of(context).size.height * 0.1,
    );
  }
  Widget _buildGoogleButton() {
    return CustomButtonOutline(
      text: "Continue with Google",
      iconSvg: "google",
      t: t,
      onPressed: () async {},
      isLoading: false,
      height: 45,
    );
  }
  Widget _buildDivider() {
    return Align(
      alignment: FractionalOffset.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Or continue with email",
              style: TextStyle(
                color: t.secondaryTextColor.withOpacity(0.7),
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildEmailInput() {
    return customInput(
      t,
      emailController,
      "Enter your email",
      "",
      context,
      isEmail: true,
      maxLines: 1,
    );
  }
  Widget _buildPasswordInput() {
    return customInput(
      t,
      passwordController,
      "Enter your password",
      "",
      context,
      isPassword: true,
      maxLines: 1,
    );
  }
  Widget _buildForgotPasswordButton() {
    return Row(
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
              false,
            );
          },
          child: const Text('Forgot password?'),
        ),
      ],
    );
  }
  Widget _buildSubmitButton() {
    return CustomButton(
      isLoading: isLoginLoading,
      t: t,
      onPressed: _handleSubmit,
      text: isLogin ? 'Log in' : "Continue",
    );
  }
  Widget _buildPrivacyPolicy() {
    return Align(
      alignment: FractionalOffset.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                url: "https://azizbalti.netlify.app",
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
    );
  }
  // --------------------------------------------------------------------------
  // ACTION HANDLERS
  // --------------------------------------------------------------------------
  Future<void> _handleSubmit() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (!_validateInputs(email, password)) {
      return;
    }

    setState(() {
      isLoginLoading = true;
    });

    try {
      await _performLogin(email, password);
    } catch (e) {
      showError(e.toString(), context);
    } finally {
      setState(() {
        isLoginLoading = false;
      });
    }
  }
  bool _validateInputs(String email, String password) {
    if (email.isEmpty) {
      showError("Please enter your email", context);
      return false;
    }
    if (password.length < 8) {
      showError("Password must be at least 8 characters", context);
      return false;
    }
    return true;
  }
  Future<void> _performLogin(String email, String password) async {
    bool loginSuccess = false;
    await Future.delayed(const Duration(seconds: 2));

    if (loginSuccess) {
      await SecureStorageService().saveCurrentKey(keyController.text.trim());
      Navigator.pop(context);
      navigateTo(context, AppScreen(t: getTheme()), true);
    } else if (isLogin) {
      showError("Incorrect login email or password", context);
    } else {
      navigateTo(
        context,
        VerifyEmail(
          t: t,
          type: verifyEmailType.createAccount,
          email: emailController.text,
        ),
        false,
      );
    }
  }

  _buildCancelButton() {
    return  Positioned(
      top: 20,
      left: 20,
      child: Align(
      alignment: AlignmentGeometry.topLeft,
      child: buildCancelIconButton(t,context)),
    );
  }
}