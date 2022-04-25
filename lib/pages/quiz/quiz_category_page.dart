import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/pages/index.dart';
import 'package:pharmaaccess/pages/quiz/random_quiz.dart';
import 'package:pharmaaccess/services/quiz_service.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/ShowSnackBar.dart';

import '../../theme.dart';

class QuizCategoryPage extends StatelessWidget {
  final QuizService quizService = QuizService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Quiz"),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 32),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 40,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Center(
                    child: Text("Choose Quiz Category",
                        style: styleNormalBodyText)),
              ),
              Expanded(
                child: FutureBuilder<List<String>>(
                    future: quizService.getQuizCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          child: ListView.builder(
                              itemCount: snapshot.data!.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                //the length should be data.length + 1 and when you detect last item return random category widget
                                if (snapshot.data!.length == index) {
                                  return QuizCategoryContainer(
                                      category: 'Random');
                                }
                                return QuizCategoryContainer(
                                  category: snapshot.data![index],
                                );
                              }),
                        );
                      }
                      return Container();
                    }),
              ),
            ],
          )),
    );
  }
}

class QuizCategoryContainer extends StatelessWidget {
  final String category;

  QuizCategoryContainer({Key? key, required this.category});

  @override
  Widget build(BuildContext context) {
    if (category != 'Random') {
      return InkWell(
        onTap: () async {
          var questions = await QuizService().getQuestions(category);
          if (questions != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    QuizPage(category: category, questions: questions),
              ),
            );
          } else {
            showSnackBar(context, INTERNAL_SERVER_ERROR);
          }
        },
        child: QuizCategoryWidget(
          first: Text(category, style: styleNormalBodyText),
          second: Text(""),
        ),
      );
    }

    return InkWell(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => RandomQuizWidget(),
        ));
      },
      child: QuizCategoryWidget(
        first: Text(category, style: styleNormalBodyText),
        second: Text(""),
      ),
    );
  }
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
