import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/pages/cardio_module/wigets/reusable_card.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/screen_shot.dart';

import '../../../../theme.dart';
import '../../constants.dart';
import 'ankylosing_disease_brain.dart';
import 'ankylosing_disease_form_widget.dart';
import 'models/ankylosing_disease_model.dart';

class AnkylosingDiseasePage extends StatefulWidget {
  final String? title;

  const AnkylosingDiseasePage({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  _AnkylosingDiseasePageState createState() => _AnkylosingDiseasePageState();
}

class _AnkylosingDiseasePageState extends State<AnkylosingDiseasePage> {
  StreamController<bool> viewController = StreamController<bool>.broadcast();
  double result = 0;
  String resultDescription = "";

  MyScreenUtil? screenUtil;
  GlobalKey _globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    screenUtil = getScreenUtilInstance(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.title!),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<bool>(
                  initialData: false,
                  stream: viewController.stream,
                  builder: (_, snapshot) {
                    if (snapshot.data!) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: screenUtil?.setWidth(20) as double,
                          right: screenUtil?.setWidth(20) as double,
                          bottom: screenUtil?.setHeight(20) as double,
                          top: screenUtil?.setHeight(20) as double,
                        ),
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
                                      width: MediaQuery.of(context).size.width *
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
                                        '${widget.title} Score',
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
                      return AnkylosingDiseaseFormWidget(
                        screenUtil: screenUtil,
                        title: widget.title,
                        onQuizDoneClick:
                            (List<AnkylosingDiseaseQuestionModel> questionList,
                                double value, int unit) {
                          setResult(questionList, value, unit);
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  setResult(List<AnkylosingDiseaseQuestionModel> questionList, double esrValue,
      int crpUnit) {
    AnkylosingDiseaseBrain brain = AnkylosingDiseaseBrain(questionList,
        esrValue, crpUnit, (widget.title != TITLE_ANKYLOSING_DISEASE_WITH_ESR));
    brain.calculateScore();
    result = brain.getScore();
    resultDescription = brain.getDescription();
    viewController.add(true);
  }

  void _capturePng() async {
    if (await PermissionUtil.getStoragePermission(
      context: context,
      screenUtil: screenUtil,
    )) {
      String filePath = await saveScreenShot(
          _globalKey, TITLE_ACR_EULAR_RHEUMATOID_ARTHRITIS_CLASSIFICATION);
      shareOption(
          filePath,
          "Hi here is your " +
              TITLE_ACR_EULAR_RHEUMATOID_ARTHRITIS_CLASSIFICATION +
              " value for your reference.");
    }
  }
}
