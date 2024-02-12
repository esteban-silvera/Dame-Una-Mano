import 'package:flutter/material.dart';

class AppDialogs {
  static showDialog1(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(message));
        });
  }

  static showDialog2(
      BuildContext context, String message, List<Widget>? actions) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(actions: actions, title: Text(message));
        });
  }
}
