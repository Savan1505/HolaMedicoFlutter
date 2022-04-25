class SpecialModel {
  SpecialModel({
    this.specialId,
    this.name,
  });

  int? specialId;
  String? name;

  SpecialModel.fromJson(Map<String, dynamic> json) {
    specialId = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.specialId;
    data['name'] = this.name;
    return data;
  }
}

List<SpecialModel> newsList = <SpecialModel>[];
