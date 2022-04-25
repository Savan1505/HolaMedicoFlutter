import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/CommonExtension.dart';
import 'package:pharmaaccess/pages/cardio_module/constants.dart';
import 'package:pharmaaccess/pages/cardio_module/models/CalculatorBrain.dart';
import 'package:pharmaaccess/pages/cardio_module/wigets/reusable_card.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/helper_functions.dart';
import 'package:pharmaaccess/util/screen_shot.dart';
import 'package:pharmaaccess/widgets/commons.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';

class MetaBolicCalculator extends StatefulWidget {
  final int type;
  final String? title;

  const MetaBolicCalculator({Key? key, this.type = BMI, this.title})
      : super(key: key);

  @override
  _MetaBolicCalculatorState createState() => _MetaBolicCalculatorState();
}

class _MetaBolicCalculatorState extends State<MetaBolicCalculator> {
  ScrollController _scrollController = new ScrollController();
  int? selectedGender = 1;

  StreamController<int?> genderStreamController =
      StreamController<int?>.broadcast();

  StreamController<bool> viewController = StreamController<bool>.broadcast();

  // List gender = ["Male", "Female"];
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  FocusNode ageFocusNode = FocusNode();

  FocusNode heightFocusNode = FocusNode();

  FocusNode weightFocusNode = FocusNode();

  bool isBodyFat = false;
  List<GenderModel> listGender = [];

  CalculatorBrain calc = CalculatorBrain();
  LifeStyleModel? selectedModel;
  StreamController<LifeStyleModel?> lifeStyleController =
      StreamController<LifeStyleModel?>.broadcast();

