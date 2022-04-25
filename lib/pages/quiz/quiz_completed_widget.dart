import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmaaccess/services/quiz_service.dart';
import 'package:pharmaaccess/theme.dart';

class QuizCompletedWidget extends StatelessWidget {
  final int? correctAnswers;
  final int? totalQuestions;
  QuizCompletedWidget({Key? key, this.correctAnswers, this.totalQuestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuizService quizService = QuizService();
    bool isCorrect = correctAnswers == totalQuestions;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Divider(height: 60, color: Color(0x00FFFFFF)),
              Text("Thank you for participating in the quiz", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              Divider(height: 20, color: Color(0x00FFFFFF)),
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0, left: 12, right: 8),
                  child: Text(correctAnswers.toString().padLeft(2,'0'), style: TextStyle(fontSize: 16, color: bodyTextColor)),
                ),
                Flexible(child: Text("Correct Answers", style: TextStyle(fontSize: 16, color: bodyTextColor)))
              ],),
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0, left: 12, right: 8),
                  child: Text(totalQuestions.toString().padLeft(2,'0'), style: TextStyle(fontSize: 16, color: bodyTextColor)),
                ),
                Flexible(child: Text("Total Questions", style: TextStyle(fontSize: 16, color: bodyTextColor)))
              ],),

              Divider(height: 22, color: Color(0x00FFFFFF)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      padding: EdgeInsets.all(10),
                      child: SvgPicture.asset("assets/images/social_home.svg"),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF5F5F5),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
