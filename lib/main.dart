import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/routing/app_router.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/learnging_management_system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await getItInit();
  await ScreenUtil.ensureScreenSize();

  runApp(
    LearngingManagementSystem(
      appRouter: AppRouter(),
      initialRoute: Routes.splashScreen,
    ),
  );
}
