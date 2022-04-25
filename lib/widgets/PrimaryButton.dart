import 'package:flutter/material.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    this.key,
    required this.onPressed,
    required this.screenUtil,
    required this.title,
    required this.bgColor,
    this.borderColor,
    this.textColor,
    this.fontSize = 10.0,
    this.horizontalPadding = 15,
    this.verticalPadding = 12,
    this.elevation = 0.0,
    this.disableColor,
  });

  final Key? key;
  final MyScreenUtil? screenUtil;
  final GestureTapCallback? onPressed;
  final String title;
  final Color? borderColor;
  final Color? bgColor;
  final double horizontalPadding;
  final double verticalPadding;
  final Color? textColor;
  final double fontSize;
  final double elevation;
  final Color? disableColor;

  @override
  Widget build(BuildContext context) => MaterialButton(
        shape: StadiumBorder(),
        elevation: elevation,
        onPressed: onPressed,
        color: bgColor,
        disabledColor: disableColor,
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenUtil!.setWidth(horizontalPadding) as double,
              vertical: screenUtil!.setHeight(verticalPadding) as double,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: screenUtil!.setSp(fontSize) as double?,
                color: Colors.white,
                height: null,
              ),
              maxLines: 1,
            )),
      );
}
