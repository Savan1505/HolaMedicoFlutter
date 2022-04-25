import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/pages/cardio_module/orthopaedic_indices/rheumatoid_arthritis/models/RheumatoidArthritisQuestionModel.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/util/Constants.dart';

import '../../../../theme.dart';
import 'RheumatoidArthritisItemWidget.dart';

class RheumatoidArthritisFormWidget extends StatefulWidget {
  final Function? onQuizDoneClick;
  final MyScreenUtil? screenUtil;

  RheumatoidArthritisFormWidget({
    Key? key,
    this.onQuizDoneClick,
    this.screenUtil,
  }) : super(key: key);

  @override
  _RheumatoidArthritisFormWidgetState createState() =>
      _RheumatoidArthritisFormWidgetState();
}

class _RheumatoidArthritisFormWidgetState
    extends State<RheumatoidArthritisFormWidget> {
  List<RheumatoidArthritisQuestionModel> list = [];

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(
      TITLE_ACR_EULAR_RHEUMATOID_ARTHRITIS_CLASSIFICATION,
    );
    list.add(
      RheumatoidArthritisQuestionModel(
        "Joint involvement",
        "Any swollen/tender joint on exam, excluding DIP joints and 1\u02e2\u1d57 MCP/MTP joints; select option that assigns the most possible points",
        [
          AnswerModel(points: 0, answerTitle: "1 large joint"),
          AnswerModel(points: 1, answerTitle: "2-10 large joints"),
          AnswerModel(
              points: 2,
              answerTitle:
                  "1-3 small joints (with or without involvement of large joints)"),
          AnswerModel(
              points: 3,
              answerTitle:
                  "4-10 small joints (with or without involvement of large joints)"),
          AnswerModel(
              points: 5, answerTitle: ">10 joints (at least 1 small joint)"),
        ],
      ),
    );
    list.add(
      RheumatoidArthritisQuestionModel(
        "Serology (need at least one serology test result to use these criteria)",
        "Negative = IU values ≤ULN per lab/assay; low-positive = IU values >ULN but <3x ULN; high-positive = IU values ≥3x ULN; if RF reported only as positive or negative, positive result should be scored as low-positive",
        [
          AnswerModel(
              points: 0,
              answerTitle:
                  "Negative rheumatoid factor and negative anti-citrullinated protein antibody"),
          AnswerModel(
              points: 2,
              answerTitle:
                  "Low-positive rheumatoid factor or low-positive anti-citrullinated protein antibody"),
          AnswerModel(
              points: 3,
              answerTitle:
                  "High-positive rheumatoid factor or high-positive anti-citrullinated protein antibody"),
        ],
      ),
    );
    list.add(
      RheumatoidArthritisQuestionModel(
        "Acute-phase reactants (need at least one acute-phase reactant test result to use these criteria)",
        "According to lab",
        [
          AnswerModel(points: 0, answerTitle: "Normal CRP and normal ESR"),
          AnswerModel(points: 1, answerTitle: "Abnormal CRP or abnormal ESR"),
        ],
      ),
    );
    list.add(
      RheumatoidArthritisQuestionModel(
        "Duration of symptoms",
        "Duration = patient self-report of the duration of synovitis signs/symptoms (e.g. pain, swelling, tenderness) in joints clinically involved at the time of assessment, regardless of treatment status",
        [
          AnswerModel(points: 0, answerTitle: "<6 weeks"),
          AnswerModel(points: 1, answerTitle: "≥6 weeks"),
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
      body: PageView.builder(
        controller: _pageController,
        itemBuilder: (_, index) => RheumatoidArthritisItemWidget(
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
          screenUtil: widget.screenUtil,
          index: index,
          questionModel: list[index],
        ),
        onPageChanged: (index) {
          isNextStreamController.add(index);
        },
        itemCount: list.length,
      ),
      bottomNavigationBar: StreamBuilder<int>(
        initialData: 0,
        stream: isNextStreamController.stream,
        builder: (_, snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              left: widget.screenUtil?.setWidth(20) as double,
              right: widget.screenUtil?.setWidth(20) as double,
              bottom: widget.screenUtil?.setHeight(15) as double,
            ),
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
