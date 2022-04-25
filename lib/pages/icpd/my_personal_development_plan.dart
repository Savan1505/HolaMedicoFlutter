import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmaaccess/SharedPref.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/icpd_activity_resp_model.dart';
import 'package:pharmaaccess/models/icpd_cme_plan_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/pages/icpd/add_my_plan_activities.dart';
import 'package:pharmaaccess/pages/icpd/create_my_icpd_traget.dart';
import 'package:pharmaaccess/pages/icpd/icpd_structure.dart';
import 'package:pharmaaccess/pages/icpd/plan_tracker.dart';
import 'package:pharmaaccess/pages/icpd/widget/CmeCatalogButton.dart';
import 'package:pharmaaccess/pages/icpd/widget/DonutPieChart.dart';
import 'package:pharmaaccess/services/icpd_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/widgets/icon_full_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MyPersonalDevelopmentPlanPage extends StatefulWidget {
  final int? planTypeIndex;

  const MyPersonalDevelopmentPlanPage({Key? key, this.planTypeIndex})
      : super(key: key);

  @override
  _MyPersonalDevelopmentPlanPageState createState() =>
      _MyPersonalDevelopmentPlanPageState();
}

class _MyPersonalDevelopmentPlanPageState
    extends State<MyPersonalDevelopmentPlanPage> {
  ScrollController _scrollControllerChart = new ScrollController();
  ScrollController _scrollControllerSimple = new ScrollController();
  IcpdService icpdService = IcpdService();

  // Widget futureWidget = Container();
  List<PlanList> alPlanListData = [];
  List<PlanList> alPlanList = [];
  PlanList planList = PlanList();
  List<ActivityListItem> alActivityListAll = [];
  List<ActivityListItem> alActivityDraftList = [];
  List<ActivityListItem> alActivityDoneList = [];
  late DBProvider dbProvider;
  ProfileModel? profileFuture;
  var countryName = "UAE";
  bool _loading = true;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnOkController =
      RoundedLoadingButtonController();
  bool isSuccessMsg = false;

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(ICPD_PERSONAL_DEVELOPMENT_PLAN_SCREEN,
        param: {"name": "iCPD My Personal Development Plan Screen"});
    _loading = true;
    dbProvider = DBProvider();
    _getProfileData();
    _getPlanListAPI();
    /*futureWidget = FutureBuilder<List<PlanList>?>(
        future: icpdService.getCMEPlanList(),
        builder: (context, snapshot) {
          dbProvider = DBProvider();
          _getProfileData();
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            for (PlanList planList in snapshot.data ?? []) {
              if (planList.name == "Personal Development") {
                */ /*FutureBuilder<List<ActivityListItem>?>(
                    future: icpdService.getMyActivityList(planList.id ?? 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return chartRow();
                      }
                      if (snapshot.connectionState == ConnectionState.done &&
                          !snapshot.hasData) {
                        return simpleButtonColumn();
                      }
                      return simpleButtonColumn();
                    });
              }*/ /*
                getActivityListAPI(planList.id);
                return chartRow(planList, snapshot.data);
              }
            }
            return simpleButtonColumn();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return simpleButtonColumn();
          }
          return Center(child: CircularProgressIndicator());
        });*/
  }

  void _getPlanListAPI() async {
    bool isLoading = false;
    alPlanListData = await icpdService.getCMEPlanList() ?? [];
    if (alPlanListData.isNotEmpty && alPlanListData.length > 0) {
      for (PlanList planListItem in alPlanListData) {
        if (planListItem.name == "Personal Development") {
          alPlanList = alPlanListData;
          planList = planListItem;
          await SharedPref.setString(
              "personalDevelopmentExpiryDate",
              planListItem.licenseExpiryDate ??
                  DateFormat("yyyy-MM-dd").format(DateTime.now()));
          isLoading = await getActivityListAPI(planListItem.id);
          //_planInAppNotification(planListItem);
        }
      }
    }
    if (!isLoading) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<bool> getActivityListAPI(int? planId) async {
    alActivityListAll = await icpdService.getMyActivityList(planId ?? 0) ?? [];
    /*for (ActivityListItem activityListItem in alActivityListAll) {
      if (activityListItem.planId != null &&
          activityListItem.planId?[0] == planId) {
        if (activityListItem.state == "draft") {
          alActivityDraftList.add(activityListItem);
        } else {
          alActivityDoneList.add(activityListItem);
        }
      }
    }*/
    alActivityDoneList = await icpdService.getMyActivityCompleteList() ?? [];
    setState(() {
      _loading = false;
    });
    return true;
  }

  void _getProfileData() async {
    profileFuture = await dbProvider.getProfile();
    countryName = profileFuture!.countryName;
  }

  /*void _planInAppNotification(PlanList planListItem) async {
    DateTime dateExpire = DateTime.parse(planListItem.licenseExpiryDate ??
        DateFormat("yyyy-MM-dd").format(DateTime.now()));

    var dateTimeExpired =
        DateTime(dateExpire.year, dateExpire.month, dateExpire.day, 0, 0, 0);
    final date2 = DateFormat("yyyy-MM-dd").format(DateTime.now());
    var difference = daysBetween(dateTimeExpired, DateTime.parse(date2));
    if (difference < 0) {
      difference = int.parse(difference.toString().replaceFirst("-", ""));
    }
    String day = "days";
    if (difference == 1) {
      day = "day";
    }
    if (difference < 0) {
      //Date are less than current
      _showSimpleInAppNotification(
          1,
          "Your Personal Development Plan was expired before $difference $day.",
          planListItem);
    } else if (difference > 0) {
      //Date are greater than current
      _showSimpleInAppNotification(
          2,
          "Your Personal Development Plan will be expired after $difference $day.",
          planListItem);
    } else if (difference == 0) {
      //Date same as current date
      _showSimpleInAppNotification(
          3, "Your Personal Development Plan was expired Today.", planListItem);
    }
  }

  _showSimpleInAppNotification(
      int id, String message, PlanList planListItem) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Hola Medico',
      "CHANNEL NAME",
      "channelDescription",
      icon: "mipmap/ic_launcher",
      enableLights: true,
      channelShowBadge: true,
      playSound: true,
      priority: Priority.high,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    var iOSPlatformChannelSpecifics;
    if (Platform.isIOS) {
      final bool? isLocalNotification = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      iOSPlatformChannelSpecifics = IOSNotificationDetails(
          sound: 'slow_spring_board.aiff',
          presentAlert: true,
          presentBadge: true,
          presentSound: true);
    }
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    DateTime currentDate =
        DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));

    var dateTimeAlert = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 10, 0, 0);

    await flutterLocalNotificationsPlugin.schedule(
      id,
      'Hola Medico',
      message,
      dateTimeAlert,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (from.difference(to).inHours / 24).round();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColor,
          title: Text(
            "My Personal Development",
          ),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            /* : alPlanList.length > 0 &&
                    (alActivityDraftList.length > 0 ||
                        alActivityDoneList.length > 0)*/
            : alPlanList.length > 0
                ? chartRow()
                : simpleButtonColumn()
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
                'You Have no Active ICPD Plans Created Yet, Start Creating Your Plan And Track Your Progress.\n\nSelect CPD Planner And Tracker to Start.',
                style: TextStyle(
                  color: Color(0xff525151),
                ),
                textAlign: TextAlign.center,
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.3,
              //   child: DonutChartWithText(),
              // ),
              SizedBox(
                height: 50.0,
              ),
              IconFullButton(
                label: "iCPD Catalog",
                iconPath: "assets/icon/catalog_icon.png",
                onPressed: () {},
              ),
              IcpdSpacer(),
              IconFullButton(
                label: "Add CPD Activities",
                iconPath: "assets/icon/add_icon.png",
                onPressed: () {},
              ),
              IcpdSpacer(),
            ],
          ),
        ),
      ),*/
        );
  }

  Widget chartRow() {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollControllerChart,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "Hello Dr. ${profileFuture!.name}, Your iCPD plan progress today is",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 8,
                          child: DonutPieChart.withSampleData(
                              isMediAct: true,
                              targetPoint: alActivityListAll.length > 0
                                  ? alActivityListAll.length.toString()
                                  : "0",
                              currentPoint: alActivityDoneList.length > 0
                                  ? alActivityDoneList.length.toString()
                                  : "0"),
                        ),
                        Text(
                          "${alActivityDoneList.length} Activities Out of ${alActivityListAll.length} Completed",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  CmeCatalog(
                    titleName: "iCPD Catalog",
                    planTypeItem: alPlanList,
                    countryName: countryName,
                    planTypeIndex: widget.planTypeIndex,
                  ),
                  /*IconFullButton(
                    label: "iCPD Catalog",
                    iconPath: "assets/icon/catalog_icon.png",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => CmeCatalogPage(
                            titleName: "iCPD Catalog",
                            planTypeItem: alPlanList,
                            countryName: countryName,
                            planTypeIndex: widget.planTypeIndex,
                          ),
                        ),
                      );
                    },
                  ),*/
                  IcpdSpacer(),
                  IconFullButton(
                    label: "Add CPD Activities",
                    iconPath: "assets/icon/add_icon.png",
                    onPressed: () async {
                      await firebaseAnalyticsEventCall(
                          ICPD_PERSONAL_DEVELOPMENT_PLAN_SCREEN,
                          param: {"name": "Add CPD Activities"});
                      var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddMyPlanActivities(
                            titleName: "Add CPD Activities",
                            planTypeIndex: widget.planTypeIndex,
                            planId: planList.id ?? 0,
                            activityListItem: null,
                            planProcessingClass: "ac",
                          ),
                        ),
                      );
                      if (result ?? false) {
                        setState(() {
                          _loading = true;
                          alPlanList = [];
                          alActivityListAll = [];
                          alActivityDraftList = [];
                          alActivityDoneList = [];
                          _getPlanListAPI();
                        });
                      }
                    },
                  ),
                  IcpdSpacer(),
                  IconFullButton(
                    label: "Activity Tracker",
                    iconPath: "assets/icon/tracker_icon.png",
                    onPressed: () async {
                      await firebaseAnalyticsEventCall(
                          ICPD_PERSONAL_DEVELOPMENT_PLAN_SCREEN,
                          param: {"name": "Activity Tracker"});
                      var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => PlanTracker(
                            planTypeIndex: widget.planTypeIndex,
                            titleName: "Activity Tracker",
                            planList: planList,
                            countryName: countryName,
                          ),
                        ),
                      );
                      if (result ?? false) {
                        setState(() {
                          _loading = true;
                          alPlanList = [];
                          alActivityListAll = [];
                          alActivityDraftList = [];
                          alActivityDoneList = [];
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
        ),
      ],
    );
  }

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
                            text: ' \"Activity Tracker\"',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  /*Text(
                    'You Have no Active ICPD Plans Created Yet, Start Creating Your Plan And Track Your Progress.\n\nSelect CPD Planner And Tracker to Start.',
                    style: TextStyle(
                      color: Color(0xff525151),
                    ),
                    textAlign: TextAlign.center,
                  ),*/
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.3,
                  //   child: DonutChartWithText(),
                  // ),
                  SizedBox(
                    height: 50.0,
                  ),
                  CmeCatalog(
                    titleName: "iCPD Catalog",
                    planTypeItem: alPlanListData,
                    countryName: countryName,
                    planTypeIndex: widget.planTypeIndex,
                  ),
                  /*IconFullButton(
                    label: "iCPD Catalog",
                    iconPath: "assets/icon/catalog_icon.png",
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => CmeCatalogPage(
                            titleName: "iCPD Catalog",
                            planTypeItem: alPlanListData,
                            countryName: countryName,
                            planTypeIndex: widget.planTypeIndex,
                          ),
                        ),
                      );
                    },
                  ),*/
                  IcpdSpacer(),
                  IconFullButton(
                    label: "Add CPD Activities",
                    iconPath: "assets/icon/add_icon.png",
                    onPressed: () async {
                      await firebaseAnalyticsEventCall(
                          ICPD_PERSONAL_DEVELOPMENT_PLAN_SCREEN,
                          param: {"name": "Add CPD Activities"});
                      if (planList.id != null) {
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddMyPlanActivities(
                              titleName: "Add CPD Activities",
                              planTypeIndex: widget.planTypeIndex,
                              planId: planList.id ?? 0,
                              activityListItem: null,
                              planProcessingClass: "ac",
                            ),
                          ),
                        );
                        if (result ?? false) {
                          setState(() {
                            _loading = true;
                            alPlanList = [];
                            alActivityListAll = [];
                            alActivityDraftList = [];
                            alActivityDoneList = [];
                            _getPlanListAPI();
                          });
                        }
                      } else {
                        // showSnackBar(context,
                        //     "You have no plan, Please Select CPD Planner And Tracker to Start.");
                        isSuccessMsg = false;
                        showDialogSuccess(
                            "You have no active iCPD plan created as yet, Please start creating your plan and tracking progress by selecting");
                      }
                    },
                  ),
                  IcpdSpacer(),
                  IconFullButton(
                    label: "Activity Tracker",
                    iconPath: "assets/icon/tracker_icon.png",
                    onPressed: () async {
                      await firebaseAnalyticsEventCall(
                          ICPD_PERSONAL_DEVELOPMENT_PLAN_SCREEN,
                          param: {"name": "Activity Tracker"});
                      var result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => CreateMyIcpdTarget(
                            planId: 0,
                            selectPlanIndex: 0,
                            planName: "Personal Development",
                            planType: "ac",
                            countryName: countryName,
                          ),
                        ),
                      );
                      if (result ?? false) {
                        setState(() {
                          _loading = true;
                          alPlanList = [];
                          alActivityListAll = [];
                          alActivityDraftList = [];
                          alActivityDoneList = [];
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

  void showDialogSuccess(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: Text.rich(
                  TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style:
                        TextStyle(color: Color(0xff525151), wordSpacing: 1.0),
                    children: <TextSpan>[
                      TextSpan(text: message),
                      TextSpan(
                          text: ' \"Activity Tracker\"',
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RoundedLoadingButton(
                borderRadius: 6,
                height: 40,
                width: MediaQuery.of(context).size.width / 4,
                onPressed: _submitRequest,
                color: primaryColor,
                animateOnTap: true,
                controller: _btnOkController,
                child: Text(
                  "OK",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .apply(
                        color: Colors.white,
                      )
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRequest() async {
    if (isSuccessMsg) {
      Navigator.of(context).pop();
      Navigator.pop(context, true);
    } else {
      Navigator.of(context).pop();
    }
  }
}
