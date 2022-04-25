import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/brand/brand_availability_model.dart';
import 'package:pharmaaccess/services/brand_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'brand_tile_widget.dart';

class BrandListPage extends StatefulWidget {
  final String? countryName;
  final String? availabilityStatus;
  BrandListPage({Key? key, required this.countryName, this.availabilityStatus})
      : super(key: key);

  @override
  _BrandListPageState createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage>
    with SingleTickerProviderStateMixin {
  final BrandService brandService = BrandService();
  TabController? _controller;
  late Future<List<BrandAvailabilityModel>> futureGetBrandForA;
  late Future<List<BrandAvailabilityModel>> futureGetBrandForN;

  @override
  void initState() {
    futureGetBrandForA = brandService.getBrandsAvailability(
        countryName: widget.countryName, availability: 'a');
    futureGetBrandForN = brandService.getBrandsAvailability(
        countryName: widget.countryName, availability: 'n');

    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    _controller!.index = widget.availabilityStatus == 'a' ? 0 : 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Brands"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xfff5f5f5)),
            child: TabBar(
              controller: _controller,
              labelColor: primaryColor,
              unselectedLabelColor: Color(0xFF8A8A8A),
              tabs: [
                Tab(
                  text: 'Available',
                ),
                Tab(
                  text: 'New Launches',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                FutureBuilder<List<BrandAvailabilityModel>>(
                  future:
                      futureGetBrandForA, //Future<List<BrandModel>>.value(brandsList),
                  builder: (context,
                      AsyncSnapshot<List<BrandAvailabilityModel>> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.length == 0 &&
                        snapshot.connectionState == ConnectionState.done) {
                      return brandError();
                    } else if (snapshot.hasData &&
                        snapshot.data!.length > 0 &&
                        snapshot.connectionState == ConnectionState.done) {
                      return GridView.builder(
                        itemCount: snapshot.data!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0),
                        itemBuilder: (BuildContext context, int position) {
                          var availabilityStatus = snapshot.data![position];
                          return BrandTile(
                              brandAvailability: availabilityStatus);
                        },
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        snapshot.hasError) {
                      return brandError();
                    }
                    return brandLoading();
                  },
                ),
                FutureBuilder<List<BrandAvailabilityModel>>(
                  future: futureGetBrandForN,
                  builder: (context,
                      AsyncSnapshot<List<BrandAvailabilityModel>> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.length == 0 &&
                        snapshot.connectionState == ConnectionState.done) {
                      return brandError();
                    } else if (snapshot.hasData &&
                        snapshot.data!.length > 0 &&
                        snapshot.connectionState == ConnectionState.done) {
                      return GridView.builder(
                        itemCount: snapshot.data!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0),
                        itemBuilder: (BuildContext context, int position) {
                          var availabilityStatus = snapshot.data![position];
                          return BrandTile(
                              brandAvailability: availabilityStatus);
                        },
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        snapshot.hasError) {
                      return brandError();
                    }
                    return brandLoading();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget brandLoading() {
    return Center(
      child: Container(
        height: 80,
        width: 80,
        child: CircularProgressIndicator(),
      ),
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
