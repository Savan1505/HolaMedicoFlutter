import 'dart:convert';

import 'package:pharmaaccess/SharedPref.dart';
import 'package:pharmaaccess/main.dart';
import 'package:pharmaaccess/models/ClubsModel.dart';
import 'package:pharmaaccess/models/GiftModel.dart';
import 'package:pharmaaccess/models/api_status_model.dart';
import 'package:pharmaaccess/models/game_score_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/models/score_model.dart';
import 'package:pharmaaccess/odoo_api/odoo_api_connector.dart';

import './auth_provider.dart';

class ScoreProvider {
  final AuthProvider apiProvider = AuthProvider();

  Future<PartnerScoreModel?> getScore() async {
    ProfileModel? profile = await apiProvider.getProfile();
    try {
      var response = await apiProvider.client
          .callController("/app/v3/partner/score/club", {});

      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          throwError(response);
        }
        return PartnerScoreModel.fromJson(result);
      } else {
        throwError(response);
      }
    } catch (e) {
      throwErrorString(e.toString());
    }
  }

  Future<List<ClubsModel>?> getClubs() async {
    var response = await apiProvider.client
        .callController("/app/partner/club/membership", {
      /*'uid': profile.uid*/
    });

    if (!response.hasError()) {
      var result = response.getResult();
      var clubs = result['clubs'];

      List<ClubsModel> clubsList = clubs.map<ClubsModel>((json) {
        return ClubsModel.fromJson(json);
      }).toList();

      for (int i = 0; i < clubsList.length; i++) {
        if (clubsList[i].name!.contains("Respimar")) {
          await SharedPref.setInt("respimar_club_id", clubsList[i].id!);
        }
        if (clubsList[i].name!.contains("MD")) {
          await SharedPref.setInt("md_club_id", clubsList[i].id!);
        }
      }
      return clubsList;
    } else {
      print(response.getError());
      return null;
    }
  }

  Future<int> getClubScore() async {
    ProfileModel? profile = await authService.getProfile();
    var response = await apiProvider.client.callController(
        "/app/partner/score/club",
        {'uid': profile?.uid, 'token': profile?.token});

    if (!response.hasError()) {
      var result = response.getResult();
      print("getClubScore : $result");
      // var clubs = result['clubs'];
      //
      // List<ClubsModel> clubsList = clubs.map<ClubsModel>((json) {
      //   return ClubsModel.fromJson(json);
      // }).toList();
      //
      // for (int i = 0; i < clubsList.length; i++) {
      //   if (clubsList[i].name!.contains("Respimar")) {
      //     await Prefs.setInt("respimar_club_id", clubsList[i].id!);
      //   }
      //   if (clubsList[i].name!.contains("MD")) {
      //     await Prefs.setInt("md_club_id", clubsList[i].id!);
      //   }
      // }
      return 0;
    } else {
      print(response.getError());
      return 0;
    }
  }

  Future<int> getRespimarClubId() async {
    int respimarId = await SharedPref().getInt("respimar_club_id");
    if (respimarId == 0) {
      await getClubs();
      respimarId = await SharedPref().getInt("respimar_club_id");
    }
    return respimarId;
  }

  Future<int> getMDClubId() async {
    int mdId = await SharedPref().getInt("md_club_id");
    if (mdId == 0) {
      await getClubs();
      mdId = await SharedPref().getInt("md_club_id");
    }
    return mdId;
  }

  Future<ApiStatusModel> redeemPoints(int points) async {
    var response = await apiProvider.client
        .callController("/app/partner/score/redeem", {'score': points});

    if (!response.hasError()) {
      var result = response.getResult();
      if (result is String) {
        result = json.decode(result);
        return ApiStatusModel.fromJson(result);
      }
      return ApiStatusModel.fromJson(result);
    } else {
      return ApiStatusModel.fromJson(response.getResult());
    }
  }

  Future<ApiStatusModel> claimPromoCode(String code) async {
    var response = await apiProvider.client
        .callController("/app/promo_code/claim", {'promo_code': code});

    if (!response.hasError()) {
      var result = response.getResult();
      if (result is String) {
        result = json.decode(result);
        return ApiStatusModel.fromJson(result);
      }
      return ApiStatusModel.fromJson(result);
    } else {
      return ApiStatusModel.fromJson(response.getResult());
    }
  }

  Future<GameScoreModel?> getGameScore(String game) async {
    return authService.authProvider.dbProvider.getGameScore(game);
  }

  Future<int?> saveGameScore(GameScoreModel gameScore) async {
    try {
      var values = gameScore.toJson();
      int updated =
          await authService.authProvider.dbProvider.updateGameScore(values);
      if (updated != 1) {
        var scoreModel = await authService.authProvider.dbProvider
            .createGameScore(gameScore);
        if (scoreModel != null) {
          return 1;
        }
        return 0;
      }
      return updated;
    } on Exception catch (e) {
      // TODO
      return null;
    }
  }

  Future<GiftModel?> getGift() async {
    try {
      var response =
          await apiProvider.client.callController("/app/v3/gift", {});
      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          throwError(response);
        }
        return GiftModel.fromJson(result);
      } else {
        throwError(response);
      }
    } catch (e) {
      throwErrorString(e.toString());
    }
  }

  redeemRequest(int id) async {
    try {
      var response = await apiProvider.client.callController(
        "/app/v3/gift/redeem",
        {
          "product_ids": [id]
        },
      );
      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return null;
        }
        return result;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
