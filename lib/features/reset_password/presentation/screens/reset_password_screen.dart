import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/spacing.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/core/widgets/app_text_form_field.dart';
import 'package:learning_management_system/core/widgets/page_title_bar.dart';
import 'package:learning_management_system/core/widgets/upside.dart';
import 'package:learning_management_system/features/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:learning_management_system/features/reset_password/presentation/widgets/reset_password_bloc_listener.dart';
import 'package:learning_management_system/generated/l10n.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;

    final cubit = context.read<ResetPasswordCubit>();

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
                PageTitleBar(title: S.of(context).set_password),
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
                                hintText:S.of(context).password,
                                icon: Icons.password,
                                validator:cubit.validatePassword,
                                controller: cubit.passwordController,
                              ),
                  verticalSpace(20),
                              AppTextFormField(
                                hintText:S.of(context).password_confirmation,
                                icon: Icons.password,
                                validator: cubit.validatePasswordConfirmation,
                                controller: cubit.passwordConfirmationController,
                              ),
                  verticalSpace(20),
                              AppTextButton(
                                buttonText: S.of(context).change_password,
                                onpressed: () {
                                  validateThenDoResetPassword(context);
                                },
                              ),  
                              verticalSpace(20),
                              ResetPasswordBlocListener()
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

void validateThenDoResetPassword(BuildContext context ) {
    if (context.read<ResetPasswordCubit>().formKey.currentState!.validate()) {
      context.read<ResetPasswordCubit>().eitherFailureOrResetPassword();
    } else {}
  }
