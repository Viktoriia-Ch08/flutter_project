import 'package:flutter/material.dart';
import 'package:flutter_project/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/screens/user_info.dart';
import 'firebase_options.dart';

final themeColor =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 103, 79, 158));

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case 'user-info':
            return MaterialPageRoute(builder: (context) => const UserInfo());
          default:
            return MaterialPageRoute(builder: (context) => const AuthScreen());
        }
      },
      theme: ThemeData().copyWith(colorScheme: themeColor),
      home: const AuthScreen(),
    );
  }
}
