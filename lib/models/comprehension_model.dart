class ComprehensionModel {
  int? comprehensionId;
  String? comprehension;
  List<int>? questionIds;
  DateTime? lastAnswered;

  ComprehensionModel({
    this.comprehensionId,
    this.comprehension,
    this.lastAnswered,
  });

  ComprehensionModel.fromJson(Map<String, dynamic> json) {
    comprehensionId = json['id'];
    comprehension = json['comprehension'];
    lastAnswered = json['last_answered'] == null
        ? null
        : DateTime.parse(json['last_answered']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.comprehensionId;
    data['comprehension'] = this.comprehension;
    data['last_answered'] = this.lastAnswered;
    return data;
  }
}

class VideoComprehensionModel {
  int? id;
  String? videoPath;

  VideoComprehensionModel({this.id, this.videoPath});

  VideoComprehensionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoPath = json['video_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video_path'] = this.videoPath;
    return data;
  }
}
