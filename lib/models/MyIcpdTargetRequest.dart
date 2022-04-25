class MyIcpdTargetRequest {
  String? name;
  String? planProcessingClass;
  double? targetPoints;
  double? targetCategory1Points;
  double? targetCategory2Points;
  double? targetCategory3Points;
  String? licenseExpiryDate;
  String? comments;

  MyIcpdTargetRequest({
    this.name,
    this.planProcessingClass,
    this.targetPoints,
    this.targetCategory1Points,
    this.targetCategory2Points,
    this.targetCategory3Points,
    this.licenseExpiryDate,
    this.comments,
  });

  MyIcpdTargetRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    planProcessingClass = json['plan_processing_class'];
    targetPoints = json['target_points'];
    targetCategory1Points = json['target_category1_points'];
    targetCategory2Points = json['target_category2_points'];
    targetCategory3Points = json['target_category3_points'];
    licenseExpiryDate = json['license_expiry_date'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['plan_processing_class'] = this.planProcessingClass;
    data['target_points'] = this.targetPoints;
    data['target_category1_points'] = this.targetCategory1Points;
    data['target_category2_points'] = this.targetCategory2Points;
    data['target_category3_points'] = this.targetCategory3Points;
    data['license_expiry_date'] = this.licenseExpiryDate;
    data['comments'] = this.comments;
    return data;
  }
}
