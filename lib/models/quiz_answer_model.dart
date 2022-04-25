enum AnswerStatus {
  right,
  wrong,
}

class QuizAnswer {
  int? uid;
  int? questionId;
  String? questionCategory;
  String? correctAnswer;
  String? answerGiven;
  AnswerStatus? answerStatus;
  int? points;

  QuizAnswer({this.uid,this.questionId, this.questionCategory, this.correctAnswer, this.answerGiven, this.answerStatus, this.points});

  QuizAnswer.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    questionId = json['question_id'];
    questionCategory = json['question_category'];
    correctAnswer = json['correct_answer'];
    answerGiven = json['answer_given'];
    answerStatus = json['answer_status'] == 'r' ? AnswerStatus.right : AnswerStatus.wrong;
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['question_id'] = this.questionId;
    data['question_category'] = this.questionCategory;
    data['correct_answer'] = this.correctAnswer;
    data['answer_given'] = this.answerGiven;
    data['answer_status'] = this.answerStatus == AnswerStatus.right ? 'r' : 'w';
    data['points'] = this.points;
    return data;
  }
}
