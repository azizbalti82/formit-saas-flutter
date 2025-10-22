// ignore_for_file: file_names

import 'dart:async';
import 'dart:ui';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:formbuilder/screens/appScreen.dart';

import '../../main.dart';
import '../../services/provider.dart';
import '../../services/secureSharedPreferencesService.dart';
import '../../services/sharedPreferencesService.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/form.dart';
import '../../widgets/messages.dart';
import 'package:blurrycontainer/blurrycontainer.dart';


class OpenVaultScreen extends StatefulWidget {
  OpenVaultScreen({super.key, required this.t});
  final theme t;
  @override
  State<OpenVaultScreen> createState() => _State();
}

class _State extends State<OpenVaultScreen> {
  final Provider provider = Get.find<Provider>();
  late theme t;
  bool showKey = true;
  TextEditingController keyController = TextEditingController();
  String _previousText = ""; // Track previous text content

  void initializeController() {
    keyController.addListener(() {
      String currentText = keyController.text;

      // Check if text was pasted (significant length increase)
      if (currentText.length > _previousText.length + 1) {
        print("Text was pasted");
        setState(() {
          showKey = false;
        });
      }

      // Update the previous text
      _previousText = currentText;
    });
  }

// Don't forget to dispose the controller
  void disposeController() {
    keyController.dispose();
  }

  @override
  void initState() {
    super.initState();
    t = widget.t;
    initializeController();
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
              return simpleAppBar(context, text: "open vault",t:t);
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
                            "Enter vault's Key",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          // Description
                          Text(
                            'If you lost your key, try contacting another vault member.\nThey can add you back as a member so you can access the vault again.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 40),

                          customWordInput(t,keyController,"Enter vault's Key","",context,showKey,t),

                          SizedBox(height: 32),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButtonOutline(isLoading: false,icon: showKey? HugeIconsStroke.viewOffSlash: HugeIconsStroke.view, height:50,isFullRow:false,borderSize:0.6,backgroundColor: t.secondaryTextColor,text: showKey?'Hide Key':'Show Key', t: t,onPressed: (){
                                setState(() {
                                  showKey = !showKey;
                                });
                              }),
                              SizedBox(width: 10,),
                              CustomButton(isLoading: false,icon: HugeIconsStroke.linkSquare01, isFullRow:false, t: t,onPressed: () async {
                                /// check if the key exist

                                /// save key and open vault
                                await SecureStorageService().saveCurrentKey(keyController.text.trim());
                                Navigator.pop(context);
                                navigateTo(context,AppScreen(t: getTheme()), true);
                                }, text: 'Open Vault',)
                            ],
                          ),
                          SizedBox(height: 30),
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

  void runEvery3Seconds(void Function() action) {
    Timer.periodic(const Duration(seconds: 3), (timer) => action());
  }

  Widget keyElement({required String text, required bool isShown}) {
    if(!isShown){
      return IntrinsicWidth(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                text,
                style: TextStyle(
                  color: t.textColor,
                  fontSize: 16,
                ),
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

    }else{
      return Text(text+'   ',style:TextStyle(color: t.textColor,fontSize: 16),);
    }
  }
}

