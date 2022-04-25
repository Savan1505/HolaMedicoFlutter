import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/pages/cardio_module/orthopaedic_indices/orthopaedic_indices_langing_page.dart';
import 'package:pharmaaccess/pages/cardio_module/renal_n_heptic/renal_n_heptic_langing_page.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/ReferenceLinkWidget.dart';
import 'package:pharmaaccess/widgets/commons.dart';

import 'cardio_vascular_indices/cardio_vascular_indices_landing_page.dart';
import 'metabolic_indices/metabolic_indices_landing_page.dart';

class CardioLandingPage extends StatefulWidget {
  const CardioLandingPage({Key? key}) : super(key: key);

  @override
  _CardioLandingPageState createState() => _CardioLandingPageState();
}

class _CardioLandingPageState extends State<CardioLandingPage> {
  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(DIAGNOSTIC_TOOLS_SCREEN,
        param: {"name": "Diagnostic Tools Screen"});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Diagnostic Tools"),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            getCommonButton(
                title: 'Metabolic Indices',
                onClick: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          MetabolicIndicesLandingPage(),
                    ),
                  );
                }),
            getCommonButton(
                title: 'Cardiovascular Indices',
                onClick: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CardioVascularLandingPage(),
                    ),
                  );
                }),
            // getCommonButton(title: 'Pulmonary indices', onClick: () {}),
            getCommonButton(
                title: 'Renal & Hepatic Indices',
                onClick: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          RenalNHepticLandingPage(),
                    ),
                  );
                }),
            getCommonButton(
                title: TITLE_ORTHOPAEDIC_INDICES,
                onClick: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          OrthopaedicIndicesLandingPage(),
                    ),
                  );
                }),
            if (Platform.isIOS) ...[
              getReferenceLinkWidget(),
            ],
          ],
        ),
      );

  Widget getReferenceLinkWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 25),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (_) => ReferenceLinkWidget(),
            );
          },
          child: Text(
            "References",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 13,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
