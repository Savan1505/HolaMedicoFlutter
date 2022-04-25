import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/pages/brand/pharma_covigilance_page.dart';
import 'package:pharmaaccess/pages/cardio_module/diabetes_quiz/models/DiabetesQuestionModel.dart';
import 'package:pharmaaccess/theme.dart';

import 'diabetes_form_widget.dart';

class DiabetesItemWidget extends StatefulWidget {
  final Function? onItemSelected;
  final int? index;
  final DiabetesQuestionModel? questionModel;

  const DiabetesItemWidget(
      {Key? key, this.onItemSelected, this.questionModel, this.index})
      : super(key: key);

  @override
  _DiabetesItemWidgetState createState() => _DiabetesItemWidgetState();
}

class _DiabetesItemWidgetState extends State<DiabetesItemWidget> {
  StreamController<String?> ansterStreamController =
      StreamController<String?>.broadcast();
  List gender = ["Male", "Female"];
  int selectedGender = 0;

  StreamController<String?> genderStreamController =
      StreamController<String?>.broadcast();

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(right: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${widget.index! + 1}. ${widget.questionModel!.question}",
                    style: styleBoldSmallBodyText,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            if (widget.questionModel!.isGender) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gender : ',
                    style: getTitleStyle(),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(child: addRadioButtonGender(0, gender[0])),
                      Expanded(child: addRadioButtonGender(1, gender[1])),
                    ],
                  ),
                ],
              )
            ],
            StreamBuilder<String?>(
              initialData: selectedAnswer,
              stream: ansterStreamController.stream,
              builder: (_, snapshot) => ListView.builder(
                itemBuilder: (_, index) => Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: addRadioButton(
                      widget.questionModel!.listAns![index].answerTitle,
                      widget.questionModel!.listAns![index]),
                ),
                itemCount: widget.questionModel!.listAns!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            )
          ],
        ),
      );

  String? selectedAnswer = "";

  Widget addRadioButton(String? title, ANswerModel aNswerModel) =>
      StreamBuilder<String?>(
        initialData: selectedAnswer,
        stream: ansterStreamController.stream,
        builder: (_, snapshot) {
          return GestureDetector(
            onTap: () {
              ansSelected(title, aNswerModel);
            },
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    ansSelected(title, aNswerModel);
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                if (widget.questionModel!.isGender) ...[
                                  TextSpan(
                                      text: selectedGender == 0
                                          ? title!.split("\n")[0]
                                          : title!.split("\n")[1],
                                      style: styleSmallBodyText)
                                ] else ...[
                                  TextSpan(
                                      text: title, style: styleSmallBodyText),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 16,
                              width: 16,
                              color: title == selectedAnswer
                                  ? primaryColor
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  void ansSelected(String? title, ANswerModel aNswerModel) {
    selectedAnswer = title;
    ansterStreamController.add(title);
    widget.onItemSelected!(
        AnswerModels(ansId: widget.index, point: aNswerModel.points));
  }

  Widget addRadioButtonGender(int btnValue, String title) =>
      StreamBuilder<String?>(
        initialData: gender[0],
        stream: genderStreamController.stream,
        builder: (_, snapshot) => GestureDetector(
          onTap: () {
            selectedGender = btnValue;
            genderStreamController.add(title);
            ansterStreamController.add(selectedAnswer);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
                height: 10,
                child: Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: gender[btnValue],
                  groupValue: snapshot.data,
                  onChanged: (dynamic value) {
                    genderStreamController.add(value);
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text(title))
            ],
          ),
        ),
      );
}
