import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toast {
  Toast({required this.text});

  final String text;

  void showError() {
    toastification.show(
        title: Text(text),
        autoCloseDuration: const Duration(seconds: 5),
        borderSide: const BorderSide(color: Colors.transparent),
        backgroundColor: Colors.redAccent.withOpacity(0.5),
        style: ToastificationStyle.simple,
        alignment: Alignment.topCenter);
  }
}
