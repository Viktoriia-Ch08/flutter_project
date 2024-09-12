import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  void addUser(user, uid) async {
    await db.collection('users').doc(uid).set(user);
  }

  Future<Map<String, dynamic>?> getUser(uid) async {
    final user = await db.collection('users').doc(uid).get();

    if (user.data() == null) return null;

    return user.data();
  }

  void updateAvatar(imageUrl, uid) async {
    await db.collection('users').doc(uid).update({'imageUrl': imageUrl});
  }

  void addTodo(todo, uid) async {
    await db.collection('todos').doc(uid).set(todo);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTodos(uid) async {
    return await db.collection('todos').where('userId', isEqualTo: uid).get();
  }

  void deleteTodo(uid) {
    db.collection('todos').doc(uid).delete();
  }

  void updateTodo(todo, uid) async {
    await db.collection('todos').doc(uid).update(todo);
  }

  void updateIsDone(status, uid) async {
    await db.collection('todos').doc(uid).update({'isDone': status});
  }
}
