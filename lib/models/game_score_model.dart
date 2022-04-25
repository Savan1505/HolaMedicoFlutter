import 'package:intl/intl.dart';

class GameScoreModel {
  int? id;
  String? game;
  int? maximumLevel;
  int? maximumScore;
  int? averageScore;
  int? accumulatedScore;
  int? gamesPlayed;
  DateTime? lastPlayed;

  GameScoreModel({this.id,this.game, this.maximumScore,this.maximumLevel,this.averageScore, this.accumulatedScore,
    this.gamesPlayed, this.lastPlayed});

  GameScoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    game = json['game'];
    maximumLevel = json['maximum_level'];
    maximumScore = json['maximum_score'];
    averageScore = json['average_score'];
    accumulatedScore = json['accumulated_score'];
    gamesPlayed = json['games_played'];
    lastPlayed = DateTime.fromMicrosecondsSinceEpoch(json['last_played']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['game'] = this.game;
    data['maximum_level'] = this.maximumLevel;
    data['maximum_score'] = this.maximumScore;
    data['average_score'] = this.averageScore;
    data['accumulated_score'] = this.accumulatedScore;
    data['games_played'] = this.gamesPlayed;
    data['last_played'] = this.lastPlayed!.millisecondsSinceEpoch;
    return data;
  }
}
