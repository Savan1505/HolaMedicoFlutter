import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/services/quiz_service.dart';
import 'package:pharmaaccess/theme.dart';

class QuizShowAnswerWidget extends StatelessWidget {
  final String? correctAnswer;
  final String? givenAnswer;
  final String? answerDescription;
  QuizShowAnswerWidget(
      {Key? key, this.correctAnswer, this.givenAnswer, this.answerDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuizService quizService = QuizService();
    bool isCorrect = correctAnswer == givenAnswer;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 72),
                  child: isCorrect
                      ? Icon(
                          Icons.check,
                          size: 128,
                        )
                      : Icon(
                          Icons.clear,
                          size: 128,
                        ) //Image.asset("assets/images/quiz_result.png", width: 180),
                  ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Divider(height: 20, color: Color(0x00FFFFFF)),
                    FutureBuilder<int?>(
                        future: quizService.getTodayQuizCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data! < 2) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, bottom: 0, left: 12, right: 8),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 18, color: bodyTextColor),
                                    children: <TextSpan>[
                                      TextSpan(text: "You are eligible for"),
                                      TextSpan(
                                          text: " one more ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              //Navigator.of(context).pushNamed('/', arguments: 'quiz',);
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      '/',
                                                      (Route<dynamic> route) =>
                                                          false,
                                                      arguments: 'quiz');
                                            }),
                                      TextSpan(
                                        text: "quiz question today.",
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              Text("Looking forward to see you tomorrow",
                                  style: TextStyle(
                                      fontSize: 18, color: bodyTextColor));
                            }
                          }
                          return Container();
                        }),
                    Divider(height: 20, color: Color(0x00FFFFFF)),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 0, left: 12, right: 8),
                          child: Icon(Icons.check),
                        ),
                        Flexible(
                            child: Text(answerDescription!,
                                style: TextStyle(
                                    fontSize: 16, color: bodyTextColor)))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 0, left: 12, right: 8),
                          child:
                              isCorrect ? Icon(Icons.check) : Icon(Icons.clear),
                        ),
                        Flexible(
                            child: Text(
                                givenAnswer == null
                                    ? 'Timed Out (Your Answer)'
                                    : '$givenAnswer (Your Answer)',
                                style: TextStyle(
                                    fontSize: 16, color: bodyTextColor)))
                      ],
                    ),
                    Divider(height: 22, color: Color(0x00FFFFFF)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
//                        Container(
//                          width: 56,
//                          height: 56,
//                          child: Icon(OMIcons.share, size: 36,color: Color(0xFFC2BDBD)),
//                          decoration: BoxDecoration(
//                            shape: BoxShape.circle,
//                            color: Color(0xFFF5F5F5),
//                          ),
//                        ),
//                        SizedBox(width: 36),
                        InkWell(
                          onTap: () {
                            //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                            //Navigator.popUntil(context, ModalRoute.withName('/'));
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 46,
                            height: 46,
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_back,
                              size: 32,
                            ), //SvgPicture.asset("assets/images/social_home.svg"),
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
            ],
          ),
        ),
      ),
    );
  }
}
