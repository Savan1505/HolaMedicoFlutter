class PartnerScoreModel {
  int? score;
  List<ScoreModel>? scores;

  PartnerScoreModel({this.score, this.scores});

  PartnerScoreModel.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    scores = json['scores'].map<ScoreModel>((s) {
      return ScoreModel.fromJson(s);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['scores'] = this.scores;
    return data;
  }
}

class ScoreModel {
  int? score;
  String? scoreType;
  String? scoreCategory;
  String? iconType;
  String? iconUri;
  String? path;

  ScoreModel({
    this.score,
    this.scoreType,
    this.scoreCategory,
    this.iconType,
    this.iconUri,
    this.path,
  });

  ScoreModel.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    scoreType = json['score_type'];
    scoreCategory = json['score_category'];
    iconType = json['icon_type'];
    iconUri = json['icon_uri'] is bool ? null : json['icon_uri'];
    path = json['path'].runtimeType == null || json['path'].runtimeType == bool
        ? ""
        : json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['score_type'] = this.scoreType;
    data['score_category'] = this.scoreCategory;
    data['icon_type'] = this.iconType;
    data['icon_uri'] = this.iconUri;
    data['path'] = this.path;
    return data;
  }
}
