import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/pages/icpd/icpd_structure.dart';
import 'package:pharmaaccess/pages/icpd/license_renewal_page.dart';
import 'package:pharmaaccess/pages/icpd/my_further_medical_education.dart';
import 'package:pharmaaccess/pages/icpd/my_personal_development_plan.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/widgets/icon_full_button.dart';
import 'package:pharmaaccess/widgets/icpd_profile.dart';

class IcpdPage extends StatefulWidget {
  const IcpdPage({Key? key}) : super(key: key);

  @override
  _IcpdPageState createState() => _IcpdPageState();
}

class _IcpdPageState extends State<IcpdPage> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAnalyticsEventCall(ICPD_SCREEN, param: {"name": "iCPD Screen"});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColor,
          title: Text(
            "iCPD",
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: IcpdProfileWidget(
                    size: 170,
                    innerBorderWidth: 8,
                    outerBorderWidth: 11,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconFullButton(
                      label: "My License Renewal CPD Plan",
                      iconPath: "assets/icon/driver_license_icon.png",
                      onPressed: () async {
                        await firebaseAnalyticsEventCall(ICPD_SCREEN,
                            param: {"name": "My License Renewal CPD Plan"});
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LicenseRenewalPage(
                              planTypeIndex: 0,
                            ),
                          ),
                        );
                      },
                    ),
                    IcpdSpacer(),
                    IconFullButton(
                      label: "My Further Medical Education",
                      iconPath: "assets/icon/college_graduation_icon.png",
                      onPressed: () async {
                        await firebaseAnalyticsEventCall(ICPD_SCREEN,
                            param: {"name": "My Further Medical Education"});
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MyFutureEducationPage(
                              planTypeIndex: 1,
                            ),
                          ),
                        );
                      },
                    ),
                    IcpdSpacer(),
                    IconFullButton(
                      label: "My Personal Development",
                      iconPath: "assets/icon/personal_development_icon.png",
                      onPressed: () async {
                        await firebaseAnalyticsEventCall(ICPD_SCREEN,
                            param: {"name": "My Personal Development"});
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MyPersonalDevelopmentPlanPage(
                              planTypeIndex: 2,
                            ),
                          ),
                        );
                      },
                    ),
                    /*IcpdSpacer(),
                    IconFullButton(
                      label: "Add/Modify My Plan Activities",
                      iconPath: "assets/icon/personal_development_icon.png",
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddMyPlanActivities(),
                          ),
                        );
                      },
                    ),
                    IcpdSpacer(),*/
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
