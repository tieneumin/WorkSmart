import 'package:flutter/material.dart';

void showSnackbar(String message, BuildContext context, {bool error = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: error == true ? Colors.red[700] : Colors.green[700],
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    ),
  );
}
