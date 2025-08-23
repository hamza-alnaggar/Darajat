import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learning_management_system/core/databases/cache/cache_helper.dart';

import 'package:learning_management_system/core/di/dependency_injection.dart';
import 'package:learning_management_system/core/routing/app_router.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/learnging_management_system.dart';

// 1. Move notification helper to top-level
// void _showNotification(RemoteMessage message) {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'your_channel_id',
//     'Your Channel Name',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
  
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
  
//   // Initialize plugin in current isolate
//   final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
//   plugin.show(
//     0,
//     message.notification?.title,
//     message.notification?.body,
//     platformChannelSpecifics,
//   );
// }

// // 2. Move background handler to top-level with required annotation
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Initialize Firebase for background isolate
//   await Firebase.initializeApp();
//   _showNotification(message);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  
  await Firebase.initializeApp();
  await getItInit();
  await ScreenUtil.ensureScreenSize();

  // Initialize local notifications
  // const AndroidInitializationSettings initializationSettingsAndroid = 
  //     AndroidInitializationSettings('@mipmap/ic_launcher');
  // final InitializationSettings initializationSettings = 
  //     InitializationSettings(android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  // // Request permissions
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  // // Get FCM token
  // String? token = await messaging.getToken();
  // print("FCM Token: $token");

  // // 3. Set background handler (now references top-level function)
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // Foreground message handler
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   _showNotification(message);
// });

  SharedPrefHelper.setData('accessToken', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5ZmIxODBiZS1hMzU5LTRhZmEtYTA0Ny00MWIxZjEwMjY5YzIiLCJqdGkiOiJiNTNlZDhlZjc3NmJiNzVjMGQwNGMyNmYwZDg3Y2M0ZGQ5NTk0N2M3Y2NlNzlhYTk1ZmY0NTliZWFkMGRhNDI5YzMwY2UzMGZkYzQ4NDkxOSIsImlhdCI6MTc1NTg0NzIxMi44NjM0MjUsIm5iZiI6MTc1NTg0NzIxMi44NjM0MjcsImV4cCI6MTc4NzM4MzIxMi44NDM0MSwic3ViIjoiMiIsInNjb3BlcyI6W119.jUDglepM6JT2aK5f7DT9x8hLGgxbLsZnkiILTccjxI9BKZ67CNz7Gt9M_XqeAIjXMq7GIc_uLUZE0F-yqWJD7Htxr8VxIKFcRloiNMxZsMTSSVm21ndphomrC6RJJEimpj44Vd5GSeaENXSbRT7p8h79KOT5jpOf5F8oO7TV423zxENovyzEBRpxOmKgDA908bit0YcShwUFKZHgKUlxkCdCj3E73aiMJx9dlOtCtW6dXgHRH1a55CBxBHKN_m-a7BJ4jMjqWwUO4zhHXf1klae5xkSwhYXYBL-rbyy7ukF3lNw6gTl-Q1DJyelKbbD9oIAWilynkUkRM8FPW05-AWF5egEztaovEEVpmEtj4jSUJqlOOdTboO3MjlgkpDEI30KyosbnmkXPiS2V0g2CXy4-SDR97H1xJSmibsTUbhRQOuNe1qUb8mHlMgoMCkHn40VaS7yxyf0C1vGYIB9bm8GNermejVXOP9VYPT9Scid4KokSa4GqklBfyMgtE6KXAg2GXwGhPR75XZiEW1nK_XMXiz8WqtX5QlhaTCZvQumm1QF-efQI3GLmlLuUOvwPyh6LgfcsKSdCaG9VM_MRrXo4TO39iJq5MEVNRMDXrLG73zoO3m30K06knK9d3EmUt9JYFbdJLiAmosKtV1S3TqoUuVyMDBgr_WRMXP1deAE');
  runApp(
    LearngingManagementSystem(
      appRouter: AppRouter(),
      initialRoute: Routes.entryPoint
      )
  );
}