import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/models/property_model.dart';
import 'package:pharmaaccess/models/quiz_answer_model.dart';
import 'package:pharmaaccess/models/quiz_question_model.dart';
import 'package:pharmaaccess/pages/quiz/choice_answer_widget.dart';
import 'package:pharmaaccess/pages/quiz/quiz_answer_widget.dart';
import 'package:pharmaaccess/pages/quiz/quiz_completed_widget.dart';
import 'package:pharmaaccess/services/quiz_service.dart';
import 'package:pharmaaccess/services/score_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/helper_functions.dart';
import 'package:pharmaaccess/widgets/ShowSnackBar.dart';

enum ButtonState {
  submit,
  next,
}

class ComprehensionQuizPage extends StatefulWidget {
  final int? uid;
  final List<QuizQuestion>? questions;
  final int? comprehensionId;
  final String? videoUrl;

  ComprehensionQuizPage(
      {Key? key,
      required this.comprehensionId,
      required this.questions,
      this.uid,
      this.videoUrl})
      : super(key: key);

  @override
  _ComprehensionQuizPageState createState() => _ComprehensionQuizPageState();
}

class _ComprehensionQuizPageState extends State<ComprehensionQuizPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final quizService = QuizService();
  DBProvider dbProvider = DBProvider();
  List<QuizQuestion>? questions;
  List<int>? choicesToExclude;
  int? currentLevel;
  String? sessionId;
  bool displayingQuestion = true;

  List<QuizAnswer> quizAnswer = [];
  int? correctAnswers;
  late int currentIndex;
  QuizQuestion? currentQuestion;
  late int selectedIndex;
  int sessionScore = 0;
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
    questions = widget.questions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Comprehension"),
      ),
      body: displayingQuestion == true ? _showQuestion() : _showAnswer(),
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
                          currentIndex += 1;
                          currentQuestion = questions![currentIndex];
                          selectedIndex = -1;
                          displayingQuestion = true;
                          givenAnswer = null;
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 38,
                        ),
                        //SvgPicture.asset("assets/images/social_home.svg"),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q:   ",
                          style: styleNormalBodyText.copyWith(
                              color: primaryColor, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Text(currentQuestion!.question!,
                              style: styleNormalBodyText.copyWith(
                                  fontWeight: FontWeight.w600)),
                        )
                        // RichText(
                        //   text: TextSpan(
                        //     children: <TextSpan>[
                        //       TextSpan(
                        //           text: "Q:   ",
                        //           style: styleNormalBodyText.copyWith(
                        //               color: primaryColor,
                        //               fontWeight: FontWeight.w600)),
                        //       TextSpan(
                        //           text: currentQuestion!.question,
                        //           style: styleNormalBodyText.copyWith(
                        //               fontWeight: FontWeight.w600)),
                        //     ],
                        //   ),
                        // ),
                      ],
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
                  int correctAnswers = sessionScore;
                  if (selectedIndex < 0) {
                    _scaffoldKey.currentState!.showSnackBar(
                      SnackBar(
                        content: Text("Please select an answer first."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  } else {
                    //if answer selected
                    String givenAnswer = currentQuestion!
                        .choices!["choice_${selectedIndex + 1}"]!;
                    bool isAnswerCorrect =
                        currentQuestion!.answer!.toLowerCase() ==
                            givenAnswer.toLowerCase();
                    if (isAnswerCorrect) {
                      correctAnswers += 1;
                    }

                    QuizAnswer answer = QuizAnswer(
                      uid: widget.uid,
                      questionId: currentQuestion!.questionId,
                      answerGiven: givenAnswer,
                      questionCategory: currentQuestion!.questionCategory,
                      answerStatus: isAnswerCorrect
                          ? AnswerStatus.right
                          : AnswerStatus.wrong,
                      correctAnswer: currentQuestion!.answer,
                      points: isAnswerCorrect ? 1 : 0,
                    );
                    var values = answer.toJson();
                    var submitResponse =
                        await quizService.submitAnswerMap(values);

                    if (submitResponse != null) {
                      updateLocalScore(isAnswerCorrect: isAnswerCorrect);
                      ScoreService().refreshScore();

                      if (currentIndex + 1 == questions!.length) {
                        //isLastQuestion?
                        //this is last question display some thank you page.
                        await _processLastQuestion(correctAnswers);
                      }

                      setState(() {
                        displayingQuestion =
                            false; //this is display answer widget with next question button to display next question.
                        sessionScore = correctAnswers;
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
              "No questions available for comprehension, Please try later.")),
    );
  }

  Future _processLastQuestion(int? correctAnswers) async {
    if (widget.comprehensionId != null) {
      dbProvider.setComprehensionId(widget.comprehensionId);
    }
    List<PropertyModel> properties = await fetchOrInitialize('game_focus', [
      'comprehensions',
      'number_of_questions',
      'correct_answers'
    ]); //This should never return null cause we initialize if not found.
    var property =
        properties.firstWhereOrNull((p) => p.propertyName == 'comprehensions')!;
    dbProvider.setProperty(
        'game_focus', 'comprehensions', property.propertyValueInt! + 1,
        propertyType: property.propertyType);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizCompletedWidget(
            correctAnswers: correctAnswers, totalQuestions: questions!.length),
      ),
    );
  }

  void updateLocalScore({required bool isAnswerCorrect}) async {
    List<PropertyModel> properties = await fetchOrInitialize('game_focus',
        ['comprehensions', 'number_of_questions', 'correct_answers']);
    if (isAnswerCorrect) {
      //Correct answer increment correct-answers and number of questions taken.
      properties.forEach((p) {
        if (p.propertyName == 'number_of_questions' ||
            p.propertyName == 'correct_answers') {
          p.propertyValueInt = p.propertyValueInt! + 1;
        }
      });
    } else {
      //Wrong answer only increment questions.
      properties.forEach((p) {
        if (p.propertyName == 'number_of_questions') {
          p.propertyValueInt = p.propertyValueInt! + 1;
        }
      });
    }

    //persist changes
    properties.forEach((p) {
      dbProvider.setProperty(
          p.category,
          p.propertyName,
          p.propertyType == PropertyType.Integer
              ? p.propertyValueInt
              : p.propertyValueString,
          propertyType: p.propertyType);
    });
  }

  void itemClicked(index) {
    selectedIndex = index;
  }

  void timeCompleted() async {
    //make an entry for wrong answer
    QuizAnswer answer = QuizAnswer(
      uid: widget.uid,
      questionId: currentQuestion!.questionId,
      answerGiven: givenAnswer,
      questionCategory: currentQuestion!.questionCategory,
      answerStatus: AnswerStatus.wrong,
      correctAnswer: currentQuestion!.answer,
      points: 0,
    );
    var values = answer.toJson();
    var submitResponse =
        await quizService.submitAnswerMap(values).then((value) {
      updateLocalScore(isAnswerCorrect: false);
      ScoreService().refreshScore();
    });

    if (submitResponse != null) {
      if (currentIndex + 1 == questions!.length) {
        //isLastQuestion?
        //this is last question display some thank you page.
        _processLastQuestion(correctAnswers);
      } else {
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
    } else {
      showSnackBar(context, INTERNAL_SERVER_ERROR);
    }
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
