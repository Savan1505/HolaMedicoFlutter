class ClubsModel {
  int? id;
  String? name;
  ClubsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
