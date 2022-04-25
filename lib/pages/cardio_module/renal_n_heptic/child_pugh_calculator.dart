import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/CommonExtension.dart';
import 'package:pharmaaccess/pages/brand/pharma_covigilance_page.dart';
import 'package:pharmaaccess/pages/cardio_module/constants.dart';
import 'package:pharmaaccess/pages/cardio_module/models/CalculatorBrain.dart';
import 'package:pharmaaccess/pages/cardio_module/wigets/reusable_card.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/screen_shot.dart';
import 'package:pharmaaccess/widgets/commons.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';

import 'ChildPughScoreBrain.dart';

class ChildPughCalculator extends StatefulWidget {
  const ChildPughCalculator({
    Key? key,
  }) : super(key: key);

  @override
  _ChildPughCalculatorState createState() => _ChildPughCalculatorState();
}

class _ChildPughCalculatorState extends State<ChildPughCalculator> {
  int albuminUnit = MG_DL, bilibrumUnit = G_DL;

  StreamController<int> bilirubinStreamController =
      StreamController<int>.broadcast();

  StreamController<int> albuminStreamController =
      StreamController<int>.broadcast();
  StreamController<PughUnitClass?> ascitesStreamController =
      StreamController<PughUnitClass?>.broadcast();
  StreamController<PughUnitClass?> encephalopathyStreamController =
      StreamController<PughUnitClass?>.broadcast();
  PughUnitClass? ascites, encephalopathy;
  StreamController<bool> viewController = StreamController<bool>.broadcast();

  final inrController = TextEditingController();
  final albuminController = TextEditingController();
  final bilirubinController = TextEditingController();

  FocusNode inrFocusNode = FocusNode();

  FocusNode albuminFocusNode = FocusNode();

  FocusNode bilirubinFocusNode = FocusNode();
  bool isBodyFat = false;

  @override
  void initState() {
    super.initState();
    ascites = calc.ascitesList[0];
    encephalopathy = calc.encephalopathy[0];
  }

