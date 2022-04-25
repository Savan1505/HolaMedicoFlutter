class MyIcpdUpdateACRequest {
  int? planId;
  String? name;
  String? planProcessingClass;
  String? licenseExpiryDate;
  String? comments;

  MyIcpdUpdateACRequest({
    this.planId,
    this.name,
    this.planProcessingClass,
    this.licenseExpiryDate,
    this.comments,
  });

  MyIcpdUpdateACRequest.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    name = json['name'];
    planProcessingClass = json['plan_processing_class'];
    licenseExpiryDate = json['license_expiry_date'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_id'] = this.planId;
    data['name'] = this.name;
    data['plan_processing_class'] = this.planProcessingClass;
    data['license_expiry_date'] = this.licenseExpiryDate;
    data['comments'] = this.comments;
    return data;
  }
}
