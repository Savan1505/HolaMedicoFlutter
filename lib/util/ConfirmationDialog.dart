import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaaccess/config/colors.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/widgets/PrimaryButton.dart';

class ConfirmationDialog {
  static String? returnSelectedOption;

  static String? returnSelectedOption2;

  static Future<String> dialog(
    BuildContext context, {
    String? title,
    String? content,
    Color? primaryColor,
    Color? buttonTextColor,
    String? option1,
    String? option2,
    MyScreenUtil? screenUtil,
    MainAxisSize? mainAxisSize,
    double horizontalPadding = 20.0,
    double? textScaleFactor,
  }) {
    Completer<String> completer = Completer<String>();
    if (option1 != null || option2 != null) {
      returnSelectedOption = option1;
      returnSelectedOption2 = option2;
    }

    showDialog(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenUtil!.setWidth(20.0) as double,
              vertical: screenUtil.setHeight(20.0) as double,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (title != null) titleWidget(title, screenUtil),
                if (content != null) contentWidget(title, content, screenUtil),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenUtil.setHeight(25.0) as double,
                  ),
                ),
                Row(
                    mainAxisSize:
                        mainAxisSize == null ? MainAxisSize.min : mainAxisSize,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (option2 != null)
                        confirmButton(
                          BackGroundGradientStart,
                          context,
                          screenUtil,
                          option2,
                          horizontalPadding,
                          onPressed: () {
                            completer.complete(returnSelectedOption2);

                            Navigator.of(context).pop();
                          },
                          textColor: buttonTextColor,
                        ),
                      if (option1 != null)
                        SizedBox(
                          width: screenUtil.setWidth(10.0) as double?,
                        ),
                      if (option1 != null)
                        Expanded(
                          child: confirmButton(
                            primaryColor,
                            context,
                            screenUtil,
                            option1,
                            horizontalPadding,
                            onPressed: () {
                              completer.complete(returnSelectedOption);

                              Navigator.of(context).pop();
                            },
                            textColor: buttonTextColor,
                          ),
                        ),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
    return completer.future;
  }

  static Widget titleWidget(String title, MyScreenUtil screenUtil) => Text(
        title,
        style: TextStyle(
          height: null,
          color: Colors.black,
          fontSize: screenUtil.setSp(18) as double?,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.center,
      );

  static Widget contentWidget(
          String? title, String content, MyScreenUtil screenUtil) =>
      Padding(
        padding: EdgeInsets.only(
          top: title == null
              ? screenUtil.setHeight(0.0) as double
              : screenUtil.setHeight(12.0) as double,
        ),
        child: Text(
          content,
          style: TextStyle(fontSize: screenUtil.setSp(14) as double?, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );

  static Widget confirmButton(
    Color? bgColor,
    BuildContext context,
    MyScreenUtil? screenUtil,
    String title,
    double horizontalPadding, {
    GestureTapCallback? onPressed,
    Color? textColor,
  }) {
    return PrimaryButton(
      bgColor: bgColor,
      title: title,
      textColor: textColor,
      screenUtil: screenUtil,
      onPressed: onPressed,
      verticalPadding: 10.0,
      horizontalPadding: horizontalPadding,
    );
  }
}
