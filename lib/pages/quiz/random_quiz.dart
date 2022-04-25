import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/pages/quiz/quiz_page.dart';
import 'package:pharmaaccess/services/quiz_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/ShowSnackBar.dart';

class RandomQuizWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: QuizService().getQuizCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Select Category"),
                  backgroundColor: primaryColor,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Divider(height: 20, color: Color(0x00FFFFFF)),
                            Text(
                              "Tap to select a category.",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Divider(height: 20, color: Color(0x00FFFFFF)),
                            RandomQuizCategoryWidget(
                              categories: snapshot.data,
                              interval: 100,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class RandomQuizCategoryWidget extends StatefulWidget {
  final List<String>? categories;
  //final VoidCallback completedCallback;
  final int? interval; //in milli seconds.

  RandomQuizCategoryWidget({Key? key, required this.categories, this.interval})
      : super(key: key);
  @override
  _RandomQuizCategoryWidgetState createState() =>
      _RandomQuizCategoryWidgetState();
}

class _RandomQuizCategoryWidgetState extends State<RandomQuizCategoryWidget> {
  int? interval;
  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    interval =
        widget.interval == null || widget.interval == 0 ? 100 : widget.interval;
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    var timerInterval = Duration(milliseconds: interval!);
    _timer = new Timer.periodic(
      timerInterval,
      (Timer timer) => setState(
        () {
          if (currentIndex == widget.categories!.length - 1) {
            currentIndex = 0;
            return;
          }
          currentIndex += 1;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _timer.cancel();
        var questions =
            await QuizService().getQuestions(widget.categories![currentIndex]);
        Navigator.of(context).pop();
        if (questions != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => QuizPage(
                    category: widget.categories![currentIndex],
                    questions: questions,
                  )));
        } else {
          showSnackBar(context, INTERNAL_SERVER_ERROR);
        }
      },
      child: Text(widget.categories![currentIndex],
          style: stylePrimaryColorHeadline2),
    );
  }
}
