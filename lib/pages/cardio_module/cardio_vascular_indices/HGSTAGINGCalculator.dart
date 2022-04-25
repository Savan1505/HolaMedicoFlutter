import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/pages/cardio_module/constants.dart';
import 'package:pharmaaccess/pages/cardio_module/wigets/reusable_card.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/screen_shot.dart';
import 'package:pharmaaccess/widgets/commons.dart';

import 'CardioVascularBrain.dart';
import 'HFStagingBrain.dart';
import 'OptionWidgetCardioVascular.dart';

class HGSTAGINGCalculator extends StatefulWidget {
  final String? title;

  const HGSTAGINGCalculator({Key? key, this.title}) : super(key: key);

  @override
  _HGSTAGINGCalculatorState createState() => _HGSTAGINGCalculatorState();
}

class _HGSTAGINGCalculatorState extends State<HGSTAGINGCalculator> {
  StreamController<bool> viewController = StreamController<bool>.broadcast();

  StreamController<List<CardioVascularOptions>> selectedAnsStreamController =
      StreamController<List<CardioVascularOptions>>.broadcast();

  StreamController<bool> _4visibilityController =
      StreamController<bool>.broadcast();
  StreamController<bool> _5visibilityController =
      StreamController<bool>.broadcast();
  StreamController<bool> _6visibilityController =
      StreamController<bool>.broadcast();
  List<CardioVascularOptions> selectedAnsList = [];
  HFStagingBrain hfStagingBrain = HFStagingBrain();

  // List<CardioVascularModel> list;
  int count = 0;

  Map<int, String?> ansMap = {};
  Map<int, String> ansMapSelection = {};

  @override
  void initState() {
    super.initState();
    for (int i = 1; i < 7; i++) {
      ansMap.putIfAbsent(i, () => no);
    }

    // list = cardioVascularBrain.getVascularList(widget.type);
    resetResult();
  }

