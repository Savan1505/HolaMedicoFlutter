class QuizQuestion {
  int? questionId;
  String? question;
  int? questionCategoryId;
  String? questionCategory;
  String? questionSubcategory;
  String? questionType;
  String? questionSubtype;
  Map<String,String?>? choices;
  String? answer;
  String? answerDescription;
  int? applicableChoices;

  QuizQuestion({
    this.questionId,this.question,
    this.questionCategory, this.questionSubcategory,
    this.questionType, this.questionSubtype,
    this.applicableChoices,this.answer,
    this.choices,
  });

  QuizQuestion.fromJson(Map<String, dynamic> json) {
    questionId = json['id'];
    question = json['question'];
    questionCategory = json['question_category_name'] == false ? "" : json['question_category_name'];
    questionCategoryId = json['question_category'] == false ? -1 : json['question_category'][0];
    questionSubcategory = json['question_subcategory'] == false ? "" : json['question_subcategory'];
    questionType = json['question_type'];
    questionSubtype = json['question_subtypes'] == false ? "" : json['question_subtypes'];
    applicableChoices = json['applicable_choices'];
    answer = json['answer'];
    answerDescription = json['answer_description'] == false ? "" : json['answer_description'];
    choices = Map<String,String?>();
    for (int i = 1; i <= applicableChoices!; i++) {
      String choice = "choice_$i";
      choices![choice] = json[choice];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.questionId;
    data['question'] = this.question;
    data['question_category'] = this.questionCategory;
    data['question_subcategory'] = this.questionSubcategory;
    data['question_type'] = this.questionType;
    data['question_subtypes'] = this.questionSubtype;
    data['applicable_choices'] = this.applicableChoices;
    data['choices'] = this.choices;
    data['answer'] = this.answer;
    data['answer_description'] = this.answerDescription;
    return data;
  }
}

//List<QuizQuestion> quizQuestion = <QuizQuestion>[
//  QuizQuestion(questionId: 1, question: 'Which number is larger?', questionCategory: 'Choices', questionSubcategory: 'Multiple Choices', questionType: 'c', questionSubtype: 'mo', applicableChoices: 2, answer: '28',
//      choices: {'choice1': '27', 'choice2': '28'},),
//  QuizQuestion(questionId: 2, question: 'Atorcor is usable in treating of?', questionCategory: 'Choices', questionSubcategory: 'Multiple Choices', questionType: 'c', questionSubtype: 'mo', applicableChoices: 4, answer: 'Headache',
//      choices: {'choice1': 'Stroke', 'choice2': 'Headache', 'choice3': 'Cholestrol', 'choice4': 'Blood Pressure'}),
//  QuizQuestion(questionId: 3, question: 'Tap the color name you see below.', questionCategory: 'Choices', questionSubcategory: 'Multiple Choices', questionType: 'c', questionSubtype: 'mo', applicableChoices: 3, answer: '#0000FF|blue',
//      choices: {'choice1': 'Red', 'choice2': 'Black', 'choice3': 'Blue'}),
//  QuizQuestion(questionId: 4, question: 'Ziquin is used to treat headache?', questionCategory: 'Choices', questionSubcategory: 'Multiple Choices', questionType: 'c', questionSubtype: 'mo', applicableChoices: 2, answer: 'true',
//      choices: {'choice1': 'False', 'choice2': 'True'},),
//];
