import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/property_model.dart';
import 'package:pharmaaccess/util/helper_functions.dart';

import '../../theme.dart';
import 'comprehension_page.dart';

class GameLandingPage extends StatefulWidget {
  @override
  _GameLandingPageState createState() => _GameLandingPageState();
}

class _GameLandingPageState extends State<GameLandingPage> {
  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(GAME_SCREEN, param: {"name": "Games Screen"});
  }

  var dbProvider = DBProvider();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Container(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Image.asset('assets/images/game_landing.png'),
          GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComprehensionPage(),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 42),
              padding: EdgeInsets.symmetric(vertical: 18),
              decoration: softCardShadow,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text('Focus',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: bodyTextColor)),
            ),
          ),
          FutureBuilder<List<PropertyModel>>(
              future: fetchOrInitialize('game_focus',
                  ['comprehensions', 'number_of_questions', 'correct_answers']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) return Container();
                  List<PropertyModel> properties = snapshot.data!;
                  int? comprehensions = 0, questions = 0, correctAnswers = 0;

                  if (properties.isNotEmpty) {
                    comprehensions = properties
                        .firstWhere((p) => p.propertyName == 'comprehensions',
                            orElse: () => PropertyModel(propertyValueInt: 0))
                        .propertyValueInt;

                    questions = properties
                        .firstWhere(
                            (p) => p.propertyName == 'number_of_questions',
                            orElse: () => PropertyModel(propertyValueInt: 0))
                        .propertyValueInt;

                    correctAnswers = properties
                        .firstWhere((p) => p.propertyName == 'correct_answers',
                            orElse: () => PropertyModel(propertyValueInt: 0))
                        .propertyValueInt;
                  }

                  return Column(
                    children: <Widget>[
                      // Divider(height: 8, color: Color(0x00FFFFFF),),
                      // RichText(
                      //   text: TextSpan(
                      //     children: <TextSpan>[
                      //       TextSpan(
                      //           text: "Score ",
                      //           style: styleNormalBodyText.copyWith(
                      //             color: primaryColor,
                      //             fontWeight: FontWeight.w600,
                      //             fontSize: 26,
                      //           ),
                      //       ),
                      //       TextSpan(
                      //         text: gameScore.accumulatedScore.toString(),
                      //         style: styleNormalBodyText.copyWith(
                      //           fontSize: 26,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Divider(
                        height: 14,
                        color: Color(0x00FFFFFF),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Comprehensions", style: styleNormalBodyText),
                          Text("Questions Taken", style: styleNormalBodyText),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(comprehensions.toString().padLeft(2, '0'),
                              style: styleMediumPrimaryText),
                          Text(questions.toString().padLeft(2, '0'),
                              style: styleMediumPrimaryText),
                        ],
                      ),
                      Divider(
                        height: 10,
                        color: Color(0x00FFFFFF),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text("Correct Answers", style: styleNormalBodyText),
                          Text("Score Percentage", style: styleNormalBodyText),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(correctAnswers.toString().padLeft(2, '0'),
                              style: styleMediumPrimaryText),
                          Text(
                              questions == 0
                                  ? '00'
                                  : ((correctAnswers! / questions!) * 100)
                                      .ceil()
                                      .toString()
                                      .padLeft(2, '0'),
                              style: styleMediumPrimaryText),
                        ],
                      ),
                    ],
                  );
                }
                return Container();
              }),
        ],
      ),
    );
  }
}
