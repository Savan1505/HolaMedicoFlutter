import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmaaccess/models/quiz_answer_model.dart';
import 'package:pharmaaccess/models/quiz_question_model.dart';
import 'package:pharmaaccess/pages/quiz/quiz_answer_widget.dart';
import 'package:pharmaaccess/pages/quiz/quiz_completed_widget.dart';
import 'package:pharmaaccess/services/quiz_service.dart';
import 'package:pharmaaccess/services/score_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/pages/quiz/choice_answer_widget.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/ShowSnackBar.dart';

enum ButtonState {
  submit,
  next,
}

class QuizPage extends StatefulWidget {
  final String category;
  final int? uid;
  final List<QuizQuestion>? questions;

  QuizPage(
      {Key? key, required this.category, required this.questions, this.uid})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final quizService = QuizService();
  List<QuizQuestion>? questions;
  List<int>? choicesToExclude;
  int? currentLevel;
  String? sessionId;
  int? uid;
  bool displayingQuestion = true;

  List<QuizAnswer> quizAnswer = [];
  int? correctAnswers;
  late int currentIndex;
  QuizQuestion? currentQuestion;
  late int selectedIndex;
  int sessionScore = 0;
  int earnedScore = 0;
  ButtonState buttonState = ButtonState.submit;

  String? givenAnswer;

  Timer? _timer;
  int _allowedTime = 90;
  int? minutes;
  int? seconds;

