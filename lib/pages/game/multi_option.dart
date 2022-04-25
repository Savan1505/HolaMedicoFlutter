import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/quiz_answer_model.dart';
import 'package:pharmaaccess/models/quiz_question_model.dart';
import 'package:pharmaaccess/widgets/game_question.dart';

class MultiOptionPage extends StatelessWidget {
  final QuizQuestion question;
  final List<String> options;
  MultiOptionPage(this.question, this.options);

  @override
  Widget build(BuildContext context) {
    print(options.length);
    print(options);
    //TODO in-active code
    /*  print(quizQuestion); */
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: Column(
          children: <Widget>[
            QuizQuestionWidget(this.question.question),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                        child: Text((index + 1).toString(),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                            )),
                      ),
                      title: RaisedButton(
                        child: Text(
                          options[index],
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                        onPressed: () {
                          bool result = question.answer!.toLowerCase() ==
                              options[index].toLowerCase();
                              //TODO in-active code
                              
                          /* Navigator.of(context).pop<QuizAnswer>(QuizAnswer(
                              question.questionId,
                              question.answer,
                              options[index],
                              result ? 'r' : 'w',
                              result ? 2 : 0)); */
                        },
                      ),
                    );
                  }),
            ),
          ],
        )),
      ),
    );
  }
}
