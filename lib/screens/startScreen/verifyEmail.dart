// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:formbuilder/screens/startScreen/newPassword.dart';
import 'package:formbuilder/screens/startScreen/signInFinalization.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../main.dart';
import '../../services/provider.dart';
import '../../services/themeService.dart';
import '../../tools/tools.dart';
import '../../widgets/basics.dart';
import '../../widgets/form.dart';


class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key, required this.t,required this.type,required this.email});
  final verifyEmailType type;
  final theme t;
  final String email;
  @override
  State<VerifyEmail> createState() => _State();
}

class _State extends State<VerifyEmail> {
  final Provider provider = Get.find<Provider>();
  late theme t;
  bool getCodeLoading = false;
  bool verifyCodeLoading = false;
  late TextEditingController emailController;
  TextEditingController codeController = TextEditingController();
  String latestEmail = "";




  @override
  void initState() {
    super.initState();
    // Start with the provided theme (fallback to dark if needed)
    emailController = TextEditingController(text :widget.email);
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
              return simpleAppBar(context, text: "Verify Email",t:t);
            },
          ),
        )
            : null,
        body: isLandscape(context)
            ? Center(
            child: Container(
              width: screenWidth*0.5,
              height: screenHeight*0.7,
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
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              landscape(t)
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

  landscape(theme theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        constraints: const BoxConstraints(maxWidth: 600), // Increased from 100 to 600
        padding: const EdgeInsets.all(24),
        child: portrait(theme),
      ),
    );
  }
  portrait(theme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: customInput(
                  theme,
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
                  onPressed: () async {
                    //prevent clicking while verifying
                    if (!getCodeLoading) {
                      try {
                        String email = emailController.text;
                        if (email.isEmpty ||
                            !RegExp(
                              r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(email)) {
                          showError(
                            'Invalid email',
                            context,
                          );
                        } else {
                          //before sending email check if the user exist
                          bool isExist = false;//await userService.isExistByMail(email);
                          if(!isExist){
                            setState(() {
                              getCodeLoading = true;
                            });
                            await Future.delayed(const Duration(seconds: 2));
                            showMsg(
                              "If the email exists, you will receive an OTP code shortly",
                              context,
                              theme,
                            );
                            setState(() {
                              getCodeLoading = false;
                            });
                            return;
                          }

                          setState(() {
                            getCodeLoading = true;
                          });

                          //send email:
                          final error = "error";//"await OTPService.sendOtp(emailController.text);
                          if (error == null) {
                            print('If the email exists, you will receive an OTP code shortly');
                            showMsg(
                              "If the email exists, you will receive an OTP code shortly",
                              context,
                              theme,
                            );
                            latestEmail = email;
                            emailController.text = '';
                            codeController.text = '';
                          } else {
                            print('Send OTP error: $error');
                            showError(
                              "Error while sending code, please try later",
                              context,
                            );
                          }
                        }
                      } catch (e) {
                        log('error while login');
                        showError(
                          'Error while login',
                          context,
                        );
                      } finally {
                        setState(() {
                          getCodeLoading = false;
                        });
                      }
                    }
                  },
                  isLoading: getCodeLoading, t: t,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
        Text(
          "Enter the code sent to your email",
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 30),

        PinCodeTextField(
          appContext: context,
          controller: codeController,
          length: 5,
          obscureText: false,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          inputFormatters: [],
          textStyle: TextStyle(color: theme.textColor),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(10),
            fieldHeight: 60,
            fieldWidth: 50,
            activeFillColor: theme.accentColor.withOpacity(0.2),
            selectedFillColor: theme.bgColor,
            inactiveFillColor: theme.bgColor,
            activeColor: theme.accentColor,
            selectedColor: theme.accentColor,
            inactiveColor: theme.border,
          ),
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          onChanged: (value) {},
        ),
        SizedBox(height: 40),
        CustomButtonOutline(
          text: verifyCodeLoading ? 'Verifying' : 'Send',
          backgroundColor: theme.accentColor.withOpacity(0.8),
          isLoading: verifyCodeLoading,
          onPressed: () async {
            //prevent clicking while verifying
            if (!verifyCodeLoading) {
              try {
                /// remove later , just for testing
                onVerified();
                return;
                /// ////////////////////////////////

                final String email = latestEmail;
                String code = codeController.text;
                if (code.length == 5) {
                  if(latestEmail.isEmpty){
                    showError("Please click on send code first", context);
                    return;
                  }
                  setState(() {
                    verifyCodeLoading = true;
                  });

                  String? error = null;//await OTPService.verifyOtp(email, code);
                  if (error == null) {
                    print("OTP verified successfully!");
                    onVerified();
                  } else {
                    print("Verification failed: $error");
                    // show error to user
                    showError(
                      'Wrong code, try again',
                      context,
                    );
                    codeController.text = "";
                  }
                }
              } catch (e) {
                log('error while verifying code');
                showError(
                  'Error while verifying code',
                  context,
                );
              } finally {
                onVerified();
                setState(() {
                  verifyCodeLoading = false;
                });
              }
            }
          }, t: t,
        ),
      ],
    );
  }

  onVerified(){
    if(widget.type==verifyEmailType.resetPassword){
      navigate(
        context,
        NewPassword(
          email: latestEmail,
          t: t,
        ),
        isReplace: true,
      );
    }else if(widget.type==verifyEmailType.createAccount){
      navigate(
        context,
        SignInFinalization(t: t),
        isReplace: true,
      );
    }else if(widget.type==verifyEmailType.updateEmail){
      Navigator.pop(context,true);
    }else if(widget.type==verifyEmailType.updatePassword){
      navigate(
        context,
        NewPassword(
          email: latestEmail,
          t: t,
        ),
        isReplace: true,
      );    }
  }
}

enum verifyEmailType{
  resetPassword,
  createAccount,
  updatePassword,
  updateEmail,
}

