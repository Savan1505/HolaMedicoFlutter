import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/quiz_answer_model.dart';
import 'package:pharmaaccess/models/quiz_question_model.dart';
import 'package:pharmaaccess/util/color_extension.dart';
import 'package:pharmaaccess/widgets/game_question.dart';

class ColorOptionPage extends StatelessWidget {
  final QuizQuestion question;
  final List<String> options;
  ColorOptionPage(this.question, this.options);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: Column(
          children: <Widget>[
            QuizQuestionWidget(this.question.question),
            Container(
              margin: EdgeInsets.all(40),
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: HexColor.fromHex(this.question.answer!.split('|')[0]),
              ),
              child: Container(),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Container(
                        margin: EdgeInsets.all(100.0),
                        decoration: BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                        child: Text((index + 1).toString()),
                      ),
                      title: MaterialButton(
                        child: Text(options[index]),
                        onPressed: () {
                          bool result =
                              question.answer!.split('|')[1].toLowerCase() ==
                                  options[index].toLowerCase();
                          //TODO In-Active code
                          /*  Navigator.of(context).pop<QuizAnswer>(
                            QuizAnswer(question.questionId,question.answer,options[index],result ? 'r' : 'w',result ? 2 : 0)
                          ); */
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
