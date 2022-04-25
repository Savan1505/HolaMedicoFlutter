class ProductInsuranceModel {
  int? productId;
  String? productName;
  String? insuranceCompanyName;
  List<Map<String,dynamic>>? packages; //  String insurancePackageName; String status;

  ProductInsuranceModel(
      {this.productId,
        this.productName,
        this.insuranceCompanyName,
        this.packages,
      });

  ProductInsuranceModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    insuranceCompanyName = json['company_name'];
    print(json['packages']);
    List<Map<String,dynamic>> p = List<Map<String,dynamic>>.from(json['packages']);
    packages = p;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['insurance_company_name'] = this.insuranceCompanyName;
    data['packages'] = this.packages;
    return data;
  }
}

List<ProductInsuranceModel> productInsuranceList = <ProductInsuranceModel>[
  ProductInsuranceModel(productId: 1, productName: "Atorcor 10mg X 28", insuranceCompanyName: "Aafiya Insurance",
      packages: [{"insurancePackageName": "Aafia TPA Basic", "status": "Available"},
        {"insurancePackageName": 'Aafia TPA Premium', "status": "Available"},
        {"insurancePackageName": "Aafia TPA Extra Cheese", "status": "Not Available"},] ),
  ProductInsuranceModel(productId: 2, productName: 'Atorcor 20mg X 28', insuranceCompanyName: "Aafiya Insurance", packages: [{"insurancePackageName": 'Aafia TPA Basic', "status": "Available"}] ),
  ProductInsuranceModel(productId: 2, productName: 'Atorcor 20mg X 28', insuranceCompanyName: "General Insurance", packages: [{"insurancePackageName": 'GI Basic', "status": "Available"}] ),
];