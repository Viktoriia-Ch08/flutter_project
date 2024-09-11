import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_project/provider/user.dart';
import 'package:flutter_project/services/firestore_service.dart';
import 'package:flutter_project/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends ConsumerState<Profile> {
  void _updateAvatar(UserModel user) async {
    final img = await ImagePicker().pickImage(source: ImageSource.camera);

    if (img == null) return;

    final newFile = File(img.path);

    final avatarUrl = await StorageService().upload(newFile, user.uid);

    final updatedUser = UserModel(
        name: user.name, email: user.email, uid: user.uid, imageUrl: avatarUrl);

    ref.read(userProvider.notifier).updateAvatar(updatedUser);

    FirestoreService().updateAvatar(avatarUrl, user.uid);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _updateAvatar(user),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              foregroundImage:
                  user.imageUrl != null ? NetworkImage(user.imageUrl!) : null,
              maxRadius: 80,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(user.name!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white70)),
          Text(user.email!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}
