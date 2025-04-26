import 'package:flutter/material.dart';
import 'package:concentric_transition/page_view.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/features/onboarding/widget/card_onboarding_data.dart';
import 'package:learning_management_system/features/sign_up/presentation/screens/sign_up_screen.dart';
import 'package:learning_management_system/generated/l10n.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final data = [
      CardOnboardingData(
        title: "observe",
        subtitle: S.of(context).on_boarding_sub_title_page_one,
        image: "assets/images/splash/splash_screen.json",
        backgroundColor: isDark ? CustomColors.darkContainer : const Color.fromRGBO(0, 10, 56, 1),
        titleColor: isDark ? CustomColors.primary : Colors.pink,
        subtitleColor: isDark ? CustomColors.light : Colors.white,
      ),
      CardOnboardingData(
        title: "imagine",
        subtitle: S.of(context).on_boarding_sub_title_page_two,
        image: "assets/images/onboarding/image1.json",
        backgroundColor: isDark ? CustomColors.dark : Colors.white,
        titleColor: isDark ? CustomColors.primary : Colors.purple,
        subtitleColor: isDark ? CustomColors.light : CustomColors.dark,
      ),
      CardOnboardingData(
        title: "stargaze",
        subtitle: S.of(context).on_boarding_sub_title_page_three,
        image: "assets/images/onboarding/image2.json",
        backgroundColor: isDark ? CustomColors.darkContainer : const Color.fromRGBO(71, 59, 117, 1),
        titleColor: isDark ? CustomColors.primary : Colors.yellow,
        subtitleColor: isDark ? CustomColors.light : Colors.white,
      ),
    ];

    return Scaffold(
      body: ConcentricPageView(
        colors: data.map((e) => e.backgroundColor).toList(),
        itemCount: data.length,
        itemBuilder: (int index) => CardOnboarding(data: data[index]),
        onFinish: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        ),
      ),
    );
  }
}