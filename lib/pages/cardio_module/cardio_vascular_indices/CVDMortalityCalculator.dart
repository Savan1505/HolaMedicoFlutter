import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/CommonExtension.dart';
import 'package:pharmaaccess/pages/cardio_module/cardio_vascular_indices/CVDMortalityBrain.dart';
import 'package:pharmaaccess/pages/cardio_module/cardio_vascular_indices/OptionWidgetCardioVascular.dart';
import 'package:pharmaaccess/pages/cardio_module/constants.dart';
import 'package:pharmaaccess/pages/cardio_module/wigets/reusable_card.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/screen_shot.dart';
import 'package:pharmaaccess/widgets/commons.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';

import 'CardioVascularBrain.dart';

class CVDMortalityCalculator extends StatefulWidget {
  final String? title;

  const CVDMortalityCalculator({Key? key, this.title}) : super(key: key);

  @override
  _CVDMortalityCalculatorState createState() => _CVDMortalityCalculatorState();
}

class _CVDMortalityCalculatorState extends State<CVDMortalityCalculator> {
  StreamController<bool> viewController = StreamController<bool>.broadcast();

  StreamController<List<CardioVascularOptions>> selectedAnsStreamController =
      StreamController<List<CardioVascularOptions>>.broadcast();
  Map<int?, int?> selectedMap = {};
  CVDMortalityBrain cardioVascularBrain = CVDMortalityBrain();
  StreamController<int> unitStreamController =
      StreamController<int>.broadcast();
  final creatinineController = TextEditingController();
  FocusNode creatinineFocusNode = FocusNode();
  late List<CardioVascularModel> list;
  int count = 0;

  @override
  void initState() {
    super.initState();
    list = cardioVascularBrain.getCardioVascularListHasBled();
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
        margin: EdgeInsets.all(screenUtil!.setHeight(12) as double),
        child: StreamBuilder<bool>(
          initialData: false,
          stream: viewController.stream,
          builder: (_, snapshot) {
            return snapshot.data!
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
                                top: screenUtil!.setHeight(5) as double,
                                bottom: screenUtil!.setHeight(5) as double,
                                left: screenUtil!.setWidth(10) as double,
                                right: screenUtil!.setWidth(10) as double,
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
                                top: screenUtil!.setHeight(5) as double,
                                bottom: screenUtil!.setHeight(5) as double,
                                left: screenUtil!.setWidth(10) as double,
                                right: screenUtil!.setWidth(10) as double,
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
                                height: screenUtil!.setHeight(10) as double?,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.all(screenUtil!.setHeight(15) as double),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Your " + widget.title! + " value",
                                  style: getTitleTextStyle(screenUtil!),
                                ),
                              ),
                              ReusableCard(
                                colour: primaryColor,
                                cardChild: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "10 years risk of fatal CVD value :",
                                      style: getResultTextStyle(screenUtil!),
                                    ),
                                    Text(
                                      "${cardioVascularBrain.result} %",
                                      style: getResultTextStyle(screenUtil!),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenUtil!.setHeight(10) as double?,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          CardioVascularModel model = list[index];
                          return OptionWidgetCardioVascular(
                            screenUtil: screenUtil,
                            isVertical: true,
                            model: model,
                            onClick: (CardioVascularOptions e) {
                              if (selectedMap.containsKey(e.point)) {
                                selectedMap.update(e.point, (value) => e.index);
                              } else {
                                selectedMap.putIfAbsent(e.point, () => e.index);
                              }
                            },
                          );
                        },
                        itemCount: list.length,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            bottom: screenUtil!.setHeight(15) as double,
                            left: screenUtil!.setWidth(7) as double,
                            top: screenUtil!.setHeight(15) as double),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(screenUtil!.setHeight(10) as double),
                          // border: Border.all(color: Colors.grey[200]),
                          color: Colors.white,
                        ),
                        child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              Text(
                                'Total Cholesterol: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: screenUtil!.setSp(10) as double?),
                              ),
                              SizedBox(
                                height: screenUtil!.setHeight(15) as double?,
                              ),
                              SizedBox(
                                width: screenUtil!.setWidth(5) as double?,
                              ),
                              Row(children: [
                                Expanded(
                                  child: addRadioButtonUnit(MG_DL, TITLE_MGDL),
                                ),
                                Expanded(
                                  child:
                                      addRadioButtonUnit(UM_OL_L, TITLE_MMOL),
                                )
                              ]),
                              Container(
                                height: 110,
                                padding: EdgeInsets.only(
                                    left: screenUtil!.setWidth(10) as double,
                                    right: screenUtil!.setWidth(10) as double,
                                    top: screenUtil!.setHeight(10) as double),
                                child: FormFieldWidget(
                                  focusNode: creatinineFocusNode,
                                  controller: creatinineController,
                                  textInputType: TextInputType.number,
                                  hintText: 'Total Cholesterol',
                                ).doneKeyBoard(creatinineFocusNode, context),
                              ),
                            ]),
                      ),
                      getButton(),
                      SizedBox(
                        height: screenUtil!.setHeight(5) as double?,
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }

  int cretenineUnit = MG_DL;

  Widget addRadioButtonUnit(int btnValue, String title) => StreamBuilder<int>(
        initialData: cretenineUnit,
        stream: unitStreamController.stream,
        builder: (_, snapshot) => GestureDetector(
          onTap: () {
            cretenineUnit = btnValue;
            unitStreamController.add(btnValue);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: screenUtil!.setWidth(10) as double?,
              ),
              SizedBox(
                width: screenUtil!.setWidth(10) as double?,
                height: screenUtil!.setHeight(10) as double?,
                child: Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: btnValue,
                  groupValue: snapshot.data,
                  onChanged: (dynamic value) {
                    cretenineUnit = btnValue;
                    unitStreamController.add(btnValue);
                  },
                ),
              ),
              SizedBox(
                width: screenUtil!.setWidth(10) as double?,
              ),
              Expanded(
                  child: Text(
                title,
                style: TextStyle(fontSize: screenUtil!.setSp(8) as double?),
              ))
            ],
          ),
        ),
      );

  GestureDetector getButton() {
    // String buttonTitle = "CALCULATE RESULT";
    return getCommonCalculateButton(
        title: buttonTitle,
        onClick: () {
          bool isAlLSet = selectedMap.length == list.length;
          if (!isAlLSet) {
            showMessage('Please select all options!');
          } else if (creatinineController.text.trim().isEmpty) {
            showMessage('Cholesterol Required!');
          } else {
            cardioVascularBrain = CVDMortalityBrain(
                selectedMap: selectedMap,
                unit: cretenineUnit,
                cholestrolVal: double.parse(creatinineController.text));
            cardioVascularBrain.calculate();
            viewController.add(true);
          }
        }) as GestureDetector;
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
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

  @override
  void dispose() {
    unitStreamController.close();
    super.dispose();
  }
}
