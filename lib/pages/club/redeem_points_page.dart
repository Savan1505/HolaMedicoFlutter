import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/models/score_model.dart';
import 'package:pharmaaccess/services/score_service.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';

import '../../theme.dart';

class RedeemPointsPage extends StatefulWidget {
  RedeemPointsPage({Key? key}) : super(key: key);

  @override
  _RedeemPointsPageState createState() => _RedeemPointsPageState();
}

class _RedeemPointsPageState extends State<RedeemPointsPage> {
  final redeemScoreController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Redeem Points"),
      ),
      body: FutureBuilder<PartnerScoreModel?>(
          future: ScoreService().getScore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              PartnerScoreModel partnerScore = snapshot.data!;
              int redeemable = partnerScore.score! <= 500 ? 0 : partnerScore.score! - 500;
              return Container(
                  color: Color(0xFFFAFAFA),
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 120,
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        decoration: softCardShadow.copyWith(
                            borderRadius: BorderRadius.circular(0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              snapshot.data!.score.toString().padLeft(4,'0'),
                              style: styleBlackHeadline1.copyWith(fontSize: 52),
                            ),
                            Text(
                                '1 point = 1 MCP (Medical Contribution Points)',
                                style: styleMutedTextMedium),
                          ],
                        ),
                      ),
                      redeemable == 0 ? Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        alignment: Alignment.center,
                        child: Text(
                          "Congratulations! You now have ${partnerScore.score} MCP. Please collect more than 500 MCP to redeem.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xEE6F706F),
                            fontSize: 14,
                          ),
                        ),
                      ): Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        alignment: Alignment.center,
                        child: Text(
                          "Congratulations! You can now redeem ${redeemable} Points.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xEE6F706F),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 50,
                        ),
                        child: FormFieldWidget(
                          controller: redeemScoreController,
                          hintText: 'Enter Point',
                          suffixIcon: Icon(
                            Icons.attach_money,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: RaisedButton(
                            color: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "SUBMIT REQUEST",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .apply(
                                    color: Colors.white,
                                  )
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              try {
                                var score = int.parse(redeemScoreController.text);
                                if (partnerScore.score! <= 500) {
                                  _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                    backgroundColor: primaryColor,
                                    content: Text(
                                        "Please collect more than 500 MPC to redeem",
                                        style: styleNormalBodyText.copyWith(
                                            color: Colors.white)),
                                  ));
                                  return;
                                }
                                if (partnerScore.score! - score < 500) {
                                  int claimable = partnerScore.score! - score;
                                  _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                    backgroundColor: primaryColor,
                                    content: Text(
                                        "You can claim only $claimable MCPs",
                                        style: styleNormalBodyText.copyWith(
                                            color: Colors.white)),
                                  ));
                                  return;
                                }
                                if (score <= snapshot.data!.score!) {
                                  var status = await ScoreService().redeemPoints(score);
                                  _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                    backgroundColor: primaryColor,
                                    content: Text(
                                        status.message!,
                                        style: styleNormalBodyText.copyWith(
                                            color: Colors.white)),
                                  ));
                                  Future.delayed(const Duration(seconds: 2),() {
                                    Navigator.of(context).pop();
                                  });
                                } else {
                                  _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                    backgroundColor: primaryColor,
                                    content: Text(
                                        'You can redeem MCPs less than earned MCPs',
                                        style: styleNormalBodyText.copyWith(
                                            color: Colors.white)),
                                  ));
                                }
                              } on Exception catch (e) {
                                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                  backgroundColor: primaryColor,
                                  content: Text(
                                      'Please enter valid score to redeem',
                                      style: styleNormalBodyText.copyWith(
                                          color: Colors.white)),
                                ));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ));
            } else {
              return Container();
            }
          }),
    );
  }
}