  void resetResult() {
    // selectedAnsList =
    //     list.map((e) => CardioVascularOptions(point: -1)).toList();
  }

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
        margin: EdgeInsets.all(15),
        child: StreamBuilder<bool>(
          initialData: false,
          stream: viewController.stream,
          builder: (_, snapshot) => snapshot.data!
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            resetResult();
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
                              width: MediaQuery.of(context).size.width * 0.06,
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
                            Text(
                              "Your " + widget.title!,
                              style: getTitle2TextStyle(screenUtil!),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ReusableCard(
                              colour: primaryColor,
                              cardChild: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  getansWidget(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
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
                )
              : ListView(
                  children: <Widget>[
                    OptionWidgetCardioVascular(
                      model: hfStagingBrain.listCardio[0],
                      onClick: (e) {
                        ansMap.update(1, (value) => e.title);
                        if (!ansMapSelection.containsKey(1)) {
                          ansMapSelection.putIfAbsent(1, () => "");
                        }
                      },
                    ),
                    OptionWidgetCardioVascular(
                      model: hfStagingBrain.listCardio[1],
                      onClick: (e) {
                        ansMap.update(2, (value) => e.title);
                        if (!ansMapSelection.containsKey(2)) {
                          ansMapSelection.putIfAbsent(2, () => "");
                        }
                      },
                    ),
                    OptionWidgetCardioVascular(
                      model: hfStagingBrain.listCardio[2],
                      onClick: (CardioVascularOptions e) {
                        ansMap.update(3, (value) => e.title);
                        if (!ansMapSelection.containsKey(3)) {
                          ansMapSelection.putIfAbsent(3, () => "");
                        }
                        _4visibilityController.add(e.title == yes);
                        if (e.title == no) {
                          _5visibilityController.add(false);
                          _6visibilityController.add(false);
                        }
                      },
                    ),
                    StreamBuilder<bool>(
                        initialData: false,
                        stream: _4visibilityController.stream,
                        builder: (_, snapshot) {
                          return snapshot.data!
                              ? OptionWidgetCardioVascular(
                                  model: hfStagingBrain.listCardio[3],
                                  onClick: (e) {
                                    ansMap.update(4, (value) => e.title);
                                    if (!ansMapSelection.containsKey(4)) {
                                      ansMapSelection.putIfAbsent(4, () => "");
                                    }
                                    _5visibilityController.add(e.title == yes);
                                    if (e.title == no) {
                                      _6visibilityController.add(false);
                                    }
                                  },
                                )
                              : Text('');
                        }),
                    StreamBuilder<bool>(
                        initialData: false,
                        stream: _5visibilityController.stream,
                        builder: (_, snapshot) {
                          return snapshot.data!
                              ? OptionWidgetCardioVascular(
                                  model: hfStagingBrain.listCardio[4],
                                  onClick: (e) {
                                    ansMap.update(5, (value) => e.title);
                                    if (!ansMapSelection.containsKey(5)) {
                                      ansMapSelection.putIfAbsent(5, () => "");
                                    }
                                    _6visibilityController.add(e.title == yes);
                                  },
                                )
                              : Text('');
                        }),
                    StreamBuilder<bool>(
                        initialData: false,
                        stream: _6visibilityController.stream,
                        builder: (_, snapshot) {
                          return snapshot.data!
                              ? OptionWidgetCardioVascular(
                                  model: hfStagingBrain.listCardio[5],
                                  onClick: (e) {
                                    ansMap.update(6, (value) => e.title);
                                    if (!ansMapSelection.containsKey(6)) {
                                      ansMapSelection.putIfAbsent(6, () => "");
                                    }
                                  },
                                )
                              : Text('');
                        }),
                    getButton()
                  ],
                ),
        ),
      ),
    );
  }

  int index = 0;

  GestureDetector getButton() {
    return getCommonCalculateButton(
        title: buttonTitle,
        onClick: () {
          if (!ansMapSelection.containsKey(1) ||
              !ansMapSelection.containsKey(2) ||
              !ansMapSelection.containsKey(3)) {
            showError(TITLE_SELECT_ALL_OPTIONS);
          } else if (ansMap[3] == yes && !ansMapSelection.containsKey(4)) {
            showError(TITLE_SELECT_ALL_OPTIONS);
          } else if (ansMap[4] == yes && !ansMapSelection.containsKey(5)) {
            showError(TITLE_SELECT_ALL_OPTIONS);
          } else if (ansMap[5] == yes && !ansMapSelection.containsKey(6)) {
            showError(TITLE_SELECT_ALL_OPTIONS);
          } else {
            if (ansMap[1] == yes && ansMap[2] == no && ansMap[3] == no) {
              index = 1;
            } else if (ansMap[2] == yes && ansMap[1] == no && ansMap[3] == no) {
              index = 1;
            } else if (ansMap[3] == yes &&
                ansMap[4] == yes &&
                ansMap[5] == yes &&
                ansMap[6] == yes) {
              index = 4;
            } else if (ansMap[3] == yes &&
                ansMap[4] == yes &&
                ansMap[5] == yes &&
                ansMap[6] == no) {
              index = 3;
            } else if (ansMap[3] == yes &&
                ansMap[4] == yes &&
                ansMap[5] == no) {
              index = 2;
            } else if (ansMap[3] == yes && ansMap[4] == no) {
              index = 1;
            } else if (ansMap[1] == no && ansMap[2] == no && ansMap[3] == no) {
              index = 0;
            }
            viewController.add(true);
          }
        }) as GestureDetector;
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget getansWidget() {
    if (index == 0) {
      return Text(
        hfStagingBrain.hfStagingResult[index].description!,
        style: kResultTextStyle,
      );
    } else {
      return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text(
            hfStagingBrain.hfStagingResult[index].title!,
            style: kResultTextStyle,
          ),
          Text(
            hfStagingBrain.hfStagingResult[index].description!,
            style: kResultTextStyle,
          ),
          Text(
            "Therapy Considerations: ",
            style: kResultTextStyle,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index1) {
              return Text(
                  "- ${hfStagingBrain.hfStagingResult[index].considerations![index1]}");
            },
            itemCount:
                hfStagingBrain.hfStagingResult[index].considerations!.length,
          ),
        ],
      );
    }
  }

  void _capturePng() async {
    if (await PermissionUtil.getStoragePermission(
      context: context,
      screenUtil: screenUtil,
    )) {
      String filePath = await saveScreenShot(_globalKey, widget.title!);
      shareOption(filePath,
          "Hi here is your " + widget.title! + " value for your reference.");
    }
  }
}
