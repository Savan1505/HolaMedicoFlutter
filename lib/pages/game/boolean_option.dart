import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/quiz_answer_model.dart';
import 'package:pharmaaccess/models/quiz_question_model.dart';
import 'package:pharmaaccess/widgets/game_question.dart';

class BooleanOptionPage extends StatelessWidget {
  final QuizQuestion question;
  final List<String> options;
  BooleanOptionPage(this.question, this.options);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: Column(
          children: <Widget>[
            QuizQuestionWidget(this.question.question),
            ButtonBar(
              buttonPadding: EdgeInsets.all(15),
              children: <Widget>[
                BooleanWidget(option: options[0], question: question),
                BooleanWidget(option: options[1], question: question),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

class BooleanWidget extends StatelessWidget {
  const BooleanWidget({
    Key? key,
    required this.option,
    required this.question,
  }) : super(key: key);

  final String option;
  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(option),
      onPressed: () {
        bool result = question.answer!.toLowerCase() == option.toLowerCase();
        /* Navigator.of(context).pop<QuizAnswer>(
          QuizAnswer(question.questionId,question.answer,option,
              result ? 'r' : 'w', result ? 2 : 0),
        ); */
        //TODO In-active code
      },
    );
  }
}
