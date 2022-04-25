class MyIcpdACRequest {
  String? name;
  String? planProcessingClass;
  String? licenseExpiryDate;
  String? comments;

  MyIcpdACRequest({
    this.name,
    this.planProcessingClass,
    this.licenseExpiryDate,
    this.comments,
  });

  MyIcpdACRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    planProcessingClass = json['plan_processing_class'];
    licenseExpiryDate = json['license_expiry_date'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['plan_processing_class'] = this.planProcessingClass;
    data['license_expiry_date'] = this.licenseExpiryDate;
    data['comments'] = this.comments;
    return data;
  }
}
