import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/app_bar.dart';
import 'package:learning_management_system/features/student/quiz/data/models/quiz_result_model.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResultModel result;

  const QuizResultScreen({super.key, required this.result});

  double _parsePercentage(dynamic p) {
    if (p == null) return 0;
    if (p is double) return p.clamp(0, 100);
    if (p is int) return p.toDouble().clamp(0, 100);
    if (p is String) {
      final cleaned = p.replaceAll('%', '').trim();
      return double.tryParse(cleaned) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).textTheme;
    final backgroundColor = isDark ? CustomColors.backgroundColor : const Color(0xFFF6F7FB);

    final headerGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [Color(0xFF0F766E), Color(0xFF065F46)]
          : [Color(0xFF4CAF50), Color(0xFF2E7D32)],
    );

    final percentage = _parsePercentage(result.percentageMark);
    final percentFraction = (percentage / 100).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        showBackButton: true,
        title: 'Quiz Result',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top header with trophy and message
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: headerGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(18.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    offset: const Offset(0, 6),
                    blurRadius: 12,
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.5), thickness: 1)),
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          result.success == true ? Icons.emoji_events : Icons.lightbulb_outline,
                          color: Colors.green[800],
                          size: 28.r,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.5), thickness: 1)),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  Text(
                    result.success == true ? 'Great job! You passed 🎉' : 'Keep going — practice makes perfect',
                    style: theme.headlineSmall?.copyWith(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    'Score: ${result.mark}  •  ${percentage.toStringAsFixed(0)}%',
                    style: theme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.95), fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 14.h),

                  // Small hint
                  Text(
                    result.success == true
                        ? 'You met the passing criteria for this quiz.'
                        : 'You were close — review the material and try again.',
                    style: theme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9), fontSize: 13.sp),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView(
                  children: [
                    // Card with circular progress and details
                    Card(
                      color: CustomColors.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Row(
                          children: [
                            // Circular progress indicator with percentage inside
                            SizedBox(
                              width: 110.w,
                              height: 110.w,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 110.w,
                                    height: 110.w,
                                    child: CircularProgressIndicator(
                                      value: percentFraction,
                                      strokeWidth: 10.w,
                                      backgroundColor: Colors.grey.withOpacity(0.2),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        percentage >= 70 ? Colors.green : (percentage >= 40 ? Colors.orange : Colors.red),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${percentage.toStringAsFixed(0)}%', style: theme.headlineSmall?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 4.h),
                                      Text('Accuracy', style: theme.bodySmall?.copyWith(fontSize: 12.sp)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 16.w),

                            // Result details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Details', style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp)),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle_outline, size: 18.r, color: Colors.green),
                                      SizedBox(width: 8.w),
                                      Expanded(child: Text('Score: ${result.mark}', style: theme.bodyMedium)),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Icon(Icons.checklist, size: 18.r, color: Colors.blueAccent),
                                      SizedBox(width: 8.w),
                                      Expanded(child: Text('Status: ${result.success == true ? 'Passed' : 'Not passed'}', style: theme.bodyMedium)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        SizedBox(width: 12.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              context.pushNamedAndRemoveUntil(Routes.episodesScreen, predicate:(route) => false,);
                            },
                            icon: Icon(Icons.exit_to_app),
                            label: Text('Return to Episode', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 28.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
