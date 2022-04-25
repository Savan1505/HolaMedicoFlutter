import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:pharmaaccess/SharedPref.dart';
import 'package:pharmaaccess/apis/auth_provider.dart';
import 'package:pharmaaccess/models/ActivityExpItem.dart';
import 'package:pharmaaccess/models/MembershipListItem.dart';
import 'package:pharmaaccess/routes.dart';
import 'package:pharmaaccess/services/auth_service.dart';

import 'application.dart';
import 'config/config.dart';

final AuthService authService = AuthService();
final AuthProvider apiProvider = AuthProvider();
final Function? originalOnError = FlutterError.onError;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  // await FlutterBackgroundService.initialize(onStart, foreground: false);
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  // await Prefs.init();
  await _pushNotification();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  // await CrashlyticsConfig.setCrashlyticsData();
  /*FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    originalOnError!(errorDetails);
  };*/
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  var isRegistered = await authService.isRegistered();
  var isActivated = await authService.isActivated();
  Config.isActivated = isActivated!;
  // _callBackgroundService(service);
  _getMembershipListAPI(isRegistered);
}

Future<List<ClubsListItem>> _getMembershipListAPI(bool isRegistered) async {
  try {
    var response = await apiProvider.client.callControllerBackSlash(
      "/app/v4/partner/club/membership",
      {},
    );
    if (response.hasError()) {
      var result = response.getData();
      if (result == null) {
        Config.isCinfaClub = false;
        runZonedGuarded<Future<void>>(() async {
          runApp(
            Application(
              initialRoute: isRegistered == true ? '/' : '/login',
              //initialRoute: '/icpd',
              authService: authService,
              // routes: isActivated == true ? registeredRoutes : guestRoutes,
              routes: guestRoutes,
            ),
          );
        },
            (error, stack) =>
                FirebaseCrashlytics.instance.recordError(error, stack));
        return [];
        // throwErrorICPD(response);
      }
      var clubsListItemRes = result['clubs'].map<ClubsListItem>((json) {
        return ClubsListItem.fromJson(json);
      }).toList();

      if (clubsListItemRes != null && clubsListItemRes.isNotEmpty) {
        Config.isCinfaClub = true;
        runZonedGuarded<Future<void>>(() async {
          runApp(
            Application(
              initialRoute: isRegistered == true ? '/' : '/login',
              //initialRoute: '/icpd',
              authService: authService,
              // routes: isActivated == true ? registeredRoutes : guestRoutes,
              routes: registeredRoutes,
            ),
          );
        },
            (error, stack) =>
                FirebaseCrashlytics.instance.recordError(error, stack));
        return clubsListItemRes;
      } else {
        Config.isCinfaClub = false;
        runZonedGuarded<Future<void>>(() async {
          runApp(
            Application(
              initialRoute: isRegistered == true ? '/' : '/login',
              //initialRoute: '/icpd',
              authService: authService,
              // routes: isActivated == true ? registeredRoutes : guestRoutes,
              routes: guestRoutes,
            ),
          );
        },
            (error, stack) =>
                FirebaseCrashlytics.instance.recordError(error, stack));
        return [];
      }
    } else {
      Config.isCinfaClub = false;
      runZonedGuarded<Future<void>>(() async {
        runApp(
          Application(
            initialRoute: isRegistered == true ? '/' : '/login',
            //initialRoute: '/icpd',
            authService: authService,
            // routes: isActivated == true ? registeredRoutes : guestRoutes,
            routes: guestRoutes,
          ),
        );
      },
          (error, stack) =>
              FirebaseCrashlytics.instance.recordError(error, stack));
      return [];
    }
  } catch (e) {
    Config.isCinfaClub = false;
    runZonedGuarded<Future<void>>(() async {
      runApp(
        Application(
          initialRoute: isRegistered == true ? '/' : '/login',
          //initialRoute: '/icpd',
          authService: authService,
          // routes: isActivated == true ? registeredRoutes : guestRoutes,
          routes: guestRoutes,
        ),
      );
    },
        (error, stack) =>
            FirebaseCrashlytics.instance.recordError(error, stack));
    return [];
  }
}

