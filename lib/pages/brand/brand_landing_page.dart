import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaaccess/apis/auth_provider.dart';
import 'package:pharmaaccess/apis/brand_provider.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/config/config.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/country_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/pages/brand/brand_availability_list_widget.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../widgets/video_player_widget.dart';
import 'brand_list_page.dart';

class BrandLandingPage extends StatefulWidget {
  @override
  _BrandLandingPageState createState() => _BrandLandingPageState();
}

class _BrandLandingPageState extends State<BrandLandingPage> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(BRAND_SCREEN, param: {"name": "Brand Screen"});
  }

  final dbProvider = DBProvider();
  bool countrySelected = true;
  String countryName = "";

  void onCountrySelection(Country country) async {
    await firebaseAnalyticsEventCall(COUNTRY_SELECTION_EVENT,
        param: {"name": country.countryName});
    setState(() {
      countryName = country.countryName!;
      countrySelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dbProvider.getProfile(),
        builder: (BuildContext context, AsyncSnapshot<ProfileModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if ((countryName.isNotEmpty ||
                    (snapshot.data!.countryName != null &&
                        snapshot.data!.countryName.isNotEmpty)) &&
                countrySelected == true) {
              countryName = countryName.isNotEmpty
                  ? countryName
                  : snapshot.data!.countryName;
              return SingleChildScrollView(
                controller: _scrollController,
                child: MultiProvider(
                  providers: [
                    Provider<BrandProvider>(create: (_) => BrandProvider()),
                  ],
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              countrySelected = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            height: 42,
                            decoration: softCardShadow,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(countryName),
                                Icon(
                                  Icons.add_location_rounded,
                                  color: Color(0xffCDCBCB),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          margin: EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                VideoWidget(
                                  videoUrl:
                                      '${Config.PROMO_BASE}brand_promo.mp4',
                                  isBrandVideo: true,
                                  height: 200,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        'assets/images/icon_share.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: () async {
                                      try {
                                        // DeepLinkSource deepLinkSource =
                                        //     DeepLinkSourceImpl();
                                        Map<String, String> param = Map();
                                        param["brandId"] = "";
                                        // String link = await deepLinkSource
                                        //     .generateDynamicLinks(
                                        //   param,
                                        //   context,
                                        //   brandId: "brandID",
                                        //   countryId: countryName,
                                        // );
                                        Share.share("Hi, I just watched an informative video on one of Cinfa's Products.  To view it, simply click on: "
                                                " \n\n " +
                                            "${Config.PROMO_BASE}brand_promo.mp4" +
                                            "\n\nIf you would like to see more of such videos and other useful information on Cinfa products, simply download their app Hola Medico" +
                                            "\nios link: https://apps.apple.com/ae/app/hola-medico/id1526398025" +
                                            "\nandroid link: https://play.google.com/store/apps/details?id=me.g3it.pharmaaccess" +
                                            "\nhuawei link: ${Config.HUAWEI_LINK}");
                                      } catch (e) {
                                        print("exception");
                                      }

                                      //Share.share(text);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Brands Available",
                                        style: TextStyle(
                                          fontSize: 18,
                                        )),
                                    InkWell(
                                      child: Text("View All",
                                          style:
                                              TextStyle(color: primaryColor)),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BrandListPage(
                                              countryName: countryName,
                                              availabilityStatus: 'a',
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  height: 140,
                                  child: BrandAvailabilityListWidget(
                                    countryName: countryName,
                                    availability: 'a',
                                  )),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Brands New Launches",
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                  InkWell(
                                      child: Text("View All",
                                          style:
                                              TextStyle(color: primaryColor)),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BrandListPage(
                                              countryName: countryName,
                                              availabilityStatus: 'n',
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                            Container(
                                height: 140,
                                child: BrandAvailabilityListWidget(
                                  countryName: countryName,
                                  availability: 'n',
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.only(
                  top: 15,
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Choose to view brands.",
                        style: Theme.of(context).textTheme.headline4),
                    Expanded(
                      child: ListView.builder(
                          itemCount: countryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var country = countryList[index];
                            return CountryWidget(
                                country: country, callback: onCountrySelection);
                          }),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class CountryWidget extends StatelessWidget {
  const CountryWidget({
    Key? key,
    required this.country,
    required this.callback,
  }) : super(key: key);

  final Country country;
  final void Function(Country country) callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: softCardShadow,
      child: ListTile(
        leading: Image.asset(
          country.imageName!,
          width: 80,
        ),
        title: Text(country.countryName!,
            style: Theme.of(context).textTheme.headline4),
        onTap: () async {
          var provider = AuthProvider().dbProvider;
          bool saved = await provider.saveCountry(country.countryName);
          callback(country);
        },
      ),
    );
  }
}
