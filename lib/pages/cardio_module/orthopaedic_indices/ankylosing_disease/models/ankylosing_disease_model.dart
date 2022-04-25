class AnkylosingDiseaseQuestionModel {
  final String title, desc;
  int selectedDiseaseIndex = 0;

  AnkylosingDiseaseQuestionModel(this.title, this.desc);
}

class AnkylosingDiseaseModel {
  final int score;
  final String name, point;

  AnkylosingDiseaseModel(
    this.name,
    this.point,
    this.score,
  );
}
