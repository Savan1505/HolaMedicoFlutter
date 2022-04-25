import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/commons.dart';

import 'LipidUnitConversation.dart';

class LipidUnitLandingPage extends StatefulWidget {
  LipidUnitLandingPage({
    Key? key,
  }) : super(key: key);

  @override
  _LipidUnitLandingPageState createState() => _LipidUnitLandingPageState();
}

class _LipidUnitLandingPageState extends State<LipidUnitLandingPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(TITLE_LIPID_UNIT_CONVERSION),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          getCommonButton(
              title: TITLE_COLESTROL,
              onClick: () async {
                await firebaseAnalyticsEventCall(
                  TITLE_COLESTROL,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LipidUnitConversation(
                      title: TITLE_COLESTROL,
                      type: COLESTROL,
                    ),
                  ),
                );
              }),
          getCommonButton(
              title: TITLE_TRIGYLCERIDES,
              onClick: () async {
                await firebaseAnalyticsEventCall(
                  TITLE_TRIGYLCERIDES,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LipidUnitConversation(
                      title: TITLE_TRIGYLCERIDES,
                      type: TRIGYLCYRIDES,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
