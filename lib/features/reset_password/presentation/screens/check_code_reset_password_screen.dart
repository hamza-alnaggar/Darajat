import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/spacing.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/core/widgets/page_title_bar.dart';
import 'package:learning_management_system/core/widgets/upside.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/check_code_reset_password_cubit.dart';
import 'package:learning_management_system/features/reset_password/presentation/widgets/check_code_reset_password_bloc_listener.dart';
import 'package:learning_management_system/generated/l10n.dart';

class CheckCodeResetPasswordScreen extends StatefulWidget {
  const CheckCodeResetPasswordScreen({super.key});

  @override
  State<CheckCodeResetPasswordScreen> createState() => _CheckCodeResetPasswordScreenState();
}

class _CheckCodeResetPasswordScreenState extends State<CheckCodeResetPasswordScreen> {
  String ?code ;
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
        return theme.bodyLarge?.copyWith(color: color,fontSize: 40.r);
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
                PageTitleBar(title: S.of(context).check_code),
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
            
            },
            onSubmit: (String checkCode) {
              setState(() {
                code = checkCode ;
              });
            }, 
    ),
                  verticalSpace(50),
                              AppTextButton(
                                buttonText: S.of(context).check_code,
                                onpressed: () {
                                  context.read<CheckCodeResetPasswordCubit>().eitherFailureOrCheckCode(code: code);
                                },
                              ),  
                              verticalSpace(20),
                              CheckCodeResetPasswordBlocListener()
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