Future<void> _pushNotification() async {
  var initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectedNotification);
}

Future<dynamic> onSelectedNotification(payload) async {
  await SharedPref.setString("payloadnotificationscreen", payload);
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (from.difference(to).inHours / 24).round();
}

Future<void> _planInAppNotificationForLicenseRenewalPlan() async {
  int remainingPoints = await SharedPref().getInt("remainingPoints");
  String licenseRenewalExpiryDate =
      await SharedPref().getString("licenseRenewalExpiryDate");
  if (licenseRenewalExpiryDate.isNotEmpty) {
    DateTime dateExpire = DateTime.parse(licenseRenewalExpiryDate);

    var dateTimeExpire =
        DateTime(dateExpire.year, dateExpire.month, dateExpire.day, 0, 0, 0);
    final date2 = DateFormat("yyyy-MM-dd").format(DateTime.now());

    var difference = daysBetween(dateTimeExpire, DateTime.parse(date2));
    // var differenceBefore = difference < 0
    //     ? int.parse(difference.toString().replaceFirst("-", ""))
    //     : 0;
    String strDay = "",
        strYear = "",
        strMonth = "",
        strWeek = "",
        afterBefore = "";
    int years = 0, months = 0, weeks = 0;
    if (difference > 0) {
      strDay = difference == 1 ? "day" : "days";
      print("difference License Renewal Plan is :  $difference");

      years = _getCalculateYear(difference); //Years
      strYear = years == 1 ? "year" : "years";

      months = _getCalculateMonth(difference); //Months
      strMonth = months == 1 ? "month" : "months";

      weeks = _getCalculateWeek(difference); //Weeks
      strWeek = weeks == 1 ? "week" : "weeks";

      //After Before
      afterBefore = "will expire in";
    }

    int id = 0;
    String notificationMessage = "";
    String messageLicense = "Your License Renewal CPD Plan";

    //Point is less or equal 10
    if (remainingPoints <= 10) {
      //Date and Point
      if (difference > 0) {
        if (years > 0) {
          //Years
          id = 1;
          notificationMessage =
              "$messageLicense $afterBefore $years $strYear and Your remaining point is $remainingPoints.";
        } else if (months > 0) {
          //Months
          id = 2;
          notificationMessage =
              "$messageLicense $afterBefore $months $strMonth and Your remaining point is $remainingPoints.";
        } else if (weeks > 0) {
          //Weeks
          id = 3;
          notificationMessage =
              "$messageLicense $afterBefore $weeks $strWeek and Your remaining point is $remainingPoints.";
        } else {
          //Days
          id = 4;
          notificationMessage =
              "$messageLicense $afterBefore $difference $strDay and Your remaining point is $remainingPoints.";
        }
      } else if (difference == 0) {
        //Current Day ( Today )
        id = 5;
        notificationMessage =
            "$messageLicense will expire today and Your remaining point is $remainingPoints.";
      } else {
        //Points
        id = 6;
        notificationMessage =
            "$messageLicense remaining points is $remainingPoints.";
      }
    } else {
      //Date
      if (difference > 0) {
        if (years > 0) {
          //Years
          id = 7;
          notificationMessage = "$messageLicense $afterBefore $years $strYear.";
        } else if (months > 0) {
          //Months
          id = 8;
          notificationMessage =
              "$messageLicense $afterBefore $months $strMonth.";
        } else if (weeks > 0) {
          //Weeks
          id = 9;
          notificationMessage = "$messageLicense $afterBefore $weeks $strWeek.";
        } else {
          //Days
          id = 10;
          notificationMessage =
              "$messageLicense $afterBefore $difference $strDay.";
        }
      } else if (difference == 0) {
        //Current Day ( Today )
        id = 11;
        notificationMessage = "$messageLicense will expire today.";
      }
    }
    if (difference >= 0) {
      await _showSimpleInAppNotification(
          id, "License Renewal CPD Plan", notificationMessage, difference);
    }
  }
}

