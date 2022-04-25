import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pharmaaccess/SharedPref.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/components/app_webview.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/icpd_cme_plan_model.dart';
import 'package:pharmaaccess/models/icpd_common_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/pages/icpd/create_my_icpd_traget.dart';
import 'package:pharmaaccess/pages/icpd/icpd_structure.dart';
import 'package:pharmaaccess/pages/icpd/plan_tracker.dart';
import 'package:pharmaaccess/pages/icpd/previous_plan.dart';
import 'package:pharmaaccess/pages/icpd/widget/BarChart.dart';
import 'package:pharmaaccess/pages/icpd/widget/CmeCatalogButton.dart';
import 'package:pharmaaccess/pages/icpd/widget/DonutPieChart.dart';
import 'package:pharmaaccess/services/icpd_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/widgets/icon_full_button.dart';

class LicenseRenewalPage extends StatefulWidget {
  final int? planTypeIndex;

  const LicenseRenewalPage({Key? key, this.planTypeIndex}) : super(key: key);

  @override
  _LicenseRenewalPageState createState() => _LicenseRenewalPageState();
}

class _LicenseRenewalPageState extends State<LicenseRenewalPage> {
  ScrollController _scrollControllerChart = new ScrollController();
  ScrollController _scrollControllerSimple = new ScrollController();
  IcpdService icpdService = IcpdService();

