import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/CommonExtension.dart';
import 'package:pharmaaccess/pages/brand/pharma_covigilance_page.dart';
import 'package:pharmaaccess/pages/cardio_module/constants.dart';
import 'package:pharmaaccess/pages/cardio_module/models/CalculatorBrain.dart';
import 'package:pharmaaccess/pages/cardio_module/renal_n_heptic/CreateningBrain.dart';
import 'package:pharmaaccess/pages/cardio_module/wigets/reusable_card.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/screen_shot.dart';
import 'package:pharmaaccess/widgets/commons.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';

class CreatinineCalculator extends StatefulWidget {
  const CreatinineCalculator({
    Key? key,
  }) : super(key: key);

  @override
  _CreatinineCalculatorState createState() => _CreatinineCalculatorState();
}

class _CreatinineCalculatorState extends State<CreatinineCalculator> {
  int? selectedGender = 1, cretenineUnit = MG_DL;

  StreamController<int?> genderStreamController =
      StreamController<int?>.broadcast();

  StreamController<int> unitStreamController =
      StreamController<int>.broadcast();

  StreamController<bool> viewController = StreamController<bool>.broadcast();

  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();
  final creatinineController = TextEditingController();
  FocusNode ageFocusNode = FocusNode();

  FocusNode heightFocusNode = FocusNode();

  FocusNode weightFocusNode = FocusNode();

  FocusNode creatinineFocusNode = FocusNode();
  bool isBodyFat = false;
  List<GenderModel> listGender = [];

  @override
  void initState() {
    super.initState();
    listGender.add(GenderModel(title: TITLE_MALE, type: MALE_Gender));
    listGender.add(GenderModel(title: TITLE_FEMALE, type: FEMALE_Gender));
  }

  MyScreenUtil? screenUtil;
  GlobalKey _globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    screenUtil = getScreenUtilInstance(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(TITLE_CREATININE),
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
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Your $TITLE_CREATININE Result : ',
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
                                    calc
                                            .calculateDoubleCreatenine()
                                            .toStringAsFixed(1) +
                                        " ml/min",
                                    style: kResultTextStyle,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    calc.getResult()[0],
                                    style: kResultTextStyle,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    calc.getResult()[1],
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
                        border: Border.all(color: Colors.grey[200]!),
                        color: Colors.white,
                      ),
                      child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Text(
                              'Gender : ',
                              style: getTitleStyle(),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Row(
                                children: listGender
                                    .map((e) => Expanded(
                                        child: addRadioButton(e.type, e.title)))
                                    .toList()),
                          ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          bottom: 15, left: 7, top: 15, right: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age : ',
                            style: getTitleStyle(),
                          ),
                          Container(
                            height: 150,
                            child: FormFieldWidget(
                              focusNode: ageFocusNode,
                              controller: ageController,
                              textInputType: TextInputType.number,
                              hintText: 'Age',
                            ).doneKeyBoard(ageFocusNode, context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          bottom: 15, left: 7, top: 15, right: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weight (in kg) : ',
                            style: getTitleStyle(),
                          ),
                          Container(
                            height: 150,
                            child: FormFieldWidget(
                              focusNode: weightFocusNode,
                              controller: weightController,
                              textInputType: TextInputType.number,
                              hintText: 'Weight',
                            ).doneKeyBoard(weightFocusNode, context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                              'Serum Creatinine: ',
                              style: getTitleStyle(),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Row(children: [
                              Expanded(
                                child: addRadioButtonUnit(
                                    MG_DL, TITLE_CREATININE_MG_DL),
                              ),
                              Expanded(
                                child: addRadioButtonUnit(
                                    UM_OL_L, TITLE_CREATININE_UMOL_L),
                              )
                            ]),
                            Container(
                              height: 110,
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: FormFieldWidget(
                                focusNode: creatinineFocusNode,
                                controller: creatinineController,
                                textInputType: TextInputType.number,
                                hintText: 'Creatinine',
                              ).doneKeyBoard(creatinineFocusNode, context),
                            ),
                          ]),
                    ),
                    getButton()
                  ],
                ),
        ),
      ),
    );
  }

  GestureDetector getButton() {
    // String title = "CALCULATE Creatinine";
    return getCommonCalculateButton(
        title: buttonTitle,
        onClick: () {
          isBodyFat = false;
          if (ageController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Age Required!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (weightController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Weight Required!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (creatinineController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Creatinine Required!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            calc = CreatenineBrain(
                weight: double.parse(weightController.text),
                creatinine: double.parse(creatinineController.text),
                age: int.parse(ageController.text),
                unit: cretenineUnit,
                gender: selectedGender);
            calc.calculateDoubleCreatenine();
            viewController.add(true);
          }
        }) as GestureDetector;
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

  CreatenineBrain calc = CreatenineBrain();
  LifeStyleModel? selectedModel;
  StreamController<LifeStyleModel?> lifeStyleController =
      StreamController<LifeStyleModel?>.broadcast();

  Widget addRadioButton(int? btnValue, String? title) => StreamBuilder<int?>(
        initialData: selectedGender,
        stream: genderStreamController.stream,
        builder: (_, snapshot) => GestureDetector(
          onTap: () {
            selectedGender = btnValue;
            genderStreamController.add(btnValue);
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
                  groupValue: snapshot.data,
                  onChanged: (dynamic value) {
                    selectedGender = btnValue;
                    genderStreamController.add(btnValue);
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text(title!))
            ],
          ),
        ),
      );

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
                width: 10,
              ),
              SizedBox(
                width: 10,
                height: 10,
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
                width: 10,
              ),
              Expanded(
                  child: Text(
                title,
                style: TextStyle(fontSize: 12),
              ))
            ],
          ),
        ),
      );

  Widget lifetStyleRadioButton(LifeStyleModel title) =>
      StreamBuilder<LifeStyleModel?>(
        initialData: selectedModel,
        stream: lifeStyleController.stream,
        builder: (_, snapshot) {
          return GestureDetector(
            onTap: () {
              selectLifeStyle(title);
            },
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    selectLifeStyle(title);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 6,
                    ),
                    decoration:
                        softCardShadow.copyWith(color: Color(0xFFF5F5F5)),
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
                                      title.value == selectedModel!.value
                                  ? primaryColor
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                        Expanded(
                            child:
                                Text(title.title!, style: styleMutedTextSmall)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  void selectLifeStyle(LifeStyleModel title) {
    selectedModel = title;
    lifeStyleController.add(selectedModel);
  }

  void _capturePng() async {
    if (await PermissionUtil.getStoragePermission(
      context: context,
      screenUtil: screenUtil,
    )) {
      String filePath = await saveScreenShot(_globalKey, TITLE_CREATININE);
      shareOption(filePath,
          "Hi here is your " + TITLE_CREATININE + " value for your reference.");
    }
  }
}

class GenderModel {
  final int? type;
  final String? title;

  GenderModel({this.type, this.title});
}