Future<void> _planInAppNotificationForFurtherMedicalEdu() async {
  String furtherMedicalEduExpiryDate =
      await SharedPref().getString("furtherMedicalEduExpiryDate");
  if (furtherMedicalEduExpiryDate.isNotEmpty) {
    DateTime dateExpire = DateTime.parse(furtherMedicalEduExpiryDate);

    var dateTimeExpire =
        DateTime(dateExpire.year, dateExpire.month, dateExpire.day, 0, 0, 0);
    final date2 = DateFormat("yyyy-MM-dd").format(DateTime.now());
    var difference = daysBetween(dateTimeExpire, DateTime.parse(date2));
    // var differenceBefore = difference < 0
    //     ? int.parse(difference.toString().replaceFirst("-", ""))
    //     : 0;

    int id = 0;
    String notificationMessage = "";
    String messageGeneralMedical = "Your General Medical Education Plan";

    //Date
    if (difference > 0) {
      String strDay = difference == 1 ? "day" : "days";
      print("difference Further Medical Edu is :  $difference");

      int years = _getCalculateYear(difference); //Years
      String strYear = years == 1 ? "year" : "years";

      int months = _getCalculateMonth(difference); //Months
      String strMonth = months == 1 ? "month" : "months";

      int weeks = _getCalculateWeek(difference); //Weeks
      String strWeek = weeks == 1 ? "week" : "weeks";

      //After Before
      String afterBefore = "will expire in";

      if (years > 0) {
        //Years
        id = 12;
        notificationMessage =
            "$messageGeneralMedical $afterBefore $years $strYear.";
      } else if (months > 0) {
        //Months
        id = 13;
        notificationMessage =
            "$messageGeneralMedical $afterBefore $months $strMonth.";
      } else if (weeks > 0) {
        //Weeks
        id = 14;
        notificationMessage =
            "$messageGeneralMedical $afterBefore $weeks $strWeek.";
      } else {
        //Days
        id = 15;
        notificationMessage =
            "$messageGeneralMedical $afterBefore $difference $strDay.";
      }
    } else if (difference == 0) {
      //Current Day ( Today )
      id = 16;
      notificationMessage = "$messageGeneralMedical will expire today.";
    }
    if (difference >= 0) {
      await _showSimpleInAppNotification(id, "General Medical Education Plan",
          notificationMessage, difference);
    }
  }
}

Future<void> _planInAppNotificationForPersonalDevelopment() async {
  String personalDevelopmentExpiryDate =
      await SharedPref().getString("personalDevelopmentExpiryDate");
  if (personalDevelopmentExpiryDate.isNotEmpty) {
    DateTime dateExpire = DateTime.parse(personalDevelopmentExpiryDate);

    var dateTimeExpire =
        DateTime(dateExpire.year, dateExpire.month, dateExpire.day, 0, 0, 0);
    final date2 = DateFormat("yyyy-MM-dd").format(DateTime.now());

    var difference = daysBetween(dateTimeExpire, DateTime.parse(date2));
    // var differenceBefore = difference < 0
    //     ? int.parse(difference.toString().replaceFirst("-", ""))
    //     : 0;

    int id = 0;
    String notificationMessage = "";
    String messageGeneralMedical = "Your Personal Development Plan";

    //Date
    if (difference > 0) {
      String strDay = difference == 1 ? "day" : "days";
      print("difference Personal Development is : $difference");

      int years = _getCalculateYear(difference); //Years
      String strYear = years == 1 ? "year" : "years";

      int months = _getCalculateMonth(difference); //Months
      String strMonth = months == 1 ? "month" : "months";

      int weeks = _getCalculateWeek(difference); //Weeks
      String strWeek = weeks == 1 ? "week" : "weeks";

      //After Before
      String afterBefore = "will expire in";
      if (years > 0) {
        //Years
        id = 17;
        notificationMessage =
            "$messageGeneralMedical $afterBefore $years $strYear.";
      } else if (months > 0) {
        //Months
        id = 18;
        notificationMessage =
            "$messageGeneralMedical $afterBefore $months $strMonth.";
      } else if (weeks > 0) {
        //Weeks
        id = 19;
        notificationMessage =
            "$messageGeneralMedical $afterBefore $weeks $strWeek.";
      } else {
        //Days
        id = 20;
        notificationMessage =
            "$messageGeneralMedical $afterBefore $difference $strDay.";
      }
    } else if (difference == 0) {
      //Current Day ( Today )
      id = 21;
      notificationMessage = "$messageGeneralMedical will expire today.";
    }
    if (difference >= 0) {
      await _showSimpleInAppNotification(
          id, "Personal Development Plan", notificationMessage, difference);
    }
  }
}

