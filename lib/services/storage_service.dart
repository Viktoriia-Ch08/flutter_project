import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final storage = FirebaseStorage.instance.ref();

  Future<String> upload(file, uid) async {
    final storageRef = storage.child('avatars').child('$uid.jpg');
    await storageRef.putFile(file);
    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }
}
