class MyIcpdCreateActivityRequest {
  int? planId;
  String? name;
  String? description;
  String? start;
  String? stop;
  int? eventCategoryId;
  double? score;
  String? scoreCategory;
  String? state;

  MyIcpdCreateActivityRequest({
    this.planId,
    this.name,
    this.description,
    this.start,
    this.stop,
    this.eventCategoryId,
    this.score,
    this.scoreCategory,
    this.state,
  });

  MyIcpdCreateActivityRequest.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    name = json['name'];
    description = json['description'];
    start = json['start'];
    stop = json['stop'];
    eventCategoryId = json['event_category_id'];
    score = json['score'];
    scoreCategory = json['score_category'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_id'] = this.planId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['start'] = this.start;
    data['stop'] = this.stop;
    data['event_category_id'] = this.eventCategoryId;
    data['score'] = this.score;
    data['score_category'] = this.scoreCategory;
    data['state'] = this.state;
    return data;
  }
}