  MyScreenUtil? screenUtil;
  GlobalKey _globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.type == LBM ||
        widget.type == CALORIE_CALCULATOR ||
        widget.type == BASAL_METABOLIC_RATE) {
      listGender.add(GenderModel(title: TITLE_MALE, type: MALE_Gender));
      listGender.add(GenderModel(title: TITLE_FEMALE, type: FEMALE_Gender));
    } else if (widget.type == BODY_FAT) {
      listGender.add(GenderModel(title: TITLE_A_MALE, type: MALE_Gender));
      listGender.add(GenderModel(title: TITLE_A_FEMALE, type: FEMALE_Gender));
      listGender.add(GenderModel(title: TITLE_BOY, type: BOY_Gender));
      listGender.add(GenderModel(title: TITLE_GIRL, type: GIRL_Gender));
    }
  }

  @override
  Widget build(BuildContext context) {
    screenUtil = getScreenUtilInstance(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.title!),
      ),
      body: Container(
        margin: EdgeInsets.all(screenUtil!.setHeight(15) as double),
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
                              top: screenUtil!.setHeight(10) as double,
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
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: RepaintBoundary(
                          key: _globalKey,
                          child: Container(
                            color: Colors.grey[50],
                            child: Column(
                              children: [
                                if (widget.type == BODY_FAT) ...[
                                  Text(calc.getRestultTitle())
                                ],
                                SizedBox(
                                  height: screenUtil!.setHeight(10) as double?,
                                ),
                                if (widget.type == BMI) ...[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: getBox(
                                            "Under weight", "18.5", Colors.red),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: getBox("Healthy weight", "24.9",
                                            Colors.greenAccent),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: getBox(
                                            "Over weight", "30", Colors.yellow),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: getBox(
                                            "Obese", "39.9", Colors.red,
                                            isLast: true),
                                      )
                                    ],
                                  ),
                                ] else if (widget.type == BODY_FAT) ...[
                                  Row(
                                    children: calc.chartModels
                                        .map(
                                          (e) => Expanded(
                                            child: getBox(
                                                e.title!,
                                                e.value!.split("-")[1] + " %",
                                                e.color,
                                                isLast: e.index == 3),
                                          ),
                                        )
                                        .toList(),
                                  )
                                ],
                                Container(
                                  padding: EdgeInsets.all(
                                      screenUtil!.setHeight(15) as double),
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'The Result : ',
                                    style: getTitleTextStyle(screenUtil!),
                                  ),
                                ),
                                ReusableCard(
                                  colour: widget.type != BODY_FAT
                                      ? primaryColor
                                      : calc.resultColor,
                                  cardChild: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      if (widget.type == BMI) ...[
                                        Text(
                                          calc.getResult().toUpperCase(),
                                          style:
                                              getResultTextStyle(screenUtil!),
                                        ),
                                      ] else if (widget.type == BODY_FAT) ...[
                                        Text(
                                          calc.resultForBodyFat!.toUpperCase(),
                                          style:
                                              getResultTextStyle(screenUtil!),
                                        ),
                                        SizedBox(
                                          height: screenUtil!.setHeight(10)
                                              as double?,
                                        )
                                      ] else if (widget.type ==
                                          CALORIE_CALCULATOR) ...[
                                        Text(
                                          "The required daily Calorie intake = ${calc.calculateBMI()} Calories",
                                          // style: kResultTextStyle,
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontSize: screenUtil!.setSp(14)
                                                as double?,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenUtil!.setHeight(10)
                                              as double?,
                                        )
                                      ],
                                      if (widget.type == LBM) ...[
                                        Text(
                                          calc.calculateBMI() + " kg",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenUtil!.setSp(14)
                                                as double?,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ] else ...[
                                        Visibility(
                                          visible:
                                              widget.type != CALORIE_CALCULATOR,
                                          child: Text(
                                            calc.calculateBMI() +
                                                ((widget.type ==
                                                        BASAL_METABOLIC_RATE)
                                                    ? " Calories / day"
                                                    : getData()),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenUtil!.setSp(14)
                                                  as double?,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                      SizedBox(
                                        height: 5,
                                      ),
                                      if (widget.type == BMI) ...[
                                        Text(
                                          calc.getInterpretation(),
                                          textAlign: TextAlign.center,
                                          style: getBodyTextStyle(screenUtil!),
                                        ),
                                      ],
                                      SizedBox(
                                        height: screenUtil!.setHeight(15)
                                            as double?,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenUtil!.setHeight(10) as double?,
                    ),
                  ],
                )
              : ListView(
                  children: <Widget>[
                    Visibility(
                      visible: widget.type != BMI,
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: screenUtil!.setHeight(15) as double,
                          left: screenUtil!.setWidth(7) as double,
                          top: screenUtil!.setHeight(15) as double,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              screenUtil!.setHeight(10) as double),
                          border: Border.all(color: Colors.grey[200]!),
                          color: Colors.white,
                        ),
                        child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              Text(
                                'Gender : ',
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
                              if (widget.type == LBM ||
                                  widget.type == BASAL_METABOLIC_RATE ||
                                  widget.type == CALORIE_CALCULATOR) ...[
                                Row(
                                    children: listGender
                                        .map((e) => Expanded(
                                            child: addRadioButton(
                                                e.type, e.title)))
                                        .toList()),
                              ] else if (widget.type == BODY_FAT) ...[
                                GridView.count(
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  childAspectRatio: MediaQuery.of(context)
                                          .size
                                          .width /
                                      (MediaQuery.of(context).size.height / 4),
                                  children: listGender
                                      .map((e) =>
                                          addRadioButton(e.type, e.title))
                                      .toList(),
                                  padding: EdgeInsets.all(
                                      screenUtil!.setHeight(10) as double),
                                ),
                              ]
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (widget.type != BMI && widget.type != LBM) ...[
                      Text(
                        'Age : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: screenUtil!.setSp(10) as double?),
                      ),
                      FormFieldWidget(
                        focusNode: ageFocusNode,
                        controller: ageController,
                        textInputType: TextInputType.number,
                        hintText: 'Age',
                      ).doneKeyBoard(ageFocusNode, context),
                    ],
                    Container(
                      height: 150,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weight (in kg) : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          screenUtil!.setSp(10) as double?),
                                ),
                                FormFieldWidget(
                                  focusNode: weightFocusNode,
                                  controller: weightController,
                                  textInputType: TextInputType.number,
                                  hintText: 'Weight',
                                ).doneKeyBoard(weightFocusNode, context),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenUtil!.setWidth(10) as double?,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Height (in cm) : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                          screenUtil!.setSp(10) as double?),
                                ),
                                FormFieldWidget(
                                  focusNode: heightFocusNode,
                                  controller: heightController,
                                  textInputType: TextInputType.number,
                                  hintText: 'Height',
                                ).doneKeyBoard(heightFocusNode, context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.type == CALORIE_CALCULATOR) ...[
                      SizedBox(
                        height: screenUtil!.setHeight(10) as double?,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            bottom: screenUtil!.setHeight(15) as double,
                            left: screenUtil!.setWidth(10) as double,
                            right: screenUtil!.setWidth(10) as double,
                            top: screenUtil!.setHeight(15) as double),
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
                              'Life Style : ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenUtil!.setSp(10) as double?),
                            ),
                            SizedBox(
                              height: screenUtil!.setHeight(5) as double?,
                            ),
                            Column(
                              children: listLifeStyle
                                  .map((e) => lifetStyleRadioButton(e))
                                  .toList(),
                            )
                          ],
                        ),
                      ),
                    ],
                    SizedBox(
                      height: screenUtil!.setHeight(20) as double?,
                    ),
                    getButton(),
                    SizedBox(
                      height: screenUtil!.setHeight(5) as double?,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String getData() {
    return widget.type == BODY_FAT ? "" : " Kg/m2";
  }

  GestureDetector getButton() {
    String title = "CALCULATE ";
    if (widget.type == BMI) {
      title = title + TITLE_BMI;
    } else if (widget.type == LBM) {
      title = title + "LBM";
    } else if (widget.type == BODY_FAT) {
      title = title + TITLE_BODY_FAT_PER;
    } else if (widget.type == BASAL_METABOLIC_RATE) {
      title = title + "BMR";
    } else if (widget.type == CALORIE_CALCULATOR) {
      title = title + "Calorie";
    }
    return getCommonCalculateButton(
        title: title,
        onClick: () {
          isBodyFat = false;
          if (widget.type == BMI || widget.type == LBM) {
            if (weightController.text.trim().isEmpty) {
              weightRequired();
            } else if (heightController.text.trim().isEmpty) {
              heightRequired();
            } else {
              calculateData();
            }
          } else if (widget.type == BODY_FAT ||
              widget.type == BASAL_METABOLIC_RATE) {
            if (ageController.text.trim().isEmpty) {
              ageRequired();
            } else if (weightController.text.trim().isEmpty) {
              weightRequired();
            } else if (heightController.text.trim().isEmpty) {
              heightRequired();
            } else {
              calculateData();
            }
          } else if (widget.type == CALORIE_CALCULATOR) {
            if (ageController.text.trim().isEmpty) {
              ageRequired();
            } else if (weightController.text.trim().isEmpty) {
              weightRequired();
            } else if (heightController.text.trim().isEmpty) {
              heightRequired();
            } else if (selectedModel == null) {
              lifeStyleRequiredRequired();
            } else {
              calculateData();
            }
          }
        }) as GestureDetector;
  }

  void heightRequired() {
    scafolldMethod('Height Required!');
  }

  void lifeStyleRequiredRequired() {
    scafolldMethod('Life Style Required!');
  }

  void scafolldMethod(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void weightRequired() {
    scafolldMethod('Weight Required!');
  }

  void ageRequired() {
    scafolldMethod('Age Required!');
  }

  void calculateData() {
    calc = CalculatorBrain(
        height: heightController.text.isNotEmpty
            ? double.parse(heightController.text)
            : 0,
        weight: weightController.text.isNotEmpty
            ? double.parse(weightController.text)
            : 0,
        type: widget.type,
        selectedModel: selectedModel,
        age: ageController.text.isNotEmpty ? int.parse(ageController.text) : 0,
        gender: selectedGender);
    calc.calculateDoubloeBMI();
    hideKeyboard();
    viewController.add(true);
  }

  Column getBox(String title, String value, Color? color,
      {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: screenUtil!.setHeight(12) as double?,
          color: color,
        ),
        Transform.translate(
          child: Text(
            value,
            style: TextStyle(fontSize: screenUtil!.setSp(10) as double?),
          ),
          offset: Offset((isLast) ? 0 : 22, 0),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(fontSize: screenUtil!.setSp(7.5) as double?),
          ),
        )
      ],
    );
  }

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
                width: screenUtil!.setWidth(20) as double?,
                height: screenUtil!.setHeight(10) as double?,
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
                width: screenUtil!.setWidth(10) as double?,
              ),
              Expanded(
                  child: Text(
                title!,
                style: TextStyle(fontSize: 18),
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
                    margin: EdgeInsets.symmetric(
                        vertical: screenUtil!.setHeight(4) as double,
                        horizontal: 0),
                    padding: EdgeInsets.symmetric(
                      vertical: screenUtil!.setHeight(6) as double,
                    ),
                    // decoration:
                    //     softCardShadow.copyWith(color: Color(0xFFF5F5F5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              right: screenUtil!.setWidth(8) as double),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: screenUtil!.setHeight(12) as double?,
                              width: screenUtil!.setHeight(12) as double?,
                              color: selectedModel != null &&
                                      title.value == selectedModel!.value
                                  ? primaryColor
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Text(title.title!,
                                style:
                                    getTextStyleMutedTextMedium(screenUtil))),
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
      String filePath = await saveScreenShot(_globalKey, widget.title!);
      shareOption(filePath,
          "Hi here is your " + widget.title! + " value for your reference.");
    }
  }
}

class GenderModel {
  final int? type;
  final String? title;

  GenderModel({this.type, this.title});
}
