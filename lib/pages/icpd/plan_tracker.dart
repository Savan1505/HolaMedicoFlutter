import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/icpd_activity_attachment_model.dart';
import 'package:pharmaaccess/models/icpd_activity_resp_model.dart';
import 'package:pharmaaccess/models/icpd_cme_plan_model.dart';
import 'package:pharmaaccess/pages/icpd/widget/AnimatedToggleWidget.dart';
import 'package:pharmaaccess/pages/icpd/add_my_plan_activities.dart';
import 'package:pharmaaccess/pages/icpd/create_my_icpd_traget.dart';
import 'package:pharmaaccess/pages/icpd/widget/BarChart.dart';
import 'package:pharmaaccess/pages/icpd/widget/DonutPieChart.dart';
import 'package:pharmaaccess/pages/icpd/widget/EventListCalendarWidget.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/services/icpd_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/widgets/date_picker.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class PlanTracker extends StatefulWidget {
  final int? planTypeIndex;
  final String titleName;
  final PlanList planList;
  final String countryName;

  const PlanTracker(
      {Key? key,
      this.planTypeIndex = 0,
      this.titleName = "Plan Tracker",
      required this.planList,
      this.countryName = "UAE"})
      : super(key: key);

  @override
  _PlanTrackerState createState() => _PlanTrackerState();
}

