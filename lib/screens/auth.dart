import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/main.dart';
import 'package:flutter_project/services/firestore_service.dart';
import 'package:flutter_project/toast/toast.dart';
import 'package:flutter_project/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;

  Future<void> onSave(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      if (isLogin) {
        final data = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        if (data.user == null) return;

        final storageUser = await FirestoreService().getUser(data.user!.uid);

        if (storageUser != null) {
          navigatorKey.currentState?.pushReplacementNamed('gallery');
          return;
        }

        navigatorKey.currentState?.pushNamed('user-info');
        return;
      }

      final data = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (data.user == null) return;

      navigatorKey.currentState?.pushNamed('user-info');
    } on FirebaseException catch (err) {
      setState(() {
        isLoading = false;
        isLogin = true;
      });
      if (err.code == 'email-already-in-use') {
        Toast(text: const Text('Email already in use. Login!')).showError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.amber,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLogin ? 'Welcome back' : 'Create an account',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthForm(onSave: onSave),
                      TextButton(
                          onPressed: () => setState(() {
                                isLogin = !isLogin;
                              }),
                          child: Text(
                            isLogin
                                ? 'Create an account'
                                : 'Already have an account?',
                            style: const TextStyle(color: Colors.white70),
                          ))
                    ],
                  )));
  }
}
