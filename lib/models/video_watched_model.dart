class VideoWatchedModel {
  String? videoUrl;

  VideoWatchedModel({this.videoUrl});

  VideoWatchedModel.fromJson(Map<String, dynamic> json) {
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_url'] = this.videoUrl;
    return data;
  }
}