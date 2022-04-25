import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/brand/product_model.dart';
import 'package:pharmaaccess/pages/brand/product_tile_widget.dart';

class BrandPricingInsuranceWidget extends StatelessWidget {
  final List<ProductModel>? products;
  BrandPricingInsuranceWidget({Key? key, required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: products!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: .80,
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0),
        itemBuilder: (BuildContext context, int position) {
          var product = products![position];
          return ProductTile(product: product);
        });
  }
}
