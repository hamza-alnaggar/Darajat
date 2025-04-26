import 'package:flutter/material.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/features/splash_screen/splash_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (context)=>SplashScreen());
      default:
        return null;
    }
  }
}
