import 'package:flutter/material.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';
import 'package:learning_management_system/core/helper/extention.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final bool showOnBoarding = 
        await SharedPrefHelper.getBool('showOnBoarding') ?? true;
    final bool isSignedUp = 
        await SharedPrefHelper.getBool('isSignedUp') ?? false;
    final bool otpSuccessfully = 
        await SharedPrefHelper.getBool('otpSuccessfully') ?? false;
  

    // Determine route based on conditions
    String nextRoute;
   
      if (otpSuccessfully) {
      nextRoute = Routes.entryPoint;
    } else if (isSignedUp) {
      nextRoute = Routes.otpScreen;
    } else if (showOnBoarding) {
      nextRoute = Routes.loginScreen;
    } else {
      nextRoute = Routes.onboarding;
    }

    // Navigate after splash animation completes
    Future.delayed(const Duration(milliseconds: 1800), () {
      context.pushReplacementNamed(nextRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: Lottie.asset('assets/images/splash/splash_screen.json'),
      ),
    );
  }
}