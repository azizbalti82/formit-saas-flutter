// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formbuilder/screens/home/appScreen.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../services/provider.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/form.dart';

class SignInFinalization extends StatefulWidget {
  const SignInFinalization({super.key, required this.t});
  final theme t;

  @override
  State<SignInFinalization> createState() => _State();
}

class _State extends State<SignInFinalization> {
  // --------------------------------------------------------------------------
  // STATE VARIABLES
  // --------------------------------------------------------------------------
  late theme t;
  bool isSignInLoading = false;
  Uint8List? imageBytes;

  // --------------------------------------------------------------------------
  // CONTROLLERS
  // --------------------------------------------------------------------------
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

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
    firstNameController.dispose();
    lastNameController.dispose();
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
        height: screenHeight * 0.7,
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
              _buildTitle(),
              const SizedBox(height: 40),
              _buildProfileImagePicker(),
              const SizedBox(height: 24),
              _buildNameInputs(),
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
            text: "Create account - Finalization",
            t: t,
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'We are almost done',
      style: TextStyle(
        color: t.textColor,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProfileImagePicker() {
    return InkWell(
      onTap: _handleImagePick,
      borderRadius: BorderRadius.circular(300),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: t.textColor.withOpacity(0.1),
              border: Border.all(
                width: 2,
                color: imageBytes != null
                    ? t.accentColor.withOpacity(0.5)
                    : Colors.transparent,
              ),
            ),
          ),
          if (imageBytes == null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  size: 40,
                  color: t.textColor.withOpacity(0.3),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add photo',
                  style: TextStyle(
                    color: t.textColor.withOpacity(0.3),
                    fontSize: 12,
                  ),
                ),
              ],
            )
          else
            ClipOval(
              child: Image.memory(
                imageBytes!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          if (imageBytes != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: t.accentColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNameInputs() {
    return Column(
      children: [
        customInput(
          t,
          firstNameController,
          "First name",
          "",
          context,
          maxLines: 1,
        ),
        const SizedBox(height: 16),
        customInput(
          t,
          lastNameController,
          "Last name",
          "",
          context,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: 'Create account',
      isLoading: isSignInLoading,
      t: t,
      onPressed: _handleCreateAccount,
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
  Future<void> _handleImagePick() async {
    try {
      var image = await pickImage();
      if (image == null) return;

      if (mounted) {
        setState(() {
          imageBytes = image;
        });
      }
    } catch (e) {
      if (mounted) {
        showError("Error while picking image", context);
      }
    }
  }

  Future<void> _handleCreateAccount() async {
    if (isSignInLoading) return;

    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();

    if (!_validateInputs(firstName, lastName)) {
      return;
    }

    setState(() {
      isSignInLoading = true;
    });

    try {
      await _performAccountCreation(firstName, lastName);
    } catch (e) {
      if (mounted) {
        showError(e.toString(), context);
      }
    } finally {
      if (mounted) {
        setState(() {
          isSignInLoading = false;
        });
      }
    }
  }

  bool _validateInputs(String firstName, String lastName) {
    if (firstName.isEmpty) {
      showError("First name is required", context);
      return false;
    }

    if (lastName.isEmpty) {
      showError("Last name is required", context);
      return false;
    }

    if (firstName.length < 2) {
      showError("First name must be at least 2 characters", context);
      return false;
    }

    if (lastName.length < 2) {
      showError("Last name must be at least 2 characters", context);
      return false;
    }

    return true;
  }

  Future<void> _performAccountCreation(String firstName, String lastName) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    bool signInSuccess = true; // Replace with actual API call

    if (mounted) {
      if (signInSuccess) {
        // Account created successfully
        // await SecureStorageService().saveCurrentKey(widget.currentKey);
        Navigator.pop(context);
        Navigator.pop(context);
        navigateTo(context, AppScreen(t: getTheme()), true);
      } else {
        showError(
          "Error while creating account",
          context,
        );
      }
    }
  }
}