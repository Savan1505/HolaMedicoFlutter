import 'package:flutter/material.dart';
import 'package:pharmaaccess/pages/cardio_module/metabolic_indices/diabetes_risk_assesment.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';

import 'metabolic_indices_landing_page.dart';

class MetabolicIndices extends StatefulWidget {
  const MetabolicIndices({Key? key}) : super(key: key);

  @override
  _MetabolicIndicesState createState() => _MetabolicIndicesState();
}

class _MetabolicIndicesState extends State<MetabolicIndices> {
  @override
  Widget build(BuildContext context) => ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          getCommonButton(
              title: 'Body Mass Index',
              onClick: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MetabolicIndicesLandingPage(),
                  ),
                );
              }),
          getCommonButton(title: TITLE_LEAN_BODY_MASS, onClick: () {}),
          getCommonButton(
              title: TITLE_DIABETES_RISK_ASSESSMENT,
              onClick: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => DiabetesRisk(),
                  ),
                );
              }),
        ],
      );

  Widget getCommonButton({required String title, Function? onClick}) =>
      GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 12),
          padding: EdgeInsets.only(top: 12, bottom: 12),
          color: primaryColor,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
          ),
        ),
        onTap: () {
          onClick!();
        },
      );
}
