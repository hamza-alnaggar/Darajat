
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/helper/spacing.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/core/widgets/app_text_form_field.dart';
import 'package:learning_management_system/core/widgets/page_title_bar.dart';
import 'package:learning_management_system/core/widgets/under_part.dart';
import 'package:learning_management_system/core/widgets/upside.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_cubit.dart';
import 'package:learning_management_system/features/login/presentation/widgets/login_bloc_listener.dart';
import 'package:learning_management_system/generated/l10n.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignUpScreenState();
}


class _SignUpScreenState extends State<LoginScreen> {
  bool isSignedup = false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSignedUp();
  }

void isSignedUp() async{
  isSignedup =  await SharedPrefHelper.getBool('isSignedUp') ?? false;
  setState(() {
    
  });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
      final loginCubit = context.read<LoginCubit>();

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
                PageTitleBar(title: S.of(context).login_with_your_account),
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
                          key: loginCubit.formKey,
                          child: Column(
                            children: [
                              AppTextFormField(
                                hintText:S.of(context).email,
                                icon: Icons.email,
                                controller: loginCubit.emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "this field can not be empty";
                                  }}
                              ),
                              AppTextFormField(
                                hintText: S.of(context).password,
                                icon: Icons.password,
                                controller: loginCubit.passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "this field can not be empty";
                                  }}
                              ),
                  verticalSpace(20),
                              AppTextButton(
                                textStyle: TextStyle(
                                  color: CustomColors.textPrimary,
                                  fontSize: 17.sp
                                ),
                                buttonText: S.of(context).login,
                                onpressed: () {
                                validateThenDoSignup(context);
                                },
                              ),
                              verticalSpace(20),
                              UnderPart(
                                title:S.of(context).Dont_have_an_account,
                                navigatorText: S.of(context).register_here,
                                onTap: () {
                                  context.pushNamed(Routes.signUpScreen);
                                },
                              ),
                              SizedBox(height: 20.h,),
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children:[
                                    GestureDetector(child: Text('Forget your password ?'),onTap: (){
                                      context.pushNamed(Routes.forgotPasswordScreen);
                                    },),
                                    SizedBox(width: 20.w,),
                                    if(isSignedup) GestureDetector(child: Text('VerfiyOtp ?'),onTap: (){
                                      context.pushNamed(Routes.otpScreen);
                                    },),
                                  ],
                                ),
                              ),
                              verticalSpace(20),
                              ElevatedButton(
                          onPressed: () {
                            context.read<LoginCubit>().signInWithGoogle();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                height: 24,
                                width: 24,
                              ),
                              SizedBox(width: 10),
                              Text('Sign in with Google'),
                            ],
                          ),
                        ),
                              LoginBlocListener()
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

  void validateThenDoSignup(BuildContext context) {
    if (context.read<LoginCubit>().formKey.currentState!.validate()) {
      context.read<LoginCubit>().eitherFailureOrLogin();
    } else {}
  }
  
}
