// ignore_for_file: file_names
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' hide colorFromHex;
import 'package:formbuilder/backend/models/form/docItem.dart';
import 'package:formbuilder/screens/home/appScreen.dart';
import 'package:formbuilder/screens/home/widgets/dropList.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:split_view/split_view.dart';
import '../../backend/models/form/screen.dart';
import '../../backend/models/form/form.dart';
import '../../backend/models/form/screenCustomization.dart';
import '../../data/constants.dart';
import '../../data/fonts.dart';
import '../../main.dart';
import '../../services/provider.dart';
import '../../services/themeService.dart';
import '../../services/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/canva.dart';
import '../../widgets/cards.dart';
import '../../widgets/dialogues.dart';
import '../../widgets/form.dart';
import '../../widgets/image.dart';
import '../../widgets/menu.dart';
import '../../widgets/screenContent.dart';

class FormSettings extends StatefulWidget {
  FormSettings({super.key, required this.t});
  final theme t;

  @override
  State<FormSettings> createState() => _State();
}

class _State extends State<FormSettings> {
  // --------------------------------------------------------------------------
  // STATE VARIABLES
  // --------------------------------------------------------------------------
  late theme t;
  bool isSavingLoading = false;
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
      customColor:t.brightness == Brightness.light
          ? Colors.white
          : t.bgColor ,
      t: t,
      child: Scaffold(
        backgroundColor: t.brightness == Brightness.light? Colors.white : t.bgColor,
        appBar: _buildAppBar(t),
        body: Center(
          child:Container(
            padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 22),
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80,),
                title(title: "General"),
                settingsItemToggle(title:"FormIt Branding",desc:"Show 'Made with FormIt' on your form.", isEnabled:true,isProFeature:false,onToggle: (value){
                  
                }),
                settingsItemToggle(title:"Progress bar",desc:"The progress bar provides a clear way for respondents to understand how much of the form they have completed, and encourages them to continue until the end.", isEnabled:true,isProFeature:false,onToggle: (value){

                }),
              ],
            ),
          ),
        )
      ),
    );
  }
  // ==========================================================================
  // APP BAR
  // ==========================================================================
  PreferredSizeWidget _buildAppBar(theme theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: _buildAppBarContent(theme)
    );
  }
  Widget _buildAppBarContent(theme theme) {
    return Row(
      children: [
        buildCancelIconButton(t, context, isX: false),
        Spacer(),
        SizedBox(width: 10),
        Text(isLandscape(context)?"Form Settings":"Settings",style: TextStyle(color: t.textColor),),
        SizedBox(width: 10),
        Spacer(),
        (!isLandscape(context))?IconButton(onPressed: onSaveSettings, icon: Icon(
          Icons.done_all_rounded,
          color: t.textColor,
          size: 24,
        )):
        FButton.icon(
          onPress: onSaveSettings,
          style: FButtonStyle.primary(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 4),
              (isSavingLoading)
                  ? SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: t.bgColor,
                ),
              )
                  : 
              SizedBox(width: 10),
              Text(
                "Save Changes",
                style: TextStyle(
                  fontSize: 14,
                  color: t.bgColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  onSaveSettings(){

  }

  title({required String title}){
    return Padding(padding: EdgeInsets.only(bottom: 30),child: Text(title,style: TextStyle(
        color: t.accentColor,
      fontSize: 20
    ),),);
  }
  settingsItemToggle({required String title, required String desc, required bool isEnabled, required bool isProFeature,required Function onToggle}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: t.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 17
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  desc,
                  style: TextStyle(
                      color: t.secondaryTextColor.withOpacity(0.7)
                  ),
                )
              ],
            )),
            SizedBox(width: 25,),
            SizedBox(
              width: 20,
              height: 5,
              child: Transform.scale(
                scale: 0.7,
                child: FSwitch(
                  value: isEnabled,
                  onChange: (value) async {
                    onToggle(value);
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5,),

        Divider(
          color: t.textColor.withOpacity(0.06),
        ),
        SizedBox(height: 5,),
      ],
    );
  }
}
