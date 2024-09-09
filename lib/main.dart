import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_project/provider/user.dart';
import 'package:flutter_project/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/screens/gallery.dart';
import 'package:flutter_project/screens/user_info.dart';
import 'package:flutter_project/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'firebase_options.dart';

final themeColor =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 103, 79, 158));

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final currentUser = FirebaseAuth.instance.currentUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends ConsumerState<MyApp> {
  Widget content = const AuthScreen();
  var storageUser;

  @override
  void initState() {
    super.initState();
    _setUserData();
  }

  void _setUserData() async {
    if (currentUser == null) return;

    storageUser = await FirestoreService().getUser(currentUser!.uid);

    if (storageUser == null) return;

    ref.read(userProvider.notifier).add(UserModel(
        name: storageUser['name'],
        email: storageUser['email'],
        uid: storageUser['uid'],
        imageUrl: storageUser['imageUrl']));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (currentUser != null && user.name != null) {
      content = const GalleryScreen();
    }

    return ToastificationWrapper(
      child: MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case 'user-info':
              return MaterialPageRoute(
                  builder: (context) => const UserInfoScreen());
            case 'gallery':
              return MaterialPageRoute(
                  builder: (context) => const GalleryScreen());
            case 'login':
              return MaterialPageRoute(
                  builder: (context) => const AuthScreen());
          default:
            return MaterialPageRoute(builder: (context) => const AuthScreen());
        }
      },
      theme: ThemeData().copyWith(colorScheme: themeColor),
        home: content,
      ),
    );
  }
}
