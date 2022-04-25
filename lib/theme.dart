import 'package:flutter/material.dart';

import 'screen_utils/MyScreenUtil.dart';

const textColor = Colors.white;
const bodyTextColor = Color(0xFF525151);
const primaryColor = Color(0xFF97BF0D);
const secondaryColor = Color(0xFFD1D0D0);
var mutedTextColor = Colors.grey.shade400;
var mutedText = TextStyle(height: 2.5, color: Colors.grey.shade400);

var bodyText = TextStyle(color: bodyTextColor);
var styleBlackHeadline1 =
    TextStyle(color: bodyTextColor, fontSize: 32, fontWeight: FontWeight.w700);
var styleBlackHeadline2 =
    TextStyle(color: bodyTextColor, fontSize: 26, fontWeight: FontWeight.w700);
var stylePrimaryColorHeadline2 = TextStyle(fontSize: 22, color: primaryColor);
var styleMutedTextSmall = TextStyle(color: mutedTextColor, fontSize: 10);
var styleMutedTextMedium = TextStyle(color: mutedTextColor, fontSize: 14);
var stylePrimaryTextMedium = TextStyle(color: primaryColor, fontSize: 14);
var styleSmallBodyText = TextStyle(color: bodyTextColor, fontSize: 14);
var styleNormalBodyText = TextStyle(color: bodyTextColor, fontSize: 16);
var styleMediumPrimaryText = TextStyle(color: primaryColor, fontSize: 16);
var styleBoldSmallBodyText =
    TextStyle(color: bodyTextColor, fontSize: 14, fontWeight: FontWeight.w600);
var styleBoldBodyText =
    TextStyle(color: bodyTextColor, fontSize: 16, fontWeight: FontWeight.w600);

final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: Colors.grey[200]!,
      style: BorderStyle.solid,
    ));
final focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: Colors.grey[300]!,
      style: BorderStyle.solid,
    ));

var softShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.1),
  spreadRadius: 5,
  blurRadius: 7,
  offset: Offset(0, 3), // changes position of shadow
);

var darkerShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.5),
  spreadRadius: 5,
  blurRadius: 7,
  offset: Offset(0, 3), // changes position of shadow
);

var softCardShadow = BoxDecoration(
  borderRadius: BorderRadius.circular(8),
  color: Colors.white,
  boxShadow: [
    softShadow,
  ],
);

var tileShadow = BoxDecoration(
  borderRadius: BorderRadius.circular(6),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1),
      spreadRadius: 2,
      blurRadius: 5,
      offset: Offset(1, 3), // changes position of shadow
    )
  ],
);

const scoreHeaderStyle = TextStyle(
  letterSpacing: 2.0,
  color: Colors.orange,
  fontSize: 16,
  fontWeight: FontWeight.w400,
  shadows: [
    Shadow(
      blurRadius: 2.0,
      color: Colors.red,
    ),
  ],
);
const questionsHeaderStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic);

const answerBoxColor = Color(0xff283593);

const questionCircleAvatarBackground = Color(0xff22273a);

const questionCircleAvatarRadius = 14.0;

const answersLeadingStyle =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700);

const answersStyle =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500);

//
// ** Summary page **
//
const dividerHeight = 12.0;
const dividerColor = Colors.white;

const circleAvatarRadius = 12.0;
//const circleAvatarBackground = Colors.blue;
const circleAvatarBackground = Color(0xff4a5580);

const summaryScoreStyle = TextStyle(
    color: Colors.lime,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic);

const questionHeaderStyle = TextStyle(
    color: Colors.white54,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic);

const questionStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const correctsHeaderStyle = TextStyle(
  color: Colors.greenAccent,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const wrongsHeaderStyle = TextStyle(
  color: Colors.redAccent,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const notAnsweredHeaderStyle = TextStyle(
  color: Color(0xffe1e1e1),
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const correctAnswerStyle =
    TextStyle(color: Colors.green, fontWeight: FontWeight.w600);

const wrongAnswerStyle = TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic);

const notChosenStyle = TextStyle(
    color: Color(0xffe1e1e1),
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic);

TextStyle getTextStyleMutedTextSmall(MyScreenUtil screenUtil) {
  return TextStyle(
      color: mutedTextColor, fontSize: screenUtil.setSp(8) as double?);
}

TextStyle getTextStyleMutedTextMedium(MyScreenUtil? screenUtil) {
  return TextStyle(
      color: mutedTextColor,
      fontSize: (screenUtil == null) ? 10 : screenUtil.setSp(10) as double?);
}

TextStyle getTextStylePrimaryTextMedium(MyScreenUtil? screenUtil) {
  return TextStyle(
      color: mutedTextColor,
      fontSize: (screenUtil == null) ? 12 : screenUtil.setSp(12) as double?);
}

TextStyle getTextStylePrimaryTextBigTitle(MyScreenUtil? screenUtil) =>
    TextStyle(
      color: bodyTextColor,
      fontWeight: FontWeight.w600,
      fontSize: (screenUtil == null) ? 12 : screenUtil.setSp(12) as double?,
    );

TextStyle getTextStylePrimaryTextMediumTitle(MyScreenUtil? screenUtil) =>
    TextStyle(
      color: bodyTextColor,
      fontWeight: FontWeight.w500,
      fontSize: (screenUtil == null) ? 10 : screenUtil.setSp(10) as double?,
    );

TextStyle getTextStylePrimaryTextSmall(MyScreenUtil? screenUtil) => TextStyle(
      color: bodyTextColor,
      fontSize: (screenUtil == null) ? 8 : screenUtil.setSp(8) as double?,
    );

TextStyle getTextStylePrimaryTextSmallWhite(MyScreenUtil? screenUtil) =>
    TextStyle(
      color: textColor,
      fontSize: (screenUtil == null) ? 8 : screenUtil.setSp(8) as double?,
    );
