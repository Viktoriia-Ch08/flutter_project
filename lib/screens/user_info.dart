import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/main.dart';
import 'package:flutter_project/models/user_model.dart';
import 'package:flutter_project/provider/user.dart';
import 'package:flutter_project/services/firestore_service.dart';
import 'package:flutter_project/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() {
    return _UserInfoState();
  }
}

class _UserInfoState extends ConsumerState<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  String? _enteredName;
  bool isLoading = false;

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();

      if (_pickedImage == null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Add an avatar')));
      }

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) return;

      final imgUrl =
          await StorageService().upload(_pickedImage, currentUser.uid);

      final user = UserModel(
          name: _enteredName,
          email: currentUser.email,
          uid: currentUser.uid,
          imageUrl: imgUrl);

      ref.read(userProvider.notifier).addUser(user);

      navigatorKey.currentState?.pushNamed('gallery');
      
      FirestoreService().addUser({
        'name': _enteredName,
        'email': currentUser.email,
        'uid': currentUser.uid,
        'imageUrl': imgUrl
      }, currentUser.uid);
    }
  }

  void _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    setState(() {
      _pickedImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.amber,
              )
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                child: Card(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  maxRadius: 60,
                                  backgroundColor: Colors.grey[400],
                                  foregroundImage: _pickedImage != null
                                      ? FileImage(_pickedImage!)
                                      : null,
                                ),
                                Positioned(
                                    child: IconButton(
                                        onPressed: _pickImage,
                                        icon: Icon(
                                          Icons.camera,
                                          size: 40,
                                          color: _pickedImage == null
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer
                                              : Colors.transparent,
                                        )))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              maxLength: 50,
                              textCapitalization: TextCapitalization.none,
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.trim().length > 50) {
                                  return 'Enter valid name';
                                }
                                return null;
                              },
                              onSaved: (newValue) => _enteredName = newValue,
                            ),
                            OutlinedButton(
                                onPressed: _onSave, child: const Text('Submit'))
                          ],
                        ),
                      )),
                ),
              ),
      ),
    );
  }
}
