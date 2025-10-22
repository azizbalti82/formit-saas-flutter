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
import 'package:formbuilder/screens/startScreen/newVaultFinalizationScreen.dart';

import '../../main.dart';
import '../../services/provider.dart';
import '../../services/sharedPreferencesService.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/form.dart';
import '../../widgets/messages.dart';
import 'package:blurrycontainer/blurrycontainer.dart';


class NewVaultScreen extends StatefulWidget {
  NewVaultScreen({super.key, required this.t});
  final theme t;
  @override
  State<NewVaultScreen> createState() => _State();
}

class _State extends State<NewVaultScreen> {
  final Provider provider = Get.find<Provider>();
  late theme t;
  bool showKey = false;
  final List<String> keyWords = [
    'buffalo', 'divert', 'style', 'lion', 'fall', 'divorce',
    'ready', 'predict', 'stadium', 'raise', 'already', 'hobby'
  ];

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
              return simpleAppBar(context, text: "create new vault",t:t);
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
                            'This is your Key',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          // Description
                          Text(
                            'This key works like your password. Keep it safe,\nbecause it’s the only way to unlock your files.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Read more link
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Read more',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          SizedBox(height: 40),

                          Container(
                            width: screenWidth * 0.85,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: t.cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Wrap(
                                      alignment:WrapAlignment.center,
                                      children: keyWords.map(
                                              (k)=> keyElement(text:k,isShown: showKey)
                                    ).toList(),
                                    )),
                                    SizedBox(width: 20,),
                                    if(showKey)
                                    Container(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: keyWords.join(" ")));
                                            showSuccess("Key copied to clipboard", context);
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            color: Colors.grey[400],
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          ),

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
                              CustomButton(isLoading: false,isFullRow:false, t: t,onPressed: (){
                                navigateTo(context, NewVaultFinalizationScreen(t: t,currentKey: keyWords.join(" "),),false);
                              }, text: 'Continue',)
                            ],
                          )
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

