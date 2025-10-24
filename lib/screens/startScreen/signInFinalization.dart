// ignore_for_file: file_names

import 'dart:async';
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

import '../../main.dart';
import '../../services/provider.dart';
import '../../services/secureSharedPreferencesService.dart';
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
  final Provider provider = Get.find<Provider>();
  late theme t;
  bool showKey = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool isSignInLoading = false;
  Uint8List? imageBytes;



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
              return simpleAppBar(context, text: "create new account - Finalization",t:t);
            },
          ),
        )
            : null,
        body: isLandscape(context)
            ? Center(
            child: Container(
              width: screenWidth*0.5,
              height: screenHeight*0.7,
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
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Title
                              Text(
                                'We are almost done',
                                style: TextStyle(
                                  color: t.textColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 40),
                              InkWell(
                                onTap: ()async{
                                  var image = (await pickImage());
                                  if (image == null) return;
                                  setState(() {
                                    imageBytes = image;
                                  });
                                },
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
                                      ),
                                    ),
                                    (imageBytes==null)?
                                    Icon(Icons.add_rounded,size: 50,color: t.textColor.withOpacity(0.3))
                                        : ClipOval(
                                      child: Image.memory(
                                        imageBytes!,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover, // fills and crops nicely
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              customInput(t,firstNameController,"First name","",context,maxLines: 1),
                              SizedBox(height: 16),
                              customInput(t,lastNameController,"Last name","",context,maxLines: 4),
                              SizedBox(height: 32),
                              CustomButton( text: 'Create account',isLoading: isSignInLoading, t: t,onPressed: () async {
                                    String firstName = firstNameController.text;
                                    String lastName = lastNameController.text;

                                    if(firstName.isEmpty){
                                      showError("First name is required", context);
                                      return;
                                    }
                                    if(lastName.isEmpty){
                                      showError("Last name is required", context);
                                      return;
                                    }

                                    setState(() {
                                      isSignInLoading = true;
                                    });
                                    try {
                                      /// try to login
                                      bool signInSuccess = true;
                                      await Future.delayed(const Duration(seconds: 2)); //simulate a logout api call
                                      if (signInSuccess) {
                                        //account created successfully!
                                        //await SecureStorageService().saveCurrentKey(widget.currentKey);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        navigateTo(context, AppScreen(t: getTheme()),true);
                                      } else {
                                        //show message for incorrect login email or password
                                        showError(
                                          "Error while creating account",
                                          context,
                                        );
                                      }
                                    } catch (e) {
                                      showError(e.toString(), context);
                                    } finally {
                                      setState(() {
                                        isSignInLoading = false;
                                      });
                                    }
                                  })
                            ],
                          ),
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
}

