import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
    Stripe.publishableKey = 'pk_test_51RuQwxBltpwFAR5eQGRQctb6L9PJ2BSbPdspRoYJuv3pQHQMysTyIPUxna0rVw9Bn8L3dkM8OfEP8V4erc8soSA2000j9Q3o0C';
await Stripe.instance.applySettings();


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
 // SharedPrefHelper.clearAllData();
  SharedPrefHelper.setData('accessToken', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5ZmMxOTc4Ni1hYmYxLTQxYzAtOWNmZC01M2FlODM0NDFkNTMiLCJqdGkiOiIwMGFmYmIyYjhlY2IzOGU3NTNjZjk1YjNiZGZhNTQzYTJlODZlNDc4NzYyM2FmNWNhOTA2NjBhNjNiNDZkYzVmNDUwOTk2ODg4NjYwZmJjZiIsImlhdCI6MTc1NzA3NzEyMi41MTAwMjIsIm5iZiI6MTc1NzA3NzEyMi41MTAwMjcsImV4cCI6MTc4ODYxMzEyMi40NzMwNDYsInN1YiI6IjMiLCJzY29wZXMiOltdfQ.TSEvOkD9MhGAWe_y4SRY-xEP2sL3dW9mMR-zVBXf7sZ-fUX6ziEr22nd1BhjCd8kB33LE8ytvVrpWf2U5-2OSWMLGsV2lwdqO0p8c-WEVrzLyw3Qi5e8rLzEqCfV5XoqNTDaUch2jdFNFMZKUzlVn5Z02T-tDHj2mARFjO2dvH_QYAqBLJ0YbMMABGy3bb_QpOP_OkXRe8yoBMKHoHfgE937PqIpx8ej-e0QQcpbfviKY8ffElJn5lUAKwfPc0YPfyLl6w7sZdB5p5TPIF8ywQRfvF3_v09XmNqbHBOEfEorusTci6WEopcQ7WWalX1aHzBcQAEx3ZZzpdVZUCTf6UROmKwNez1SGhId7aKemKShCGtcYrEDYrK_ro1aWp0vh2A_jD6L8v6f-2lqY6c18MPsGVBuVWiob0LEm2H2YI6t7ItCxCCRjF_LiSzj3BoooDDy4TSPdjgxNtkbUSkk51CfX182GbI1KSJw4sZ1BcM_RIBxbNZRoA7MEm7UUizJl404puLn2NkjV_mq4dUklifelFbfx0Vz-E2vdtGlEAwKpuHOOyxY1C-TUo5mEIB_fsV0X_dHOcIfcC8x1JxANCdZAIgr0bfY8VljdrGHAjK4bSn3fqtIbwYeTh7SmgPEqQDBiAVw8Msbhz3xLrhm2SLYVLgXZi49d047FFXZAZo');
  runApp(
    LearngingManagementSystem(
      appRouter: AppRouter(),
      initialRoute: Routes.entryPoint
      )
  );
}