import 'package:flutter/material.dart';

import '../theme.dart';

Widget getCommonButton({required String title, Function? onClick}) =>
    GestureDetector(
      child: Card(
        margin: EdgeInsets.only(left: 30, right: 30, top: 12),
        // padding: EdgeInsets.only(top: 12, bottom: 12),
        // decoration: softCardShadow,
        child: Container(
          // decoration: softCardShadow,
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      onTap: () {
        onClick!();
      },
    );

Widget getCommonCalculateButton(
        {String? title, Function? onClick, bool isUpperCase = true}) =>
    GestureDetector(
      child: Card(
        elevation: 1.5,
        margin: EdgeInsets.only(left: 15, right: 15, top: 12),
        color: primaryColor,
        // padding: EdgeInsets.only(top: 12, bottom: 12),
        // decoration: softCardShadow,
        child: Container(
          // decoration: softCardShadow,
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: Center(
            child: Text(
              isUpperCase ? title!.toUpperCase() : title!,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18),
            ),
          ),
        ),
      ),
      onTap: () {
        onClick!();
      },
    );
