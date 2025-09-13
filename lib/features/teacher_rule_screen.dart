import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_bar.dart';
import 'package:learning_management_system/core/widgets/app_text_button.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/promote_student_cubit.dart';
import 'package:learning_management_system/features/student/profile/presentation/cubit/promote_student_state.dart';
import 'package:learning_management_system/generated/l10n.dart';
import 'package:lottie/lottie.dart';

class TeacherRulesScreen extends StatefulWidget {
  const TeacherRulesScreen({Key? key}) : super(key: key);

  @override
  _TeacherRulesScreenState createState() => _TeacherRulesScreenState();
}

class _TeacherRulesScreenState extends State<TeacherRulesScreen> {
   bool _acceptedRules = false;
  bool _isDialogShowing = false; 
  @override
  Widget build(BuildContext context) {
      bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<PromoteStudentCubit, PromoteStudentState>(
      listener: (context, state) async {
        // Show loading dialog
        if (state is PromoteStudentLoading) {
          if (!_isDialogShowing) {
            _isDialogShowing = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              useRootNavigator: true,
              builder: (_) => const Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(), 
                ),
              ),
            );
          }
          return;
        }

        if (_isDialogShowing) {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          _isDialogShowing = false;
        }

        // Handle states
        if (state is PromoteStudentError) {
          // show error snackbar
          _showSnackBar(context, message: state.message);
          return;
        }

        if (state is PromoteStudentSuccess) {
          if (!mounted) return;
          Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil(Routes.sidebar, (route) => false);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).Become_a_Teacher,
          showBackButton: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(
                          Icons.school,
                          size: 60.r,
                          color: CustomColors.primary,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          S.of(context).Teacher_Rules,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? CustomColors.textWhite
                                : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      _buildRuleSection(
                        context,
                        '1. ${S.of(context).Technical_Quality_Standards}',
                        [
                          S.of(context).Rule_1_1,
                          S.of(context).Rule_1_2,
                          S.of(context).Rule_1_3,
                        ],
                      ),
                      _buildRuleSection(
                        context,
                        '2. ${S.of(context).Educational_Value}',
                        [
                          S.of(context).Rule_2_1,
                          S.of(context).Rule_2_2,
                          S.of(context).Rule_2_3,
                        ],
                      ),
                      _buildRuleSection(
                        context,
                        '3. ${S.of(context).Legal_Compliance}',
                        [S.of(context).Rule_3_1, S.of(context).Rule_3_2],
                      ),
                      _buildRuleSection(
                        context,
                        '4. ${S.of(context).Student_Engagement}',
                        [S.of(context).Rule_4_1, S.of(context).Rule_4_2],
                      ),
                      _buildRuleSection(
                        context,
                        '5. ${S.of(context).Monetization}',
                        [S.of(context).Rule_5_1, S.of(context).Rule_5_2],
                      ),
                      _buildRuleSection(
                        context,
                        '6. ${S.of(context).Review_Process}',
                        [S.of(context).Rule_6_1, S.of(context).Rule_6_2],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptedRules,
                            onChanged: (value) {
                              setState(() {
                                _acceptedRules = value ?? false;
                              });
                            },
                            activeColor: CustomColors.primary,
                          ),
                          Expanded(
                            child: Text(
                              S.of(context).Accept_Rules,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: isDark
                                    ? CustomColors.textWhite
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: _acceptedRules
                    ? () {
                        _promoteToTeacher();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.primary,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  S.of(context).Accept_And_Continue,
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleSection(
    BuildContext context,
    String title,
    List<String> points,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: CustomColors.primary,
          ),
        ),
        SizedBox(height: 8.h),
        ...points.map(
          (point) => Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    color: isDark ? CustomColors.textWhite : Colors.black,
                  ),
                ),
                Expanded(
                  child: Text(
                    point,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: isDark ? CustomColors.textWhite : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  void _promoteToTeacher() {
    context.read<PromoteStudentCubit>().promoteStudent();
  }

  void _showSnackBar(
  BuildContext context, {
  required String message,
}) {

final snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    color: CustomColors.backgroundColor,
                    title: 'On Snap!',
                    message:
                        message,

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              }
}


