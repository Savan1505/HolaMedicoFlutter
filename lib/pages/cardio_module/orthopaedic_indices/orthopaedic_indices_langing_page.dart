import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/pages/cardio_module/orthopaedic_indices/gout_classification/gout_classification_page.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/commons.dart';

import 'ankylosing_disease/ankylosing_disease_page.dart';
import 'neuropathic_pain/neuropathic_pain_page.dart';
import 'rheumatoid_arthritis/rheumatoid_arthritis_classification_page.dart';

class OrthopaedicIndicesLandingPage extends StatefulWidget {
  @override
  _OrthopaedicIndicesLandingPageState createState() =>
      _OrthopaedicIndicesLandingPageState();
}

class _OrthopaedicIndicesLandingPageState
    extends State<OrthopaedicIndicesLandingPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(ORTHOPAEDIC_INDICES_SCREEN,
        param: {"name": TITLE_ORTHOPAEDIC_INDICES});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(TITLE_ORTHOPAEDIC_INDICES),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          getCommonButton(
              title: TITLE_ACR_EULAR_RHEUMATOID_ARTHRITIS_CLASSIFICATION,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT, param: {
                  "name": TITLE_ACR_EULAR_RHEUMATOID_ARTHRITIS_CLASSIFICATION
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        RheumatoidArthritisClassificationPage(),
                  ),
                );
              }),
          getCommonButton(
              title: TITLE_ACR_EULAR_GOUT_CLASSIFICATION,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_ACR_EULAR_GOUT_CLASSIFICATION});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => GoutClassificationPage(),
                  ),
                );
              }),
          getCommonButton(
              title: TITLE_ANKYLOSING_DISEASE_WITH_CRP,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_ANKYLOSING_DISEASE_WITH_CRP});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AnkylosingDiseasePage(
                      title: TITLE_ANKYLOSING_DISEASE_WITH_CRP,
                    ),
                  ),
                );
              }),
          getCommonButton(
              title: TITLE_ANKYLOSING_DISEASE_WITH_ESR,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_ANKYLOSING_DISEASE_WITH_ESR});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AnkylosingDiseasePage(
                      title: TITLE_ANKYLOSING_DISEASE_WITH_ESR,
                    ),
                  ),
                );
              }),
          getCommonButton(
              title: TITLE_NEUROPATHIC_PAIN_DN4_QUESTIONNAIRE,
              onClick: () async {
                await firebaseAnalyticsEventCall(CALCULATOR_EVENT,
                    param: {"name": TITLE_NEUROPATHIC_PAIN_DN4_QUESTIONNAIRE});
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => NeuropaticPainPage(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
