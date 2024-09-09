import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_project/provider/user.dart';
import 'package:flutter_project/screens/auth.dart';
import 'package:flutter_project/services/firestore_service.dart';
import 'package:flutter_project/widgets/gallery_list.dart';
import 'package:flutter_project/widgets/user_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() {
    return _GalleryScreenState();
  }
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _setUserData();
  }

  void _setUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final storageUser = await FirestoreService().getUser(currentUser!.uid);

    if (storageUser == null) return;

    ref.read(userProvider.notifier).add(UserModel(
        name: storageUser['name'],
        email: storageUser['email'],
        uid: storageUser['uid'],
        imageUrl: storageUser['imageUrl']));
  }

  void _logout() {
    setState(() {
      isLoading = true;
    });

    FirebaseAuth.instance.signOut();
    ref.read(userProvider.notifier).delete();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              title: Text('Gallery',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white70)),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white70,
                    )),
                IconButton(
                    onPressed: _logout,
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white70,
                    ))
              ],
            ),
            body: Container(
              child: Column(
                children: [
                  if (user.name != null) const UserData(),
                  const SizedBox(
                    height: 20,
                  ),
                  const GalleryList(),
                ],
              ),
            ));
  }
}
