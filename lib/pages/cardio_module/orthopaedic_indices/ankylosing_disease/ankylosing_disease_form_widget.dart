import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaaccess/CommonExtension.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/pages/cardio_module/orthopaedic_indices/ankylosing_disease/ankylosing_disease_item_widget.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';

import '../../../../theme.dart';
import 'models/ankylosing_disease_model.dart';

class AnkylosingDiseaseFormWidget extends StatefulWidget {
  final Function(List<AnkylosingDiseaseQuestionModel>, double, int)?
      onQuizDoneClick;
  final MyScreenUtil? screenUtil;
  final String? title;

  AnkylosingDiseaseFormWidget({
    Key? key,
    this.onQuizDoneClick,
    this.screenUtil,
    this.title,
  }) : super(key: key);

  @override
  _AnkylosingDiseaseFormWidgetState createState() =>
      _AnkylosingDiseaseFormWidgetState();
}

class _AnkylosingDiseaseFormWidgetState
    extends State<AnkylosingDiseaseFormWidget> {
  ScrollController _scrollController = new ScrollController();
  List<AnkylosingDiseaseQuestionModel> questionList = [
    AnkylosingDiseaseQuestionModel(
      "Back pain",
      "Ask the patient: \"How would you describe the overall level of AS neck, back, or hip pain you have had?\"",
    ),
    AnkylosingDiseaseQuestionModel(
      "Duration of morning stiffness",
      "Ask the patient: \"How would you describe the overall level of morning stiffness you have had from the time you wake up?\"",
    ),
    AnkylosingDiseaseQuestionModel(
      "Patient global assessment of disease activity",
      "Ask the patient: \"How active was your spondylitis, on average, during the last week?\"",
    ),
    AnkylosingDiseaseQuestionModel(
      "Peripheral pain/swelling",
      "Ask the patient: \"How would you describe the overall level of pain/swelling in joints other than neck, back, or hips you have had?\"",
    ),
  ];

  FocusNode esrFocusNode = FocusNode();
  TextEditingController esrTextEditingController = TextEditingController();

  FocusNode crpFocusNode = FocusNode();
  TextEditingController crpTextEditingController = TextEditingController();
  int crpUnit = MG_L;
  StreamController<int> crpStreamController = StreamController<int>.broadcast();

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(CALCULATOR_EVENT,
        param: {"name": "Ankylosing Disease Question"});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    itemCount: questionList.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: widget.screenUtil
                              ?.setHeight((index == 0) ? 30 : 0) as double,
                        ),
                        child: AnkylosingDiseaseItemWidget(
                          model: questionList[index],
                          screenUtil: widget.screenUtil,
                          index: index,
                        ),
                      );
                    },
                  ),
                  if (widget.title == TITLE_ANKYLOSING_DISEASE_WITH_ESR)
                    ...getESRWidgets()
                  else
                    ...getCRPWidgets(),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: widget.screenUtil?.setWidth(15) as double,
            right: widget.screenUtil?.setWidth(15) as double,
            top: widget.screenUtil?.setHeight(15) as double,
            bottom: widget.screenUtil?.setHeight(15) as double,
          ),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor)),
            onPressed: onClickCalculate,
            child: Padding(
              padding: EdgeInsets.only(
                left: widget.screenUtil?.setWidth(30) as double,
                right: widget.screenUtil?.setWidth(30) as double,
              ),
              child: Text('Calculate'),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> getCRPWidgets() {
    return [
      Padding(
        padding: EdgeInsets.only(
          left: widget.screenUtil?.setWidth(30) as double,
          right: widget.screenUtil?.setWidth(30) as double,
          bottom: widget.screenUtil?.setHeight(10) as double,
        ),
        child: Text(
          "5) CRP (C-reactive Protein)",
          style: styleBoldSmallBodyText,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: widget.screenUtil?.setWidth(30) as double,
          right: widget.screenUtil?.setWidth(30) as double,
          bottom: widget.screenUtil?.setHeight(2) as double,
        ),
        child: StreamBuilder<int>(
            initialData: crpUnit,
            stream: crpStreamController.stream,
            builder: (_, snapshot) {
              return Row(children: [
                Expanded(
                  child: addRadioButtonUnit(MG_L, TITLE_MGL, () {
                    crpUnit = MG_L;
                    crpStreamController.add(crpUnit);
                  }, crpUnit),
                ),
                Expanded(
                  child: addRadioButtonUnit(MG_DL, TITLE_MGDL, () {
                    crpUnit = MG_DL;
                    crpStreamController.add(crpUnit);
                  }, crpUnit),
                )
              ]);
            }),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: widget.screenUtil?.setWidth(30) as double,
          right: widget.screenUtil?.setWidth(30) as double,
          bottom: widget.screenUtil?.setHeight(10) as double,
        ),
        child: Row(
          children: [
            Expanded(
              child: FormFieldWidget(
                focusNode: crpFocusNode,
                controller: crpTextEditingController,
                textInputType: TextInputType.number,
                hintText: 'CRP',
              ).doneKeyBoard(crpFocusNode, context),
            ),
            SizedBox(
              width: widget.screenUtil?.setWidth(10) as double,
            ),
            StreamBuilder<int>(
                initialData: crpUnit,
                stream: crpStreamController.stream,
                builder: (_, snapshot) {
                  return Text(
                    (snapshot.data == MG_L) ? TITLE_MGL : TITLE_MGDL,
                    style:
                        getTextStylePrimaryTextMediumTitle(widget.screenUtil),
                  );
                })
          ],
        ),
      ),
    ];
  }

  List<Widget> getESRWidgets() {
    return [
      Padding(
        padding: EdgeInsets.only(
          left: widget.screenUtil?.setWidth(30) as double,
          right: widget.screenUtil?.setWidth(30) as double,
          bottom: widget.screenUtil?.setHeight(10) as double,
        ),
        child: Text(
          "5) ESR (Erythrocyte sedimentation rate)",
          style: styleBoldSmallBodyText,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: widget.screenUtil?.setWidth(30) as double,
          right: widget.screenUtil?.setWidth(30) as double,
          bottom: widget.screenUtil?.setHeight(10) as double,
        ),
        child: Row(
          children: [
            Expanded(
              child: FormFieldWidget(
                focusNode: esrFocusNode,
                controller: esrTextEditingController,
                textInputType: TextInputType.number,
                hintText: 'ESR',
              ).doneKeyBoard(esrFocusNode, context),
            ),
            Text(
              " (mm/hr)",
              style: getTextStylePrimaryTextMediumTitle(widget.screenUtil),
            )
          ],
        ),
      ),
    ];
  }

  onClickCalculate() {
    if (widget.title == TITLE_ANKYLOSING_DISEASE_WITH_ESR) {
      if (esrTextEditingController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter ESR value"),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      widget.onQuizDoneClick!(
          questionList, double.parse(esrTextEditingController.text), 0);
    } else {
      if (crpTextEditingController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please enter CRP value"),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      widget.onQuizDoneClick!(
          questionList, double.parse(crpTextEditingController.text), crpUnit);
    }
  }

  @override
  void dispose() {
    crpStreamController.close();
    super.dispose();
  }

  Widget addRadioButtonUnit(
          int btnValue, String title, Function onClick, int groupValue) =>
      GestureDetector(
        onTap: () {
          onClick();
        },
        child: AbsorbPointer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: widget.screenUtil?.setWidth(10) as double,
              ),
              SizedBox(
                width: widget.screenUtil?.setWidth(8) as double,
                height: widget.screenUtil?.setHeight(8) as double,
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
                width: widget.screenUtil?.setWidth(10) as double,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: widget.screenUtil?.setSp(10) as double),
                ),
              )
            ],
          ),
        ),
      );
}
