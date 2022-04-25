import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/components/timeline.dart';

import '../../theme.dart';

class MDEarningPointsPage extends StatelessWidget {
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
          child: Text('MD Club',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Registration", style: stylePrimaryTextMedium),
                      RichText(
                        text: TextSpan(
                          style: styleSmallBodyText, //children will inherit
                          children: <TextSpan>[
                            TextSpan(
                                text: "Upon registration of the application "),
                            TextSpan(
                                text: "(100 medical contribution points)",
                                style: styleBoldSmallBodyText),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Watch a Promotional Video",
                          style: stylePrimaryTextMedium),
                      RichText(
                        text: TextSpan(
                          style: styleSmallBodyText, //children will inherit
                          children: <TextSpan>[
                            TextSpan(text: "Watch a promotional video "),
                            TextSpan(
                                text: "(25 Medical Contribution points)",
                                style: styleBoldSmallBodyText),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Participtate in quiz or survey (5 questions)",
                          style: stylePrimaryTextMedium),
                      RichText(
                        text: TextSpan(
                          style: styleSmallBodyText, //children will inherit
                          children: <TextSpan>[
                            TextSpan(
                                text: "Participate in any quiz or survey "),
                            TextSpan(
                                text: "(25 medical contribution points)",
                                style: styleBoldSmallBodyText),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Participate in Cerebrum ",
                          style: stylePrimaryTextMedium),
                      Text(
                          "Participate in Cerebrum enhancement games (to be decided when we see the games)")
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Participate in Socrates Quiz questions",
                          style: stylePrimaryTextMedium),
                      RichText(
                        text: TextSpan(
                          style: styleSmallBodyText, //children will inherit
                          children: <TextSpan>[
                            TextSpan(text: "Respond to Socrates questions "),
                            TextSpan(
                                text: "(100 medical contribution points)",
                                style: styleBoldSmallBodyText),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Participate in Survey",
                          style: stylePrimaryTextMedium),
                      RichText(
                        text: TextSpan(
                          style: styleSmallBodyText, //children will inherit
                          children: <TextSpan>[
                            TextSpan(text: "Quiz or survey participation "),
                            TextSpan(
                                text:
                                    "(max 5 questions) (25 medical contribution points)",
                                style: styleBoldSmallBodyText),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                indicators: <Widget>[
                  primaryCircle(),
                  primaryCircle(),
                  primaryCircle(),
                  primaryCircle(),
                  primaryCircle(),
                  primaryCircle(),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

Widget primaryCircle() {
  return Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
  );
}