  // Widget futureWidget = Container();
  List<PlanList> alPlanList = [];
  late DBProvider dbProvider;
  ProfileModel? profileFuture;
  var countryName = "UAE";
  String countryGuidName = "unitedarabemirates";
  bool _loading = true;
  int? targetPoints = 0;
  int? currentPoints = 0;
  int? remainingPoints = 0;

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(ICPD_LICENSE_RENEWAL_PLAN_SCREEN,
        param: {"name": "iCPD My License Renewal CPD Plan Screen"});
    _loading = true;
    dbProvider = DBProvider();
    _getProfileData();
    _getPlanListAPI();
    /*futureWidget = FutureBuilder<List<PlanList>?>(
        future: icpdService.getCMEPlanList(),
        builder: (context, snapshot) {
          dbProvider = DBProvider();
          _getProfileData();
          if (snapshot.data != null && snapshot.data!.length > 0) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              for (PlanList planList in snapshot.data ?? []) {
                if (planList.name == "License Renewal CME") {
                  return chartRow(snapshot.data);
                }
              }
            }
            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasData) {
              return simpleButtonColumn();
            }
          } else {
            return simpleButtonColumn();
          }
          return Center(child: CircularProgressIndicator());
        });*/
  }

  void _getPlanListAPI() async {
    List<PlanList> alPlanListData = await icpdService.getCMEPlanList() ?? [];
    if (alPlanListData.isNotEmpty && alPlanListData.length > 0) {
      for (PlanList planListItem in alPlanListData) {
        if (planListItem.name == "License Renewal CME") {
          targetPoints = planListItem.targetPoints?.round();
          currentPoints = planListItem.cappedPoints?.round();
          remainingPoints = targetPoints! - currentPoints!;
          await SharedPref.setString(
              "licenseRenewalExpiryDate",
              planListItem.licenseExpiryDate ??
                  DateFormat("yyyy-MM-dd").format(DateTime.now()));
          await SharedPref.setInt("remainingPoints", remainingPoints ?? 0);

          alPlanList = alPlanListData;
          _planInAppNotification(planListItem);
        }
      }
    }
    setState(() {
      _loading = false;
    });
  }

  void _planInAppNotification(PlanList planListItem) async {
    int remainingPoints = await SharedPref().getInt("remainingPoints");
    String licenseRenewalExpiryDate =
        await SharedPref().getString("licenseRenewalExpiryDate");
    if (licenseRenewalExpiryDate.isNotEmpty) {
      DateTime dateExpire = DateTime.parse(licenseRenewalExpiryDate);

      var dateTimeExpire =
          DateTime(dateExpire.year, dateExpire.month, dateExpire.day, 0, 0, 0);
      final date2 = DateFormat("yyyy-MM-dd").format(DateTime.now());

      var difference = daysBetween(dateTimeExpire, DateTime.parse(date2));
      var differenceBefore = difference < 0
          ? int.parse(difference.toString().replaceFirst("-", ""))
          : 0;
      String strDay = "",
          strYear = "",
          strMonth = "",
          strWeek = "",
          afterBefore = "";
      int years = 0, months = 0, weeks = 0;
      if (differenceBefore > 0) {
        strDay = differenceBefore == 1 ? "day" : "days";
        print("difference License Renewal Plan is :  $differenceBefore");

        years = _getCalculateYear(differenceBefore); //Years
        strYear = years == 1 ? "year" : "years";

        months = _getCalculateMonth(differenceBefore); //Months
        strMonth = months == 1 ? "month" : "months";

        weeks = _getCalculateWeek(differenceBefore); //Weeks
        strWeek = weeks == 1 ? "week" : "weeks";

        //After Before
        afterBefore = "ago";

        String notificationMessage = "";
        String messageLicense = "Your License Renewal CPD Plan has expired";

        //Point is less or equal 10
        if (remainingPoints <= 10) {
          //Date and Point
          if (differenceBefore > 0) {
            if (years > 0) {
              //Years
              notificationMessage =
                  "$messageLicense $years $strYear $afterBefore and Your remaining point is $remainingPoints.";
            } else if (months > 0) {
              //Months
              notificationMessage =
                  "$messageLicense $months $strMonth $afterBefore and Your remaining point is $remainingPoints.";
            } else if (weeks > 0) {
              //Weeks
              notificationMessage =
                  "$messageLicense $weeks $strWeek $afterBefore and Your remaining point is $remainingPoints.";
            } else {
              //Days
              notificationMessage =
                  "$messageLicense $differenceBefore $strDay $afterBefore and Your remaining point is $remainingPoints.";
            }
          } else {
            //Points
            notificationMessage =
                "Your License Renewal CPD Plan remaining points is $remainingPoints.";
          }
        } else {
          //Date
          if (differenceBefore > 0) {
            if (years > 0) {
              //Years
              notificationMessage =
                  "$messageLicense $years $strYear $afterBefore.";
            } else if (months > 0) {
              //Months
              notificationMessage =
                  "$messageLicense $months $strMonth $afterBefore.";
            } else if (weeks > 0) {
              //Weeks
              notificationMessage =
                  "$messageLicense $weeks $strWeek $afterBefore.";
            } else {
              //Days
              notificationMessage =
                  "$messageLicense $differenceBefore $strDay $afterBefore.";
            }
          }
        }

        await _showSimpleInAppNotification(
            notificationMessage, planListItem.id ?? 0);
      }
    }
  }

  _showSimpleInAppNotification(String message, int planId) {
    showSimpleNotification(
      Text(
        message,
        textAlign: TextAlign.start,
        style: TextStyle(color: Colors.orange),
      ),
      background: Colors.white,
      autoDismiss: false,
      subtitle: Builder(builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              textColor: Colors.red,
              onPressed: () {
                OverlaySupportEntry.of(context)?.dismiss();
              },
              child: Text('Dismiss'),
            ),
            FlatButton(
                textColor: Colors.green,
                onPressed: () async {
                  OverlaySupportEntry.of(context)?.dismiss();
                  CommonResultMessage? commonResultMessage =
                      await icpdService.archiveCurrentPlan(planId);
                  if (commonResultMessage?.isSuccess ?? false) {
                    setState(() {
                      _loading = true;
                      alPlanList = [];
                      _getPlanListAPI();
                    });
                  }
                },
                child: Text('Archive'))
          ],
        );
      }),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (from.difference(to).inHours / 24).round();
  }

  int _getCalculateYear(int difference) {
    if (difference > 364) {
      // Years Current day +
      return difference ~/ 365;
    }
    return 0;
  }

  int _getCalculateMonth(int difference) {
    //Months
    if (difference > 29 && difference < 365) {
      // Months Current day +
      int year = difference ~/ 365;
      return (difference - year * 365) ~/ 30;
    }
    return 0;
  }

  int _getCalculateWeek(int difference) {
    //Weeks
    if (difference > 6 && difference < 30) {
      // Week Current day +
      int year = difference ~/ 365;
      int month = (difference - year * 365) ~/ 30;
      return (difference - month * 365) ~/ 7;
    }
    return 0;
  }

  void _getProfileData() async {
    profileFuture = await dbProvider.getProfile();
    countryName = profileFuture!.countryName;
    if (countryName == "Kuwait") {
      countryGuidName = "kuwait";
    } else if (countryName == "Qatar") {
      countryGuidName = "qatar";
    } else if (countryName == "Saudi Arabia") {
      countryGuidName = "saudiarabia";
    } else {
      countryGuidName = "unitedarabemirates";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text(
          "My License Renewal CPD Plan",
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: InkWell(
          onTap: () async {
            await firebaseAnalyticsEventCall(ICPD_LICENSE_RENEWAL_PLAN_SCREEN,
                param: {"name": "Previous Plan"});
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => PreviousPlan(),
              ),
            );
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 16,
              ),
              Text(
                "Previous Plans",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff525151),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : alPlanList.length > 0
              ? chartRow()
              : simpleButtonColumn(),
      // body: futureWidget,
      /*body: SingleChildScrollView(
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
              Text(
                'You Have no Active ICPD Plans Created yet, Start Creating Your Plan And Track Your Progress.\n\nSelect CPD Planner And Tracker to Start.',
                style: TextStyle(
                  color: Color(0xff525151),
                ),
                textAlign: TextAlign.center,
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.3,
              //   child: chartRow(),
              // ),
              SizedBox(
                height: 50.0,
              ),
              IconFullButton(
                label: "CME Guide Lines for UAE",
                iconPath: "assets/icon/cme_guide_icon.png",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => CMEGuideLinesForUAE(),
                    ),
                  );
                },
              ),
              IcpdSpacer(),
              CmeCatalog(),
              IcpdSpacer(),
              IconFullButton(
                label: "CPD Planner and Tracker",
                iconPath: "assets/icon/tracker_icon.png",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => PlanTracker(),
                    ),
                  );
                },
              ),
              IcpdSpacer(),
            ],
          ),
        ),
      ),*/
    );
  }

  Widget chartRow() => Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollControllerChart,
            child: Container(
              child: Column(
                children: List.generate(alPlanList.length, (index) {
                  DateTime beforeDateFormat = new DateFormat("yyyy-MM-dd")
                      .parse(alPlanList[index].licenseExpiryDate!);
                  String beForeDate =
                      DateFormat("dd-MMM-yy").format(beforeDateFormat);
                  return alPlanList[index].planProcessingClass == "td"
                      ? Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 10,
                                        child: Column(
                                          children: [
                                            Text(
                                              "My Plan Summary",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff525151),
                                              ),
                                            ),
                                            Flexible(
                                              child: GroupedBarChart
                                                  .withSampleData(
                                                planList: alPlanList[index],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  legend(
                                                    "Planned",
                                                    Color(0xff61A0D7),
                                                  ),
                                                  legend(
                                                    "Achieved",
                                                    Color(0xffEE8336),
                                                  ),
                                                  legend(
                                                    "Considered",
                                                    Color(0xffDFDFDF),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Flexible(
                                        flex: 5,
                                        child: Column(
                                          children: [
                                            Flexible(
                                              flex: 8,
                                              child:
                                                  DonutPieChart.withSampleData(
                                                      targetPoint:
                                                          alPlanList[index]
                                                              .targetPoints!
                                                              .round()
                                                              .toString(),
                                                      currentPoint:
                                                          alPlanList[index]
                                                              .cappedPoints!
                                                              .round()
                                                              .toString()),
                                            ),
                                            Flexible(
                                              flex: 4,
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Remaining Points: ",
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Color(
                                                                0xff525151),
                                                          ),
                                                        ),
                                                        Text(
                                                          remainingPoints
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Text(
                                                      "Before: $beForeDate",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff525151),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50.0,
                                ),
                                IconFullButton(
                                  label: "CME Guide Lines for $countryName",
                                  iconPath: "assets/icon/cme_guide_icon.png",
                                  onPressed: () async {
                                    await firebaseAnalyticsEventCall(
                                        ICPD_LICENSE_RENEWAL_PLAN_SCREEN,
                                        param: {
                                          "name":
                                              "CME Guide Lines for $countryName"
                                        });
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MyWebView(
                                          title:
                                              "CME Guide Lines for $countryName",
                                          selectedUrl:
                                              "https://portal.pharmaaccess.com/cp/countryguidelines/$countryGuidName",
                                        ),
                                      ),
                                    );
                                    /*Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CMEGuideLinesForUAE(
                                          countryName: countryName,
                                        ),
                                      ),
                                    );*/
                                  },
                                ),
                                IcpdSpacer(),
                                CmeCatalog(
                                  titleName: "CME Catalog",
                                  planTypeItem: alPlanList,
                                  countryName: countryName,
                                  planTypeIndex: widget.planTypeIndex,
                                ),
                                IcpdSpacer(),
                                IconFullButton(
                                  label: "CPD Planner and Tracker",
                                  iconPath: "assets/icon/tracker_icon.png",
                                  onPressed: () async {
                                    await firebaseAnalyticsEventCall(
                                        ICPD_LICENSE_RENEWAL_PLAN_SCREEN,
                                        param: {
                                          "name": "CPD Planner and Tracker"
                                        });
                                    var result =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PlanTracker(
                                                planTypeIndex:
                                                    widget.planTypeIndex,
                                                titleName:
                                                    "CPD Planner and Tracker",
                                                countryName: countryName,
                                                planList: alPlanList[index]),
                                      ),
                                    );
                                    if (result ?? false) {
                                      setState(() {
                                        _loading = true;
                                        alPlanList = [];
                                        _getPlanListAPI();
                                      });
                                    }
                                  },
                                ),
                                IcpdSpacer(),
                              ],
                            ),
                          ),
                        )
                      : Container();
                }),
              ),
            ),
          ),
        ],
      );

  Widget simpleButtonColumn() => Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollControllerSimple,
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
                  Text.rich(
                    TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style:
                          TextStyle(color: Color(0xff525151), wordSpacing: 1.0),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                'You have no active iCPD plan created as yet, Please start creating your plan and tracking progress by selecting'),
                        TextSpan(
                            text: ' \"CPD Planner and Tracker\"',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.3,
                  //   child: chartRow(),
                  // ),
                  SizedBox(
                    height: 50.0,
                  ),
                  IconFullButton(
                    label: "CME Guide Lines for $countryName",
                    iconPath: "assets/icon/cme_guide_icon.png",
                    onPressed: () async {
                      await firebaseAnalyticsEventCall(
                          ICPD_LICENSE_RENEWAL_PLAN_SCREEN,
                          param: {"name": "CME Guide Lines for $countryName"});
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => MyWebView(
                            title: "CME Guide Lines for $countryName",
                            selectedUrl:
                                "https://portal.pharmaaccess.com/cp/countryguidelines/$countryGuidName",
                          ),
                        ),
                      );
                      /*Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CMEGuideLinesForUAE(
                                          countryName: countryName,
                                        ),
                                      ),
                                    );*/
                    },
                  ),
                  IcpdSpacer(),
                  /*CmeCatalog(
                    planTypeItem: [],
                    planTypeIndex: widget.planTypeIndex,
                  ),*/
                  CmeCatalog(
                    titleName: "CME Catalog",
                    planTypeItem: alPlanList,
                    countryName: countryName,
                    planTypeIndex: widget.planTypeIndex,
                  ),
                  IcpdSpacer(),
                  IconFullButton(
                    label: "CPD Planner and Tracker",
                    iconPath: "assets/icon/tracker_icon.png",
                    onPressed: () async {
                      await firebaseAnalyticsEventCall(
                          ICPD_LICENSE_RENEWAL_PLAN_SCREEN,
                          param: {"name": "CPD Planner and Tracker"});
                      /*Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => PlanTracker(
                            planList: PlanList(),
                          ),
                        ),
                      );*/
                      var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => CreateMyIcpdTarget(
                            planId: 0,
                            selectPlanIndex: 0,
                            planName: "License Renewal CME",
                            planType: "td",
                            countryName: countryName,
                          ),
                        ),
                      );
                      if (result ?? false) {
                        setState(() {
                          _loading = true;
                          alPlanList = [];
                          _getPlanListAPI();
                        });
                      }
                    },
                  ),
                  IcpdSpacer(),
                ],
              ),
            ),
          ),
        ],
      );

  Widget legend(String text, Color color) => Row(
        children: [
          Container(
            height: 13.0,
            width: 13.0,
            color: color,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.0,
              color: Color(0xff525151),
            ),
          ),
        ],
      );
}
