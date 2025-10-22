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
import 'package:formbuilder/data/constants.dart';
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


class NewVaultFinalizationScreen extends StatefulWidget {
  NewVaultFinalizationScreen({super.key, required this.t,required this.currentKey});
  final theme t;
  final String currentKey;
  @override
  State<NewVaultFinalizationScreen> createState() => _State();
}

class _State extends State<NewVaultFinalizationScreen> {
  final Provider provider = Get.find<Provider>();
  late theme t;
  bool showKey = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();


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
              return simpleAppBar(context, text: "create new vault - Finalization",t:t);
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
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 40),

                          customInput(t,nameController,"vault's Name","",context,maxLines: 1),
                          SizedBox(height: 32),
                          customInput(t,descriptionController,"vault's Description","",context,maxLines: 4),
                          SizedBox(height: 32),
                          Row(
                            children: [
                              Icon(HugeIconsStroke.informationCircle,color: t.errorColor,),
                              SizedBox(width: 12,),
                              Expanded(child: Text("We’d Love to Keep You Updated (Don't worry we don't Spam)",softWrap: true,overflow: TextOverflow.visible,style: TextStyle(color: t.errorColor),))
                            ],
                          ),
                          SizedBox(height: 12),
                          customInput(t,emailController,"Enter your email","",context,maxLines: 1,isEmail: true),
                          SizedBox(height: 32),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(isLoading: false,isFullRow:false, t: t,onPressed: () async {
                                /// save the key metadata to backend

                                /// save key and open vault
                                await SecureStorageService().saveCurrentKey(widget.currentKey);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                navigateTo(context, AppScreen(t: getTheme()),true);
                              }, text: 'Open Vault',)
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

