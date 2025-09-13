import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';

import 'package:learning_management_system/core/routing/app_router.dart';
import 'package:learning_management_system/core/theme/theme.dart';
import 'package:learning_management_system/generated/l10n.dart';

class LearngingManagementSystem extends StatefulWidget {
  const LearngingManagementSystem({
    Key? key,
    required this.appRouter,
    required this.initialRoute,
  }) : super(key: key);

  final AppRouter appRouter;
  final String initialRoute;

  @override
  State<LearngingManagementSystem> createState() => _LearngingManagementSystemState();
}

class _LearngingManagementSystemState extends State<LearngingManagementSystem> {
    String localization = 'en'; // Use a safe default
  
  @override
  void initState() {
    super.initState();
    _loadLocalization();
  }

  Future<void> _loadLocalization() async {
    try {
      final savedLocal = await SharedPrefHelper.getString('local') ?? 'en';
      
      // Validate the locale value
      if (savedLocal.isNotEmpty) {
        if (mounted) {
          setState(() {
            localization = savedLocal;
          });
        }
      }
    } catch (e) {
      // Fallback to default locale
      if (mounted) {
        setState(() {
          localization = 'en';
        });
      }
    }
  }
  Widget build(BuildContext context) {
  
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
                locale: Locale(localization),
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
                onGenerateRoute: widget.appRouter.generateRoute,
                initialRoute: widget.initialRoute,
                builder: (context, child) {
                return WillPopScope(
                  onWillPop: () async {
                    final canPop = Navigator.of(context).canPop();
                    if (!canPop) {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(S.of(context).exitApp),
                          content: Text(S.of(context).exitAppConfirmation),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(S.of(context).cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(S.of(context).exit),
                            ),
                          ],
                        ),
                      );
                    }
                    return true;
                  },
                  child: child!,
                );
              },
              );
      },
      
    );
  }
}
