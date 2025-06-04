import 'package:flutter/material.dart';

void showSnackbar(
  String message,
  BuildContext context, {
  bool success = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: success == true ? Colors.green[700] : Colors.red[900],
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    ),
  );
}
