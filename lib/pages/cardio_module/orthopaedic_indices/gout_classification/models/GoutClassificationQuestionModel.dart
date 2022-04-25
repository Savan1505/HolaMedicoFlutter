class GoutClassificationQuestionModel {
  String title = "";
  List<QuestionModel> questionModels = [];

  GoutClassificationQuestionModel(
    this.title,
    this.questionModels,
  );
}

class QuestionModel {
  String question = "";
  String desc = "";
  List<AnswerModel> answerModels = [];
  int selectedIndex = -1;

  QuestionModel(this.question, this.desc, this.answerModels);
}

class AnswerModel {
  int points = 0;
  String answerTitle = "";

  AnswerModel(
    this.points,
    this.answerTitle,
  );
}
