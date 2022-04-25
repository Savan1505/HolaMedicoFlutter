import 'package:flutter/material.dart';
import 'package:pharmaaccess/theme.dart';

Future<DateTime?> datePicker(
    BuildContext context, DateTime selectedDate) async {
  return await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(1500),
    lastDate: DateTime(3101),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: primaryColor,
          accentColor: primaryColor,
          colorScheme: ColorScheme.light(primary: primaryColor),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      );
    },
  );
}
