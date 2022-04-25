import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/commons.dart';

import 'HGSTAGINGCalculator.dart';
import 'cardio_vascular_indices_calculator.dart';
import 'lipid_unit_landing_page.dart';

class CardioVascularLandingPage extends StatefulWidget {
  CardioVascularLandingPage({
    Key? key,
  }) : super(key: key);

  @override
  _CardioVascularLandingPageState createState() =>
      _CardioVascularLandingPageState();
}

class _CardioVascularLandingPageState extends State<CardioVascularLandingPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(CARDIOVASCULAR_INDICES_SCREEN,
        param: {"name": "${TITLE_CARDIO_VASCULAR_INDICES} Screen"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(TITLE_CARDIO_VASCULAR_INDICES),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          getCommonButton(
              title: TITLE_CHADSC2,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_CHADSC2_CLEAR});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CardioVascularIndicesCalculator(
                      title: TITLE_CHADSC2,
                      type: CHADCS2,
                    ),
                  ),
                );
              }),
          getCommonButton(
              title: TITLE_CHADSC2_VASC,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_CHADSC2_VASC_CLEAR});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CardioVascularIndicesCalculator(
                      title: TITLE_CHADSC2_VASC,
                      type: CHADCS2_VASC,
                    ),
                  ),
                );
              }),
          getCommonButton(
              title: TITLE_HAS_BLED_SCORE,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_HAS_BLED_SCORE});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CardioVascularIndicesCalculator(
                      title: TITLE_HAS_BLED_SCORE,
                      type: HAS_BLED_SCORE,
                    ),
                  ),
                );
              }),
          getCommonButton(
              title: TITLE_DASH_SCORE,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_DASH_SCORE});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CardioVascularIndicesCalculator(
                      title: TITLE_DASH_SCORE,
                      type: DASH_SCORE,
                    ),
                  ),
                );
              }),
          getCommonButton(
              title: TITLE_LIPID_UNIT_CONVERSION,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_LIPID_UNIT_CONVERSION});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LipidUnitLandingPage(),
                  ),
                );
              }),
          // getCommonButton(
          //     title: TITLE_CVD_MORTALITY_RISK,
          //     onClick: () async {
          //       await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
          //           param: {"name": TITLE_CVD_MORTALITY_RISK});
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (BuildContext context) => CVDMortalityCalculator(
          //             title: TITLE_CVD_MORTALITY_RISK,
          //           ),
          //         ),
          //       );
          //     }),
          getCommonButton(
              title: TITLE_HG_STAGING,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_HG_STAGING});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => HGSTAGINGCalculator(
                      title: TITLE_HG_STAGING,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
