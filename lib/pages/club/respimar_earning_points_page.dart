import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/components/timeline.dart';

import '../../theme.dart';

class RespimarEarningPointsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("How to Earn MCP"),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Respimar Club',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 34,
                  fontWeight: FontWeight.w600)),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(18),
              padding:
                  EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 60),
              decoration: softCardShadow,
              child: Timeline(
                children: <Widget>[
                  // getItem("Respimar recorded webinars",
                  //     "Watch Respimar recorded webinars in the Educational Section in Socrates and answer questions (500 RCPs)"),
                  getItem("Respimar video",
                      "Watch Respimar video in the Brands Section and answer questions (400 MCPs per month)"),
                  // getItem("Respimar competition",
                  //     "Participate in Respimar competition. You will be notified periodically about competition details (500 RCPs)"),
                  getItem("Socrates",
                      "Answer questions in Socrates with maximum 5 questions per day (150 MCPs per month)"),
                  // getItem("Add \"Referrals\"",
                  //     "Refer your colleague physicians and gain (500 points) for each referral"),
                ],
                indicators: <Widget>[
                  // primaryCircle(),
                  // primaryCircle(),
                  primaryCircle(),
                  primaryCircle(),
                  // primaryCircle(),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Column getItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: stylePrimaryTextMedium),
        RichText(
          text: TextSpan(
            style: styleSmallBodyText, //children will inherit
            children: <TextSpan>[
              TextSpan(text: description),
            ],
          ),
        ),
      ],
    );
  }
}

Widget primaryCircle() {
  return Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
  );
}
