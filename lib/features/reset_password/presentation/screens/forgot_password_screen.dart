import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/spacing.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/core/widgets/app_text_form_field.dart';
import 'package:learning_management_system/core/widgets/page_title_bar.dart';
import 'package:learning_management_system/core/widgets/upside.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/forgot_passwrod_cubit.dart';
import 'package:learning_management_system/features/reset_password/presentation/widgets/forgot_password_bloc_listener.dart';
import 'package:learning_management_system/generated/l10n.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;

    final cubit = context.read<ForgotPasswordCubit>();

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
                PageTitleBar(title: S.of(context).forget_password),
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
                          key: cubit.formKey,
                          child: Column(
                            children: [
                              AppTextFormField(
                                hintText:S.of(context).email,
                                icon: Icons.email,
                                validator: cubit.validateEmail,
                                controller: cubit.emailController,
                              ),
                  verticalSpace(20),
                              AppTextButton(
                                buttonText: S.of(context).check_email,
                                onpressed: () {
                                  validateThenDoForgotPassword(context);
                                },
                              ), 
                              ForgotPasswordBlocListener(), 
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
}

void validateThenDoForgotPassword(BuildContext context ) {
    if (context.read<ForgotPasswordCubit>().formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().eitherFailureOrForgotPassword();
    } else {}
  }
