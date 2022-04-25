import 'package:pharmaaccess/apis/auth_provider.dart';
import 'package:pharmaaccess/apis/video_watched_provider.dart';
import 'package:pharmaaccess/main.dart';
import 'package:pharmaaccess/models/profile_model.dart';

class VideoWatchedService {
  final AuthProvider apiProvider = AuthProvider();
  final VideoWatchedProvider watchedProvider = VideoWatchedProvider();

  Future<bool> isVideoWatched(
    String? videoUrl,
  ) async {
    return watchedProvider.isVideoWatched(videoUrl);
  }

  Future<bool> setVideoWatched(String? videoUrl) async {
    return watchedProvider.setVideoWatched(videoUrl);
  }

  Future<bool?> uploadVideoWatchedInfo(String? videoUrl,
      {int? scoreCategoryId}) async {
    try {
      ProfileModel? profile = await authService.getProfile();
      Map<String, dynamic> param = {
        'uid': profile?.uid,
        'token': profile?.token,
        'video_url': videoUrl,
      };
      if (scoreCategoryId != null) {
        param['score_category'] = scoreCategoryId;
      }
      var response = await apiProvider.client
          .callController("/app/partner/video/watched", param);

      if (response == null) {
        return false;
      }
      if (!response.hasError()) {
        var result = response.getResult();
        return result['result'];
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
