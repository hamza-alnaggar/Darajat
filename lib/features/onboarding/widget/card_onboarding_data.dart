import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CardOnboardingData {
  final String title;
  final String subtitle;
  final String image;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final Widget? background;

  CardOnboardingData({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
    this.background,
  });
}

class CardOnboarding extends StatelessWidget {
  const CardOnboarding({
    required this.data,
    super.key,
  });

  final CardOnboardingData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Stack(
      children: [
        if (data.background != null) data.background!,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              Flexible(
                flex: 20,
                child: LottieBuilder.asset(data.image),
              ),
              const Spacer(flex: 1),
              Text(
                data.title.toUpperCase(),
  textAlign: TextAlign.center, 
                style: textTheme.headlineMedium?.copyWith(
                  color: data.titleColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                maxLines: 1,
              ),
              const Spacer(flex: 1),
              Text(
                data.subtitle,
                style: textTheme.headlineSmall?.copyWith(
                  color: data.subtitleColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              const Spacer(flex: 10),
            ],
          ),
        ),
      ],
    );
  }
}