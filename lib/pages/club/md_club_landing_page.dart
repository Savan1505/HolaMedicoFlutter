import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/score_model.dart';
import 'package:pharmaaccess/pages/club/md_earning_points_page%20copy.dart';
import 'package:pharmaaccess/pages/club/redeem_points_page.dart';
import 'package:pharmaaccess/services/score_service.dart';
import 'package:pharmaaccess/widgets/CommonOverflowMenu.dart';

import '../../theme.dart';
import 'promo_code_page.dart';

class MDClubLandingPage extends StatefulWidget {
  @override
  _MDClubLandingPageState createState() => _MDClubLandingPageState();
}

class _MDClubLandingPageState extends State<MDClubLandingPage>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    firebaseAnalyticsEventCall(MDCLUB_SCREEN,
        param: {"name": "MD Club Screen"});
  }

  void buttonClicked(int? index) {
    if (index == 0) {
      //display invite friends page
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => PromoCodePage()));
      return;
    }
    if (index == 1) {
      //redeem points page
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => RedeemPointsPage()));
      return;
    }
    //Earning points page
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MDEarningPointsPage()));
    return;
  }

  @override
  Widget build(BuildContext context) {
    var scoreService = ScoreService();
    return Material(
      child: Scaffold(
        appBar: AppBar(
          primary: true,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Image.asset(
              'assets/images/app_logo_small.png',
              height: 32,
            ),
          ),
          titleSpacing: 0,
          backgroundColor: primaryColor,
          actions: <Widget>[
            CommonOverFlowMenu(),
          ],
        ),
        body: FutureBuilder<PartnerScoreModel?>(
            future: scoreService.getScore(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                var points = scoreService.getPoints()!;
                var transactions = scoreService.getTransactions()!;
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
                              Text('MD Club',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w600)),
                              // InkWell(
                              //   child: Text(
                              //     snapshot.data.score
                              //         .toString()
                              //         .padLeft(4, '0'),
                              //     style: styleBlackHeadline1.copyWith(
                              //         fontSize: 52),
                              //   ),
                              //   onTap: () async {
                              //     await scoreService.refreshScore();
                              //     setState(() {});
                              //   },
                              // ),
                              // Text(
                              //     '1 point = 1 MCP (Medical Contribution Points)',
                              //     style: styleMutedTextMedium),
                            ],
                          ),
                        ),
                        Container(
                          height: 78,
                          color: Colors.white,
                          padding: EdgeInsets.only(
                            top: 0,
                            left: 18,
                            right: 18,
                            bottom: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              MDVerticalButton(
                                index: 0,
                                callback: buttonClicked,
                                icon: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: SvgPicture.asset(
                                      'assets/images/invite_friends.svg',
                                      width: 26),
                                ),
                                text: Text(
                                  "Enter Promo",
                                  style: TextStyle(
                                    color: Color(0xFFCBCBC9),
                                  ),
                                ),
                                color: Colors.white,
                              ),
                              MDVerticalButton(
                                index: 1,
                                callback: buttonClicked,
                                icon: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: SvgPicture.asset(
                                      'assets/images/redeem_points.svg',
                                      width: 26),
                                ),
                                text: Text(
                                  "Redeem Points",
                                  style: TextStyle(
                                    color: Color(0xFFCBCBC9),
                                  ),
                                ),
                                color: Colors.white,
                              ),
                              MDVerticalButton(
                                index: 2,
                                callback: buttonClicked,
                                icon: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: SvgPicture.asset(
                                      'assets/images/earn_points.svg',
                                      width: 26),
                                ),
                                text: Text(
                                  "Earning MCP",
                                  style: TextStyle(
                                    color: Color(0xFFCBCBC9),
                                  ),
                                ),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Color(0xFFFAFAFA),
                          padding: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: 8, bottom: 0, left: 20, right: 20),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: softCardShadow,
                                child: TabBar(
                                  indicator: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 4.0,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  controller: _controller,
                                  labelColor: primaryColor,
                                  labelStyle: TextStyle(fontSize: 16),
                                  unselectedLabelColor: Color(0xFFCBCBC9),
                                  tabs: [
                                    Tab(
                                      text: 'Points',
                                    ),
                                    Tab(
                                      text: 'Transaction',
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 330,
                                child: TabBarView(
                                  controller: _controller,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 18,
                                      ),
                                      child: ListView.builder(
                                          itemCount: points.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var score = points[index];
                                            return InkWell(
                                              onTap: () {
                                                //Get question and pass to page
//                                          Navigator.of(context).push(MaterialPageRoute(
//                                              builder: (BuildContext context) => QuizLandingPage()
//                                          ));
                                              },
                                              child: MDClubCategoryWidget(
                                                score: score,
                                                first: Text(
                                                    score.scoreCategory!,
                                                    style: styleNormalBodyText),
                                                second: Text(
                                                    score.score
                                                        .toString()
                                                        .padLeft(3, '0'),
                                                    style:
                                                        stylePrimaryTextMedium),
                                              ),
                                            );
                                          }),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 18,
                                      ),
                                      child: ListView.builder(
                                          itemCount: transactions.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var score = transactions[index];
                                            return InkWell(
                                              onTap: () {
                                                //Get question and pass to page
//                                          Navigator.of(context).push(MaterialPageRoute(
//                                              builder: (BuildContext context) => QuizLandingPage()
//                                          ));
                                              },
                                              child: MDClubCategoryWidget(
                                                score: score,
                                                first: Text(
                                                    score.scoreCategory!,
                                                    style: styleNormalBodyText),
                                                second: Text(
                                                    score.score
                                                        .toString()
                                                        .padLeft(3, '0'),
                                                    style:
                                                        stylePrimaryTextMedium),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ));
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasData) {
                return Center(child: Text("Can't fetch the score information"));
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

class MDVerticalButton extends StatelessWidget {
  final Widget? icon;
  final Widget? text;
  final Color? color;
  final void Function(int? index)? callback;
  final int? index;

  MDVerticalButton(
      {Key? key, this.icon, this.text, this.color, this.callback, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        callback!(index);
      },
      color: this.color,
      padding: EdgeInsets.all(10.0),
      child: Column(
        // Replace with a Row for horizontal icon + text
        children: [
          icon!,
          text!,
        ],
      ),
    );
  }
}

class MDClubCategoryWidget extends StatelessWidget {
  //firstIcon: SvgPicture.asset('assets/images/icon_game.svg', width: 24),
  final ScoreModel? score;
  final Widget? first;
  final Widget? firstIcon;
  final Widget? second;
  final bool lessPadding;

  MDClubCategoryWidget(
      {Key? key,
      this.first,
      this.second,
      this.firstIcon,
      this.lessPadding = true,
      this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? icon;
    if (score!.iconType == "a") {
      icon = SvgPicture.asset(score!.iconUri!, width: 24);
    }
    if (score!.iconType == "u") {
      icon = SvgPicture.network(score!.iconUri!, width: 24);
    }
    if (score!.iconType == "m") {
      //TODO Hetvi change
      icon = Icon(
        Icons.alarm,
        //Icons.access_alarm,
        size: 24,
        color: Color(0xFFD1D0D0),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 52,
      decoration: softCardShadow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: this.lessPadding
                    ? const EdgeInsets.symmetric(horizontal: 8.0)
                    : const EdgeInsets.symmetric(vertical: 14, horizontal: 8.0),
                child: icon == null ? Container() : icon,
              ),
              first!,
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: primaryColor, width: 1),
              ),
            ),
            child: second,
          ),
        ],
      ),
    );
  }
}
