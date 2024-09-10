import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final avatarStorageRef = FirebaseStorage.instance.ref().child('avatars');
  final todoStorageRef = FirebaseStorage.instance.ref().child('todos');
  final uuid = Uuid().v4();

  Future<String> upload(file, uid) async {
    final avatarRef = avatarStorageRef.child('$uid.jpg');
    await avatarRef.putFile(file);
    final imageUrl = await avatarRef.getDownloadURL();
    return imageUrl;
  }

  Future<String> uploadTodoImage(file, uid) async {
    final todoRef = todoStorageRef.child('$uid.jpg');
    await todoRef.putFile(file);

    return await todoRef.getDownloadURL();
  }

  void deleteTodoImage(uid) {
    todoStorageRef.child('$uid.jpg').delete();
  }
}