class _PlanTrackerState extends State<PlanTracker> {
  ScrollController _scrollController = new ScrollController();
  TextEditingController dateTextEditingController = TextEditingController();
  RoundedLoadingButtonController _btnDownloadNoController =
      RoundedLoadingButtonController();
  RoundedLoadingButtonController _btnDownloadYesController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnFolderOkController =
      RoundedLoadingButtonController();
  DateTime selectedDate = DateTime.now();
  IcpdService icpdService = IcpdService();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  PlanList planListItem = PlanList();
  List<ActivityListItem> alActivityList = [];
  List<ActivityListItem> alActivityDoneList = [];
  List<ActivityListItem> alActivityListSelectedDate = [];
  List<ActivityListItem> alActivityListAllDate = [];
  var dateTimeStart;
  var dateFormat = new DateFormat('yyyy-MM-dd');
  var dateFormatSelectDisplay = new DateFormat('yyyy/MM/dd');
  var dateFormatDisplay = new DateFormat('dd MMM, yyyy hh:mm');
  var dateFormatTime = new DateFormat('hh:mm a');
  var currentDate;
  bool _loading = true;
  int _switchCalendar = 0;
  List<EventAttachment> alAttachmentItemList = [];
  File file = File("");
  late ProgressDialog pd;
  MyScreenUtil? myScreenUtil;

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(ICPD_PLAN_TRACKER,
        param: {"name": "iCPD Plan Tracker Screen"});
    currentDate = dateFormat.format(DateTime.now());
    _loading = true;
    _switchCalendar = 0;
    alActivityList = [];
    alActivityDoneList = [];
    alActivityListSelectedDate = [];
    alActivityListAllDate = [];
    planListItem = widget.planList;
    _getActivityListAPI();
    pd = ProgressDialog(context: context);
  }

  Future<void> getPlanListAPI() async {
    List<PlanList> alPlanList = await icpdService.getCMEPlanList() ?? [];
    if (alPlanList.isNotEmpty && alPlanList.length > 0) {
      for (PlanList planList in alPlanList) {
        if (planList.name == planListItem.name) {
          planListItem = planList;
          // _planInAppNotification(planList);
        }
      }
    }
    // alActivityList = [];
    // alActivityDoneList = [];
    // alActivityListSelectedDate = [];
    // alActivityListAllDate = [];
    // _getActivityListAPI();
  }

  void _getActivityListAPI() async {
    getPlanListAPI();
    alActivityList =
        await icpdService.getMyActivityList(planListItem.id ?? 0) ?? [];
    alActivityDoneList = await icpdService.getMyActivityCompleteList() ?? [];
    _getActivityList();
  }

  void _getActivityList() async {
    currentDate = dateFormat.format(_focusedDay);
    dateTextEditingController.text = planListItem.licenseExpiryDate ?? "";
    for (ActivityListItem activityListItem in alActivityList) {
      dateTimeStart = DateTime.parse(activityListItem.start ?? "");
      var startDate = dateFormat.format(dateTimeStart);
      if (currentDate == startDate &&
          activityListItem.planId != null &&
          activityListItem.planId!.isNotEmpty &&
          activityListItem.planId![0] == planListItem.id) {
        alActivityListSelectedDate.add(activityListItem);
      }
    }
    _getActivityListAllDate();
  }

  void _getActivityListAllDate() async {
    for (ActivityListItem activityListItem in alActivityList) {
      /*if (activityListItem.planId != null &&
          activityListItem.planId!.isNotEmpty &&
          activityListItem.planId![0] == planListItem.id) {
        alActivityListAllDate.add(activityListItem);
      }*/
      alActivityListAllDate.add(activityListItem);
    }
    setState(() {
      _loading = false;
    });
  }

  /*void _planInAppNotification(PlanList planList) async {
    int targetPoints = planList.targetPoints ?? 0;
    int currentPoints = planList.currentPoints ?? 0;
    int remainingPoints = targetPoints - currentPoints;
    DateTime dateExpire = DateTime.parse(planList.licenseExpiryDate ??
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
    if (difference == 0 &&
        remainingPoints < 10 &&
        planList.planProcessingClass == "td") {
      //Date same as current date and remaining point less than 10
      _showSimpleInAppNotification(
          1,
          "Your ${planList.name == "General Media Education" ? "Further Medical Education" : planList.name} Plan was expired Today and Your remaining point is $remainingPoints.",
          planList);
    } else if (difference < 0 &&
        remainingPoints < 10 &&
        planList.planProcessingClass == "td") {
      //Date are less than current and remaining point less than 10
      _showSimpleInAppNotification(
          2,
          "Your ${planList.name == "General Media Education" ? "Further Medical Education" : planList.name} Plan was expired before $difference $day and Your remaining point is $remainingPoints.",
          planList);
    } else if (difference > 0 &&
        remainingPoints < 10 &&
        planList.planProcessingClass == "td") {
      //Date are greater than current and remaining point less than 10
      _showSimpleInAppNotification(
          3,
          "Your  ${planList.name == "General Media Education" ? "Further Medical Education" : planList.name} Plan will be expired after $difference $day and Your remaining point is $remainingPoints.",
          planList);
    } else if (difference < 0) {
      //Date are less than current
      _showSimpleInAppNotification(
          4,
          "Your  ${planList.name == "General Media Education" ? "Further Medical Education" : planList.name} Plan was expired before $difference $day.",
          planList);
    } else if (difference > 0) {
      //Date are greater than current
      _showSimpleInAppNotification(
          5,
          "Your  ${planList.name == "General Media Education" ? "Further Medical Education" : planList.name} Plan will be expired after $difference $day.",
          planList);
    } else if (difference == 0) {
      //Date same as current date
      _showSimpleInAppNotification(
          6,
          "Your  ${planList.name == "General Media Education" ? "Further Medical Education" : planList.name} Plan was expired Today.",
          planList);
    } else if (remainingPoints < 10 && planList.planProcessingClass == "td") {
      //Remaining point less than 10
      _showSimpleInAppNotification(
          7,
          "Your  ${planList.name == "General Media Education" ? "Further Medical Education" : planList.name} Plan remaining points is $remainingPoints.",
          planList);
    }
  }

  _showSimpleInAppNotification(
      int id, String message, PlanList planList) async {
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
    myScreenUtil = getScreenUtilInstance(context);
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.titleName),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          IconButton(
            iconSize: 32,
            color: Colors.white,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Plan',
            onPressed: () async {
              await firebaseAnalyticsEventCall(ICPD_PLAN_TRACKER,
                  param: {"name": "Edit ${planListItem.name} Plan"});
              var result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => CreateMyIcpdTarget(
                    planId: planListItem.id,
                    planName: planListItem.name ?? "License Renewal CME",
                    planType: planListItem.planProcessingClass ?? "td",
                    countryName: widget.countryName,
                    planListItem: planListItem,
                  ),
                ),
              );
              if (result ?? false) {
                setState(() {
                  _switchCalendar = 0;
                  _loading = true;
                });
                alActivityList = [];
                alActivityDoneList = [];
                alActivityListSelectedDate = [];
                alActivityListAllDate = [];
                _getActivityListAPI();
                // await getPlanListAPI();

              }
            },
          ),
          Visibility(
            visible: alActivityList.isNotEmpty && alActivityList.length > 0,
            child: IconButton(
              iconSize: 32,
              color: Colors.white,
              icon: const Icon(Icons.download),
              tooltip: 'Download Attachment Certificate',
              onPressed: () async {
                alAttachmentItemList = [];
                if (await PermissionUtil.getStoragePermission(
                  context: context,
                  screenUtil: myScreenUtil,
                )) {
                  _showAttachmentDownloadDialog();
                }
              },
            ),
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _getBodyPlanTracker(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => AddMyPlanActivities(
                planTypeIndex: widget.planTypeIndex,
                planId: planListItem.id ?? 0,
                activityListItem: null,
                planProcessingClass: planListItem.planProcessingClass ?? "td",
              ),
            ),
          );
          if (result ?? false) {
            setState(() {
              _switchCalendar = 0;
              _loading = true;
            });
            alActivityList = [];
            alActivityDoneList = [];
            alActivityListSelectedDate = [];
            alActivityListAllDate = [];
            _getActivityListAPI();
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget eventItem(ActivityListItem activityItem) => InkWell(
        onTap: () async {
          var result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => AddMyPlanActivities(
                planId: planListItem.id ?? 0,
                activityListItem: activityItem,
                isEditActivity: true,
                planProcessingClass: planListItem.planProcessingClass ?? "td",
              ),
            ),
          );
          if (result ?? false) {
            setState(() {
              _switchCalendar = 0;
              _loading = true;
            });
            alActivityList = [];
            alActivityDoneList = [];
            alActivityListSelectedDate = [];
            alActivityListAllDate = [];
            _getActivityListAPI();
          }
        },
        /*child: activityItem.planId?[0] == planListItem.id
            ? Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 72.0,
                        width: 72.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFAFAFA),
                          border: Border.all(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            dateFormatTime
                                .format(
                                    DateTime.parse(activityItem.start ?? ""))
                                .toUpperCase(),
                            style: TextStyle(
                              color: Color(0xffD3D2D2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 65.0,
                        width: 1.5,
                        color: Color(0xffD3D2D2),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activityItem.name ?? "",
                            style: TextStyle(
                                color: Color(0xff686767),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            dateFormatDisplay
                                    .format(DateTime.parse(
                                        activityItem.start ?? ""))
                                    .toUpperCase() +
                                " Hr",
                            style: TextStyle(
                                color: Color(0xff686767), fontSize: 14),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            activityItem.eventCategoryId?[1] ?? "",
                            style: TextStyle(
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              )
            : Container(),*/
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 72.0,
                  width: 72.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffFAFAFA),
                    border: Border.all(
                      color: activityItem.state == "draft"
                          ? Colors.orange
                          : primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      dateFormatTime
                          .format(DateTime.parse(activityItem.start ?? ""))
                          .toUpperCase(),
                      style: TextStyle(
                        color: Color(0xffD3D2D2),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  height: 65.0,
                  width: 1.5,
                  color: Color(0xffD3D2D2),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activityItem.name ?? "-NA-",
                        style: TextStyle(
                            color: Color(0xff686767),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        dateFormatDisplay
                                .format(
                                    DateTime.parse(activityItem.start ?? ""))
                                .toUpperCase() +
                            " Hr",
                        style:
                            TextStyle(color: Color(0xff686767), fontSize: 14),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        activityItem.eventCategoryId?[1] ?? "-NA-",
                        style: TextStyle(
                          color: activityItem.state == "draft"
                              ? Colors.orange
                              : primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      );

  Widget chart() => Column(
        children: [
          Text(
            planListItem.name != "License Renewal CME"
                ? "My Activity Summary"
                : "My Plan Summary",
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff525151),
            ),
          ),
          Visibility(
            visible: planListItem.name == "License Renewal CME",
            child: Flexible(
              child: GroupedBarChart.withSampleData(
                planList: planListItem,
              ),
            ),
          ),
          Visibility(
            visible: planListItem.name != "License Renewal CME",
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                children: [
                  Flexible(
                    flex: 8,
                    child: DonutPieChart.withSampleData(
                      isMediAct: true,
                      targetPoint: alActivityList.length > 0
                          ? alActivityList.length.toString()
                          : "0",
                      currentPoint: alActivityDoneList.length > 0
                          ? alActivityDoneList.length.toString()
                          : "0",
                    ),
                  ),
                  Text(
                    "${alActivityDoneList.length} Activities Out of ${alActivityList.length} Completed",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ), /*Flexible(
              child: GroupedBarChartActivity.withSampleData(
                currentDate: currentDate,
                alActivityList: alActivityList,
              ),
            ),*/
          ),
          Visibility(
            visible: planListItem.name == "License Renewal CME",
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          ),
        ],
      );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await datePicker(context, selectedDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateTextEditingController.text =
            dateFormatSelectDisplay.format(selectedDate);
        _selectedDay = selectedDate;
        _focusedDay = selectedDate;
        alActivityListSelectedDate = [];
        _getActivityList();
      });
  }

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

  Widget _getBodyPlanTracker() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                /*if (planListItem.name != "License Renewal CME") {
                  _selectDate(context);
                }*/
              },
              child: AbsorbPointer(
                child: FormFieldWidget(
                  controller: dateTextEditingController,
                  hintText: 'My License Renewal Date',
                  readonly:
                      planListItem.name != "License Renewal CME" ? false : true,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/gray_calender_icon.png',
                        height: 22,
                        width: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: planListItem.name != "License Renewal CME"
                        ? MediaQuery.of(context).size.height * 0.22
                        : MediaQuery.of(context).size.height * 0.27,
                    child: chart(),
                  ),
                ],
              ),
            ),
            /*Visibility(
              visible: planListItem.name == "License Renewal CME" ||
                  alActivityListSelectedDate.length > 0,
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: planListItem.name != "License Renewal CME"
                          ? MediaQuery.of(context).size.height * 0.22
                          : MediaQuery.of(context).size.height * 0.27,
                      child: chart(),
                    ),
                  ],
                ),
              ),
            ),*/
            /*SizedBox(
              height: 20,
            ),*/
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedToggle(
                    values: ['Tabular View', 'Calendar View '],
                    onToggleCallback: (value) {
                      setState(() {
                        alActivityListAllDate = [];
                        _getActivityListAllDate();
                        _switchCalendar = value;
                      });
                    },
                    buttonColor: primaryColor,
                    backgroundColor: const Color(0xFFB7C291),
                    textColor: const Color(0xFFFFFFFF),
                  ),
                ],
              ),
            ),
            _switchCalendar != 0
                ? Container(
                    child: SfCalendar(
                      view: CalendarView.month,
                      showNavigationArrow: true,
                      showDatePickerButton: true,
                      viewNavigationMode: ViewNavigationMode.snap,
                      todayHighlightColor: primaryColor.withOpacity(0.5),
                      onTap: (CalendarTapDetails details) {
                        dynamic appointments = details.appointments;
                        _showDialogActivityList(appointments);
                      },
                      dataSource:
                          EventListCalendarWidget(alActivityListAllDate),
                      // by default the month appointment display mode set as Indicator, we can
                      // change the display mode as appointment using the appointment display
                      // mode property
                      monthViewSettings: const MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.indicator,
                      ),
                    ),
                  )
                : /*TableCalendar(
                    availableCalendarFormats: {
                      CalendarFormat.week: 'Week',
                    },
                    headerStyle: HeaderStyle(
                      headerPadding: EdgeInsets.symmetric(vertical: 15.0),
                      leftChevronPadding: const EdgeInsets.all(0.0),
                      rightChevronPadding: const EdgeInsets.all(0.0),
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          dateTextEditingController.text =
                              dateFormatSelectDisplay
                                  .format(_selectedDay ?? DateTime.now());
                          alActivityListSelectedDate = [];
                          _getActivityList();
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  )*/
                Container(),
            /*SizedBox(
              height: 10,
            ),*/
            /*eventItem(),
              SizedBox(
                height: 30,
              ),
              eventItem(),*/
            _switchCalendar != 0
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    padding: EdgeInsets.only(bottom: 30),
                    child: alActivityList.length > 0
                        ? ListView.builder(
                            shrinkWrap: false,
                            scrollDirection: Axis.vertical,
                            itemCount: alActivityList.length,
                            itemBuilder: (context, index) {
                              return eventItem(alActivityList[index]);
                            },
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No Activity!",
                              style: TextStyle(
                                color: Color(0xffD3D2D2),
                              ),
                            ),
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget activityCalenderItem(ActivityListItem activityItem) => InkWell(
        onTap: () async {
          Navigator.of(context).pop();
          var result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => AddMyPlanActivities(
                planId: planListItem.id ?? 0,
                activityListItem: activityItem,
                isEditActivity: true,
                planProcessingClass: planListItem.planProcessingClass ?? "td",
              ),
            ),
          );
          if (result ?? false) {
            setState(() {
              _switchCalendar = 0;
              _loading = true;
            });
            alActivityList = [];
            alActivityDoneList = [];
            alActivityListSelectedDate = [];
            alActivityListAllDate = [];
            _getActivityListAPI();
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 62.0,
                  width: 62.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffFAFAFA),
                    border: Border.all(
                      color: activityItem.state == "draft"
                          ? Colors.orange
                          : primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      dateFormatTime
                          .format(DateTime.parse(activityItem.start ?? ""))
                          .toUpperCase(),
                      style: TextStyle(
                        color: Color(0xffD3D2D2),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  height: 40.0,
                  width: 1.5,
                  color: Color(0xffD3D2D2),
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activityItem.name ?? "-NA-",
                        style: TextStyle(
                            color: Color(0xff686767),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                        dateFormatDisplay
                                .format(
                                    DateTime.parse(activityItem.start ?? ""))
                                .toUpperCase() +
                            " Hr",
                        style:
                            TextStyle(color: Color(0xff686767), fontSize: 12),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        activityItem.eventCategoryId?[1] ?? "-NA-",
                        style: TextStyle(
                            color: activityItem.state == "draft"
                                ? Colors.orange
                                : primaryColor,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ), /*activityItem.planId?[0] == planListItem.id
            ? Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 62.0,
                        width: 62.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFAFAFA),
                          border: Border.all(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            dateFormatTime
                                .format(
                                    DateTime.parse(activityItem.start ?? ""))
                                .toUpperCase(),
                            style: TextStyle(
                              color: Color(0xffD3D2D2),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 40.0,
                        width: 1.5,
                        color: Color(0xffD3D2D2),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activityItem.name ?? "",
                            style: TextStyle(
                                color: Color(0xff686767),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Text(
                            dateFormatDisplay
                                    .format(DateTime.parse(
                                        activityItem.start ?? ""))
                                    .toUpperCase() +
                                " Hr",
                            style: TextStyle(
                                color: Color(0xff686767), fontSize: 12),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            activityItem.eventCategoryId?[1] ?? "",
                            style: TextStyle(color: primaryColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              )
            : Container(),*/
      );

  _showDialogActivityList(List<dynamic> alActivityList) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.all(10.0),
            content: Container(
              margin: EdgeInsets.only(left: 0.0, right: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 13.0, right: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: 500,
                            padding: EdgeInsets.all(10.0),
                            child: alActivityList.length > 0
                                ? ListView.builder(
                                    shrinkWrap: false,
                                    scrollDirection: Axis.vertical,
                                    itemCount: alActivityList.length,
                                    itemBuilder: (context, index) {
                                      return activityCalenderItem(
                                          alActivityList[index]);
                                    },
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No Activity!",
                                      style: TextStyle(
                                        color: Color(0xffD3D2D2),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      )),
                  Positioned(
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showAttachmentDownloadDialog() {
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
                child: Text(
                  "Do you want to download all the attachment certificate?",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 4,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: mutedTextColor,
                      animateOnTap: true,
                      controller: _btnDownloadNoController,
                      child: Text(
                        "No",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .apply(
                              color: Colors.white,
                            )
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 4,
                      onPressed: submitRequest,
                      color: primaryColor,
                      animateOnTap: true,
                      controller: _btnDownloadYesController,
                      child: Text(
                        "Yes",
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAllEventAttachment(ActivityListItem activityListItem) async {
    List<EventAttachment> alAttachmentItemLst = await icpdService
            .getCMEEventAttachmentCertificateList(activityListItem.id ?? 0) ??
        [];
    if (alAttachmentItemLst.length > 0) {
      for (EventAttachment eventAttachment in alAttachmentItemLst) {
        if (eventAttachment.eventAttachmentId != null) {
          alAttachmentItemList.add(eventAttachment);
          await downloadAttachmentCertificate(activityListItem.id ?? 0,
              eventAttachment.eventAttachmentId ?? "");
        }
      }
    }
  }

  Future<void> downloadAttachmentCertificate(
      int activityId, String attachmentCertificate) async {
    if (alAttachmentItemList.isNotEmpty && alAttachmentItemList.length > 0) {
      final directory = Directory("storage/emulated/0/hola medico");
      directory.create(recursive: true);
      if ((await directory.exists())) {
        // TODO:
        print("exist");
      } else {
        // TODO:
        print("not exist");
        directory.create();
      }
      String path = directory.path;
      print(path);
      file = File("/$path/" + "Attach_Activity_$activityId" + ".png");
      await file.create(recursive: true);
      Uint8List decoded =
          base64Decode(attachmentCertificate.toString().replaceAll("\n", ""));
      await file.writeAsBytes(decoded);
    }
  }

  void _showDownloadDirDialog(String message) {
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
                child: Text(
                  message,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 4,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: primaryColor,
                      animateOnTap: true,
                      controller: _btnFolderOkController,
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
            ],
          ),
        ),
      ),
    );
  }

  void submitRequest() async {
    Navigator.pop(context);
    pd.show(
        max: alActivityList.length,
        msg: 'Preparing Download...',
        progressType: ProgressType.valuable,
        backgroundColor: Colors.white,
        progressValueColor: primaryColor,
        progressBgColor: Color(0x1097BF0D),
        msgColor: primaryColor,
        valueColor: primaryColor);
    for (int i = 0; i <= alActivityList.length; i++) {
      pd.update(value: i, msg: 'Downloading...');
      if (i != alActivityList.length) {
        await getAllEventAttachment(alActivityList[i]);
      }
    }
    pd.close();
    if (!pd.isOpen()) {
      if (file.path.isNotEmpty && file.absolute.path.isNotEmpty) {
        _showDownloadDirDialog(
            "Certificates attached to this plan have been saved to\n${file.parent}");
      } else {
        _showDownloadDirDialog("No Certificates attached to this plan!");
      }
    }
  }
}
