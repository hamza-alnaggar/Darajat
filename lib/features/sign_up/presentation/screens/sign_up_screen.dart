
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/helper/spacing.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/core/widgets/app_text_form_field.dart';
import 'package:learning_management_system/core/widgets/page_title_bar.dart';
import 'package:learning_management_system/core/widgets/under_part.dart';
import 'package:learning_management_system/core/widgets/upside.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_state.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/widgets/drop_down_countries.dart';
import 'package:learning_management_system/features/sign_up/presentation/widgets/sign_up_bloc_listener.dart';
import 'package:learning_management_system/generated/l10n.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final countryCubit = context.read<GetCountryCubit>();
    final signUpCubit = context.read<SignUpCubit>();
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
                PageTitleBar(title: S.of(context).create_new_account),
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
                          key:signUpCubit.formKey,
                          child: Column(
                            children: [
                              AppTextFormField(
                                hintText:S.of(context).fist_name,
                                icon: Icons.person,
                                validator: signUpCubit.validateName,
                                controller: signUpCubit.firstNameController,
                              ),
                              AppTextFormField(
                                hintText: S.of(context).last_name,
                                icon: Icons.phone,
                                validator: signUpCubit.validateName,
                                controller: signUpCubit.lastNameController,
                              ),
                              AppTextFormField(
                                hintText:S.of(context).email,
                                icon: Icons.email,
                                validator: signUpCubit.validateEmail,
                                controller: signUpCubit.emailController,
                              ),
                              AppTextFormField(
                                hintText: S.of(context).password,
                                icon: Icons.password,
                                validator: signUpCubit.validatePassword,
                                controller: signUpCubit.passwordController,
                              ),
                              AppTextFormField(
                                hintText: S.of(context).password_confirmation,
                                icon: Icons.password,
                                validator: signUpCubit.validatePasswordConfirmation,
                                controller: signUpCubit.passwordConfirmationController,
                              ),
                              SizedBox(height: 10.h,),
                              BlocBuilder<GetCountryCubit, GetCountryState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: size.width * 0.8,
                      child: DropDownCountries(
                        selectedCountry: countryCubit.selectedCountry,
                        countryList: countryCubit.countryList,
                      ),
                    );
                  },
                ),
                  verticalSpace(20),
                              AppTextButton(
                                buttonText: S.of(context).register,
                                onpressed: () {
                                validateThenDoSignup(context,countryCubit);
                                },
                              ),
                              verticalSpace(20),
                              UnderPart(
                                title:S.of(context).already_have_an_account,
                                navigatorText: S.of(context).login_here,
                                onTap: () {
                                  context.pushNamed(Routes.loginScreen);
                                },
                              ),
                              verticalSpace(20),
                              SignupBlocListener()
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

  void validateThenDoSignup(BuildContext context,GetCountryCubit cubit) {
    if (context.read<SignUpCubit>().formKey.currentState!.validate()) {
      context.read<SignUpCubit>().eitherFailureOrSignUp(countryId:cubit.selectedCountry?.id );
    } else {}
  }
}
