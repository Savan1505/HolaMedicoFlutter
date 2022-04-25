class ActivityExpItem {
  ActivityExpItem({this.planTypeIndex, this.activityName, this.activityExpDate});

  final int? planTypeIndex;
  final String? activityName;
  final String? activityExpDate;

  factory ActivityExpItem.fromJson(Map<String, dynamic> parsedJson) {
    return new ActivityExpItem(
        planTypeIndex: parsedJson['planTypeIndex'] ?? 0,
        activityName: parsedJson['activityName'] ?? "",
        activityExpDate: parsedJson['activityExpDate'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "planTypeIndex": this.planTypeIndex,
      "activityName": this.activityName,
      "activityExpDate": this.activityExpDate,
    };
  }
}
