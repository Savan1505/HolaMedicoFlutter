class QuizCategoryModel {
  int? id;
  int? questionId;
  String? category;
  DateTime? lastAnswered;

  QuizCategoryModel({this.id,this.questionId, this.category, this.lastAnswered,});

  QuizCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    category = json['category'];
    lastAnswered = json['last_answered'] == null ? null : DateTime.parse(json['last_answered']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_id'] = this.questionId;
    data['category'] = this.category;
    data['last_answered'] = this.lastAnswered;
    return data;
  }
}
