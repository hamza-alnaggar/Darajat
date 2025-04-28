
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/spacing.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/core/widgets/app_text_form_field.dart';
import 'package:learning_management_system/core/widgets/page_title_bar.dart';
import 'package:learning_management_system/core/widgets/under_part.dart';
import 'package:learning_management_system/core/widgets/upside.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                const Upside(
                  imgUrl: "assets/images/register/register.json",
                ),
                PageTitleBar(title: "create new account"),
                Padding(
                  padding:  EdgeInsets.only(top: 320.0.h),
                  child: Container(
                    width: double.infinity,
                    decoration:  BoxDecoration(
                      color: CustomColors.backgroundColor,
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
                              AppTextFormField(
                                hintText:"first name",
                                icon: Icons.person,
                              ),
                              AppTextFormField(
                                hintText: "last name",
                                icon: Icons.phone,
                              ),
                              AppTextFormField(
                                hintText:"email",
                                icon: Icons.email,
                              ),
                              AppTextFormField(
                                hintText: "password",
                                icon: Icons.password,
                              ),
                  verticalSpace(20),
                              AppTextButton(
                                textStyle: TextStyle(
                                  color: CustomColors.textPrimary,
                                  fontSize: 17.sp
                                ),
                                buttonText: "register",
                                onpressed: () {
                                //  validateThenDoSignup(context);
                                },
                              ),
                              verticalSpace(20),
                              UnderPart(
                                title:"Already have an account",
                                navigatorText: "Login here",
                                onTap: () {
                                  // context.pushNamed(Routes.loginScreen);
                                },
                              ),
                              verticalSpace(20),
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

  // void validateThenDoSignup(BuildContext context) {
  //   if (context.read<SignUpCubit>().formKey.currentState!.validate()) {
  //     context.read<SignUpCubit>().eitherFailureOrSignUp();
  //   } else {}
  // }
}
