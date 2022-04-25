import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pharmaaccess/SharedPref.dart';
import 'package:pharmaaccess/apis/error_handler_provider.dart';
import 'package:pharmaaccess/models/news_item_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/models/tip_of_day_model.dart';
import 'package:pharmaaccess/odoo_api/odoo_api_connector.dart';

import './auth_provider.dart';
import 'db_provider.dart';

class NewsProvider extends ErrorHandlerProvider {
  final AuthProvider apiProvider = AuthProvider();

  Future<List<NewsModel>?> getNews() async {
    try {
      var response =
          await apiProvider.client.callController("/app/v3/news", {});

      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwError(response);
        }
        var news = result.map<NewsModel>((json) {
          return NewsModel.fromJson(json);
        }).toList();
        if (news != null && news.isNotEmpty) {
          return news;
        } else {
          return throwError(response);
        }
      } else {
        return throwError(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<List<NewsModel>?> getNewsForHome() async {
    try {
      var response =
          await apiProvider.client.callController("/app/v3/news", {});
      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return null;
        }
        var news = result.map<NewsModel>((json) {
          return NewsModel.fromJson(json);
        }).toList();
        if (news != null && news.isNotEmpty) {
          return news;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<NewsModel>?> getNewsForAvicennaAndExpertMessage(
      int categoryId) async {
    try {
      var response = await apiProvider.client
          .callController("/app/v4/news", {"category_id": categoryId});
      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return null;
        }
        var news = result.map<NewsModel>((json) {
          return NewsModel.fromJson(json);
        }).toList();
        if (news != null && news.isNotEmpty) {
          return news;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<TipOfDayModel?> getTip() async {
    try {
      var response =
          await apiProvider.client.callController("/app/tip_of_day", {});

      if (!response.hasError()) {
        var result = response.getResult();
        if (result != null) {
          var tip = result.map<TipOfDayModel>((json) {
            return TipOfDayModel.fromJson(json);
          }).toList();
          if (tip != null && tip.isNotEmpty) {
            return tip[0];
          } else {
            return throwError(response);
          }
        } else {
          return throwError(response);
        }
      } else {
        return throwError(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<ProfileModel?> getProfile() async {
    final DBProvider dbProvider = DBProvider();
    return dbProvider.getProfile();
  }

  Future<String?> updateToken() async {
    ProfileModel? model = await getProfile();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    String? token = await _firebaseMessaging.getToken();
    print(" token :: $token");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceID = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceID = androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceID = iosInfo.identifierForVendor;
    }

    var response = await apiProvider.client.callController(
      "/app/register_token",
      {
        'messaging_platform': "FCM",
        "login": model?.email,
        "password": model?.token,
        "device_id": deviceID,
        "token": token,
        'os': Platform.isAndroid ? "Android" : "iOS"
      },
    );

    return await baseApiRepo(response, (response) async {
      await SharedPref.setString("TokenStore", token!);
      await SharedPref.setInt(
          "TokenTimeStamp", DateTime.now().millisecondsSinceEpoch);
    });
  }
}
