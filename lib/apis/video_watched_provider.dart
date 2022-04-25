import 'dart:convert';

import 'package:pharmaaccess/main.dart';
import 'package:pharmaaccess/models/api_status_model.dart';
import 'package:pharmaaccess/models/game_score_model.dart';
import 'package:pharmaaccess/models/score_model.dart';


import './auth_provider.dart';

class VideoWatchedProvider {
  final AuthProvider apiProvider = AuthProvider();

  Future<bool> isVideoWatched(String? videoUrl) async {
    return apiProvider.dbProvider.isVideoWatched(videoUrl);
  }

  Future<bool> setVideoWatched(String? videoUrl) async {
    return apiProvider.dbProvider.setVideoWatched(videoUrl);
  }
}
