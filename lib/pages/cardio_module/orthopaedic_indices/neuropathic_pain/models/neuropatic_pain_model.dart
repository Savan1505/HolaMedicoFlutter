class NeuropaticQuestionModel {
  final String title;
  final List<NeuropaticOptionModel> optionList;

  NeuropaticQuestionModel(
    this.title,
    this.optionList,
  );
}

class NeuropaticOptionModel {
  final String title;
  bool isSelectedYes = false;

  NeuropaticOptionModel(this.title);
}
