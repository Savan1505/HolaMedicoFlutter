class TipOfDayModel {
  TipOfDayModel({
    this.tipId,
    this.cacheId,
    this.tip,
    this.tipDate,
  });

  int? tipId;
  int? cacheId;
  String? tip;
  DateTime? tipDate;

  TipOfDayModel.fromJson(Map<String, dynamic> json) {
    tipId = json['id'];
    cacheId = json['cache_id'];
    tip = json['name'];
    tipDate = DateTime.parse(json['tip_date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.tipId;
    data['cache_id'] = this.cacheId;
    data['name'] = this.tip;
    data['tip_date'] = this.tipDate!.toIso8601String();
    return data;
  }

}