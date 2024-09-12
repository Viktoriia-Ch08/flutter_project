import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum StatusTitle { high, medium, low }

class Status {
  Status({this.title = StatusTitle.low, this.color = Colors.green});

  final StatusTitle title;
  final Color color;
}

final statusData = [
  Status(title: StatusTitle.high, color: Colors.red.shade400),
  Status(title: StatusTitle.medium, color: Colors.yellow.shade300),
  Status(title: StatusTitle.low, color: Colors.green),
];

class TodoModel {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? status;
  bool isDone;
  final String? userId;
  final String? uid;
  final Timestamp createdAt;

  TodoModel(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.status,
      this.isDone = false,
      required this.userId,
      required this.uid,
      required this.createdAt});

  factory TodoModel.fromJSON(Map<String, dynamic> todo) {
    return TodoModel(
        title: todo['title'],
        description: todo['description'],
        imageUrl: todo['imageUrl'],
        status: todo['status'],
        userId: todo['userId'],
        uid: todo['uid'],
        createdAt: todo['createdAt']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'status': status,
      'userId': userId,
      'uid': uid,
      'createdAt': createdAt,
      'isDone': isDone
    };
  }

  TodoModel copyWith({
    final String? title,
    final String? description,
    final String? imageUrl,
    final String? status,
    bool? isDone,
    final Timestamp? createdAt,
    final String? uid,
    final String? userId,
  }) {
    return TodoModel(
      title: title ?? this.title,
      userId: userId ?? this.userId,
      uid: uid ?? this.uid,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TodosList {
  final List<TodoModel>? todos;

  TodosList({this.todos});

  factory TodosList.fromJSON(QuerySnapshot storageTodos) {
    var allTodos = storageTodos.docs;

    List<TodoModel> todosList = allTodos.map((doc) {
      Map<String, dynamic> todo = doc.data() as Map<String, dynamic>;
      return TodoModel.fromJSON(todo);
    }).toList();

    return TodosList(todos: todosList);
  }
}