  @override
  void initState() {
    // TODO: implement initState
    selectedIndex = -1;
    currentIndex = 0;
    uid = widget.uid;
    questions = widget.questions;
    //this.currentQuestion = questions[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Socrates"),
      ),
      body: displayingQuestion == true ? _showQuestion() : _showAnswer(),
    );
  }

  void itemClicked(index) {
    selectedIndex = index;
//    setState(() {
//      selectedIndex = value;
//    });
  }

  void timeCompleted() {
    //make an entry for wrong answer
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//          builder: (context) => QuizResultWidget(correctAnswer: currentQuestion.answer, answerDescription: currentQuestion.answerDescription)),
//    );
    //push wrong result to server, setState.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizShowAnswerWidget(
            correctAnswer: currentQuestion!.answer,
            givenAnswer: "",
            answerDescription: currentQuestion!.answerDescription),
      ),
    );
  }

  Widget _showAnswer() {
    return Center(
      child: ListView(
        children: <Widget>[
          Divider(
            height: 40,
            color: Color(0x00FFFFFF),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 72),
              child: currentQuestion!.answer == givenAnswer
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
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 0, left: 12, right: 8),
                      child: Icon(Icons.check),
                    ),
                    Flexible(
                        child: Text(currentQuestion!.answerDescription!,
                            style:
                                TextStyle(fontSize: 16, color: bodyTextColor)))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 0, left: 12, right: 8),
                      child: currentQuestion!.answer == givenAnswer
                          ? Icon(Icons.check)
                          : Icon(Icons.clear),
                    ),
                    Flexible(
                        child: Text(
                            givenAnswer == null
                                ? 'Timed Out (Your Answer)'
                                : '$givenAnswer (Your Answer)',
                            style:
                                TextStyle(fontSize: 16, color: bodyTextColor)))
                  ],
                ),
                Divider(height: 22, color: Color(0x00FFFFFF)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (currentIndex + 1 == questions!.length) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizCompletedWidget(
                                    correctAnswers: sessionScore,
                                    totalQuestions: questions!.length),
                              ),
                            );
                            return;
                          } else {
                            currentIndex += 1;
                            currentQuestion = questions![currentIndex];
                            selectedIndex = -1;
                            displayingQuestion = true;
                            givenAnswer = null;
                          }
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 38,
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
    );
  }

  Widget _showQuestion() {
    if (questions!.length > 0) {
      this.currentQuestion = questions![currentIndex];
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FaIcon(
                            FontAwesomeIcons.clock,
                            color: primaryColor,
                            size: 28,
                          ),
                          CountDownTimerWidget(
                            countdownSeconds: 90,
                            completedCallback: timeCompleted,
                          ),
                        ],
                      ),
                      Text(
                          "Points: $sessionScore Questions: ${currentIndex + 1}/${questions!.length}",
                          style: stylePrimaryTextMedium),
                    ],
                  ),
                  Divider(
                    height: 20,
                    color: Color(0x00FFFFFF),
                  ),
                  Container(
                    decoration: softCardShadow,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 6,
                    ),
                    margin: EdgeInsets.only(bottom: 12),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: "Q:   ",
                              style: styleNormalBodyText.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600)),
                          TextSpan(
                              text: currentQuestion!.question,
                              style: styleNormalBodyText.copyWith(
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ChoiceAnswerListWidget(
                      question: currentQuestion,
                      callback: itemClicked,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Show button
          SizedBox(
            height: 60,
            width: double.infinity,
            child: Container(
              child: RaisedButton(
                color: primaryColor,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "SUBMIT ANSWER",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .apply(
                        color: Colors.white,
                      )
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  if (selectedIndex < 0) {
                    _scaffoldKey.currentState!.showSnackBar(
                      SnackBar(
                        content: Text("Please select an answer first."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  } else {
                    String givenAnswer = currentQuestion!
                        .choices!["choice_${selectedIndex + 1}"]!;
                    earnedScore = 0;
                    if (currentQuestion!.answer!.toLowerCase() ==
                        givenAnswer.toLowerCase()) {
                      sessionScore = sessionScore + 1;
                      earnedScore = 1;
                    }
                    QuizAnswer answer = QuizAnswer(
                        uid: uid,
                        questionId: currentQuestion!.questionId,
                        answerGiven: givenAnswer,
                        questionCategory: currentQuestion!.questionCategory,
                        answerStatus: givenAnswer == currentQuestion!.answer
                            ? AnswerStatus.right
                            : AnswerStatus.wrong,
                        correctAnswer: currentQuestion!.answer,
                        points: earnedScore);
                    //var quizService = QuizService();
                    var answers = (await quizService.getTodayQuizCount())!;
                    var values = answer.toJson();
                    values['today_quiz_count'] = answers + 1;
                    var submitAnswer =
                        await quizService.submitAnswerMap(values);
                    if (submitAnswer != null) {
                      quizService.updateDailyQuizCount(answers + 1);
                      ScoreService().refreshScore();

                      /*  if (currentIndex + 1 == questions.length) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizCompletedWidget(
                              correctAnswers: sessionScore,
                              totalQuestions: questions.length),
                        ),
                      );

                      //this is last question display some thank you page.
                      /* await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizCompletedWidget(
                              correctAnswers: sessionScore,
                              totalQuestions: questions.length),
                        ),
                      ); */

                      return;
                    } */
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => QuizShowAnswerWidget(correctAnswer: currentQuestion.answer, givenAnswer: givenAnswer,answerDescription: currentQuestion.answerDescription),
//                      ),
//                    );
                      setState(() {
//                      currentIndex += 1;
//                      currentQuestion = questions[currentIndex];
//                      selectedIndex = -1;
                        displayingQuestion = false;
                        sessionScore = sessionScore;
                        this.givenAnswer = givenAnswer;
                      });
                    } else {
                      showSnackBar(context, INTERNAL_SERVER_ERROR);
                    }
                  }
                },
              ),
            ),
          )
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: Text(
              "No questions available in this category yet, Please try later.")),
    );
  }
}

class CountDownTimerWidget extends StatefulWidget {
  final int countdownSeconds;
  final String? formatString;
  final VoidCallback completedCallback;

  CountDownTimerWidget(
      {Key? key,
      required this.countdownSeconds,
      this.formatString,
      required this.completedCallback})
      : super(key: key);
  @override
  _CountDownTimerWidgetState createState() => _CountDownTimerWidgetState();
}

class _CountDownTimerWidgetState extends State<CountDownTimerWidget> {
  late int minutes;
  int? seconds;
  late int currentSeconds;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentSeconds = widget.countdownSeconds;
    minutes = (currentSeconds / 60).floor();
    seconds = currentSeconds - minutes * 60;
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (currentSeconds < 1) {
            //TODO - if not last question, move to next question and reset timer to 90 else cancel timer and move to thank you.
            timer.cancel();
            widget.completedCallback();
          } else {
            currentSeconds = currentSeconds - 1;
            minutes = (currentSeconds / 60).floor();
            seconds = currentSeconds - minutes * 60;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        " 00:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
        style: stylePrimaryColorHeadline2);
  }
}
