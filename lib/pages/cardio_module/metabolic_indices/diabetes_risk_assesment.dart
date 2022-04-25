import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/pages/cardio_module/diabetes_quiz/diabetes_form_widget.dart';
import 'package:pharmaaccess/pages/cardio_module/wigets/reusable_card.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/screen_shot.dart';

import '../../../theme.dart';
import '../constants.dart';

class DiabetesRisk extends StatefulWidget {
  const DiabetesRisk({Key? key}) : super(key: key);

  @override
  _DiabetesRiskState createState() => _DiabetesRiskState();
}

class _DiabetesRiskState extends State<DiabetesRisk> {
  StreamController<bool> viewController = StreamController<bool>.broadcast();
  int result = 0;

  MyScreenUtil? screenUtil;
  GlobalKey _globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    screenUtil = getScreenUtilInstance(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(TITLE_DIABETES_RISK_ASSESSMENT),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              Text('(FINDRISC Score)'),
              Expanded(
                child: StreamBuilder<bool>(
                    initialData: false,
                    stream: viewController.stream,
                    builder: (_, snapshot) {
                      if (snapshot.data!) {
                        return Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      viewController.add(false);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black.withOpacity(0.5),
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _capturePng();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Image.asset(
                                        'assets/images/icon_share.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              RepaintBoundary(
                                key: _globalKey,
                                child: Container(
                                  color: Colors.grey[50],
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(15.0),
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          'Your risk of developing type 2 Diabetes within 10 years',
                                          style: kTitleTextStyle,
                                        ),
                                      ),
                                      ReusableCard(
                                        colour: primaryColor.withOpacity(0.7),
                                        cardChild: Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "FINDRISC Score = " +
                                                    result.toString(),
                                                style: kTitleTextStyle,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                resultDescription,
                                                style: TextStyle(
                                                  color: Color(0xEE6F706F),
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return DiabetesFormWidget(
                          onQuizDoneClick: (int _result) {
                            setResult(_result);
                          },
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String resultTitle = "", resultDescription = "";

  void setResult(int _result) {
    result = _result;
    int valuationData = result;
    resultTitle = "";
    resultDescription = "";
    if (valuationData < 7) {
      resultTitle = "Low";
      resultDescription = "Estimated 1 in 100 will develop disease";
    } else if (valuationData >= 7 && valuationData <= 11) {
      resultTitle = "Slightly elevated";
      resultDescription = "Estimated 1 in 25 will develop disease";
    } else if (valuationData >= 12 && valuationData <= 14) {
      resultTitle = "Moderate";
      resultDescription = "Estimated 1 in 6 will develop disease";
    } else if (valuationData >= 15 && valuationData <= 20) {
      resultTitle = "High";
      resultDescription = "Estimated 1 in 3 will develop disease";
    } else if (valuationData > 20) {
      resultTitle = "Very High";
      resultDescription = "Estimated 1 in 2 will develop disease";
    }
    viewController.add(true);
  }

  void _capturePng() async {
    if (await PermissionUtil.getStoragePermission(
      context: context,
      screenUtil: screenUtil,
    )) {
      String filePath =
          await saveScreenShot(_globalKey, TITLE_DIABETES_RISK_ASSESSMENT);
      shareOption(
          filePath,
          "Hi here is your " +
              TITLE_DIABETES_RISK_ASSESSMENT +
              " value for your reference.");
    }
  }
}

class ReferenceValuesModel {
  final String? index, description;

  ReferenceValuesModel({this.index, this.description});
}
