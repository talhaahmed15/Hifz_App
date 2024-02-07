import 'dart:convert';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hafiz_diary/provider/provider_class.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferences.getInstance().then((value) {
    lang = value.getString("lang") ?? "en";
  });
  await readJson();
  initializeNotifications();

  String storageLocation = (await getApplicationCacheDirectory()).path;

  await FastCachedImageConfig.init(
      subDir: storageLocation, clearCacheAfter: const Duration(days: 15));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProviderClass(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

void initializeNotifications() {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hafiz Diary',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: primaryColor, // Change this to the desired text color
            fontWeight:
                FontWeight.bold, // Change this to the desired font weight
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                primaryColor, // Change this to the desired background color
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

Future<void> readJson() async {
  final String response =
      await rootBundle.loadString('assets/json/surah_name.json');
  final data = await json.decode(response);

  for (int i = 0; i < data["data"].length; i++) {
    surahName.add(data['data'][i]['name']);
  }
}
