// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formbuilder/screens/appScreen.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../main.dart';
import '../../services/provider.dart';
import '../../services/secureSharedPreferencesService.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/form.dart';


class NewPassword extends StatefulWidget {
  NewPassword({super.key, required this.t, required this.email});
  final theme t;
  final String email;
  @override
  State<NewPassword> createState() => _State();
}

class _State extends State<NewPassword> {
  final Provider provider = Get.find<Provider>();
  late theme t;
  bool showKey = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool isSignInLoading = false;
  Uint8List? imageBytes;
  bool getCodeLoading = false;
  bool verifyCodeLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String latestEmail = "";
  bool updatePasswordLoading = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();



  @override
  void initState() {
    super.initState();
    // Start with the provided theme (fallback to dark if needed)
    t = widget.t;
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
              return simpleAppBar(context, text: "Reset password",t:t);
            },
          ),
        )
            : null,
        body: isLandscape(context)
            ? Center(
            child: Container(
              width: screenWidth*0.5,
              height: screenHeight*0.4,
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
              child: ClipRRect( // Use ClipRRect instead of clipBehavior
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
                          filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
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
                      child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              landscape(t)
                            ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
            : const Center(child: Text("Welcome")),
      ),
    );
  }

  portrait(theme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        customInput(
          theme,
          passwordController,
          "Enter new password",
          '',
          context,
          isPassword: true,
        ),
        const SizedBox(height: 30),
        CustomButton(
          text: "Change password",
          onPressed: () async {
            //prevent clicking while verifying
            if (!updatePasswordLoading) {
              try {
                String password = passwordController.text;
                if (password.length < 8 ||
                    !RegExp(r'\d').hasMatch(password)) {
                  showError(
                    'Password must be at least 8 characters and include numbers.',
                    context,
                  );
                } else {
                  setState(() {
                    updatePasswordLoading = true;
                  });

                  bool isPasswordUpdated = true;//await userService.updatePassword(widget.email, password);
                  if (isPasswordUpdated) {
                    showSuccess(
                      "Password updated successfully",
                      context,
                    );
                    //go to the login page
                    Navigator.pop(context);
                  } else {
                    showError(
                      "Could not update password",
                      context,
                    );
                  }
                }
              } catch (e) {
                log('error while updating password');
                showError(
                  'Error while updating password',
                  context,
                );
              } finally {
                setState(() {
                  updatePasswordLoading = false;
                });
              }
            }
          },
          isLoading: updatePasswordLoading, t: theme,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
  landscape(theme theme) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600), // Increased from 100 to 600
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: portrait(theme),
      ),
    );
  }
}

