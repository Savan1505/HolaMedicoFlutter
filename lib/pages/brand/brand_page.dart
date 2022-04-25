import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/apis/brand_provider.dart';
import 'package:pharmaaccess/config/config.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/brand/brand_model.dart';
import 'package:pharmaaccess/pages/brand/side_effects_widget.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/widgets/CommonOverflowMenu.dart';
import 'package:pharmaaccess/widgets/video_player_widget.dart';
import 'package:share/share.dart';

import 'brand_pricing_insurance_widget.dart';
import 'clinical_trial_widget.dart';
import 'drug_interaction_widget.dart';
import 'indication_widget.dart';

class BrandPage extends StatefulWidget {
  final BrandModel? brand;

  BrandPage({Key? key, required this.brand}) : super(key: key);

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage>
    with SingleTickerProviderStateMixin {
  final BrandProvider brandProvider = BrandProvider();
  int _currentIndex = 0;
  PageController _controller = PageController(initialPage: 0);

  StreamController<int> pageCurrentIndexStreamController =
      StreamController<int>.broadcast();

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(BRAND_SELECTION_EVENT,
        param: {"Brand Name": widget.brand!.name});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(widget.brand!.name!.toUpperCase()),
          actions: [CommonOverFlowMenu()],
        ),
        body: Column(
          children: <Widget>[
            StreamBuilder<int>(
              initialData: _currentIndex,
              stream: pageCurrentIndexStreamController.stream,
              builder: (_, snapshot) => Container(
                height: 40,
                child: ListView(
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    MenuItemWidget(
                      label: "Indication & Dose",
                      index: 0,
                      currentIndex: _currentIndex,
                      callback: itemClicked,
                    ),
                    MenuItemWidget(
                      label: "Drugs Interaction",
                      index: 1,
                      currentIndex: _currentIndex,
                      callback: itemClicked,
                    ),
                    MenuItemWidget(
                      label: "Clinical Trials",
                      index: 2,
                      currentIndex: _currentIndex,
                      callback: itemClicked,
                    ),
                    MenuItemWidget(
                      label: "Side Effects",
                      index: 3,
                      currentIndex: _currentIndex,
                      callback: itemClicked,
                    ),
                    MenuItemWidget(
                      label: "Pricing & Insurance",
                      index: 4,
                      currentIndex: _currentIndex,
                      callback: itemClicked,
                    ),
                  ],
                ),
              ),
            ), //ListView
            widget.brand!.promoAvailable!
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          VideoWidget(
                            videoUrl: widget.brand!.videoUrl,
                            isBrandVideo: true,
                            isLooping: false,
                            scoreCategoryId: widget.brand!.scoreCategoryId,
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
                                      MediaQuery.of(context).size.width * 0.06,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () async {
                                try {
                                  await firebaseAnalyticsEventCall(VIDEO_SHARE,
                                      param: {"name": "Brand Video Screen"});
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
                                      "${widget.brand!.videoUrl}" +
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
                  )
                : Container(),

            Expanded(
              child: PageView(
                onPageChanged: (int page) {
                  _currentIndex = page;
                  pageCurrentIndexStreamController.add(_currentIndex);
                },
                controller: _controller,
                children: <Widget>[
                  IndicationWidget(indications: widget.brand!.indications),

                  //indicationList,),
                  DrugInteractionWidget(
                      drugInteractions: widget.brand!.drugInteractions),

                  //drugInteractionList,),
                  ClinicalTrialWidget(
                    trialList: widget.brand!.clinicalTrials,
                  ),

                  SideEffectsWidget(
                    sideEffects: widget.brand!.groupedSideEffects,
                  ),

                  //clinicalTrialList,),
                  BrandPricingInsuranceWidget(
                    products: widget.brand!.products,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    pageCurrentIndexStreamController.close();
    super.dispose();
  }

  void itemClicked(index) {
    _currentIndex = index;
    pageCurrentIndexStreamController.add(_currentIndex);

    _controller.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}

class MenuItemWidget extends StatelessWidget {
  final String label;
  final int? index;
  final int? currentIndex;
  final void Function(int? index)? callback;

  const MenuItemWidget({
    Key? key,
    required this.label,
    this.index,
    this.currentIndex,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          callback!(index);
        },
        child: Container(
          margin: EdgeInsets.all(8),
          child: Text(label,
              style: TextStyle(
                  color: index == currentIndex ? primaryColor : bodyTextColor,
                  fontSize: 18)),
        ),
      );
}
