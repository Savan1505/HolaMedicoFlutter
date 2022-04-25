import 'package:flutter/material.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';

const kBottomContainerHeight = 80.0;
const kActiveCardColour = Color(0xFF111328);
const kInactiveCardColour = Colors.blue;
const kBottomContainerColour = Color(0xFFEB1555);
const kInactiveGrayColor = Color(0xFFF0F0F0);

const kLabelTextStyle = TextStyle(
  fontSize: 12.0,
  color: Color(0xFF8D8E98),
);

const kNumberTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w900,
);

const kLargeButtonTextStyle = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
);

const kTitleTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const kResultTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 12.0,
  fontWeight: FontWeight.bold,
);

const kBMITextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const kBodyTextStyle = TextStyle(
  fontSize: 17.0,
);

const kTextStyleBlack = TextStyle(
  fontSize: 15.0,
  color: Colors.black,
);

const kTextStyleWhite = TextStyle(
  fontSize: 15.0,
  color: Colors.white,
);

TextStyle getTitleTextStyle(MyScreenUtil screenUtil) => TextStyle(
      fontSize: screenUtil.setSp(16) as double?,
      fontWeight: FontWeight.bold,
    );

TextStyle getTitle2TextStyle(MyScreenUtil screenUtil) => TextStyle(
      fontSize: screenUtil.setSp(14) as double?,
      fontWeight: FontWeight.bold,
    );

TextStyle getResultTextStyle(MyScreenUtil screenUtil) => TextStyle(
      color: Colors.white,
      fontSize: screenUtil.setSp(12) as double?,
      fontWeight: FontWeight.bold,
    );

TextStyle getBodyTextStyle(MyScreenUtil screenUtil) => TextStyle(
      fontSize: screenUtil.setSp(17) as double?,
    );
