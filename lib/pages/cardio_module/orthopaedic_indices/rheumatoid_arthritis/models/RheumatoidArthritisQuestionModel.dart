class RheumatoidArthritisQuestionModel {
  String question = "";
  String desc = "";
  List<AnswerModel> listAns = [];

  RheumatoidArthritisQuestionModel(
    this.question,
    this.desc,
    this.listAns,
  );
}

class AnswerModel {
  final int? points;
  final String? answerTitle;

  AnswerModel({
    this.points,
    this.answerTitle,
  });
}
