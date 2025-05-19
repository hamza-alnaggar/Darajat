import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/localization/cubit/local_cubit.dart';
import 'package:learning_management_system/core/localization/cubit/local_state.dart';
import 'package:learning_management_system/core/routing/app_router.dart';
import 'package:learning_management_system/core/theme/theme.dart';
import 'package:learning_management_system/generated/l10n.dart';

class LearngingManagementSystem extends StatelessWidget {
  const LearngingManagementSystem({
    super.key,
    required this.appRouter,
    required this.initialRoute,
  });

  final AppRouter appRouter;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
  
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, child) {
        return BlocProvider(
          create: (context) => LocaleCubit()..getSavedLanguage(),
          child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
        builder: (context, state) {
          return
          MaterialApp(
                  locale: state.locale,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  title: 'LearningManagementSystem',
                  themeMode: ThemeMode.system,
                  theme: CustomAppTheme.lightTheme,
                  darkTheme: CustomAppTheme.darkTheme,
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: appRouter.generateRoute,
                  initialRoute: initialRoute,
                );
        })
        );
      },
      
    );
  }
}