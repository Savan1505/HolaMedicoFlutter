import 'models/GoutClassificationQuestionModel.dart';

class GoutClassificationBrain {
  List<GoutClassificationQuestionModel> list = [];

  GoutClassificationBrain(this.list);

  int? resultScore = 0;
  String resultDescription = "";

  calculateResult() {
    var step1 = list[0];
    var step2 = list[1];
    var step3 = list[2];

    if (step2.questionModels[0]
            .answerModels[step2.questionModels[0].selectedIndex].points ==
        1) {
      resultScore = null;
      resultDescription = "Patient meets criteria for gout classification";
    } else if (step1.questionModels[0]
                .answerModels[step1.questionModels[0].selectedIndex].points ==
            1 &&
        step2.questionModels[0]
                .answerModels[step2.questionModels[0].selectedIndex].points ==
            0) {
      resultScore = 0;

      for (int i = 0; i < step3.questionModels.length; i++) {
        var questionModel = step3.questionModels[i];
        resultScore = resultScore! +
            questionModel.answerModels[questionModel.selectedIndex].points;
      }

      if (resultScore! >= 8) {
        resultDescription = "Patient meets criteria for gout classification";
      } else if (resultScore! < 8) {
        resultDescription =
            "Patient Does not meet criteria for gout classification";
      }
    } else if (step1.questionModels[0]
                .answerModels[step1.questionModels[0].selectedIndex].points ==
            0 &&
        step2.questionModels[0]
                .answerModels[step2.questionModels[0].selectedIndex].points ==
            0) {
      resultScore = null;
      resultDescription = "Not eligible for scoring";
    }
  }

  String getDescription() {
    return resultDescription;
  }

  int? getScore() {
    return resultScore;
  }
}
