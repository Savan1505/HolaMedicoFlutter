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
import 'OptionWidgetCardioVascular.dart';

class CardioVascularIndicesCalculator extends StatefulWidget {
  final int? type;
  final String? title;

  const CardioVascularIndicesCalculator({Key? key, this.type, this.title})
      : super(key: key);

  @override
  _CardioVascularIndicesCalculatorState createState() =>
      _CardioVascularIndicesCalculatorState();
}

class _CardioVascularIndicesCalculatorState
    extends State<CardioVascularIndicesCalculator> {
  StreamController<bool> viewController = StreamController<bool>.broadcast();

  StreamController<List<CardioVascularOptions>> selectedAnsStreamController =
      StreamController<List<CardioVascularOptions>>.broadcast();
  List<CardioVascularOptions> selectedAnsList = [];
  CardioVascularBrain cardioVascularBrain = CardioVascularBrain();
  late List<CardioVascularModel> list;
  int count = 0;

  @override
  void initState() {
    super.initState();
    list = cardioVascularBrain.getVascularList(widget.type);
    resetResult();
  }

  void resetResult() {
    selectedAnsList =
        list.map((e) => CardioVascularOptions(point: -1)).toList();
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
                            Container(
                              padding: EdgeInsets.all(15.0),
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Your " + widget.title!,
                                    style: kTitleTextStyle,
                                  ),
                                  if (widget.type == CHADCS2_VASC ||
                                      widget.type == CHADCS2 ||
                                      widget.type == HAS_BLED_SCORE) ...[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      ":   " + cardioVascularBrain.getResult(),
                                      style: kTitleTextStyle,
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            ReusableCard(
                              colour: primaryColor,
                              cardChild: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  if (widget.type == CHADCS2_VASC ||
                                      widget.type == CHADCS2) ...[
                                    Text(
                                      "Adjusted Risk of Stroke per Year : ${cardioVascularBrain.result}",
                                      style: kResultTextStyle,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${cardioVascularBrain.recommendations}",
                                      style: kResultTextStyle,
                                    ),
                                  ] else ...[
                                    if (widget.type == HAS_BLED_SCORE) ...[
                                      Text(
                                        "Bleeds per 100 patient-years ${cardioVascularBrain.bleeds_per_year}",
                                        style: kResultTextStyle,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        cardioVascularBrain.use_of_negotiation,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                  if (widget.type == DASH_SCORE) ...[
                                    Text(
                                      cardioVascularBrain.getResult(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      cardioVascularBrain.result,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ]
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
                    if (widget.type == DASH_SCORE) ...[
                      Text(
                        "DASH Prediction Score for Recurrent VTE",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: (screenUtil == null)
                                ? 15
                                : screenUtil!.setSp(10) as double?),
                      ),
                    ],
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        CardioVascularModel model = list[index];
                        return OptionWidgetCardioVascular(
                          model: model,
                          onClick: (e) {
                            selectedAnsList.removeAt(index);
                            selectedAnsList.insert(index, e);
                          },
                        );
                      },
                      itemCount: list.length,
                    ),
                    getButton()
                  ],
                ),
        ),
      ),
    );
  }

  GestureDetector getButton() {
    String buttonTitle = "CALCULATE ${widget.title}";
    return getCommonCalculateButton(
        title: buttonTitle,
        onClick: () {
          bool isAlLSet = true;
          selectedAnsList.forEach((element) {
            if (element.point == -1) {
              isAlLSet = false;
            }
          });
          if (!isAlLSet) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please select all options!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            cardioVascularBrain = CardioVascularBrain(
                optionSelected: selectedAnsList, type: widget.type);
            cardioVascularBrain.getResult();
            viewController.add(true);
          }
        }) as GestureDetector;
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
