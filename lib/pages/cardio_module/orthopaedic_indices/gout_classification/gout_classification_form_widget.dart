import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/util/Constants.dart';

import '../../../../theme.dart';
import 'GoutClassificationItemWidget.dart';
import 'models/GoutClassificationQuestionModel.dart';

class GoutClassificationFormWidget extends StatefulWidget {
  final Function? onQuizDoneClick;
  final MyScreenUtil? screenUtil;

  GoutClassificationFormWidget(
      {Key? key, this.onQuizDoneClick, this.screenUtil})
      : super(key: key);

  @override
  _GoutClassificationFormWidgetState createState() =>
      _GoutClassificationFormWidgetState();
}

class _GoutClassificationFormWidgetState
    extends State<GoutClassificationFormWidget> {
  List<GoutClassificationQuestionModel> list = [];

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(
      TITLE_ACR_EULAR_RHEUMATOID_ARTHRITIS_CLASSIFICATION,
    );
    list.add(
      GoutClassificationQuestionModel(
        "Step One - Entry Criterion",
        [
          QuestionModel(
            "≥1 episode of swelling, pain, or tenderness in a peripheral joint/bursa",
            "",
            [
              AnswerModel(1, "Yes"),
              AnswerModel(0, "No"),
            ],
          ),
        ],
      ),
    );
    list.add(
      GoutClassificationQuestionModel(
        "Step Two - Sufficient Criterion",
        [
          QuestionModel(
            "Presence of Monosodium Urate (MSU) crystals in a symptomatic joint, bursa, or tophus",
            "",
            [
              AnswerModel(1, "Yes"),
              AnswerModel(0, "No"),
            ],
          ),
        ],
      ),
    );
    list.add(
      GoutClassificationQuestionModel(
        "Step Three - Classification Criteria",
        [
          QuestionModel(
            "Pattern of joint/bursa involvement during episodes",
            "",
            [
              AnswerModel(0,
                  "Joint/bursa other than ankle, midfoot or 1\u02e2\u1d57 MTP (or involvement in a polyarthritis)"),
              AnswerModel(1,
                  "Ankle OR midfoot (as part of monoarticular/oligoarticular episode without 1\u02e2\u1d57 MTP)"),
              AnswerModel(2,
                  "1\u02e2\u1d57 MTP (as part of monoarticular or oligoarticular episode)"),
            ],
          ),
          QuestionModel(
            "How many characteristics during episode(s)?",
            "Erythema overlying joint (reported or observed); can't bear touch or pressure to joint; great difficulty with walking or inability to use joint.",
            [
              AnswerModel(0, "No Characteristics"),
              AnswerModel(1, "One Characteristics"),
              AnswerModel(2, "Two Characteristics"),
              AnswerModel(3, "Three Characteristics"),
            ],
          ),
          QuestionModel(
            "How many episodes with the following time-course?",
            "≥2 time course symptoms, regardless of anti-inflammatory use: (1)Time to maximal pain < 24 hours; (2)Resolution of symptoms in ≤14 days; (3)Complete resolution (to baseline level) between symptomatic episodes.",
            [
              AnswerModel(0, "No typical episodes"),
              AnswerModel(1, "One typical episode"),
              AnswerModel(2, "Recurrent typical episodes"),
            ],
          ),
          QuestionModel(
            "Evidence of tophus",
            "Draining or chalk-like subcutaneous nodule, located in typical locations: joints, ears, olecranon bursae, finger pads, tendons (e.g., Achilles).",
            [
              AnswerModel(0, "Absent"),
              AnswerModel(4, "Present"),
            ],
          ),
          QuestionModel(
            "Serum Urate",
            "(Measured by uricase method.) Ideally scored when patient not taking urate-lowering treatment and patient was >4 weeks from an episode. If practical, retest under those conditions. Highest value irrespective of timing should be used.",
            [
              AnswerModel(-4, "< 4mg/dL [< 0.24mM]"),
              AnswerModel(0, "≥ 4 or < 6mg/dL [≥ 0.24 or < 0.36mM]"),
              AnswerModel(2, "≥ 6 or < 8mg/dL [≥ 0.36 or < 0.48mM]"),
              AnswerModel(3, "≥ 8 or < 10mg/dL [≥ 0.48 or < 0.60mM]"),
              AnswerModel(4, "≥ 10mg/dL [≥ 0.60mM]"),
            ],
          ),
          QuestionModel(
            "Synovial fluid analysis of a symptomatic (ever) joint or bursa",
            "Should be assessed by a trained observer.",
            [
              AnswerModel(-2, "Negative for MSU"),
              AnswerModel(0, "Not done"),
            ],
          ),
          QuestionModel(
            "Imaging evidence of urate deposition in symptomatic joint/bursa",
            "Ultrasound: double-contour sign OR DECT: Demonstrates urate deposition.",
            [
              AnswerModel(0, "Absent or not done"),
              AnswerModel(4, "Present"),
            ],
          ),
          QuestionModel(
            "Imaging evidence of gout-related joint damage",
            "X-Ray of hands or feet with ≥1 erosion.",
            [
              AnswerModel(0, "Absent"),
              AnswerModel(4, "Present"),
            ],
          ),
        ],
      ),
    );
  }

  PageController _pageController = PageController();
  StreamController<int> isNextStreamController =
      StreamController<int>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemBuilder: (_, index) => GoutClassificationItemWidget(
          screenUtil: widget.screenUtil,
          index: index,
          questionModel: list[index],
        ),
        onPageChanged: (index) {
          isNextStreamController.add(index);
        },
        itemCount: list.length,
      ),
      bottomNavigationBar: StreamBuilder<int>(
        initialData: 0,
        stream: isNextStreamController.stream,
        builder: (_, snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              left: widget.screenUtil?.setWidth(20) as double,
              right: widget.screenUtil?.setWidth(20) as double,
              bottom: widget.screenUtil?.setHeight(15) as double,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                if (snapshot.data != 0) ...[
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                      onPressed: previousPage,
                      child: Text('Previous'),
                    ),
                  ),
                  SizedBox(
                    width: widget.screenUtil?.setWidth(50) as double,
                  ),
                ],
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor)),
                    onPressed: () {
                      switch (snapshot.data) {
                        case 0:
                          if (list[0].questionModels[0].selectedIndex == -1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please select your option"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            nextPage();
                          }
                          break;
                        case 1:
                          if (list[1].questionModels[0].selectedIndex == -1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please select your option"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            if (list[0]
                                        .questionModels[0]
                                        .answerModels[list[0]
                                            .questionModels[0]
                                            .selectedIndex]
                                        .points ==
                                    1 &&
                                list[1]
                                        .questionModels[0]
                                        .answerModels[list[1]
                                            .questionModels[0]
                                            .selectedIndex]
                                        .points ==
                                    0) {
                              nextPage();
                            } else {
                              widget.onQuizDoneClick!(list);
                            }
                          }
                          break;
                        case 2:
                          popScreen();
                          break;
                      }
                    },
                    child: Text(
                        snapshot.data != list.length - 1 ? 'Next' : 'Done'),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void popScreen() {
    bool isValidated = true;
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list[i].questionModels.length; j++) {
        var questionModel = list[i].questionModels[j];

        if (questionModel.selectedIndex == -1) {
          isValidated = false;
        }
      }
    }

    if (isValidated) {
      widget.onQuizDoneClick!(list);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select all ans!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void nextPage() {
    isNextStreamController.add(_pageController.page!.toInt() + 1);
    _pageController.animateToPage(_pageController.page!.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    isNextStreamController.add(_pageController.page!.toInt() - 1);
    _pageController.animateToPage(_pageController.page!.toInt() - 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }
}
