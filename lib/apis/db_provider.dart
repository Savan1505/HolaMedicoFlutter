import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmaaccess/models/game_score_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/models/property_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final DBProvider _instance = DBProvider._internal();
  static Database? _database;
  final profileTable = "profile";
  final todayQuizCountTable = "today_quiz_count";
  final quizCategoryTable = "quiz_category";
  final gameScoreTable = "game_score";
  final videoWatchedTable = "video_watched";
  final comprehensionTable = 'comprehension';
  final appPropertiesTable = "app_properties";

  int? uid;

  DBProvider._internal();

  factory DBProvider() {
    return _instance;
  }

  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "pharmaaccess.db");
    var d = await openDatabase(
      path,
      version: 2,
      //TODO- change this to v2 handle db upgrade and add comprehension and score related tables etc.

      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE $profileTable
            (
              id INTEGER PRIMARY KEY,
              title TEXT,
              name TEXT,
              email TEXT,
              phone TEXT,
              token TEXT,
              hospital Text,
              profilePictureUrl TEXT,
              countryCode TEXT,
              countryName TEXT,
              specialization TEXT,
              uid INTEGER,
              partnerId INTEGER
            )
        """);

        newDb.execute("""
          CREATE TABLE $todayQuizCountTable
            (
              id INTEGER PRIMARY KEY,
              count INTEGER,
              last_answered TEXT
            )
        """);

        newDb.execute("""
          CREATE TABLE $quizCategoryTable
            (
              id INTEGER PRIMARY KEY,
              category TEXT,
              question_id INTEGER DEFAULT 0,
              last_answered TEXT
            )
        """);

        newDb.execute("""
          CREATE TABLE $gameScoreTable
            (
              id INTEGER PRIMARY KEY,
              game TEXT,
              maximum_level INTEGER,
              maximum_score INTEGER,
              average_score INTEGER,
              accumulated_score INTEGER,
              games_played INTEGER,
              last_played INTEGER
            )
        """);

        newDb.execute("""
          CREATE TABLE $appPropertiesTable
            (
              id INTEGER PRIMARY KEY,
              category_name TEXT,
              sequence INTEGER,
              property_name TEXT,
              property_type TEXT,
              property_value_text TEXT,
              property_value_int INTEGER
            )
        """);

        newDb.execute("""
          CREATE TABLE $videoWatchedTable
            (
              id INTEGER PRIMARY KEY,
              video_url TEXT
            )
        """);

        newDb.execute("""
          CREATE TABLE $comprehensionTable
            (
              id INTEGER PRIMARY KEY,
              last_answered TEXT
            )
        """);
        newDb.insert(comprehensionTable,
            {'id': 0, 'last_answered': DateTime.now().toIso8601String()});
        newDb.insert(todayQuizCountTable,
            {'count': 0, 'last_answered': DateTime.now().toIso8601String()});
      },
    );
    await d.execute(
        """CREATE TABLE IF NOT EXISTS $appPropertiesTable(id INTEGER PRIMARY KEY,
        category_name TEXT,
        sequence INTEGER,
        property_name TEXT,
        property_type TEXT,
        property_value_text TEXT,
        property_value_int INTEGER)""");
    await d.execute(
        "CREATE TABLE IF NOT EXISTS $comprehensionTable(id INTEGER PRIMARY KEY, last_answered TEXT)");
    return d;
  }

  Future<ProfileModel?> getProfile() async {
    try {
      Database? database = await db;
      final maps = await database?.query(
        "$profileTable",
        columns: null,
      );
      if (maps!.length > 0) {
        var model = ProfileModel.fromMap(maps.first, "");
        model.oldPassword = model.token;
        return model;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getProfileStringDataTesting() async {
    try {
      Database? database = await db;
      final maps = await database?.query(
        "$profileTable",
        columns: null,
      );
      if (maps!.length > 0) {
        // var model = ProfileModel.fromMap(maps.first, "");
        // model.oldPassword = model.token;
        return maps.toString();
      }

      return "user not found";
    } catch (e) {
      return "Exception Found :: $e";
    }
  }

  Future<bool> saveName(String profileName) async {
    try {
      Database? database = await db;
      int updateCount = await database!.update(
        profileTable,
        {"name": profileName},
      );
      return updateCount == 1
          ? true
          : false; //TODO- after testing change the second to false
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveEamil(String profilEmail) async {
    try {
      Database? database = await db;
      int updateCount = await database!.update(
        profileTable,
        {"email": profilEmail},
      );
      return updateCount == 1
          ? true
          : false; //TODO- after testing change the second to false
    } catch (e) {
      return false;
    }
  }

  Future<bool> savePhoneNumber(String phoneNumber) async {
    try {
      Database? database = await db;
      int updateCount = await database!.update(
        profileTable,
        {"phone": phoneNumber},
      );
      return updateCount == 1
          ? true
          : false; //TODO- after testing change the second to false
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveToken(String? token) async {
    try {
      Database? database = await db;
      int updateCount = await database!.update(
        profileTable,
        {"token": token},
      );
      return updateCount == 1
          ? true
          : false; //TODO- after testing change the second to false
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveCountry(String? countryName) async {
    try {
      Database? database = await db;
      int updateCount = await database!.update(
        profileTable,
        {"countryName": countryName},
      );
      return updateCount == 1
          ? true
          : false; //TODO- after testing change the second to false
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveProfilePicture(String? base64Image, String title) async {
    try {
      Database? database = await db;
      int updateCount = await database!.update(
        profileTable,
        {
          "profilePictureUrl": base64Image,
          "title": title,
        },
      );
      return updateCount == 1
          ? true
          : false; //TODO- after testing change the second to false
    } catch (e) {
      return false;
    }
  }

  Future<ProfileModel?> createProfile(ProfileModel profile) async {
    try {
      Database? database = await db;
      Map<String, dynamic> m = profile.toMap();
      m.removeWhere((key, value) => key == 'id');
      profile.id = await database!.insert(
        "$profileTable",
        m,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      return profile;
    } on DatabaseException catch (e) {
      return null;
    }
  }

  Future<bool> profileExist() async {
    var profile = await getProfile();
    return profile == null ? false : true;
  }

  Future<int?> getUID() async {
    if (uid == 0 || uid == null) {
      var profile = await getProfile();
      uid = profile?.uid;
      return uid;
    }
    return uid;
  }

  Future<Map<String, dynamic>?> getQuizCount() async {
    try {
      Database? database = await db;
      final listMap = await database!.query(
        "$todayQuizCountTable",
        columns: null,
      );
      if (listMap.length == 1) return listMap.first;
      return null;
    } on DatabaseException catch (e) {
      return null;
    }
  }

  Future<int> updateDailyQuizCount(Map<String, dynamic> values) async {
    try {
      Database? database = await db;
      var row = await getQuizCount();
      int updateCount = await database!.update(todayQuizCountTable, values,
          where: "id = ?", whereArgs: [row!['id']]);
      return updateCount;
    } on Exception catch (e) {
      return 0;
    }
  }

  Future<int?> getCategoryQuestionId(String category) async {
    try {
      Database? database = await db;
      final listMap = await database!.query(quizCategoryTable,
          columns: null, where: 'category = ?', whereArgs: [category]);
      if (listMap.length > 0) {
        return listMap.first['question_id'] as int?;
      }
      return 0;
    } on DatabaseException catch (e) {
      return 0;
    }
  }

  Future<int?> getComprehensionId() async {
    try {
      Database? database = await db;
      final listMap = await database!.query(comprehensionTable, columns: null);
      if (listMap.length > 0) {
        return listMap.first['id'] as int?;
      }
      return 0;
    } on DatabaseException catch (e) {
      return 0;
    }
  }

  Future<bool> setComprehensionId(int? comprehensionId) async {
    try {
      Database? database = await db;
      Map<String, dynamic> row = Map();
      row['id'] = comprehensionId;
      row['last_answered'] = DateTime.now().toIso8601String();
      database!.delete(comprehensionTable);
      await database.insert(
        comprehensionTable,
        row,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      return true;
    } on Exception catch (e) {
      // TODO
      return false;
    }
  }

  Future<bool> setQuizCategoryMaxAnswered(
      String? category, int? questionId) async {
    try {
      Map<String, dynamic> row = Map();
      row['question_id'] = questionId;
      row['last_answered'] = DateTime.now().toIso8601String();
      Database? database = await db;
      List<Map<String, dynamic>> results = await database!.query(
          quizCategoryTable,
          columns: null,
          where: 'category = ?',
          whereArgs: [category]);
      if (results.length == 0) {
        // insert record
        row['category'] = category;
        await database.insert(
          quizCategoryTable,
          row,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        return true;
      }
      //update record
      var result = results.first;
      int updateCount = await database.update(quizCategoryTable, row,
          where: "id = ?", whereArgs: [result['id']]);
      return true;
    } on Exception catch (e) {
      // TODO
      return false;
    }
  }

  Future<GameScoreModel?> getGameScore(String game) async {
    try {
      String g = game.toLowerCase();
      Database? database = await db;
      final listMap = await database!.query(gameScoreTable,
          columns: null, where: 'game = ?', whereArgs: [game]);
      if (listMap.length > 0) {
        if (listMap.length > 0) return GameScoreModel.fromJson(listMap.first);
      }
      return null;
    } on DatabaseException catch (e) {
      return null;
    }
  }

  Future<int> updateGameScore(Map<String, dynamic> values) async {
    try {
      values.remove('id');
      Database? database = await db;
      int updateCount = await database!.update(gameScoreTable, values,
          where: "game = ?", whereArgs: [values['game']]);
      return updateCount;
    } on Exception catch (e) {
      return 0;
    }
  }

  Future<GameScoreModel?> createGameScore(GameScoreModel score) async {
    try {
      Database? database = await db;
      Map<String, dynamic> m = score.toJson();
      m.removeWhere((key, value) => key == 'id');
      score.id = await database!.insert(
        gameScoreTable,
        m,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      return score;
    } on DatabaseException catch (e) {
      return null;
    }
  }

  Future<bool> isVideoWatched(String? videoUrl) async {
    try {
      Database? database = await db;
      final listMap = await database!.query(videoWatchedTable,
          columns: null, where: 'video_url = ?', whereArgs: [videoUrl]);
      if (listMap.length > 0) {
        return true;
      }
      return false;
    } on DatabaseException catch (e) {
      return false;
    }
  }

  Future<bool> setVideoWatched(String? videoUrl) async {
    try {
      var alreadyWatched = await this.isVideoWatched(videoUrl);
      if (alreadyWatched == true) return true;
      Database? database = await db;
      Map<String, dynamic> m = {'video_url': videoUrl};
      int addedId = await database!.insert(
        "$videoWatchedTable",
        m,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      if (addedId != null && addedId > 0) {
        return true;
      }
      return false;
    } on DatabaseException catch (e) {
      return false;
    }
  }

  Future<List<PropertyModel>> getProperties(String category) async {
    Database? database = await db;
    var properties = <PropertyModel>[];
    final result = await database?.query(appPropertiesTable,
        columns: null,
        where: 'category_name = ?',
        whereArgs: [category],
        orderBy: 'sequence');
    result?.forEach((row) {
      var property = PropertyModel(
        id: int.parse(row['id'].toString()),
        category: row['category_name'].toString(),
        propertyType: row['property_type'] == 'PropertyType.Integer'
            ? PropertyType.Integer
            : PropertyType.String,
        propertyName: row['property_name'].toString(),
        sequence: int.parse(row['sequence'].toString()),
      );
      if (row['property_type'] == "PropertyType.Integer") {
        property.propertyValueInt =
            int.parse(row['property_value_int'].toString());
      } else {
        property.propertyValueInt =
            int.parse(row['property_value_text'].toString());
      }
      properties.add(property);
    });
    return properties;
  }

  Future<PropertyModel> getProperty(
      String category, String property, dynamic defaultValue,
      {PropertyType propertyType = PropertyType.Integer}) async {
    try {
      PropertyModel propertyModel = PropertyModel(
          category: category,
          propertyName: property,
          propertyType: propertyType);

      Database? database = await db;
      final listMap = await database!.query(appPropertiesTable,
          columns: null,
          where: 'category_name = ? and property_name = ?',
          whereArgs: [category, property],
          limit: 1);
      if (listMap.length == 0) {
        propertyModel.sequence = 0;
        if (propertyType == PropertyType.Integer) {
          propertyModel.propertyValueInt = defaultValue;
        } else {
          propertyModel.propertyValueString = defaultValue;
        }
        return propertyModel;
      }
      switch (propertyType) {
        case PropertyType.String:
          propertyModel.propertyValueString =
              listMap[0]['property_value_text'].toString();
          break;
        case PropertyType.Integer:
        default:
          propertyModel.propertyValueInt =
              int.parse(listMap[0]['property_value_int'].toString());
      }
      propertyModel.sequence = int.parse(listMap[0]['sequence'].toString());
      return propertyModel;
    } on DatabaseException catch (e) {
      return defaultValue;
    }
  }

  Future<bool> setProperty(String? category, String? property, dynamic value,
      {int sequence = 0,
      PropertyType? propertyType = PropertyType.Integer}) async {
    try {
      var database = await db;

      Map<String, dynamic> values = {
        'sequence': sequence,
        'property_type': propertyType.toString()
      };
      switch (propertyType) {
        case PropertyType.String:
          values['property_value_text'] = value;
          break;
        case PropertyType.Integer:
        default:
          values['property_value_int'] = value;
      }

      int count = await database!.update(
        appPropertiesTable,
        values,
        where: 'category_name = ? and property_name = ?',
        whereArgs: [category, property],
      );
      if (count == 0) {
        //TODO: no record updated, so create new record.
        values['category_name'] = category;
        values['property_name'] = property;
        int id = await database.insert(
          appPropertiesTable,
          values,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      return true;
    } on DatabaseException catch (e) {
      return false;
    }
  }
}
