import 'package:pharmaaccess/apis/score_provider.dart';
import 'package:pharmaaccess/models/ClubsModel.dart';
import 'package:pharmaaccess/models/GiftModel.dart';
import 'package:pharmaaccess/models/api_status_model.dart';
import 'package:pharmaaccess/models/game_score_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/models/score_model.dart';

class ScoreService {
  final scoreProvider = ScoreProvider();
  static PartnerScoreModel? score;
  int? scoreData = 0;
  GiftModel? giftModel;

  Future<PartnerScoreModel?> getScore() async {
    if (score == null) {
      score = await scoreProvider.getScore();
      return score;
    }
    scoreData = score!.score;
    return score;
  }

  getScoreT() {
    if (score == null) {
      return null;
    }
    return score!.score;
  }

  Future<List<ClubsModel>?> getClubs() async {
    await getScore();
    return await scoreProvider.getClubs();
  }

  Future<int> getClubScore() async {
    return await scoreProvider.getClubScore();
  }

  Future<int?> getTotalScores() async {
    if (score == null) {
      score = await scoreProvider.getScore();
      return score!.score;
    }
    return score!.score;
  }

  Future<PartnerScoreModel?> refreshScore() async {
    score = await scoreProvider.getScore();
    return score;
  }

  List<ScoreModel>? getTransactions() {
    if (score != null) {
      return score!.scores!.where((s) => s.scoreType == 't').toList();
    }
    return null;
  }

  List<ScoreModel>? getPoints() {
    if (score != null) {
      return score!.scores!.where((s) => s.scoreType == 'p').toList();
    }
    return null;
  }

  Future<ApiStatusModel> redeemPoints(int points) async {
    return scoreProvider.redeemPoints(points);
  }

  Future<ApiStatusModel> claimPromoCode(String code) async {
    return scoreProvider.claimPromoCode(code);
  }

  Future<GameScoreModel> getGameScore(String game) async {
    var gameScore = await scoreProvider.getGameScore(game);
    if (gameScore == null) {
      return GameScoreModel(
          game: 'memtiles',
          averageScore: 0,
          maximumLevel: 0,
          maximumScore: 0,
          accumulatedScore: 0,
          gamesPlayed: 0,
          lastPlayed: DateTime.now().subtract(Duration(days: 3650)));
    }
    return gameScore;
  }

  Future<int?> saveGameScore(GameScoreModel gameScore) async {
    return scoreProvider.saveGameScore(gameScore);
  }

  Future<bool> processGameScore(Map<String, dynamic> values) async {
    try {
      ProfileModel? profile = await scoreProvider.apiProvider.getProfile();
      values['uid'] = profile?.uid;
      values['token'] = profile?.token;
      var response = await scoreProvider.apiProvider.client
          .callController("/app/game/played", values);
      if (response.hasError()) return false;
      return true;
    } on Exception catch (e) {
      // TODO
      return false;
    }
  }

  Future<GiftModel?> getGifts({bool isRefresh: false}) async {
    if (giftModel == null || isRefresh) {
      giftModel = await scoreProvider.getGift();
      return giftModel;
    }
    return giftModel;
  }

  redeemRequest(int id) async {
    return await scoreProvider.redeemRequest(id);
  }
}
