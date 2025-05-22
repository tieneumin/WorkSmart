import 'package:flutter/material.dart';

void showErrorSnackbar(String error, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error),
      backgroundColor: Colors.red[900],
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    ),
  );
}
