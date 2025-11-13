// ignore_for_file: file_names
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:formbuilder/screens/auth/newPassword.dart';
import 'package:formbuilder/screens/auth/signInFinalization.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:get/get.dart';
import 'package:pin_code/pin_code.dart';

import '../../main.dart';
import '../../services/provider.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/form.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({
    super.key,
    required this.t,
    required this.type,
    required this.email,
  });
  final verifyEmailType type;
  final theme t;
  final String email;

  @override
  State<VerifyEmail> createState() => _State();
}

class _State extends State<VerifyEmail> {
  // --------------------------------------------------------------------------
  // STATE VARIABLES
  // --------------------------------------------------------------------------
  late theme t;
  bool getCodeLoading = false;
  bool verifyCodeLoading = false;
  String latestEmail = "";

  // --------------------------------------------------------------------------
  // CONTROLLERS
  // --------------------------------------------------------------------------
  late TextEditingController emailController;
  TextEditingController codeController = TextEditingController();

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
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // BUILD METHOD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SystemUiStyleWrapper(
      t: t,
      child: Scaffold(
        backgroundColor: t.bgColor,
        appBar: isLandscape(context) ? _buildAppBar() : null,
        body: _buildBody(),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // BODY BUILDERS
  // --------------------------------------------------------------------------
  Widget _buildBody() {
    if (isLandscape(context)) {
      return _buildLandscapeBody();
    } else {
      return _buildPortraitBody();
    }
  }

  Widget _buildLandscapeBody() {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: screenSize.width * 0.5,
        height: screenSize.height * 0.7,
        constraints: const BoxConstraints(maxWidth: 500),
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
              _buildOptimizedGradientBackground(),
              _buildMainContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitBody() {
    return Stack(
      children: [
        _buildOptimizedGradientBackground(),
        _buildMainContent(),
        _buildCancelButton(),
      ],
    );
  }

  // OPTIMIZED: Removed BackdropFilter, using simple gradient
  Widget _buildOptimizedGradientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.0, -0.5),
            radius: 1.5,
            colors: [
              const Color(0xFF8B5CF6).withOpacity(0.25),
              const Color(0xFFA855F7).withOpacity(0.15),
              const Color(0xFF9333EA).withOpacity(0.08),
              Colors.transparent,
            ],
            stops: const [0.0, 0.3, 0.6, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isLandscape(context)) ...[
                const SizedBox(height: 60),
              ],
              _buildEmailInputSection(),
              const SizedBox(height: 40),
              _buildCodeInputSection(),
              const SizedBox(height: 40),
              _buildVerifyButton(),
              if (!isLandscape(context)) ...[
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
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
      title: simpleAppBar(context, text: "Verify Email", t: t),
    );
  }

