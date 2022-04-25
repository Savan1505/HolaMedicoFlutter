import 'package:pharmaaccess/models/brand/product_insurance_model.dart';

class ProductModel {
  ProductModel({this.name,this.id,this.cacheId,this.thumbnailUrl,this.price});
  int? id;
  int? cacheId;
  String? name;
  String? price;
  String? thumbnailUrl;
  List<ProductInsuranceModel>? insurances;

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cacheId = json['cacheId'];
    name = json['name'];
    price = json['price'].toString();
    thumbnailUrl = json['thumbnail_url'];
    insurances = json['insurances'] .map<ProductInsuranceModel>((insurance) {
      return ProductInsuranceModel.fromJson(insurance);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cacheId'] = this.cacheId;
    data['name'] = this.name;
    data['thumbnailUrl'] = this.thumbnailUrl;
    return data;
  }
}

List<ProductModel> productList = <ProductModel>[
  ProductModel(id: 1, name: 'Atorcor 10mg X 28', price: "AED60.000", thumbnailUrl: 'https://g3it.me/pa/brand_1_thumbnail.png'),
  ProductModel(id: 2, name: 'Atorcor 20mg X 28', price: "AED96.500", thumbnailUrl: 'https://g3it.me/pa/brand_2_thumbnail.png'),
  ProductModel(id: 2, name: 'Atorcor 40mg X 28', price: "AED113.500", thumbnailUrl: 'https://g3it.me/pa/brand_3_thumbnail.png'),
  ProductModel(id: 2, name: 'Atorcor 80mg X 28', price: "AED157.000", thumbnailUrl: 'https://g3it.me/pa/brand_4_thumbnail.png'),
];