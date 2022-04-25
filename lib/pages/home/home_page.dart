import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:pharmaaccess/SharedPref.dart';
import 'package:pharmaaccess/apis/auth_provider.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/components/app_webview.dart';
import 'package:pharmaaccess/config/config.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/news_item_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/pages/cardio_module/cardio_main_page.dart';
import 'package:pharmaaccess/pages/icpd/icpd_page.dart';
import 'package:pharmaaccess/pages/icpd/license_renewal_page.dart';
import 'package:pharmaaccess/pages/icpd/my_further_medical_education.dart';
import 'package:pharmaaccess/pages/icpd/my_personal_development_plan.dart';
import 'package:pharmaaccess/pages/quiz/quiz_category_page.dart';
import 'package:pharmaaccess/pages/registered_main_screen.dart';
import 'package:pharmaaccess/services/news_service.dart';
import 'package:pharmaaccess/services/profile_service.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/helper_functions.dart';
import 'package:pharmaaccess/util/screen_shot.dart';
import 'package:pharmaaccess/widgets/news_headline.dart';
import 'package:provider/provider.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../screen_utils/MyScreenUtil.dart';
import '../../screen_utils/ScreenUtil.dart';
import '../../theme.dart';
import '../../util/ConfirmationDialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollControllerNested = new ScrollController();
  String versionName = "";
  late NewsService newsService;

  MyScreenUtil? myScreenUtil;

  bool loadNextPage = false;
  int scrollProgress = 0;
  StreamController<bool> showProgressStreamController =
      StreamController.broadcast();
  StreamController<NewsData?> newsListStreamController =
      StreamController<NewsData?>.broadcast();
  StreamController<bool> newsErrorStreamController =
      StreamController<bool>.broadcast();
  int pageNo = 0;
  bool isErrorInNewsFetching = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(HOME_SCREEN, param: {"name": "Home Screen"});
    getSharePayLoadNotfication();
    _firebaseMessaging
      ..requestPermission(sound: true, badge: true, alert: true);
    newsService = NewsService();
    showProgressStreamController = StreamController.broadcast();
    newsListStreamController = StreamController<NewsData?>.broadcast();
    newsErrorStreamController = StreamController<bool>.broadcast();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (await SharedPref().getString("TokenStore") != newToken) {
        await SharedPref.setString("TokenStore", "");
      }
    });
    callAPI();
    try {
      _initPackageInfo();

      FirebaseMessaging.onMessage.listen(
        (RemoteMessage remoteMessage) async {
          Map<String, dynamic> message = remoteMessage.data;
          showNotification(message);
        },
      );
      DBProvider().getProfile().then((provider) async {
        try {
          String countryName = provider!.countryName;

          if (countryName.isNotEmpty && countryName.isNotEmpty) {
            await FirebaseMessaging.instance.subscribeToTopic(countryName);
          }
          await FirebaseMessaging.instance
              .subscribeToTopic("general_notification");
        } catch (e) {}
      });
    } catch (e) {}
    prepareAnimations();
    _runExpandCheck();
  }

  Future<void> getSharePayLoadNotfication() async {
    String payloadNotification =
        await SharedPref().getString("payloadnotificationscreen");

    if (payloadNotification.isNotEmpty) {
      await SharedPref.setString("payloadnotificationscreen", "");
      if (payloadNotification == "License Renewal CPD Plan" ||
          payloadNotification == "License Plan Pending Activity") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => LicenseRenewalPage(
              planTypeIndex: 0,
            ),
          ),
        );
      } else if (payloadNotification == "General Medical Education Plan" ||
          payloadNotification == "Medical Plan Pending Activity") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => MyFutureEducationPage(
              planTypeIndex: 1,
            ),
          ),
        );
      } else if (payloadNotification == "Personal Development Plan" ||
          payloadNotification == "Personal Plan Pending Activity") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => MyPersonalDevelopmentPlanPage(
              planTypeIndex: 2,
            ),
          ),
        );
      }
    }
  }

  int i = 0;

  showNotification(Map<String, dynamic> message) async {
    i++;
    String? body = "body", title = "title";
    if (message.containsKey('data') && message['data']['body'] != null) {
      body = message['data']['body'];
      title = message['data']['title'];
    } else {
      body = message['aps']['body'];
      title = message['aps']['title'];
    }
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var android = new AndroidNotificationDetails(
      'Hola Medico',
      "CHANNEL NAME",
      channelDescription: "channelDescription",
      icon: "mipmap/ic_launcher",
      enableLights: true,
      channelShowBadge: true,
      playSound: true,
      priority: Priority.high,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    var iOS;
    if (Platform.isIOS) {
      final bool? isLocalNotification = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      iOS = IOSNotificationDetails(
          sound: 'slow_spring_board.aiff',
          presentAlert: true,
          presentBadge: true,
          presentSound: true);
    }
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(i, title!, body!, platform);
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      versionName = info.version;
    });

    try {
      callVersion();
    } catch (e) {}
  }

  callVersion() async {
    MyScreenUtil screenUtil = getScreenUtilInstance(context);
    final AuthProvider authProvider = AuthProvider();
    double liveVersion = await authProvider.getVersion();
    double currentVersion = double.parse(versionName.replaceAll(".", ""));
    if (liveVersion > currentVersion) {
      ConfirmationDialog.dialog(
        context,
        title: "App update available",
        option1: "Update",
        content:
            "A newer version of the application is available for download. Please click update?",
        screenUtil: screenUtil,
        horizontalPadding: 5.0,
        mainAxisSize: MainAxisSize.max,
        textScaleFactor: 1.0,
        primaryColor: primaryColor,
        buttonTextColor: Colors.white,
      ).then((value) async {
        if (value.compareTo(ConfirmationDialog.returnSelectedOption!) == 0) {
          StoreRedirect.redirect(
            androidAppId: "me.g3it.pharmaaccess",
            iOSAppId: "1526398025",
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    myScreenUtil = getScreenUtilInstance(context);
    var theme = Theme.of(context);
    return NestedScrollView(
      controller: _scrollControllerNested,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          getTopicWidget(),
          medicalUpdateTitle(theme),
        ];
      },
      body: StreamBuilder<bool>(
        initialData: isErrorInNewsFetching,
        stream: newsErrorStreamController.stream,
        builder: (context, snapshot) {
          return isErrorInNewsFetching
              ? newsError()
              : StreamBuilder<NewsData?>(
                  stream: newsListStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return newsList(
                        snapshot.data!.newsModel,
                        snapshot.data!.total,
                      );
                    } else {
                      return loading();
                    }
                  },
                );
        },
      ),
    );
  }

  Widget loading() {
    return Center(
      child: Container(
        height: 80,
        width: 80,
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ),
    );
  }

  Widget medicalUpdateTitle(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 20),
        child: Text(
          'Medical Update',
          style: theme.textTheme.headline4,
        ),
      ),
    );
  }

  Widget newsList(List<NewsModel>? data, int total) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        int progress = 0;
        if (notification.metrics.pixels != 0 &&
            notification.metrics.maxScrollExtent != 0) {
          progress = ((notification.metrics.pixels /
                      notification.metrics.maxScrollExtent) *
                  100)
              .toInt();
        }

        if (progress != scrollProgress) {
          scrollProgress = progress;
          if (data != null) {
            setLastPage(data, total);
          }
          if (loadNextPage && scrollProgress == 100) {
            callAPI();
          }
        }
        return true;
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ...data!
                    .map(
                      (news) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: NewsHeadlineItem(news, () async {
                          await firebaseAnalyticsEventCall(NEWS_VISIT_EVENT,
                              param: {"name": "News HeadLine"});
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => MyWebView(
                                title: "Healthcare News",
                                selectedUrl: news.externalUrl,
                              ),
                            ),
                          );
                        }, (GlobalKey _globalKey) async {
                          if (await PermissionUtil.getStoragePermission(
                            context: context,
                            screenUtil: myScreenUtil,
                          )) {
                            String filePath =
                                await saveScreenShot(_globalKey, news.title!);
                            shareOption(filePath,
                                news.title! + "\n" + news.externalUrl!);
                          }
                        }, () {}),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<bool>(
              initialData: loadNextPage,
              stream: showProgressStreamController.stream,
              builder: (context, snapshot) => Padding(
                padding: const EdgeInsets.only(bottom: 45.0),
                child: getLoadingPaginationWidget(snapshot),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setLastPage(List<NewsModel>? data, int total) {
    loadNextPage = (total > data!.length);
    if (!showProgressStreamController.isClosed) {
      showProgressStreamController.add(loadNextPage);
    }
  }

  Widget getLoadingPaginationWidget(AsyncSnapshot<bool> snapshot) {
    if (!snapshot.data!) {
      return SizedBox();
    }
    return Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }

  bool isMoreNews(int length) => length > 2;

  Widget newsError() => Center(child: Text("Cannot fetch news"));

  Widget tipError() => Text("Cannot fetch Tip of Day");

  Widget newCalculator(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 8, left: 10, right: 10),
      decoration: softCardShadow,
      margin: EdgeInsets.only(top: 7, bottom: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              await firebaseAnalyticsEventCall("Cardio_page",
                  param: {"timeStamp": DateTime.now().toString()});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => CardioLandingPage(),
                ),
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Diagnostic',
                      style: theme.textTheme.headline4,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4.5,
                        ),
                      ]),
                  child: Icon(
                    Icons.calculate_outlined,
                    color: primaryColor,
                    size: MediaQuery.of(context).size.width * 0.057,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tools  ',
                      style: theme.textTheme.headline4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  late AnimationController expandController;
  late Animation<double> animation;
  bool isExpanded = true;

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (isExpanded) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  List<String> list = [
    "Diagnostic Tools",
    "Educational Support",
    "Quiz",
    "iCPD",
    /*if (Config.isActivated) ...[
      "Respimar Club",
    ],*/
  ];

  List<String> listClub = [
    "Diagnostic Tools",
    "Educational Support",
    "Quiz",
    "iCPD",
    "Respimar Club",
  ];

  List<MenuIcon> icons = [
    MenuIcon("assets/images/calculator.png"),
    MenuIcon("assets/images/educational.png"),
    MenuIcon("assets/images/quiz.png"),
    MenuIcon("assets/images/icon_icpd.png"),
    /*if (Config.isActivated) ...[
      MenuIcon("assets/images/icon_club.svg", isSvg: true),
    ],*/
    // MenuIcon("assets/images/icon_club.svg", isSvg: true),
  ];

  List<MenuIcon> iconsClub = [
    MenuIcon("assets/images/calculator.png"),
    MenuIcon("assets/images/educational.png"),
    MenuIcon("assets/images/quiz.png"),
    MenuIcon("assets/images/icon_icpd.png"),
    /*if (Config.isActivated) ...[
      MenuIcon("assets/images/icon_club.svg", isSvg: true),
    ],*/
    MenuIcon("assets/images/icon_club.svg", isSvg: true),
  ];

  Widget getTopicWidget() => MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: SliverToBoxAdapter(
          child: Column(
            children: [
              SizeTransition(
                axisAlignment: 1.0,
                sizeFactor: animation,
                axis: Axis.vertical,
                child: Container(
                  color: Colors.white,
                  child: GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                      // crossAxisCount: (Config.isActivated) ? 4 : 3,
                      // childAspectRatio: (Config.isActivated) ? 1 : 1.5,
                    ),
                    children: List.generate(
                      Config.isCinfaClub ? listClub.length : list.length,
                      (index) {
                        return Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () async {
                              switch (index) {
                                case 0:
                                  await firebaseAnalyticsEventCall(CARDIO_EVENT,
                                      param: {
                                        "timeStamp": DateTime.now().toString()
                                      });
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CardioLandingPage(),
                                    ),
                                  );
                                  break;
                                case 1:
                                  await firebaseAnalyticsEventCall(
                                      SOCRATES_SELECTION_EVENT,
                                      param: {"name": "Educational Support"});
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MyWebView(
                                        title: "Socrates",
                                        selectedUrl:
                                            'https://content.pharmaaccess.com/static/mrcp/EduSupportHomepage.html',
                                      ),
                                    ),
                                  );
                                  break;
                                case 2:
                                  await firebaseAnalyticsEventCall(
                                      SOCRATES_SELECTION_EVENT,
                                      param: {"name": "Quiz"});
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          QuizCategoryPage(),
                                    ),
                                  );
                                  break;
                                case 3:
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          IcpdPage(),
                                    ),
                                  );
                                  break;
                                case 4:
                                  bottomNavigationController.jumpToPage(3);
                                  break;
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor,
                                          blurRadius: 5,
                                        ),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Config.isCinfaClub
                                        ? iconsClub[index].isSvg
                                            ? SvgPicture.asset(
                                                iconsClub[index].iconPath,
                                                color: Colors.white,
                                                width: 25,
                                                height: 25,
                                              )
                                            : Image.asset(
                                                iconsClub[index].iconPath,
                                                width: 25,
                                                height: 25,
                                                color: Colors.white,
                                              )
                                        : icons[index].isSvg
                                            ? SvgPicture.asset(
                                                icons[index].iconPath,
                                                color: Colors.white,
                                                width: 25,
                                                height: 25,
                                              )
                                            : Image.asset(
                                                icons[index].iconPath,
                                                width: 25,
                                                height: 25,
                                                color: Colors.white,
                                              ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  Config.isCinfaClub
                                      ? listClub[index]
                                      : list[index],
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: [
                        Material(
                          type: MaterialType.card,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          shadowColor: Colors.grey,
                          color: Colors.white,
                          elevation: 1,
                          clipBehavior: Clip.none,
                          child: Container(
                            height: 25,
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      start: (MediaQuery.of(context).size.width / 2) - 20,
                      top: 5,
                      child: FloatingActionButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        mini: true,
                        isExtended: true,
                        focusElevation: 0,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          isExpanded = !isExpanded;
                          _runExpandCheck();
                        },
                        child: new AnimatedBuilder(
                          animation: expandController,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black,
                          ),
                          builder: (BuildContext context, Widget? widget) {
                            return new Transform.rotate(
                              angle: expandController.value * 3.1,
                              child: widget,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    newsListStreamController.close();
    newsErrorStreamController.close();
    showProgressStreamController.close();
    expandController.dispose();
    super.dispose();
  }

  void callAPI() async {
    NewsData? newsModel = await newsService.getNewsForHome(++pageNo);
    if (newsModel != null && !newsListStreamController.isClosed) {
      newsListStreamController.add(newsModel);
    } else {
      isErrorInNewsFetching = true;
      if (!newsErrorStreamController.isClosed) {
        newsErrorStreamController.add(isErrorInNewsFetching);
      }
    }
  }
}

class WelcomeMessageWidget extends StatelessWidget {
  const WelcomeMessageWidget({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);

    return FutureBuilder<Object?>(
      future: profileService.getProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          ProfileModel profile = snapshot.data as ProfileModel;
          return Container(
              padding: EdgeInsets.all(10),
              decoration: softCardShadow,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Text("Hola ${titleCase(profile.name)}",
                        style: theme.textTheme.headline4!
                            .apply(color: primaryColor)
                            .copyWith(
                              height: 2,
                              fontSize: 22,
                            )),
                    Text("Let's connect. Let's learn. Let's evolve.",
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.5,
                        )),
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "This is the promise of ",
                        style: TextStyle(fontSize: 17, color: bodyTextColor),
                      ),
                      TextSpan(
                        text: "Hola Medico!",
                        style: TextStyle(
                            fontSize: 17,
                            color: bodyTextColor,
                            fontWeight: FontWeight.w500,
                            height: 1.5),
                      ),
                    ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(DateFormat("MMMM dd yyyy").format(DateTime.now()),
                            style: mutedText),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ));
        } else {
          return Center(
            child: Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    return FutureBuilder<Object?>(
        future: profileService.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            ProfileModel profile = snapshot.data as ProfileModel;
            return Container(
              color: Colors.white,
              padding: EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/profile');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Container(
                        color: Colors.grey,
                        child: FutureBuilder<Object>(
                            future: profile.getProfileImage(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return snapshot.data as Widget;
                              }
                              return Image.asset(
                                  'assets/images/profile_placeholder.png');
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "Hola, ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: bodyTextColor,
                                )),
                            TextSpan(
                                text: titleCase(profile.name),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class MenuIcon {
  String iconPath;
  bool isSvg;

  MenuIcon(this.iconPath, {this.isSvg: false});
}
