import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/features/home/presentation/screen/home_screen.dart';
import 'package:learning_management_system/features/login/presentation/screen/login_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedSplashScreen(
      backgroundColor: isDark ? Colors.black : Colors.white,
      splash: Column(
        children: [
          Center(child: Lottie.asset('assets/images/splash/splash_screen.json')),
        ],
      ),
      nextScreen:HomeScreen() ,
      splashIconSize: 400,
    );
  }
}