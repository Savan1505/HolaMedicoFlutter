import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/pages/cardio_module/renal_n_heptic/creatinine_calculator.dart';
import 'package:pharmaaccess/services/brand_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/commons.dart';

import 'child_pugh_calculator.dart';

class RenalNHepticLandingPage extends StatefulWidget {
  final String? availabilityStatus;

  RenalNHepticLandingPage({Key? key, this.availabilityStatus})
      : super(key: key);

  @override
  _RenalNHepticLandingPageState createState() =>
      _RenalNHepticLandingPageState();
}

class _RenalNHepticLandingPageState extends State<RenalNHepticLandingPage>
    with SingleTickerProviderStateMixin {
  final BrandService brandService = BrandService();

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(RENAL_HEPATIC_FUNCTIONS_SCREEN,
        param: {"name": "Renal & Hepatic Functions Screen"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Renal & Hepatic Functions"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          getCommonButton(
              title: TITLE_CREATININE,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_CREATININE});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CreatinineCalculator(),
                  ),
                );
              }),
          getCommonButton(
              title: 'Child Pugh Score',
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": "Child Pugh Score"});

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ChildPughCalculator(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
