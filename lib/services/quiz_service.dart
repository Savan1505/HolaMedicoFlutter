import 'package:pharmaaccess/apis/quiz_provider.dart';
import 'package:pharmaaccess/models/comprehension_model.dart';
import 'package:pharmaaccess/models/quiz_answer_model.dart';
import 'package:pharmaaccess/models/quiz_question_model.dart';

class QuizService {
  final quizProvider = QuizProvider();
  final List<String> categoryList = [
    'Internal Medicine',
    'Cardiology',
    'Paediatrics',
    'General Surgery',
    'ENT',
    'Orthopedic',
    'Ob/Gynae',
    'Urology',
  ];

  Future<ComprehensionModel?> getComprehension() async {
    return quizProvider.getComprehension();
  }

  Future<VideoComprehensionModel?> getComprehensionVideo(String videoUrl) async {
    return quizProvider.getComprehensionVideo(videoUrl);
  }

  Future<List<QuizQuestion>?> getComprehensionQuestions(
      {int? comprehensionId = 0}) async {
    return quizProvider.getComprehensionQuestions(
        comprehensionId: comprehensionId);
  }

  Future<List<QuizQuestion>?> getQuestions(String category) async {
    return quizProvider.getQuestions(category);
  }

  Future<List<String>> getQuizCategories() async {
    return categoryList;
  }

  Future<bool?> submitAnswer(QuizAnswer answer) async {
    return quizProvider.submitAnswer(answer);
  }

  Future<bool?> submitAnswerMap(Map<String, dynamic> m) async {
    return quizProvider.submitAnswerMap(m);
  }

  Future<int?> getTodayQuizCount() async {
    var values = await quizProvider.getQuizCount();
    if (values == null) return 0;
    DateTime now = DateTime.now();
    DateTime date = DateTime.parse(values['last_answered'].toString());

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime quizDate = DateTime(date.year, date.month, date.day);
    var duration = today.difference(quizDate);
    if (duration.inDays > 0) {
      return 0;
    }
    return values['count'] as int?;
  }

  Future<bool> updateDailyQuizCount(int count) async {
    Map<String, dynamic> values = Map();
    values['count'] = count;
    values['last_answered'] = DateTime.now().toIso8601String();
    int c = await quizProvider.updateDailyQuizCount(values);
    if (c > 0) {
      return true;
    }
    return false;
  }
}
