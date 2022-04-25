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

class MyFutureEducationPage extends StatefulWidget {
  final int? planTypeIndex;

  const MyFutureEducationPage({Key? key, this.planTypeIndex}) : super(key: key);

  @override
  _MyFutureEducationPageState createState() => _MyFutureEducationPageState();
}

class _MyFutureEducationPageState extends State<MyFutureEducationPage> {
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
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnOkController =
      RoundedLoadingButtonController();
  bool isSuccessMsg = false;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(ICPD_FURTHER_MEDICAL_EDUCATION_PLAN_SCREEN,
        param: {"name": "iCPD My Further Medical Education Plan Screen"});
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
              if (planList.name == "General Media Education") {
                //Call that on the chartRow Function
                */ /*FutureBuilder<List<ActivityListItem>?>(
                    future: icpdService.getMyActivityList(planList.id ?? 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return chartRow(planList);
                      }
                      if (snapshot.connectionState == ConnectionState.done &&
                          !snapshot.hasData) {
                        return simpleButtonColumn();
                      }
                      return Center(child: CircularProgressIndicator());
                    });*/ /*
                return chartRow(planList, snapshot.data);
              }
            }
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
        if (planListItem.name == "General Media Education") {
          alPlanList = alPlanListData;
          planList = planListItem;
          await SharedPref.setString(
              "furtherMedicalEduExpiryDate",
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

    var dateTimeExpire =
        DateTime(dateExpire.year, dateExpire.month, dateExpire.day, 0, 0, 0);
    final date2 = DateFormat("yyyy-MM-dd").format(DateTime.now());
    var difference = daysBetween(dateTimeExpire, DateTime.parse(date2));
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
          "Your Further Medical Education Plan was expired before $difference $day.",
          planListItem);
    } else if (difference > 0) {
      //Date are greater than current
      _showSimpleInAppNotification(
          2,
          "Your Further Medical Education Plan will be expired after $difference $day.",
          planListItem);
    } else if (difference == 0) {
      //Date same as current date
      _showSimpleInAppNotification(
          3,
          "Your Further Medical Education Plan was expired Today.",
          planListItem);
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
          "My Further Medical Education",
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          /*: alPlanList.length > 0 &&
                  (alActivityDraftList.length > 0 ||
                      alActivityDoneList.length > 0)*/
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
                'You Have General CME Activities Added.\n\nStart Exploring Our CME Catelog Or Add Activities by Clicking on Relevant Button Below.',
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
              CmeCatalog(),
              IcpdSpacer(),
              IconFullButton(
                label: "Add General CME Activities",
                iconPath: "assets/icon/add_icon.png",
                onPressed: () {},
              ),
              IcpdSpacer(),
              IconFullButton(
                label: "Activity Tracker",
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
                                : "0",
                          ),
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
                  CmeCatalog(
                    titleName: "CME Catalog",
                    planTypeItem: alPlanList,
                    countryName: countryName,
                    planTypeIndex: widget.planTypeIndex,
                  ),
                  IcpdSpacer(),
                  IconFullButton(
                    label: "Add General CME Activities",
                    iconPath: "assets/icon/add_icon.png",
                    onPressed: () async {
                      await firebaseAnalyticsEventCall(
                          ICPD_FURTHER_MEDICAL_EDUCATION_PLAN_SCREEN,
                          param: {"name": "Add General CME Activities"});
                      if (planList.id != null) {
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddMyPlanActivities(
                              titleName: "Add General CME Activities",
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
                          ICPD_FURTHER_MEDICAL_EDUCATION_PLAN_SCREEN,
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
                    'You Have General CME Activities Added.\n\nStart Exploring Our CME Catelog Or Add Activities by Clicking on Relevant Button Below.',
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
                  /*CmeCatalog(
                    planTypeIndex: widget.planTypeIndex,
                  ),*/
                  CmeCatalog(
                    titleName: "CME Catalog",
                    planTypeItem: alPlanListData,
                    countryName: countryName,
                    planTypeIndex: widget.planTypeIndex,
                  ),
                  IcpdSpacer(),
                  IconFullButton(
                    label: "Add General CME Activities",
                    iconPath: "assets/icon/add_icon.png",
                    onPressed: () async {
                      await firebaseAnalyticsEventCall(
                          ICPD_FURTHER_MEDICAL_EDUCATION_PLAN_SCREEN,
                          param: {"name": "Add General CME Activities"});
                      if (planList.id != null) {
                        var result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddMyPlanActivities(
                              titleName: "Add General CME Activities",
                              planTypeIndex: widget.planTypeIndex,
                              planId: planList.id ?? 0,
                              activityListItem: ActivityListItem(),
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
                          ICPD_FURTHER_MEDICAL_EDUCATION_PLAN_SCREEN,
                          param: {"name": "Activity Tracker"});
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
                            selectPlanIndex: widget.planTypeIndex ?? 0,
                            planName: "General Media Education",
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
