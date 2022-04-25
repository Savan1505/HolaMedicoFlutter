import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/config/config.dart';
import 'package:pharmaaccess/models/comprehension_model.dart';
import 'package:pharmaaccess/models/quiz_answer_model.dart';
import 'package:pharmaaccess/models/quiz_question_model.dart';
import 'package:pharmaaccess/odoo_api/odoo_api_connector.dart';

import 'auth_provider.dart';

class QuizProvider {
  final AuthProvider apiProvider = AuthProvider();
  final DBProvider dbProvider = DBProvider();

  Future<List<QuizQuestion>?> getComprehensionQuestions(
      {int? comprehensionId = 0}) async {
    if (comprehensionId == 0) {
      comprehensionId = await dbProvider.getComprehensionId();
    }
    try {
      var response = await apiProvider.client.callController(
          "/app/quiz/comprehension/questions",
          {'comprehension_id': comprehensionId});

      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return null;
        }
        var questions = result.map<QuizQuestion>((json) {
          return QuizQuestion.fromJson(json);
        }).toList();
        return questions;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void setComprehensionId() async {
    await dbProvider.setComprehensionId(0);
  }

  Future<ComprehensionModel?> getComprehension() async {
    int? maxComprehensionId = await dbProvider.getComprehensionId();
    try {
      var response = await apiProvider.client.callController(
          "/app/quiz/comprehension",
          {'max_comprehension_id': maxComprehensionId});

      if (!response.hasError()) {
        var result = response.getResult();
        if (result != null) {
          var comprehension = result.map<ComprehensionModel>((json) {
            return ComprehensionModel.fromJson(json);
          }).toList();
          if (comprehension != null && comprehension.isNotEmpty) {
            return comprehension[0];
          } else {
            setComprehensionId();
            return throwError(response);
          }
        } else {
          setComprehensionId();
          return throwError(response);
        }
      } else {
        setComprehensionId();
        return throwError(response);
      }
    } catch (e) {
      setComprehensionId();
      return throwErrorString(e.toString());
    }
  }

  Future<VideoComprehensionModel?> getComprehensionVideo(
      String videoUrl) async {
    try {
      var response = await apiProvider.client.callController(
          "/app/quiz/comprehension/video", {
        "video_path": videoUrl.replaceAll(Config.CONTENT_SERVER_ADDRESS, "")
      });
      print(
          "videoUrl :: ${videoUrl.replaceAll(Config.CONTENT_SERVER_ADDRESS, "")}");
      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return null;
        }
        var comprehension = result.map<VideoComprehensionModel>((json) {
          return VideoComprehensionModel.fromJson(json);
        }).toList();
        if (comprehension != null && comprehension.length > 0) {
          return comprehension[0];
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<QuizQuestion>?> getQuestions(String category) async {
    int? maxQuestionId = await dbProvider.getCategoryQuestionId(category);
    try {
      var response = await apiProvider.client.callController(
          "/app/quiz/questions",
          {'category': category, 'max_question_id': maxQuestionId});

      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return null;
        }
        var questions = result.map<QuizQuestion>((json) {
          return QuizQuestion.fromJson(json);
        }).toList();
        if (questions == null) {
          return null;
        }
        return questions;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool?> submitAnswer(QuizAnswer answer,
      {bool comprehensionAnswer = false}) async {
    //TODO - Submit answer should also increment quiz count by one.
    int? uid = await apiProvider.getUID();
    var m = answer.toJson();
    m['uid'] = uid;
    var response =
        await apiProvider.client.callController("/app/quiz/answer", m);

    if (!response.hasError()) {
      //TODO - update quiz category question
      if (comprehensionAnswer == false) {
        var database = await dbProvider.db;
        dbProvider.setQuizCategoryMaxAnswered(
            answer.questionCategory, answer.questionId);
      }
      return response.getResult();
    } else {
      //print(response.getError());
      return false;
    }
  }

  Future<bool?> submitAnswerMap(Map<String, dynamic> m,
      {bool comprehensionAnswer = false}) async {
    //TODO - Submit answer should also increment quiz count by one.
    try {
      int? uid = await apiProvider.getUID();
      m['uid'] = uid;
      var response =
          await apiProvider.client.callController("/app/quiz/answer", m);

      if (!response.hasError()) {
        //TODO - update quiz category question
        if (comprehensionAnswer == false) {
          var database = await dbProvider.db;
          dbProvider.setQuizCategoryMaxAnswered(
              m['question_category'], m['question_id']);
        }
        return response.getResult();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getQuizCount() async {
    Map<String, dynamic>? values = await dbProvider.getQuizCount();
    return values;
  }

  Future<bool> incrementQuizCount() async {
    try {
      DateTime today = DateTime.now();
      Map<String, dynamic>? values = await dbProvider.getQuizCount();
      Map<String, dynamic> row = Map();
      row['count'] = (values?['count'] as int) + 1;
      row['last_answered'] = today.toIso8601String();
      int updateCount = await dbProvider.updateDailyQuizCount(row);
      if (updateCount > 0) {
        return true;
      }
      return false;
    } on Exception catch (e) {
      return false;
    }
  }

  Future<int> updateDailyQuizCount(Map<String, dynamic> values) async {
    return dbProvider.updateDailyQuizCount(values);
  }
}
