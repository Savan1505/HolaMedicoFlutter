import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:pharmaaccess/config/config.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/FailureModel.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/odoo_api/odoo_api.dart';
import 'package:pharmaaccess/odoo_api/odoo_user_response.dart';
import 'package:sqflite/sqflite.dart';

import 'db_provider.dart';
import 'error_handler_provider.dart';

class AuthProvider extends ErrorHandlerProvider {
  OdooUser? user;
  var _isLoggedIn = false;
  static DateTime _lastLogin = DateTime.utc(1970, 1, 1);
  final String _store = Config.STORE;
  final DBProvider dbProvider = DBProvider();
  final _client = new OdooClient("${Config.SERVER_ADDRESS}");

  //final _client = new OdooClient("https://pharmaaccess.g3it.me"); //TODO: this must be changed to pharmaccess domain.

  static final AuthProvider _instance = AuthProvider._internal();

  AuthProvider._internal();

  factory AuthProvider() {
    return _instance;
  }

  OdooClient get client {
    _client.debugRPC(true);
    return _client;
  }

  DateTime get lastLogin {
    return _lastLogin;
  }

  Future<int?> getUID() async {
    var profile = await dbProvider.getProfile();
    return profile?.uid;
  }

  Future<OdooUser?> login(String username, String password) async {
    try {
      var auth = await client.authenticate(username, password, _store);
      if (auth.isSuccess!) {
        //TODO In-Active Code
        /*    print(auth.getResponse().getResult()[0]); */
        user = auth.getUser();
        //TODO: build profile from user
        _isLoggedIn = true;
        _lastLogin = DateTime.now();
        return user;
      }
    } catch (e) {
      _isLoggedIn = false;
      print(e);
      return null;
    }
    return null;
  }

  Future<OdooUser?> autoLogin() async {
    //TODO - this should handle timeout/session exceptions
    try {
      var profile = await dbProvider.getProfile();
      if (profile == null) return null;
      var user = await this.login(profile.email, profile.token);
      return user;
    } on Exception catch (e) {
      // TODO
      return null;
    }
  }

  Future<ProfileModel?> getProfile() async {
    return dbProvider.getProfile();
  }

  Future<double> getVersion() async {
    double currentVersionCode = 0;
    try {
      var response = await client.callController("/app/version", {});
      List<dynamic> data = response.getResult();

      if (data == null || response.getStatusCode() != 200) {
        return currentVersionCode;
      }

      String platform = (Platform.isAndroid) ? "android" : "ios";
      for (var i = 0; i < data.length; i++) {
        Map<String, dynamic> row = data[i];

        if (row['platform'] == platform) {
          currentVersionCode =
              double.parse(row['version_code'].toString().replaceAll(".", ""));
          break;
        }
      }
    } catch (e) {}
    return currentVersionCode;
  }

  Future<dynamic> fetchProfile() async {
    // var response = await client.callController("/app/profile", {});
    try {
      var response =
          await client.callControllerICPDBackSlash("/app/v4/profile", {});
      if (response.hasError()) {
        var result = response.getData();
        if (result == null) {
          // throwErrorICPD(response);
          return [];
        }
        return response.getData();
      } else {
        return [];
        // return throwErrorICPD(response);
      }
    } catch (e) {
      return [];
      // return throwErrorString(e.toString());
    }

    /*return await baseApiSlashRepo(response, (response) => response);*/
  }

  Future<ProfileModel?> saveProfile(ProfileModel profile) async {
    //TODO: delete all profile records and create new one
    Database? _db = await dbProvider.db;
    _db?.delete(
      dbProvider.profileTable,
    );
    return dbProvider.createProfile(profile);
  }

  Future<Either<FailureModel, ProfileModel?>> registerProfile(
      ProfileModel profile) async {
    //TODO: delete all profile records and create new one
    Map<String, String?> params = {
      "login": profile.email,
      'name': profile.name,
      'password': profile.token,
      'phone': profile.phone,
      'title': profile.title,
      'country': profile.countryName,
      'hospital': profile.hospital,
      "specialization": profile.specialization,
      "countryCode": profile.countryCode,
      "countryName": profile.countryName,
    };
    var response = await client.callController("/app/signup", params);

    var r = response.getResult();
    //TODO- should use .first here instead of [0]
    Map<String, dynamic>? s;
    if (r is List) {
      s = r[0];
      //s = r.first;
    } else {
      s = r;
    }
    if (response.hasError() || s!.containsKey('error')) {
      if (response.hasError()) {
        return Left(FailureModel());
      } else if (s!.containsKey('error')) {
        return Left(FailureModel(message: s['error']));
      }
    } else {
      await firebaseAnalyticsEventCall(SIGNUP_EVENT, param: params);
    }
    int uid = s['uid'];
    String? message = s['message'];
    profile.uid = uid;
    Database? _db = await dbProvider.db;
    await _db?.delete(
      dbProvider.profileTable,
    );
    return Right(await dbProvider.createProfile(profile));
  }

  Future<Either<FailureModel, ProfileModel>> updateProfile(
      ProfileModel profile) async {
    Map<String, String?> param;
    if (profile.token != profile.oldPassword) {
      param = {
        "login": profile.email,
        'password': profile.oldPassword,
        'new_password': profile.token,
        'name': profile.name,
        'phone': profile.phone,
        'title': profile.title,
        'image': profile.image
      };
    } else {
      param = {
        "login": profile.email,
        'password': profile.token,
        'name': profile.name,
        'phone': profile.phone,
        'title': profile.title,
        'image': profile.image
      };
    }
    var response = await client.callController("/app/update_profile", param);
    var r = response.getResult();
    //TODO- should use .first here instead of [0]
    Map<String, dynamic>? s;
    if (r is List) {
      s = r[0];
      //s = r.first;
    } else {
      s = r;
    }

    if (response.hasError() || s!.containsKey('error')) {
      if (response.hasError()) {
        return Left(FailureModel());
      } else if (s!.containsKey('error')) {
        return Left(FailureModel(message: s['error']));
      }
    } else {
      var provider = AuthProvider().dbProvider;
      bool saved = await provider.saveToken(profile.token);
    }
    int? uid = s['uid'];
    String? message = s['message'];
    return Right(profile);
    // profile.uid = uid;
    // var _db = await dbProvider.db;
    // await _db.delete(
    //   dbProvider.profileTable,
    // );
    // return Right(await dbProvider.createProfile(profile));
  }

  Future<bool> isRegistered() async {
    //TODO: get user profile from database if not found return false else return true
    return await dbProvider.profileExist();
  }

  Future<String?> getResgistrationData() async {
    //TODO: get user profile from database if not found return false else return true
    return await dbProvider.getProfileStringDataTesting();
  }

  bool isLoggedIn() {
    //TODO: get user profile from database if not found return false else return true
    return _isLoggedIn;
  }

  Future<bool> isActivated() async {
    var user = await this.autoLogin();
    return user == null ? false : true;
  }

  submitContactUs(String description) async {
    try {
      ProfileModel? profile = await getProfile();
      if (profile != null) {
        var response = await client.callController(
          '/app/contact_us',
          {
            'token': profile.token,
            'email': profile.email,
            'aemail': profile.email,
            'subject': "",
            'description': description,
            'feedback_type': 'r'
          },
        );
        if (!response.hasError()) {
          var result = response.getResult();
          if (result != null) {
            return result;
          }
          return null;
        }
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
