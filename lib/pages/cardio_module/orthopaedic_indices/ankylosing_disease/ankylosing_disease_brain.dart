import 'dart:math';

import 'package:pharmaaccess/util/Constants.dart';

import 'models/ankylosing_disease_model.dart';

class AnkylosingDiseaseBrain {
  List<AnkylosingDiseaseQuestionModel> questionList = [];
  double inputValue = 0;
  int crpUnit = 0;
  bool isCRP = false;
  double resultScore = 0;
  String resultDescription = "";

  AnkylosingDiseaseBrain(
    this.questionList,
    this.inputValue,
    this.crpUnit,
    this.isCRP,
  );

  calculateScore() {
    if (isCRP) {
      if (crpUnit == MG_DL) {
        inputValue = inputValue * 10;
      }

      resultScore = (0.12 * questionList[0].selectedDiseaseIndex) +
          (0.06 * questionList[1].selectedDiseaseIndex) +
          (0.11 * questionList[2].selectedDiseaseIndex) +
          (0.07 * questionList[3].selectedDiseaseIndex) +
          (0.58 * log(inputValue + 1));
    } else {
      resultScore = (0.08 * questionList[0].selectedDiseaseIndex) +
          (0.07 * questionList[1].selectedDiseaseIndex) +
          (0.11 * questionList[2].selectedDiseaseIndex) +
          (0.09 * questionList[3].selectedDiseaseIndex) +
          (0.29 * sqrt(inputValue));
    }
    resultScore = double.parse(resultScore.toStringAsFixed(1));
    resultDescription = "";
    if (resultScore < 1.3) {
      resultDescription = "Inactive";
    } else if (resultScore >= 1.3 && resultScore <= 2.0) {
      resultDescription = "Low";
    } else if (resultScore >= 2.1 && resultScore <= 3.5) {
      resultDescription = "High";
    } else if (resultScore > 3.5) {
      resultDescription = "Very High";
    }
  }

  double getScore() {
    return resultScore;
  }

  String getDescription() {
    return resultDescription;
  }
}
