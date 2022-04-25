import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/components/app_webview.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/pages/avicenna_expert_message/Avicenna_Message_Expert_Page.dart';
import 'package:pharmaaccess/pages/club/md_club_landing_page.dart';
import 'package:pharmaaccess/pages/icpd/icpd_page.dart';
import 'package:pharmaaccess/pages/quiz/quiz_category_page.dart';
import 'package:pharmaaccess/services/quiz_service.dart';

import '../../theme.dart';

class QuizLandingPage extends StatelessWidget {
  @override
  StatelessElement createElement() {
    firebaseAnalyticsEventCall(SOCRATES_SELECTION_EVENT,
        param: {"name": "Socrates Screen"});
    return super.createElement();
  }

  final QuizService quizService = QuizService();
  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 32, bottom: 10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Text("Welcome to Socrates", style: styleBoldBodyText),
                      Text("Your personal development section in",
                          style: styleNormalBodyText),
                      Text("Hola Medico", style: styleBlackHeadline2),
                    ],
                  )),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    top: 28,
                    left: 8,
                    right: 8,
                    bottom: 18,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 150,
                            padding: EdgeInsets.only(top: 6),
                            margin: EdgeInsets.only(right: 50),
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
                              callback: (index) async {
                                await firebaseAnalyticsEventCall(
                                    SOCRATES_SELECTION_EVENT,
                                    param: {"name": "Educational Support"});
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MyWebView(
                                      title: "Educational Support",
                                      selectedUrl:
                                          'https://content.pharmaaccess.com/static/mrcp/EduSupportHomepage.html',
                                    ),
                                  ),
                                );
                              },
                              icon: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Image.asset(
                                  'assets/images/learning_educational_support.png',
                                  width: 60,
                                ),
                              ),
                              text: Container(
                                padding: EdgeInsets.only(top: 12),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Educational",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Support",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            height: 150,
                            padding: EdgeInsets.only(top: 6),
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
                            child: MDVerticalButton(
                              index: 2,
                              callback: (index) async {
                                await firebaseAnalyticsEventCall(
                                    SOCRATES_SELECTION_EVENT,
                                    param: {"name": "Quiz"});
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        QuizCategoryPage()));
                              },
                              icon: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Image.asset(
                                  'assets/images/learning_quiz.png',
                                  width: 60,
                                ),
                              ),
                              text: Container(
                                padding: EdgeInsets.only(top: 12),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Quiz",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      " ",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 150,
                            padding: EdgeInsets.only(top: 6),
                            margin: EdgeInsets.only(right: 50),
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
                              index: 3,
                              callback: (index) async {
                                await firebaseAnalyticsEventCall(
                                  SOCRATES_SELECTION_EVENT,
                                  param: {"name": "iCPD"},
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        IcpdPage(),
                                  ),
                                );
                              },
                              icon: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Image.asset(
                                  'assets/images/icon_icpd_socrates.png',
                                  width: 60,
                                ),
                              ),
                              text: Container(
                                padding: EdgeInsets.only(top: 12),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "iCPD",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      " ",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            height: 150,
                            padding: EdgeInsets.only(top: 6),
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
                            child: MDVerticalButton(
                              index: 4,
                              callback: (index) async {
                                await firebaseAnalyticsEventCall(
                                    SOCRATES_SELECTION_EVENT,
                                    param: {"name": "Avicenna"});
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AvicennaMessageExpertPage(
                                      titleName: "Avicenna",
                                      categoryId: 1,
                                    ),
                                  ),
                                );
                              },
                              icon: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Image.asset(
                                  'assets/images/icon_avicenna.png',
                                  width: 60,
                                ),
                              ),
                              text: Container(
                                padding: EdgeInsets.only(top: 12),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Avicenna",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      " ",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 150,
                            padding: EdgeInsets.only(top: 6),
                            margin: EdgeInsets.only(right: 40),
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
                              index: 5,
                              callback: (index) async {
                                await firebaseAnalyticsEventCall(
                                    SOCRATES_SELECTION_EVENT,
                                    param: {"name": "Message from Expert"});
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AvicennaMessageExpertPage(
                                      titleName: "Message from Expert",
                                      categoryId: 3,
                                    ),
                                  ),
                                );
                              },
                              icon: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                child: Image.asset(
                                  'assets/images/icon_message_from_expert.png',
                                  width: 60,
                                ),
                              ),
                              text: Container(
                                padding: EdgeInsets.only(top: 12),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Message",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "from",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Expert",
                                      style: TextStyle(
                                        color: Color(0xFF6F706F),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            height: 150,
                            padding: EdgeInsets.only(top: 6),
                            margin: EdgeInsets.only(right: 60),
                            width: 60,
                            /*decoration: BoxDecoration(
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
                            ),*/
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