  Widget _buildEmailInputSection() {
    return isLandscape(context)
        ? IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: customInput(
              t,
              emailController,
              "Enter your email",
              '',
              context,
            ),
          ),
          const SizedBox(width: 10),
          IntrinsicWidth(
            child: CustomButton(
              text: "Get Code",
              onPressed: _handleGetCode,
              isLoading: getCodeLoading,
              t: t,
            ),
          ),
        ],
      ),
    )
        : ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: t.bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: customInput(
                  t,
                  emailController,
                  "Enter your email",
                  '',
                  context,
                  backgroundColor: t.bgColor,
                  haveBorder: false,
                ),
              ),
              const SizedBox(height: 5),
              IntrinsicWidth(
                child: CustomButton(
                  height: 40,
                  text: "Get Code",
                  onPressed: _handleGetCode,
                  isLoading: getCodeLoading,
                  t: t,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter the code sent to your email",
          style: TextStyle(
            color: t.textColor,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: 300,
            child: _buildPinCodeField(),
          ),
        ),
      ],
    );
  }

  Widget _buildPinCodeField() {
    return PinCode(
      appContext: context,
      length: 6,
      textStyle: TextStyle(color: t.textColor),
      pinTheme: PinCodeTheme(
        borderRadius: BorderRadius.circular(10),
        shape: PinCodeFieldShape.box,
        activeColor: t.secondaryTextColor.withOpacity(1),
        inactiveColor: t.secondaryTextColor.withOpacity(0.3),
        selectedColor: t.accentColor,
      ),
      onChanged: (value) {
        codeController.text = value;
      },
      onCompleted: (value) {
        codeController.text = value;
        // Optionally auto-verify
        // _handleVerifyCode();
      },
    );
  }

  Widget _buildVerifyButton() {
    return Center(
      child: CustomButtonOutline(
        text: verifyCodeLoading ? 'Verifying' : 'Verify Code',
        backgroundColor: t.accentColor.withOpacity(0.8),
        isLoading: verifyCodeLoading,
        onPressed: _handleVerifyCode,
        t: t,
      ),
    );
  }

  Widget _buildCancelButton() {
    return Positioned(
      top: 40,
      left: 20,
      child: buildCancelIconButton(t, context),
    );
  }

  // --------------------------------------------------------------------------
  // ACTION HANDLERS
  // --------------------------------------------------------------------------
  Future<void> _handleGetCode() async {
    if (getCodeLoading) return;

    try {
      String email = emailController.text;
      if (!_validateEmail(email)) {
        return;
      }

      setState(() {
        getCodeLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      bool isExist = false; // await userService.isExistByMail(email);

      if (!isExist) {
        if (mounted) {
          showMsg(
            "If the email exists, you will receive an OTP code shortly",
            context,
            t,
          );
        }
        return;
      }

      // Send email - replace with actual API call
      final error = null; // await OTPService.sendOtp(emailController.text);
      if (mounted) {
        if (error == null) {
          showMsg(
            "If the email exists, you will receive an OTP code shortly",
            context,
            t,
          );
          latestEmail = email;
          // Clear fields for better UX
          emailController.text = '';
          codeController.text = '';
        } else {
          showError("Error while sending code, please try later", context);
        }
      }
    } catch (e) {
      log('Error while getting code: $e');
      if (mounted) {
        showError('Error while sending code', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          getCodeLoading = false;
        });
      }
    }
  }

  Future<void> _handleVerifyCode() async {
    if (verifyCodeLoading) return;

    try {
      String code = codeController.text;
      if (!_validateCode(code)) {
        return;
      }

      setState(() {
        verifyCodeLoading = true;
      });

      // For testing - remove this in production
      if (code.length == 6) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          _onVerified();
        }
        return;
      }

      // Actual verification - uncomment in production
      /*
      String? error = await OTPService.verifyOtp(latestEmail, code);
      if (mounted) {
        if (error == null) {
          _onVerified();
        } else {
          showError('Wrong code, try again', context);
          codeController.text = "";
        }
      }
      */
    } catch (e) {
      log('Error while verifying code: $e');
      if (mounted) {
        showError('Error while verifying code', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          verifyCodeLoading = false;
        });
      }
    }
  }

  // --------------------------------------------------------------------------
  // VALIDATION METHODS
  // --------------------------------------------------------------------------
  bool _validateEmail(String email) {
    if (email.isEmpty ||
        !RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showError('Invalid email', context);
      return false;
    }
    return true;
  }

  bool _validateCode(String code) {
    //just for testing
    _onVerified();
    /////////////////

    if (code.length != 6) {
      showError("Please enter the 6-digit code", context);
      return false;
    }
    if (latestEmail.isEmpty) {
      showError("Please click on send code first", context);
      return false;
    }
    return true;
  }

  // --------------------------------------------------------------------------
  // NAVIGATION HANDLERS
  // --------------------------------------------------------------------------
  void _onVerified() {
    if (!mounted) return;

    switch (widget.type) {
      case verifyEmailType.resetPassword:
      case verifyEmailType.updatePassword:
        navigate(
          context,
          NewPassword(email: latestEmail, t: t),
          isReplace: true,
        );
        break;
      case verifyEmailType.createAccount:
        navigate(
          context,
          SignInFinalization(t: t),
          isReplace: true,
        );
        break;
      case verifyEmailType.updateEmail:
        Navigator.pop(context, true);
        break;
    }
  }
}

enum verifyEmailType {
  resetPassword,
  createAccount,
  updatePassword,
  updateEmail,
}