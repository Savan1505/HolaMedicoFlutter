import 'package:flutter/material.dart';

class QuizQuestionWidget extends StatelessWidget {
  final String? question;
  QuizQuestionWidget(this.question);
  @override
  Widget build(BuildContext context) {
    return Container(child: Text(question!, style: TextStyle(fontSize: 28,),));
  }
}
