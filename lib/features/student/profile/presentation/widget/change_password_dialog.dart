// features/profile/presentation/widgets/change_password_dialog.dart
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_text_form_field.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/change_password_cubit.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/change_password_state.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_cubit.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/profile_state.dart';
import 'package:learning_management_system/generated/l10n.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = S.of(context);
    
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).password_change_successfully),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state is ChangePasswordError) {
          Navigator.of(context).pop();
          final snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    color: CustomColors.backgroundColor,
                    title: 'On Snap!',
                    message:
                        state.message,

                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              
        }
      },
      child: Dialog(
        backgroundColor: isDark ? CustomColors.backgroundColor : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).change_password,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      
                      // Current Password Field
                      AppTextFormField(
                      onChange: (value){
                        setState(() {
                          
                        });
                      },
                      icon: Icons.password,
                        controller: context.read<ChangePasswordCubit>().currentPasswordController,
                        hintText: S.of(context).current_password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).please_enter_your_current_password;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      
                      // New Password Field
                      ValueListenableBuilder<TextEditingValue>(
  valueListenable: context.read<ChangePasswordCubit>().newPasswordController,
  builder: (context, value, child) {
    return Column(
      children: [
        AppTextFormField(
          icon: Icons.password,
          controller: context.read<ChangePasswordCubit>().newPasswordController,
          hintText: S.of(context).new_Password,
          validator: (value) => context.read<ChangePasswordCubit>().validatePassword(value),
          // No need for explicit onChanged when using ValueListenableBuilder
        ),
        SizedBox(height: 16.h),
        if(!value.text.isEmpty)
        _PasswordStrengthIndicator(
          password: value.text, // This will update automatically
        ),
      ],
    );
  },
),
                  SizedBox(height: 15.h,)
                      ,
                      // Confirm New Password Field
                      AppTextFormField(
                        icon: Icons.password,
                        controller: context.read<ChangePasswordCubit>().confirmPasswordController,
                        hintText: S.of(context).Confirm_New_Password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).Confirm_New_Password;
                          }
                          if (value != context.read<ChangePasswordCubit>().newPasswordController.text) {
                            return S.of(context).Passwords_do_not_match;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      
                      _PasswordRequirements(),
                      SizedBox(height: 24.h),
                      
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(s.Cancel),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: state is ChangePasswordLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<ChangePasswordCubit>().changePassword();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: state is ChangePasswordLoading
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                      ),
                                    )
                                  : Text(S.of(context).change_password),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).Password_must_contain,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 8.h),
        _RequirementItem(text: S.of(context).At_least_8_characters),
        _RequirementItem(text: S.of(context).One_uppercase_letter),
        _RequirementItem(text: S.of(context).One_number),
        _RequirementItem(text: S.of(context).One_special_character),
      ],
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;

  const _RequirementItem({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 8.r,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// Add this widget to your change password dialog
class _PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  
  const _PasswordStrengthIndicator({required this.password});
  
  @override
  Widget build(BuildContext context) {
    final strength = _calculatePasswordStrength(password);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: strength.value,
          backgroundColor: Colors.grey.shade300,
          color: strength.color,
          minHeight: 6.h,
          borderRadius: BorderRadius.circular(3.r),
        ),
        SizedBox(height: 4.h),
        Text(
          strength.text,
          style: TextStyle(
            fontSize: 12.sp,
            color: strength.color,
          ),
        ),
      ],
    );
  }
  
  _PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return _PasswordStrength('', 0.0, Colors.grey);
    if (password.length < 6) return _PasswordStrength('Weak', 0.3, Colors.red);
    
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    double strength = 0.0;
    if (password.length > 8) strength += 0.2;
    if (hasUppercase) strength += 0.2;
    if (hasDigits) strength += 0.2;
    if (hasSpecial) strength += 0.2;
    if (password.length > 12) strength += 0.2;
    
    if (strength < 0.5) return _PasswordStrength('Weak', strength, Colors.red);
    if (strength < 0.75) return _PasswordStrength('Fair', strength, Colors.orange);
    if (strength < 0.9) return _PasswordStrength('Good', strength, Colors.lightGreen);
    return _PasswordStrength('Strong', strength, Colors.green);
  }
}

class _PasswordStrength {
  final String text;
  final double value;
  final Color color;
  
  _PasswordStrength(this.text, this.value, this.color);
}