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
import 'GoutClassificationBrain.dart';
import 'gout_classification_form_widget.dart';
import 'models/GoutClassificationQuestionModel.dart';

class GoutClassificationPage extends StatefulWidget {
  const GoutClassificationPage({Key? key}) : super(key: key);

  @override
  _GoutClassificationPageState createState() => _GoutClassificationPageState();
}

class _GoutClassificationPageState extends State<GoutClassificationPage> {
  StreamController<bool> viewController = StreamController<bool>.broadcast();
  int? result = 0;
  String resultDescription = "";

  MyScreenUtil? screenUtil;
  GlobalKey _globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    screenUtil = getScreenUtilInstance(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(TITLE_ACR_EULAR_GOUT_CLASSIFICATION),
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
                                        'Gout Classification Score',
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
                                            if (result != null)
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
                      return GoutClassificationFormWidget(
                        screenUtil: screenUtil,
                        onQuizDoneClick:
                            (List<GoutClassificationQuestionModel> list) {
                          setResult(list);
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

  setResult(List<GoutClassificationQuestionModel> list) {
    GoutClassificationBrain brain = GoutClassificationBrain(list);
    brain.calculateResult();
    result = brain.getScore();
    resultDescription = brain.getDescription();
    viewController.add(true);
  }

  void _capturePng() async {
    if (await PermissionUtil.getStoragePermission(
      context: context,
      screenUtil: screenUtil,
    )) {
      String filePath =
          await saveScreenShot(_globalKey, TITLE_ACR_EULAR_GOUT_CLASSIFICATION);
      shareOption(
          filePath,
          "Hi here is your " +
              TITLE_ACR_EULAR_GOUT_CLASSIFICATION +
              " value for your reference.");
    }
  }
}
