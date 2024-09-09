// db = FirebaseFirestore.instance;

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  void addUser(user, uid) async {
    await db.collection('users').doc(uid).set(user);
    print(user['name']);
  }

  Future<Map<String, dynamic>?> getUser(uid) async {
    final user = await db.collection('users').doc(uid).get();

    if (user.data() == null) return null;

    return user.data();
  }
}
