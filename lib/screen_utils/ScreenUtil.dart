import 'package:flutter/cupertino.dart';

import 'MyScreenUtil.dart';

double defaultScreenWidth = 360.0;
double defaultScreenHeight = 640.0;
double screenWidth = defaultScreenWidth;
double screenHeight = defaultScreenHeight;

MyScreenUtil getScreenUtilInstance(BuildContext context) {
  MyScreenUtil.init(context,
      allowFontScaling: true,
      height: defaultScreenHeight,
      width: defaultScreenWidth);

  return MyScreenUtil();
}
