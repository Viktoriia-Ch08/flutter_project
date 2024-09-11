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
  TodoModel(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.status,
      this.isDone = false,
      required this.userId,
      required this.uid,
      required this.createdAt});

  final String? title;
  final String? description;
  final String? imageUrl;
  final String? status;
  bool isDone;
  final String userId;
  final String? uid;
  final Timestamp createdAt;
}
