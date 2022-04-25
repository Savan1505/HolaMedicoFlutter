class DiabetesQuestionModel {
  final String? question;
  final List<ANswerModel>? listAns;
  final bool isGender;

  DiabetesQuestionModel({this.question, this.listAns, this.isGender = false});
}

class ANswerModel {
  final int? points;
  final String? answerTitle;

  ANswerModel({
    this.points,
    this.answerTitle,
  });
}