int _getCalculateYear(int difference) {
  if (difference > 364) {
    // Years Current day +
    return difference ~/ 365;
  }
  /*else if (differenceBefore > 364) {
    // Years Current day -
    return differenceBefore ~/ 365;
  }*/
  return 0;
}

int _getCalculateMonth(int difference) {
  //Months
  if (difference > 29 && difference < 365) {
    // Months Current day +
    int year = difference ~/ 365;
    return (difference - year * 365) ~/ 30;
  }
  /*else if (differenceBefore > 29 && differenceBefore < 365) {
    // Months Current day -
    int year = differenceBefore ~/ 365;
    return (differenceBefore - year * 365) ~/ 30;
  }*/
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
  /*else if (differenceBefore > 6 && differenceBefore < 30) {
    // Week Current day -
    int year = differenceBefore ~/ 365;
    int month = (differenceBefore - year * 365) ~/ 30;
    return (differenceBefore - month * 365) ~/ 7;
  }*/
  return 0;
}

_showSimpleInAppNotification(
    int id, String titleNotification, String message, int afterDay,
    {String? activityTitleName}) async {
  var bigTextStyleInformation = BigTextStyleInformation(message);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'Hola Medico',
    "CHANNEL NAME",
    channelDescription: "channelDescription",
    icon: "mipmap/ic_launcher",
    enableLights: true,
    channelShowBadge: true,
    playSound: true,
    enableVibration: true,
    styleInformation: bigTextStyleInformation,
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

    print("isLocalNotification : $isLocalNotification");

    iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'slow_spring_board.aiff',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
  }
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  if (afterDay > 364) {
    //year
    if (titleNotification == "License Renewal CPD Plan") {
      await SharedPref.setString("lrcpNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } else if (titleNotification == "General Medical Education Plan") {
      await SharedPref.setString("gmepNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } else if (titleNotification == "Personal Development Plan") {
      await SharedPref.setString("pdpNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    }

    await flutterLocalNotificationsPlugin.schedule(id, titleNotification,
        message, DateTime.now(), platformChannelSpecifics,
        androidAllowWhileIdle: true, payload: titleNotification);
  } else if (afterDay > 29) {
    //month
    if (titleNotification == "License Renewal CPD Plan") {
      await SharedPref.setString("lrcpNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } else if (titleNotification == "General Medical Education Plan") {
      await SharedPref.setString("gmepNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } else if (titleNotification == "Personal Development Plan") {
      await SharedPref.setString("pdpNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    }

    await flutterLocalNotificationsPlugin.schedule(id, titleNotification,
        message, DateTime.now(), platformChannelSpecifics,
        androidAllowWhileIdle: true, payload: titleNotification);
  } else if (afterDay > 6) {
    //week
    if (titleNotification == "License Renewal CPD Plan") {
      await SharedPref.setString("lrcpNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } else if (titleNotification == "General Medical Education Plan") {
      await SharedPref.setString("gmepNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } else if (titleNotification == "Personal Development Plan") {
      await SharedPref.setString("pdpNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    }

    await flutterLocalNotificationsPlugin.schedule(id, titleNotification,
        message, DateTime.now(), platformChannelSpecifics,
        androidAllowWhileIdle: true, payload: titleNotification);
    /*await flutterLocalNotificationsPlugin.periodicallyShow(
        id,
        titleNotification,
        message,
        RepeatInterval.weekly,
        platformChannelSpecifics,
        androidAllowWhileIdle: true);*/
  } else if (afterDay <= 6) {
    //day
    if (titleNotification == "License Renewal CPD Plan") {
      await SharedPref.setString("lrcpNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } else if (titleNotification == "General Medical Education Plan") {
      await SharedPref.setString("gmepNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } else if (titleNotification == "Personal Development Plan") {
      await SharedPref.setString("pdpNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } else if (activityTitleName == "Pending Activity") {
      await SharedPref.setString("activityNotificationDate",
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
    }
    await flutterLocalNotificationsPlugin.schedule(id, titleNotification,
        message, DateTime.now(), platformChannelSpecifics,
        androidAllowWhileIdle: true, payload: titleNotification);
    /*await flutterLocalNotificationsPlugin.periodicallyShow(
        id,
        titleNotification,
        message,
        RepeatInterval.daily,
        platformChannelSpecifics,
        androidAllowWhileIdle: true);*/
  }
}

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.setForegroundMode(true);
  service.setAutoStartOnBootMode(true);
  _callBackgroundService(service);
}

_callBackgroundService(FlutterBackgroundService service) async {
  await SharedPref().reload();
  final currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  //Activity
  List<String> lstActivityExpDate =
      await SharedPref().getListData('pendingActivityDate');
  if (lstActivityExpDate.length > 0) {
    for (String actExpiryDate in lstActivityExpDate) {
      ActivityExpItem activityExpItem =
          ActivityExpItem.fromJson(jsonDecode(actExpiryDate));
      var lstActivityExpDateDifference = -1;
      if (actExpiryDate.isNotEmpty && activityExpItem.toString().isNotEmpty) {
        lstActivityExpDateDifference = daysBetween(
            DateTime.parse(activityExpItem.activityExpDate.toString()),
            DateTime.parse(currentDate));
        if (lstActivityExpDateDifference == 0 ||
            lstActivityExpDateDifference == 1) {
          String dayOf =
              lstActivityExpDateDifference == 0 ? "today" : "tomorrow";
          String titleNotification = "";
          if (activityExpItem.planTypeIndex == 0) {
            titleNotification = "License Plan Pending Activity";
          } else if (activityExpItem.planTypeIndex == 1) {
            titleNotification = "Medical Plan Pending Activity";
          } else if (activityExpItem.planTypeIndex == 2) {
            titleNotification = "Personal Plan Pending Activity";
          }
          String activityNotificationDate =
              await SharedPref().getString("activityNotificationDate");
          var activityNotificationDateDifference = -1;
          if (activityNotificationDate.isNotEmpty) {
            activityNotificationDateDifference = daysBetween(
                DateTime.parse(activityNotificationDate),
                DateTime.parse(currentDate));
          }
          if (activityNotificationDateDifference != 0) {
            await _showSimpleInAppNotification(
                22,
                titleNotification,
                "Your activity \"${activityExpItem.activityName.toString()}\" is scheduled for $dayOf",
                0,
                activityTitleName: "Pending Activity");
          }
        }
      }
    }
  }

  //License Renewal Plan Check
  String lrcpNotificationDate =
      await SharedPref().getString("lrcpNotificationDate");
  var lrcpNotificationDateDifference = -1;
  if (lrcpNotificationDate.isNotEmpty) {
    lrcpNotificationDateDifference = daysBetween(
        DateTime.parse(lrcpNotificationDate), DateTime.parse(currentDate));
  }
  if (lrcpNotificationDateDifference != 0) {
    await _planInAppNotificationForLicenseRenewalPlan();
  }

  //General Media Education Plan Check
  String gmepNotificationDate =
      await SharedPref().getString("gmepNotificationDate");
  var gmepNotificationDateDifference = -1;
  if (gmepNotificationDate.isNotEmpty) {
    gmepNotificationDateDifference = daysBetween(
        DateTime.parse(gmepNotificationDate), DateTime.parse(currentDate));
  }
  if (gmepNotificationDateDifference != 0) {
    await _planInAppNotificationForFurtherMedicalEdu();
  }

  //Personal Development Plan Check
  String pdpNotificationDate =
      await SharedPref().getString("pdpNotificationDate");
  var pdpNotificationDateDifference = -1;
  if (pdpNotificationDate.isNotEmpty) {
    pdpNotificationDateDifference = daysBetween(
        DateTime.parse(pdpNotificationDate), DateTime.parse(currentDate));
  }
  if (pdpNotificationDateDifference != 0) {
    await _planInAppNotificationForPersonalDevelopment();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 5;
  }
}
