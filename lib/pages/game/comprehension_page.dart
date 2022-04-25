import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/comprehension_model.dart';
import 'package:pharmaaccess/models/quiz_question_model.dart';
import 'package:pharmaaccess/services/quiz_service.dart';

import '../../theme.dart';
import 'comprehension_quiz_page.dart';

class ComprehensionPage extends StatefulWidget {
  @override
  _ComprehensionPageState createState() => _ComprehensionPageState();
}

class _ComprehensionPageState extends State<ComprehensionPage> {
  ScrollController _scrollController = new ScrollController();
  final QuizService quizService = QuizService();
  ComprehensionModel? comprehension;
  late Future<ComprehensionModel?> future;

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(COMPREHENSION_SCREEN,
        param: {"name": "Comprehension Screen"});
    future = quizService.getComprehension();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Comprehension"),
        ),
        body: Container(
            //margin: EdgeInsets.only(top: 32),
            child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: FutureBuilder<ComprehensionModel?>(
                  future: future,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      this.comprehension = snapshot.data;
                      return dataWidget();
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        snapshot.hasError) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Internal server error")));
                        Navigator.pop(context);
                      });
                      return empty();
                    }
                    return loading();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Container(
                child: RaisedButton(
                  color: primaryColor,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "START QUIZ",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .apply(
                          color: Colors.white,
                        )
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    if (this.comprehension != null) {
                      List<QuizQuestion>? questions =
                          await quizService.getComprehensionQuestions(
                              comprehensionId:
                                  this.comprehension!.comprehensionId);
                      if (questions != null && questions.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComprehensionQuizPage(
                                comprehensionId:
                                    this.comprehension!.comprehensionId,
                                questions: questions),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Internal server error"),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            )
          ],
        )),
      );

  Widget empty() => SizedBox.shrink();

  Widget loading() => Center(child: CircularProgressIndicator());

  Widget dataWidget() => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18,
        ),
        child: Container(
          decoration: softCardShadow,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 24,
          ),
          margin: EdgeInsets.only(bottom: 12),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: comprehension!.comprehension,
                    style: styleNormalBodyText.copyWith(
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      );
}

class QuizCategoryWidget extends StatelessWidget {
  final Widget? first;
  final Widget? second;

  QuizCategoryWidget({
    Key? key,
    this.first,
    this.second,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 6,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 52,
      decoration: softCardShadow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          first!,
          second!,
        ],
      ),
    );
  }
}
