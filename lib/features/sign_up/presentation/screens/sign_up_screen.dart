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
import 'package:learning_management_system/features/sign_up/data/models/sub_models/country_sub_model.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_state.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_language_state.dart';
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
    final languageCubit = context.read<GetLanguageCubit>();
    final signUpCubit = context.read<SignUpCubit>();
    Size size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<GetCountryCubit, GetCountryState>(
          listener: (context, state) {
          if( state is GetCountryFailure){
            _showSnackBar(context, message: state.errMessage, backgroundColor: CustomColors.secondary);
          }
          },
        ),
        BlocListener<GetLanguageCubit, GetLanguageState>(
          listener: (context, state) {
if( state is GetLanguageFailure){
            _showSnackBar(context, message: state.errMessage, backgroundColor: CustomColors.secondary);
          }
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: SizedBox(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  const Upside(imgUrl: "assets/images/register/register.json",canBack: true,),
                  PageTitleBar(title: S.of(context).create_new_account),
                  Padding(
                    padding: EdgeInsets.only(top: 320.0.h),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? CustomColors.backgroundColor
                                : CustomColors.white,
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
                            key: signUpCubit.formKey,
                            child: Column(
                              children: [
                                AppTextFormField(
                                  hintText: S.of(context).fist_name,
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
                                  hintText: S.of(context).email,
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
                                  validator:
                                      signUpCubit.validatePasswordConfirmation,
                                  controller:
                                      signUpCubit
                                          .passwordConfirmationController,
                                ),
                                SizedBox(height: 10.h),
                                BlocBuilder<GetCountryCubit, GetCountryState>(
                                  builder: (context, state) {
                                    return SizedBox(
                                      width: size.width * 0.8,
                                      child: BlocBuilder<
                                        GetCountryCubit,
                                        GetCountryState
                                      >(
                                        builder: (context, state) {
                                          final countryCubit =
                                              context.read<GetCountryCubit>();
                                          return CustomDropDown<
                                            CountryOrLanguageSubModel
                                          >(
                                            selectedVal:
                                                countryCubit.selectedCountry,
                                            list: countryCubit.countryList,
                                            hint: "Choose Country",
                                            itemToString: (item) => item.name,
                                            onChanged:
                                                (value) => countryCubit
                                                    .selectCountry(value!),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 20.h),
                                BlocBuilder<GetLanguageCubit, GetLanguageState>(
                                  builder: (context, state) {
                                    return SizedBox(
                                      width: size.width * 0.8,
                                      child: CustomDropDown<
                                        CountryOrLanguageSubModel
                                      >(
                                        selectedVal:
                                            languageCubit.selectedLanguage,
                                        list: languageCubit.languageList,
                                        hint: "Choose Your Language",
                                        itemToString: (item) => item.name,
                                        onChanged:
                                            (value) => languageCubit
                                                .selectLanguage(value!),
                                      ),
                                    );
                                  },
                              ),
                                verticalSpace(20),
                                AppTextButton(
                                  buttonText: S.of(context).register,
                                  onpressed: () {
                                    validateThenDoSignup(
                                      context,
                                      countryCubit,
                                      languageCubit,
                                    );
                                  },
                                ),
                                verticalSpace(20),
                                UnderPart(
                                  title: S.of(context).already_have_an_account,
                                  navigatorText: S.of(context).login_here,
                                  onTap: () {
                                    context.pushNamed(Routes.loginScreen);
                                  },
                                ),
                                verticalSpace(20),
                                SignupBlocListener(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validateThenDoSignup(
    BuildContext context,
    GetCountryCubit countryCubit,
    GetLanguageCubit languageCubit,
  ) {
    if (context.read<SignUpCubit>().formKey.currentState!.validate()) {
      context.read<SignUpCubit>().eitherFailureOrSignUp(
        countryId: countryCubit.selectedCountry?.id,
        languageId: languageCubit.selectedLanguage?.id,
      );
    } else {}
  }
   void _showSnackBar(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content:
          Text(message,style: TextStyle(color: Colors.white),),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 3),
    ),
  );
}
}
