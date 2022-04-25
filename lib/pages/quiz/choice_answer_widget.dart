import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/quiz_question_model.dart';

import '../../theme.dart';

class ChoiceAnswerListWidget extends StatefulWidget {
  final QuizQuestion? question;

  //final VoidCallback callback;
  final void Function(int) callback;

  ChoiceAnswerListWidget(
      {Key? key, required this.question, required this.callback})
      : super(key: key);

  @override
  _ChoiceAnswerListWidgetState createState() => _ChoiceAnswerListWidgetState();
}

class _ChoiceAnswerListWidgetState extends State<ChoiceAnswerListWidget> {
  int? selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    selectedIndex = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.question!.applicableChoices,
      itemBuilder: (BuildContext context, int index) {
        return ChoiceAnswerWidget(
          currentQuestion: widget.question,
          callback: itemClicked,
          index: index,
          currentIndex: selectedIndex,
        );
      },
    );
  }

  void itemClicked(index) {
    this.widget.callback(index);
    int value = index == selectedIndex ? -1 : index;
    setState(() {
      selectedIndex = value;
    });
  }
}

class ChoiceAnswerWidget extends StatelessWidget {
  final QuizQuestion? currentQuestion;
  final int? index;
  final int? currentIndex;
  final void Function(int? index)? callback;

  const ChoiceAnswerWidget(
      {Key? key,
      required this.currentQuestion,
      this.index,
      this.currentIndex,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback!(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 6,
        ),
        decoration: index == currentIndex
            ? softCardShadow.copyWith(color: Color(0xFFF5F5F5))
            : softCardShadow,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "${String.fromCharCode(65 + index!)}.   ",
              style: styleNormalBodyText.copyWith(color: primaryColor),
            ),
            Flexible(
                child: Text(currentQuestion!.choices!["choice_${index! + 1}"]!,
                    style: styleNormalBodyText)),
            // Flexible(
            //   child: RichText(
            //     text: TextSpan(
            //       children: <TextSpan>[
            //         TextSpan(
            //           text: "${String.fromCharCode(65 + index!)}.   ",
            //           style: styleNormalBodyText.copyWith(color: primaryColor),
            //         ),
            //         TextSpan(
            //             text: currentQuestion!.choices!["choice_${index! + 1}"],
            //             style: styleNormalBodyText),
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                    height: 16,
                    width: 16,
                    color: index == currentIndex ? primaryColor : Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
