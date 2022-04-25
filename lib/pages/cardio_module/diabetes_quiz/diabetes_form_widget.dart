import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/pages/cardio_module/diabetes_quiz/DiabetesItemWidget.dart';

import '../../../theme.dart';
import 'models/DiabetesQuestionModel.dart';

class DiabetesFormWidget extends StatefulWidget {
  final Function? onQuizDoneClick;

  DiabetesFormWidget({Key? key, this.onQuizDoneClick}) : super(key: key);

  @override
  _DiabetesFormWidgetState createState() => _DiabetesFormWidgetState();
}

class _DiabetesFormWidgetState extends State<DiabetesFormWidget> {
  List<DiabetesQuestionModel> list = [];

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(CALCULATOR_EVENT,
        param: {"name": "Diabetes Question"});
    list.add(
      DiabetesQuestionModel(
        question: "Age",
        listAns: [
          ANswerModel(points: 0, answerTitle: "Under 45 years"),
          ANswerModel(points: 2, answerTitle: "45–54 years"),
          ANswerModel(points: 3, answerTitle: "55–64 years"),
          ANswerModel(points: 4, answerTitle: "Over 64 years")
        ],
      ),
    );

    list.add(
      DiabetesQuestionModel(
        question: "Body-mass index",
        listAns: [
          ANswerModel(points: 0, answerTitle: "Lower than 25 kg/m2"),
          ANswerModel(points: 1, answerTitle: "25–30 kg/m2"),
          ANswerModel(points: 3, answerTitle: "Higher than 30 kg/m2")
        ],
      ),
    );

    list.add(
      DiabetesQuestionModel(
        question:
            "Waist circumference measured below the ribs (usually at the level of the navel)",
        isGender: true,
        listAns: [
          ANswerModel(
              points: 0, answerTitle: "Less than 94 cm\nLess than 80 cm"),
          ANswerModel(points: 3, answerTitle: "94–102 cm\n80–88 cm"),
          ANswerModel(
              points: 4, answerTitle: "More than 102 cm\nMore than 88 cm"),
        ],
      ),
    );

    list.add(
      DiabetesQuestionModel(
        question:
            "Do you usually have daily at least 30 minutes of physical activity at work and/or during leisure time (including normal daily activity)?",
        listAns: [
          ANswerModel(points: 0, answerTitle: "Yes"),
          ANswerModel(points: 2, answerTitle: "No")
        ],
      ),
    );

    list.add(
      DiabetesQuestionModel(
        question: "How often do you eat vegetables, fruit or berries?",
        listAns: [
          ANswerModel(points: 0, answerTitle: "Every day"),
          ANswerModel(points: 1, answerTitle: "Not every day"),
        ],
      ),
    );

    list.add(
      DiabetesQuestionModel(
        question:
            "Have you ever taken medication for high blood pressure on regular basis?",
        listAns: [
          ANswerModel(points: 0, answerTitle: "No"),
          ANswerModel(points: 2, answerTitle: "Yes"),
        ],
      ),
    );

    list.add(
      DiabetesQuestionModel(
        question:
            "Have you ever been found to have high blood glucose (eg in a health examination, during an illness, during pregnancy)?",
        listAns: [
          ANswerModel(points: 0, answerTitle: "No"),
          ANswerModel(points: 5, answerTitle: "Yes")
        ],
      ),
    );

    list.add(
      DiabetesQuestionModel(
        question:
            "Have any of the members of your immediate family or other relatives been diagnosed with diabetes (type 1 or type 2)?",
        listAns: [
          ANswerModel(points: 0, answerTitle: "No"),
          ANswerModel(
              points: 3,
              answerTitle:
                  "Yes: grandparent, aunt, uncle or first cousin (but no own parent, brother, sister or child)"),
          ANswerModel(
              points: 5,
              answerTitle: "Yes: parent, brother, sister or own child"),
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
      appBar: null,
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25, top: 5),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (_, index) => DiabetesItemWidget(
                    onItemSelected: (AnswerModels selectedAns) {
                      if (listAnsSelected.isEmpty) {
                        listAnsSelected.add(selectedAns);
                      } else {
                        bool isItemFound = false;
                        int indexToBeRemoved = 0;
                        for (int i = 0; i < listAnsSelected.length; i++) {
                          if (selectedAns.ansId == listAnsSelected[i].ansId) {
                            indexToBeRemoved = i;
                            isItemFound = true;
                            break;
                          }
                        }

                        if (isItemFound) {
                          listAnsSelected.removeAt(indexToBeRemoved);
                          listAnsSelected.add(selectedAns);
                        } else {
                          listAnsSelected.add(selectedAns);
                        }
                      }
                    },
                    index: index,
                    questionModel: list[index],
                  ),
                  onPageChanged: (index) {
                    isNextStreamController.add(index);
                  },
                  itemCount: list.length,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        initialData: 0,
        stream: isNextStreamController.stream,
        builder: (_, snapshot) {
          return Padding(
            padding: EdgeInsets.all(15),
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
                    width: 50,
                  ),
                ],
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor)),
                    onPressed:
                        snapshot.data != list.length - 1 ? nextPage : popScreen,
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
    if (list.length != listAnsSelected.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select all ans!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    int result = 0;
    for (int i = 0; i < listAnsSelected.length; i++) {
      result = result + listAnsSelected[i].point!;
    }

    widget.onQuizDoneClick!(result);
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

  List<AnswerModels> listAnsSelected = [];
}

class AnswerModels {
  final int? ansId;
  final int? point;

  AnswerModels({this.ansId, this.point});
}
