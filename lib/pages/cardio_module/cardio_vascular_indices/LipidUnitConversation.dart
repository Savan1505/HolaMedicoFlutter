import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/CommonExtension.dart';
import 'package:pharmaaccess/pages/cardio_module/wigets/reusable_card.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/screen_shot.dart';
import 'package:pharmaaccess/widgets/commons.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:spannable_grid/spannable_grid.dart';

class LipidUnitConversation extends StatefulWidget {
  final String? title;
  final int? type;

  const LipidUnitConversation({Key? key, this.title, this.type})
      : super(key: key);

  @override
  _LipidUnitConversationState createState() => _LipidUnitConversationState();
}

class _LipidUnitConversationState extends State<LipidUnitConversation> {
  StreamController<bool> viewController = StreamController<bool>.broadcast();

  StreamController<int> optoinController = StreamController<int>.broadcast();

  final creatinineController = TextEditingController();

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
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
        padding: EdgeInsets.all(15),
        child: ListView(children: [
          StreamBuilder<int>(
              initialData: cretenineUnit,
              stream: optoinController.stream,
              builder: (_, snapshot) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Expanded(
                        child: addRadioButtonUnit(MG_DL, TITLE_MGDL),
                      ),
                      Expanded(
                        child: addRadioButtonUnit(UM_OL_L, TITLE_MMOL),
                      )
                    ]),
                    Container(
                      height: 150,
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: FormFieldWidget(
                        focusNode: focusNode,
                        controller: creatinineController,
                        textInputType: TextInputType.number,
                        hintText: 'Total Cholesterol',
                      ).doneKeyBoard(focusNode, context),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    getButton()
                  ],
                );
              }),
          StreamBuilder<bool>(
            initialData: false,
            stream: viewController.stream,
            builder: (_, snapshot) => !snapshot.data!
                ? Text('')
                : Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            child: ReusableCard(
                              colour: primaryColor,
                              cardChild: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    getResult(),
                                    // style: kResultTextStyle,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                _capturePng();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
                                  bottom: 5,
                                  left: 5,
                                  right: 10,
                                ),
                                child: Image.asset(
                                  'assets/images/icon_share.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.06,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      RepaintBoundary(
                        key: _globalKey,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              getInfoWidget(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ]),
      ),
    );
  }

  String getResult() {
    double value = double.parse(creatinineController.text);
    double unitCOnvertorVal = widget.type == COLESTROL ? 38.6 : 88.5;
    if (cretenineUnit == MG_DL) {
      value = value / unitCOnvertorVal;
    } else {
      value = value * unitCOnvertorVal;
    }
    return value.toStringAsFixed(2);
  }

  int cretenineUnit = MG_DL;

  Widget addRadioButtonUnit(int btnValue, String title) => GestureDetector(
        onTap: () {
          cretenineUnit = btnValue;
          viewController.add(false);
          optoinController.add(btnValue);
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
                groupValue: cretenineUnit,
                onChanged: (dynamic value) {
                  cretenineUnit = btnValue;
                  viewController.add(false);
                  optoinController.add(btnValue);
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
      );

  GestureDetector getButton() {
    String title = "CONVERT ";

    if (cretenineUnit == MG_DL) {
      title = title + " to " + TITLE_MMOL;
    } else {
      title = title + " to " + TITLE_MGDL;
    }
    return getCommonCalculateButton(
        title: title,
        isUpperCase: false,
        onClick: () {
          if (creatinineController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please enter data to convert!'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            viewController.add(true);
          }
          /*if (ageController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Age Required!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else*/
          /*  if (heightController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Height Required!'),
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
        } else if (selectedModel == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please select life style'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {*/

          // }
        }) as GestureDetector;
  }

  void _capturePng() async {
    if (await PermissionUtil.getStoragePermission(
      context: context,
      screenUtil: screenUtil,
    )) {
      String filePath = await saveScreenShot(_globalKey, widget.title!);
      shareOption(
          filePath,
          "Hi, here is the Healthy " +
              getTitleTable() +
              " Range table for your reference");
    }
  }

  String getTitleTable() =>
      ((widget.type == COLESTROL) ? "Cholesterol" : "Triglycerides");

  Widget getInfoWidget() {
    List<SpannableGridCellData> cells = [];
    cells.add(SpannableGridCellData(
      column: 1,
      row: 1,
      columnSpan: 5,
      rowSpan: 1,
      id: 11,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              color: Colors.black,
            ),
            right: BorderSide(
              color: Colors.black,
            ),
            top: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        child: Center(
          child: Text(
            "Healthy " + getTitleTable() + " Range",
            style: getHeadingTextStyle(),
          ),
        ),
      ),
    ));
    cells.add(SpannableGridCellData(
      column: 1,
      row: 2,
      columnSpan: 1,
      rowSpan: 1,
      id: 21,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              color: Colors.black,
            ),
            top: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        child: Center(
          child: Text(
            "",
          ),
        ),
      ),
    ));
    cells.add(SpannableGridCellData(
      column: 2,
      row: 2,
      columnSpan: 1,
      rowSpan: 1,
      id: 22,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              color: Colors.black,
            ),
            top: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        child: Center(
          child: Text(
            "Unit",
            style: getValueBlackTextStyle(),
          ),
        ),
      ),
    ));
    cells.add(SpannableGridCellData(
      column: 3,
      row: 2,
      columnSpan: 1,
      rowSpan: 1,
      id: 23,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border(
            left: BorderSide(
              color: Colors.black,
            ),
            top: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        child: Center(
          child: Text(
            "Optimal",
            style: getValueBlackTextStyle(),
          ),
        ),
      ),
    ));
    cells.add(SpannableGridCellData(
      column: 4,
      row: 2,
      columnSpan: 1,
      rowSpan: 1,
      id: 24,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
          border: Border(
            left: BorderSide(
              color: Colors.black,
            ),
            top: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        child: Center(
          child: Text(
            "Intermediate",
            style: getValueBlackTextStyle(),
          ),
        ),
      ),
    ));
    cells.add(SpannableGridCellData(
      column: 5,
      row: 2,
      columnSpan: 1,
      rowSpan: 1,
      id: 25,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border(
            left: BorderSide(
              color: Colors.black,
            ),
            right: BorderSide(
              color: Colors.black,
            ),
            top: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        child: Center(
          child: Text(
            "High",
            style: getValueWhiteTextStyle(),
          ),
        ),
      ),
    ));

    if (widget.type == COLESTROL) {
      cells.add(SpannableGridCellData(
        column: 1,
        row: 3,
        columnSpan: 1,
        rowSpan: 2,
        id: 31,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "Total Cholesterol",
              textAlign: TextAlign.center,
              style: getHeadingTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 2,
        row: 3,
        columnSpan: 1,
        rowSpan: 1,
        id: 32,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "mg/dL",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 3,
        row: 3,
        columnSpan: 1,
        rowSpan: 1,
        id: 33,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "<200",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 4,
        row: 3,
        columnSpan: 1,
        rowSpan: 1,
        id: 34,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "200 - 239",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 5,
        row: 3,
        columnSpan: 1,
        rowSpan: 1,
        id: 35,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              right: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              ">239",
              style: getValueWhiteTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 2,
        row: 4,
        columnSpan: 1,
        rowSpan: 1,
        id: 42,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "mmol/L",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 3,
        row: 4,
        columnSpan: 1,
        rowSpan: 1,
        id: 43,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "<5.2",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 4,
        row: 4,
        columnSpan: 1,
        rowSpan: 1,
        id: 44,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "5.3 - 6.2",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 5,
        row: 4,
        columnSpan: 1,
        rowSpan: 1,
        id: 45,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              right: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              ">6.2",
              style: getValueWhiteTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 1,
        row: 5,
        columnSpan: 1,
        rowSpan: 2,
        id: 51,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "LDL Cholesterol",
              textAlign: TextAlign.center,
              style: getHeadingTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 2,
        row: 5,
        columnSpan: 1,
        rowSpan: 1,
        id: 52,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "mg/dL",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 3,
        row: 5,
        columnSpan: 1,
        rowSpan: 1,
        id: 53,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "<130",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 4,
        row: 5,
        columnSpan: 1,
        rowSpan: 1,
        id: 54,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "130 - 159",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 5,
        row: 5,
        columnSpan: 1,
        rowSpan: 1,
        id: 55,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              right: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              ">159",
              style: getValueWhiteTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 2,
        row: 6,
        columnSpan: 1,
        rowSpan: 1,
        id: 62,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "mmol/L",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 3,
        row: 6,
        columnSpan: 1,
        rowSpan: 1,
        id: 63,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "<3.36",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 4,
        row: 6,
        columnSpan: 1,
        rowSpan: 1,
        id: 64,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "3.36 - 4.11",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 5,
        row: 6,
        columnSpan: 1,
        rowSpan: 1,
        id: 65,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              right: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              ">4.11",
              style: getValueWhiteTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 1,
        row: 7,
        columnSpan: 1,
        rowSpan: 2,
        id: 71,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "HDL Cholesterol",
              textAlign: TextAlign.center,
              style: getHeadingTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 2,
        row: 7,
        columnSpan: 1,
        rowSpan: 1,
        id: 72,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "mg/dL",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 3,
        row: 7,
        columnSpan: 1,
        rowSpan: 1,
        id: 73,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              ">60",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 4,
        row: 7,
        columnSpan: 1,
        rowSpan: 1,
        id: 74,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "40 - 60",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 5,
        row: 7,
        columnSpan: 1,
        rowSpan: 1,
        id: 75,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              right: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "<40",
              style: getValueWhiteTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 2,
        row: 8,
        columnSpan: 1,
        rowSpan: 1,
        id: 82,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "mmol/L",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 3,
        row: 8,
        columnSpan: 1,
        rowSpan: 1,
        id: 83,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              ">1.55",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 4,
        row: 8,
        columnSpan: 1,
        rowSpan: 1,
        id: 84,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "1.03 - 1.55",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 5,
        row: 8,
        columnSpan: 1,
        rowSpan: 1,
        id: 85,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              right: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "<1.03",
              style: getValueWhiteTextStyle(),
            ),
          ),
        ),
      ));
    } else {
      cells.add(SpannableGridCellData(
        column: 1,
        row: 3,
        columnSpan: 1,
        rowSpan: 2,
        id: 31,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "Triglycerides",
              textAlign: TextAlign.center,
              style: getHeadingTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 2,
        row: 3,
        columnSpan: 1,
        rowSpan: 1,
        id: 32,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "mg/dL",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 3,
        row: 3,
        columnSpan: 1,
        rowSpan: 1,
        id: 33,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "<150",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 4,
        row: 3,
        columnSpan: 1,
        rowSpan: 1,
        id: 34,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "150 - 199",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 5,
        row: 3,
        columnSpan: 1,
        rowSpan: 1,
        id: 35,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              right: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              ">199",
              style: getValueWhiteTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 2,
        row: 4,
        columnSpan: 1,
        rowSpan: 1,
        id: 42,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "mmol/L",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 3,
        row: 4,
        columnSpan: 1,
        rowSpan: 1,
        id: 43,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "<1.69",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 4,
        row: 4,
        columnSpan: 1,
        rowSpan: 1,
        id: 44,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "1.69 - 2.25",
              style: getValueBlackTextStyle(),
            ),
          ),
        ),
      ));
      cells.add(SpannableGridCellData(
        column: 5,
        row: 4,
        columnSpan: 1,
        rowSpan: 1,
        id: 45,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border(
              left: BorderSide(
                color: Colors.black,
              ),
              right: BorderSide(
                color: Colors.black,
              ),
              top: BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          child: Center(
            child: Text(
              ">2.25",
              style: getValueWhiteTextStyle(),
            ),
          ),
        ),
      ));
    }
    return SpannableGrid(
      columns: 5,
      rows: (widget.type == COLESTROL) ? 8 : 4,
      cells: cells,
      spacing: 0,
      rowHeight: 24,
      onCellChanged: (cell) {},
    );
  }
}

TextStyle getValueBlackTextStyle() => TextStyle(
      fontSize: 10,
      color: Colors.black,
      height: 1.5,
      fontWeight: FontWeight.normal,
    );

TextStyle getValueWhiteTextStyle() => TextStyle(
      fontSize: 10,
      color: Colors.white,
      height: 1.5,
      fontWeight: FontWeight.normal,
    );

TextStyle getHeadingTextStyle() => TextStyle(
      fontSize: 10,
      color: Colors.black,
      height: 1,
      fontWeight: FontWeight.w700,
    );
