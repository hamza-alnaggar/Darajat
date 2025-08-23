import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/helper/spacing.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/core/widgets/page_title_bar.dart';
import 'package:learning_management_system/core/widgets/under_part.dart';
import 'package:learning_management_system/core/widgets/upside.dart';
import 'package:learning_management_system/features/otp/presentation/cubit/otp_cubit.dart';
import 'package:learning_management_system/features/otp/presentation/widgets/resend_otp_bloc_listener.dart';
import 'package:learning_management_system/features/otp/presentation/widgets/verify_otp_bloc_listener.dart';
import 'package:learning_management_system/generated/l10n.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = '';
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    

    Color accentPurpleColor = Color(0xFF6A53A1);
    Color primaryColor = Color(0xFF121212);
    Color accentPinkColor = Color(0xFFF99BBD);
    Color accentDarkGreenColor = Color(0xFF115C49);
    Color accentYellowColor = Color(0xFFFFB612);
    Color accentOrangeColor = Color(0xFFEA7A3B);

    TextStyle? createStyle(Color color) {
        return theme.headlineLarge?.copyWith(color: color,fontSize: 40.r);
    }

    final  otpTextStyles = [
        createStyle(accentPurpleColor),
        createStyle(accentYellowColor),
        createStyle(accentDarkGreenColor),
        createStyle(accentOrangeColor),
        createStyle(accentPinkColor),
        createStyle(accentPurpleColor),
    ];

    
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  canBack: false,
                  imgUrl: "assets/images/register/register.json",
                ),
                PageTitleBar(title: S.of(context).verify_otp),
                Padding(
                  padding:  EdgeInsets.only(top: 320.0.h),
                  child: Container(
                    width: double.infinity,
                    decoration:  BoxDecoration(
                      color:isDark? CustomColors.backgroundColor : CustomColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.r),
                        topRight: Radius.circular(50.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      verticalSpace(20),
                        Form(
                          child: Column(
                            children: [
                              OtpTextField(
            numberOfFields: 6,
            borderColor: accentPurpleColor,
            focusedBorderColor: accentPurpleColor,
            styles: otpTextStyles,
            showFieldAsBox: false,
            borderWidth: 4.0,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              print(code);
                              // 2. Update OTP as user types
                              setState(() {
                              
                                otp = code;
                              });
                            },
                            onSubmit: (String verificationCode) {
                              print(verificationCode);
                              setState(() {
                                otp = verificationCode;
                              });
                            },
    ),
                  verticalSpace(40),
                              AppTextButton(
                                buttonText: S.of(context).register,
                                onpressed: () {
                              if (otp.isEmpty || otp.length != 6)
                            { 
                              _showSnackBar(context, message:'you must enter 6 number', backgroundColor: CustomColors.secondary);
                              return;
                            }
                              print(otp);
                              context.read<OtpCubit>().eitherFailureOrVerifyOtp(otp: otp);
                            },
                              ),  
                              verticalSpace(40),
                                UnderPart(
                                  title: 'do not receive a code ?',
                                  navigatorText: 'resend otp !',
                                  onTap: () {
                                    context.read<OtpCubit>().eitherFailureOrResendOtp();
                                  },
                                ),
                              verticalSpace(20.h),
                              UnderPart(
                                  title: 'want change email ?',
                                  navigatorText: 'signUpHere !',
                                  onTap: () {
                                    context.pushNamed(Routes.signUpScreen);
                                  },
                                ),
                              ResendOtpBlocListener(),
                              VerifyOtpBlocListener()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 void _showSnackBar(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content:
      Text(message),
      
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 3),
    ),
  );
}
