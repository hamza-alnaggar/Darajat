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
        title: S.of(context).on_boarding_title_page_one,
        subtitle: S.of(context).on_boarding_sub_title_page_one,
        image: "assets/images/splash/splash_screen.json",
        backgroundColor: isDark ? CustomColors.backgroundColor : const Color.fromRGBO(0, 10, 56, 1),
        titleColor: isDark ? CustomColors.textPrimary : Colors.pink,
        subtitleColor: isDark ? CustomColors.textSecondary : Colors.white,
      ),
      CardOnboardingData(
        title: S.of(context).on_boarding_title_page_two,
        subtitle: S.of(context).on_boarding_sub_title_page_two,
        image: "assets/images/onboarding/image1.json",
        backgroundColor: isDark ? CustomColors.white : Colors.white,
        titleColor: isDark ? CustomColors.textDark : Colors.purple,
        subtitleColor: isDark ? CustomColors.textDark2 : CustomColors.dark,
      ),
      CardOnboardingData(
        title: S.of(context).on_boarding_title_page_three,
        subtitle: S.of(context).on_boarding_sub_title_page_three,
        image: "assets/images/onboarding/image2.json",
        backgroundColor: isDark ? CustomColors.backgroundColor : const Color.fromRGBO(71, 59, 117, 1),
        titleColor: isDark ? CustomColors.textPrimary : Colors.yellow,
        subtitleColor: isDark ? CustomColors.textSecondary : Colors.white,
      ),
      CardOnboardingData(
        title: S.of(context).on_boarding_title_page_four,
        subtitle: S.of(context).on_boarding_sub_title_page_four,
        image: "assets/images/onboarding/image2.json",
        backgroundColor: isDark ? CustomColors.white : const Color.fromRGBO(71, 59, 117, 1),
        titleColor: isDark ? CustomColors.textDark : Colors.yellow,
        subtitleColor: isDark ? CustomColors.textDark2 : Colors.white,
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