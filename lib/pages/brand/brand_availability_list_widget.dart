import 'package:flutter/material.dart';
import 'package:pharmaaccess/apis/brand_provider.dart';
import 'package:pharmaaccess/models/brand/brand_availability_model.dart';
import 'package:pharmaaccess/services/brand_service.dart';

import 'brand_tile_widget.dart';

class BrandAvailabilityListWidget extends StatefulWidget {
  final String? domain;
  final String availability;
  final String? countryName;
  BrandAvailabilityListWidget(
      {Key? key,
      this.domain,
      required this.countryName,
      required this.availability})
      : super(key: key);

  @override
  _BrandAvailabilityListWidgetState createState() =>
      _BrandAvailabilityListWidgetState();
}

class _BrandAvailabilityListWidgetState
    extends State<BrandAvailabilityListWidget> {
  final BrandService brandService = BrandService();
  late Future<List<BrandAvailabilityModel>> futureGetBrands;

  @override
  void initState() {
    futureGetBrands = brandService.getBrandsAvailability(
        countryName: widget.countryName, availability: widget.availability);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BrandAvailabilityModel>>(
      future: futureGetBrands,
      builder: (context, AsyncSnapshot<List<BrandAvailabilityModel>> snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.length == 0 &&
            snapshot.connectionState == ConnectionState.done) {
          return brandError();
        } else if (snapshot.hasData &&
            snapshot.data!.length > 0 &&
            snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int position) {
              BrandAvailabilityModel availabilityStatus =
                  snapshot.data![position];
              return BrandTile(brandAvailability: availabilityStatus);
            },
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError) {
          return brandError();
        }
        return Center(
          child: Container(
            height: 80,
            width: 80,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget brandError() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 46),
      child: Text(
        "No Brands information can be fetched, check internet connection or contact support.",
        style: TextStyle(fontSize: 18.9),
        textAlign: TextAlign.center,
      ),
    );
  }
}
