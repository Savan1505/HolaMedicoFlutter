class GiftModel {
  List<Gift>? gift;

  GiftModel({
    this.gift,
  });

  GiftModel.fromJson(var json) {
    gift = json.map<Gift>((s) {
      return Gift.fromJson(s);
    }).toList();
  }
}

class Gift {
  String? product_url, name;
  int? points, id;

  Gift({
    this.id,
    this.name,
    this.points,
    this.product_url,
  });

  Gift.fromJson(Map<String, dynamic> json) {
    product_url = json['product_url'];
    id = json['id'];
    points = json['points'];
    name = json['name'];
  }
}
