// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../services/provider.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/form.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key, required this.t, required this.email});
  final theme t;
  final String email;

  @override
  State<NewPassword> createState() => _State();
}

class _State extends State<NewPassword> {
  // --------------------------------------------------------------------------
  // STATE VARIABLES
  // --------------------------------------------------------------------------
  late theme t;
  bool updatePasswordLoading = false;

  // --------------------------------------------------------------------------
  // CONTROLLERS
  // --------------------------------------------------------------------------
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
        appBar: isLandscape(context) ? _buildAppBar() : null,
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
        height: screenHeight * 0.5,
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

  // OPTIMIZED: Simple gradient without BackdropFilter
  Widget _buildOptimizedGradientBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.0, -0.8),
            radius: 1.2,
            colors: [
              const Color(0xFF8B5CF6).withOpacity(0.3),
              const Color(0xFFA855F7).withOpacity(0.2),
              const Color(0xFF9333EA).withOpacity(0.1),
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
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPasswordInputs(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
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
    return Stack(
      children: [
        _buildOptimizedGradientBackground(),
        _buildMainContent(),
        _buildCancelButton(),
      ],
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
            text: "Reset password",
            t: t,
          );
        },
      ),
    );
  }

  Widget _buildPasswordInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Create new password",
          style: TextStyle(
            color: t.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your new password must be different from previously used passwords",
          style: TextStyle(
            color: t.secondaryTextColor.withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
        customInput(
          t,
          passwordController,
          "Enter new password",
          '',
          context,
          isPassword: true,
          maxLines: 1,
        ),
        const SizedBox(height: 16),
        customInput(
          t,
          confirmPasswordController,
          "Confirm new password",
          '',
          context,
          isPassword: true,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      isLoading: updatePasswordLoading,
      t: t,
      onPressed: _handleChangePassword,
      text: 'Change password',
    );
  }

  Widget _buildCancelButton() {
    return Positioned(
      top: 20,
      left: 20,
      child: Align(
        alignment: Alignment.topLeft,
        child: buildCancelIconButton(t, context),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // ACTION HANDLERS
  // --------------------------------------------------------------------------
  Future<void> _handleChangePassword() async {
    if (updatePasswordLoading) return;

    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (!_validatePasswords(password, confirmPassword)) {
      return;
    }

    setState(() {
      updatePasswordLoading = true;
    });

    try {
      await _performPasswordUpdate(password);
    } catch (e) {
      log('Error while updating password: $e');
      if (mounted) {
        showError('Error while updating password', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          updatePasswordLoading = false;
        });
      }
    }
  }

  bool _validatePasswords(String password, String confirmPassword) {
    if (password.isEmpty) {
      showError('Please enter a password', context);
      return false;
    }

    if (password.length < 8) {
      showError(
        'Password must be at least 8 characters',
        context,
      );
      return false;
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      showError(
        'Password must include at least one number',
        context,
      );
      return false;
    }

    if (password != confirmPassword) {
      showError(
        'Passwords do not match',
        context,
      );
      return false;
    }

    return true;
  }

  Future<void> _performPasswordUpdate(String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    bool isPasswordUpdated = true; // await userService.updatePassword(widget.email, password);

    if (mounted) {
      if (isPasswordUpdated) {
        showSuccess(
          "Password updated successfully",
          context,
        );
        // Go back to login page
        Navigator.pop(context);
      } else {
        showError(
          "Could not update password",
          context,
        );
      }
    }
  }
}