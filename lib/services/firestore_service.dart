import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/models/todo_model.dart';

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

  void addTodo(todo, uid) async {
    await db.collection('todos').doc(uid).set(todo);
  }

  Future<List<TodoModel>> getTodos(uid) async {
    final todos =
        await db.collection('todos').where('userId', isEqualTo: uid).get();

    List<TodoModel> allTodos = [];

    for (var doc in todos.docs) {
      allTodos.add(TodoModel(
          title: doc.get('title'),
          description: doc.get('description'),
          imageUrl: doc.get('imageUrl'),
          status: doc.get('status'),
          userId: doc.get('userId'),
          isDone: doc.get('isDone'),
          uid: doc.get('uid'),
          createdAt: doc.get('createdAt')));
    }
    return allTodos;
  }

  void deleteTodo(uid) {
    db.collection('todos').doc(uid).delete();
  }

  void updateTodo(todo, uid) async {
    await db.collection('todos').doc(uid).update(todo);
  }
}
