import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/widgets/flame.dart';
import 'package:learning_management_system/core/widgets/home.dart';
import 'package:learning_management_system/core/widgets/profile.dart';
import 'package:learning_management_system/core/widgets/widget.dart';
import 'package:learning_management_system/features/cource_details/presentation/screen/course_details.dart';
import 'package:learning_management_system/features/home/presentation/screen/entry_point.dart';
import 'package:learning_management_system/features/login/presentation/cubit/login_cubit.dart';
import 'package:learning_management_system/features/login/presentation/screen/login_screen.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/get_country_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:learning_management_system/features/sign_up/presentation/screens/sign_up_screen.dart';
import 'package:learning_management_system/features/splash_screen/splash_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (context)=>SplashScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: [
                    BlocProvider(
                              create: (context) => sl<LoginCubit>(),
                            ),
                ],
                                  child: const LoginScreen(),
            ));
      case Routes.signUpScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                providers: [
                    BlocProvider(
                              create: (context) => sl<SignUpCubit>(),
                            ),
                    BlocProvider(
                        create: (context) => sl<GetCountryCubit>()..eitherFailureOrGetCountry(),
                    ),
                ],
                                  child: const SignUpScreen(),
            ));
      case Routes.entryPoint:
        return MaterialPageRoute(builder: (context)=>EntryPoint());
      case Routes.instructionView:
        return MaterialPageRoute(builder: (context)=>SectionBuilderPage());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context)=>Home());
      case Routes.courseDetailsScreen:
        return MaterialPageRoute(builder: (context)=>CourseDetails());
      case Routes.flameScreen:
        return MaterialPageRoute(builder: (context)=>Flame());
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (context)=>Profile());
      default:
        return null;
    }
  }
}
