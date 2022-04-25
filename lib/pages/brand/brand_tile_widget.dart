import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/brand/brand_availability_model.dart';
import 'package:pharmaaccess/models/brand/brand_model.dart';
import 'package:pharmaaccess/services/brand_service.dart';

import '../../theme.dart';
import 'brand_page.dart';

class BrandTile extends StatelessWidget {
  BrandTile({
    Key? key,
    required this.brandAvailability,
  }) : super(key: key);

  final BrandAvailabilityModel brandAvailability;
  final BrandService brandService = BrandService();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        BrandModel? brand = await brandService.getBrand(
            brandAvailability.brandId, brandAvailability.countryName);
        if (brand != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BrandPage(brand: brand)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Internal server error"),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: tileShadow,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FadeInImage.assetNetwork(
                image: brandAvailability.thumbnailUrl == null
                    ? "assets/images/cinfa_hexagon_small.png"
                    : brandAvailability.thumbnailUrl!,
                placeholder: "assets/images/cinfa_hexagon_small.png",
                imageErrorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset("assets/images/cinfa_hexagon_small.png");
                },
                placeholderErrorBuilder: (BuildContext context,
                    Object exception, StackTrace? stackTrace) {
                  return Image.asset("assets/images/cinfa_hexagon_small.png");
                },
              ),
            ),
            Text(brandAvailability.brandName!.toUpperCase()),
          ],
        ),
      ),
    );
  }
}
