import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/ClubsModel.dart';
import 'package:pharmaaccess/pages/club/md_club_landing_page.dart';
import 'package:pharmaaccess/pages/club/respimar_club_landing_page.dart';
import 'package:pharmaaccess/services/quiz_service.dart';
import 'package:pharmaaccess/services/score_service.dart';

import '../../theme.dart';

class ClubLandingPage extends StatelessWidget {
  @override
  StatelessElement createElement() {
    firebaseAnalyticsEventCall(CLUB_SCREEN, param: {"name": "Clubs Screen"});
    return super.createElement();
  }

  final QuizService quizService = QuizService();
  var scoreService = ScoreService();

  @override
  Widget build(BuildContext context) => Container(
          child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text("Welcome to Cinfa Club", style: styleBoldBodyText),
                  Text("Your personal rewards redemption section in",
                      style: styleNormalBodyText),
                  Text("Hola Medico", style: styleBlackHeadline2),
                ],
              ),
            ),
          ),
          FutureBuilder<List<ClubsModel>?>(
              future: scoreService.getClubs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  bool isMdClub = false;
                  bool isRespimarClub = false;
                  snapshot.data!.forEach((element) {
                    if (element.name!.contains("Respimar")) {
                      isRespimarClub = true;
                    }
                    if (element.name!.contains("MD")) {
                      isMdClub = true;
                    }
                  });
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                          top: 8,
                          left: 8,
                          right: 8,
                          bottom: 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (isMdClub) ...[
                              Expanded(
                                child: Container(
                                  height: 140,
                                  margin: EdgeInsets.only(right: 30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: MDVerticalButton(
                                    index: 1,
                                    callback: (index) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MDClubLandingPage(),
                                        ),
                                      );
                                    },
                                    icon: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Image.asset(
                                        'assets/images/md_club.png',
                                        width: 40,
                                      ),
                                    ),
                                    text: Container(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "MD Club",
                                            style: TextStyle(
                                              color: Color(0xFF6F706F),
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            " ",
                                            style: TextStyle(
                                              color: Color(0xFF6F706F),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                            if (isRespimarClub) ...[
                              Expanded(
                                child: Container(
                                  height: 140,
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: RCVerticalButton(
                                    index: 2,
                                    callback: (index) => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                RespimarClubLandingPage())),
                                    icon: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Image.asset(
                                        'assets/images/meeting.png',
                                        width: 40,
                                      ),
                                    ),
                                    text: Container(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Respimar",
                                            style: TextStyle(
                                              color: Color(0xFF6F706F),
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            "Club",
                                            style: TextStyle(
                                              color: Color(0xFF6F706F),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Your current MCP',
                                  style: styleBoldSmallBodyText),
                              InkWell(
                                child: Text(
                                  scoreService
                                      .getScoreT()
                                      .toString()
                                      .padLeft(4, '0'),
                                  style: styleBlackHeadline1.copyWith(
                                      fontSize: 52),
                                ),
                                onTap: () async {
                                  await scoreService.refreshScore();
                                  //setState(() {});
                                },
                              ),
                              Text(
                                  '1 point = 1 MCP (Medical Contribution Points)',
                                  style: styleMutedTextMedium),
                              // Text('1 point = 1 MCP (Medical Contribution Points)',
                              //     style: styleMutedTextMedium),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return Center(
                      child: Text("Can't fetch the score information"));
                }
                return Center(child: CircularProgressIndicator());
              }),

          /*  FutureBuilder<PartnerScoreModel>(
                future: scoreService.getScore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    var points = scoreService.getPoints();
                    var transactions = scoreService.getTransactions();
                    return Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 16),
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    child: Text(
                                      snapshot.data.score
                                          .toString()
                                          .padLeft(4, '0'),
                                      style: styleBlackHeadline1.copyWith(
                                          fontSize: 52),
                                    ),
                                    onTap: () async {
                                      await scoreService.refreshScore();
                                      //setState(() {});
                                    },
                                  ),
                                  Text(
                                      '1 point = 1 MCP (Medical Contribution Points)',
                                      style: styleMutedTextMedium),
                                ],
                              ),
                            ),
                          ],
                        ));
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      !snapshot.hasData) {
                    return Center(
                        child: Text("Can't fetch the score information"));
                  }
                  return Center(child: CircularProgressIndicator());
                }), */
        ],
      ));
}