  MyScreenUtil? screenUtil;
  GlobalKey _globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    screenUtil = getScreenUtilInstance(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(TITLE_CHILD_PUGH),
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
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(15.0),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Your $TITLE_CHILD_PUGH Result : ',
                                style: getTitle2TextStyle(screenUtil!),
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
                                    calc.calculatePughScore().toString(),
                                    style: kResultTextStyle,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    calc.getResult(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
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
                    Container(
                      padding: EdgeInsets.only(bottom: 15, left: 7, top: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.grey[200]),
                        color: Colors.white,
                      ),
                      child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Text(
                              TITLE_SERUM_BILIRUBIN,
                              style: getTitleStyle(),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            StreamBuilder<int>(
                                stream: bilirubinStreamController.stream,
                                builder: (_, snapshot) {
                                  return Row(children: [
                                    Expanded(
                                      child: addRadioButtonUnit(
                                          MG_DL, TITLE_MGDL, () {
                                        bilibrumUnit = MG_DL;
                                        bilirubinStreamController
                                            .add(bilibrumUnit);
                                      }, bilibrumUnit),
                                    ),
                                    Expanded(
                                      child: addRadioButtonUnit(
                                          UM_OL_L, TITLE_UMOL, () {
                                        bilibrumUnit = UM_OL_L;
                                        bilirubinStreamController
                                            .add(bilibrumUnit);
                                      }, bilibrumUnit),
                                    )
                                  ]);
                                }),
                            Container(
                              height: 120,
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: FormFieldWidget(
                                focusNode: bilirubinFocusNode,
                                controller: bilirubinController,
                                textInputType: TextInputType.number,
                                hintText: 'Bilirubin',
                              ).doneKeyBoard(bilirubinFocusNode, context),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15, left: 7, top: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.grey[200]),
                        color: Colors.white,
                      ),
                      child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Text(
                              TITLE_ALBUMIN,
                              style: getTitleStyle(),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            StreamBuilder<int>(
                                stream: albuminStreamController.stream,
                                builder: (_, snapshot) {
                                  return Row(children: [
                                    Expanded(
                                      child: addRadioButtonUnit(G_DL, TITLE_GDL,
                                          () {
                                        albuminUnit = G_DL;
                                        albuminStreamController
                                            .add(albuminUnit);
                                      }, albuminUnit),
                                    ),
                                    Expanded(
                                      child:
                                          addRadioButtonUnit(G_L, TITLE_GL, () {
                                        albuminUnit = G_L;
                                        albuminStreamController
                                            .add(albuminUnit);
                                      }, albuminUnit),
                                    )
                                  ]);
                                }),
                            Container(
                              height: 120,
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: FormFieldWidget(
                                focusNode: albuminFocusNode,
                                controller: albuminController,
                                textInputType: TextInputType.number,
                                hintText: 'Albumin',
                              ).doneKeyBoard(albuminFocusNode, context),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 15, left: 15, top: 15, right: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.grey[200]),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "INR",
                            style: getTitleStyle(),
                          ),
                          Container(
                            height: 120,
                            child: FormFieldWidget(
                              focusNode: inrFocusNode,
                              controller: inrController,
                              textInputType: TextInputType.number,
                              hintText: 'INR',
                            ).doneKeyBoard(inrFocusNode, context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15, left: 7, top: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[200]!),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ascites",
                            style: getTitleStyle(),
                          ),
                          StreamBuilder<PughUnitClass?>(
                              stream: ascitesStreamController.stream,
                              builder: (_, snapshot) {
                                return Column(
                                  children: calc.ascitesList
                                      .map((e) => lifetStyleRadioButton(
                                            e,
                                            () {
                                              ascites = e;
                                              ascitesStreamController
                                                  .add(ascites);
                                            },
                                            ascites,
                                          ))
                                      .toList(),
                                );
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 15, left: 7, top: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[200]!),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Encephalopathy",
                            style: getTitleStyle(),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          StreamBuilder<PughUnitClass?>(
                              stream: encephalopathyStreamController.stream,
                              builder: (_, snapshot) {
                                return Column(
                                  children: calc.encephalopathy
                                      .map((e) => lifetStyleRadioButton(
                                            e,
                                            () {
                                              encephalopathy = e;
                                              encephalopathyStreamController
                                                  .add(encephalopathy);
                                            },
                                            encephalopathy,
                                          ))
                                      .toList(),
                                );
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getButton(),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  GestureDetector getButton() {
    String title = "CALCULATE Creatinine";
    return getCommonCalculateButton(
        title: buttonTitle,
        onClick: () {
          isBodyFat = false;
          if (bilirubinController.text.trim().isEmpty) {
            showError('Serum Bilirubin Required!');
          } else if (albuminController.text.trim().isEmpty) {
            showError('Serum Albumin Required!');
          } else if (inrController.text.trim().isEmpty) {
            showError('INR Required!');
          } else {
            calc = ChildPughScoreBrain(
                albuminUnit: albuminUnit,
                bilirubinUnit: bilibrumUnit,
                albumin: double.parse(albuminController.text.trim()),
                bilirubin: double.parse(bilirubinController.text.trim()),
                inr: double.parse(inrController.text.trim()),
                ascites: ascites,
                encephalopathyList: encephalopathy);
            calc.calculatePughScore();
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

  Column getBox(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 12,
          color: color,
        ),
        Transform.translate(
          child: Text(
            value,
            style: TextStyle(fontSize: 10),
          ),
          offset: Offset(7, 0),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(fontSize: 7.5),
          ),
        )
      ],
    );
  }

  ChildPughScoreBrain calc = ChildPughScoreBrain();
  LifeStyleModel? selectedModel;
  StreamController<LifeStyleModel?> lifeStyleController =
      StreamController<LifeStyleModel?>.broadcast();

  Widget addRadioButtonUnit(
          int btnValue, String title, Function onClick, int groupValue) =>
      GestureDetector(
        onTap: () {
          onClick();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 10,
              height: 10,
              child: Radio(
                activeColor: Theme.of(context).primaryColor,
                value: btnValue,
                groupValue: groupValue,
                onChanged: (dynamic value) {
                  onClick();
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      );

  Widget lifetStyleRadioButton(
      PughUnitClass model, Function onClick, PughUnitClass? selectedModel) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          onClick();
        },
        child: Column(
          children: [
            InkWell(
              onTap: () {
                onClick();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 6,
                ),
                decoration: softCardShadow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 16,
                          width: 16,
                          color: selectedModel != null &&
                                  model.index == selectedModel.index
                              ? primaryColor
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(model.title!.toUpperCase(),
                          style: styleMutedTextSmall),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectLifeStyle(LifeStyleModel title) {
    selectedModel = title;
    lifeStyleController.add(selectedModel);
  }

  void _capturePng() async {
    if (await PermissionUtil.getStoragePermission(
      context: context,
      screenUtil: screenUtil,
    )) {
      String filePath = await saveScreenShot(_globalKey, TITLE_CHILD_PUGH);
      shareOption(filePath,
          "Hi here is your " + TITLE_CHILD_PUGH + " value for your reference.");
    }
  }
}

class GenderModel {
  final int? type;
  final String? title;

  GenderModel({this.type, this.title});
}
