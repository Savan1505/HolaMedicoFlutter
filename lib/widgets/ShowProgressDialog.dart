import 'package:flutter/material.dart';

Future<dynamic> showProgressDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}

hideDialog(BuildContext context) {
  Navigator.of(context).pop();
}
