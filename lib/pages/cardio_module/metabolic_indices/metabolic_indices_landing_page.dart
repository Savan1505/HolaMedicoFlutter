import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/pages/cardio_module/metabolic_indices/metabolic_calculator.dart';
import 'package:pharmaaccess/services/brand_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/commons.dart';

import 'diabetes_risk_assesment.dart';

class MetabolicIndicesLandingPage extends StatefulWidget {
  final String? availabilityStatus;

  MetabolicIndicesLandingPage({Key? key, this.availabilityStatus})
      : super(key: key);

  @override
  _MetabolicIndicesLandingPageState createState() =>
      _MetabolicIndicesLandingPageState();
}

class _MetabolicIndicesLandingPageState
    extends State<MetabolicIndicesLandingPage>
    with SingleTickerProviderStateMixin {
  final BrandService brandService = BrandService();
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(CALCULATOR_EVENT,
        param: {"name": "Metabolic Indices Screen"});
    _controller = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    _controller.index = widget.availabilityStatus == 'a' ? 0 : 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Metabolic Indices"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          getCommonButton(
              title: 'BMI',
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_BMI});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MetaBolicCalculator(
                      type: BMI,
                      title: TITLE_BMI,
                    ),
                  ),
                );
              }),
          getCommonButton(
            title: TITLE_LEAN_BODY_MASS,
            onClick: () async {
              await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                  param: {"name": TITLE_LEAN_BODY_MASS});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => MetaBolicCalculator(
                    type: LBM,
                    title: TITLE_LEAN_BODY_MASS,
                  ),
                ),
              );
            },
          ),
          getCommonButton(
            title: TITLE_BODY_FAT_PER,
            onClick: () async {
              await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                  param: {"name": "Body Fat"});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => MetaBolicCalculator(
                    type: BODY_FAT,
                    title: TITLE_BODY_FAT_PER,
                  ),
                ),
              );
            },
          ),
          getCommonButton(
            title: TITLE_BASAL_META_RATE,
            onClick: () async {
              await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                  param: {"name": TITLE_BASAL_META_RATE});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => MetaBolicCalculator(
                    type: BASAL_METABOLIC_RATE,
                    title: TITLE_BASAL_META_RATE,
                  ),
                ),
              );
            },
          ),
          getCommonButton(
            title: TITLE_CALORIE_CALCULATOR,
            onClick: () async {
              await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                  param: {"name": "Calorie"});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => MetaBolicCalculator(
                    type: CALORIE_CALCULATOR,
                    title: TITLE_CALORIE_CALCULATOR,
                  ),
                ),
              );
            },
          ),
          getCommonButton(
            title: TITLE_DIABETES_RISK_ASSESSMENT,
            onClick: () async {
              await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                  param: {"name": TITLE_DIABETES_RISK_ASSESSMENT});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => DiabetesRisk(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
