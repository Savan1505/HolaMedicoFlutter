import 'models/neuropatic_pain_model.dart';

class NeuropathicPainBrain {
  List<NeuropaticQuestionModel> questionList = [];
  int resultScore = 0;
  String resultDescription = "";

  NeuropathicPainBrain(
    this.questionList,
  );

  calculateScore() {
    resultScore = 0;
    for (int i = 0; i < questionList.length; i++) {
      for (int j = 0; j < questionList[i].optionList.length; j++) {
        if (questionList[i].optionList[j].isSelectedYes) {
          resultScore++;
        }
      }
    }

    resultDescription = "";
    if (resultScore >= 4) {
      resultDescription = "Diagnosis of neuropathic pain is confirmed";
    } else {
      resultDescription =
          "No enough evidence to diagnose the patient with neuropathic pain";
    }
  }

  int getScore() {
    return resultScore;
  }

  String getDescription() {
    return resultDescription;
  }
}
