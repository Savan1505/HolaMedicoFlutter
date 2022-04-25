import 'package:flutter/material.dart';
import 'package:pharmaaccess/theme.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    BuildContext context, String message,
    {bool isSuccess = false}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: primaryColor,
      duration: Duration(seconds: isSuccess ? 1 : 3),
    ),
  );
}
