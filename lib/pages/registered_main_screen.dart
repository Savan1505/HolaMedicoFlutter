import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/pages/club/respimar_club_landing_page.dart';
import 'package:pharmaaccess/pages/game/game_landing_page.dart';
import 'package:pharmaaccess/pages/index.dart';
import 'package:pharmaaccess/pages/quiz/quiz_landing_page.dart';
import 'package:pharmaaccess/services/profile_service.dart';
import 'package:pharmaaccess/widgets/CommonOverflowMenu.dart';
import 'package:pharmaaccess/widgets/bottombar/button.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../theme.dart';
import 'notification/notification_page.dart';

class RegisteredMainScreen extends StatefulWidget {
  @override
  _RegisteredMainScreenState createState() => _RegisteredMainScreenState();

  RegisteredMainScreen({Key? key}) : super(key: key);
}

PageController bottomNavigationController = PageController(initialPage: 2);

class _RegisteredMainScreenState extends State<RegisteredMainScreen>
    with TickerProviderStateMixin<RegisteredMainScreen> {
  int _page = 2, backpress = 0;

  bool _isPageViewAnimating = false;
  int _animateTo = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    bottomNavigationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
    firebaseAnalyticsEventCall(REGISTRATION_EVENT,
        param: {"name": "Registration Screen"});
  }

  ProfileImageWidget? profileWidget;

  @override
  Widget build(BuildContext context) {
    final String? pageName =
        ModalRoute.of(context)!.settings.arguments as String?;
    if (pageName == 'quiz') {
      _page = 1;
      bottomNavigationController = PageController(initialPage: 1);
    } else {
      if (bottomNavigationController.initialPage != 2) {
        bottomNavigationController = PageController(initialPage: 2);
      }
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        //endDrawer: AppDrawer(),
        body: SafeArea(
          top: false,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              if (profileWidget == null) {
                profileWidget = ProfileImageWidget();
              }
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  leading: profileWidget,
                  primary: true,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Image.asset(
                      'assets/images/app_logo_small.png',
                      height: 32,
                    ),
                  ),
                  titleSpacing: 0,
                  backgroundColor: primaryColor,
                  actions: <Widget>[
//                      Badge(
//                        showBadge: true,
//                        borderRadius: 0,
//                        position: BadgePosition.topRight(top: 8, right: 4),
//                        badgeColor: Colors.white,
//                        badgeContent: Text(
//                          '3',
//                          style: TextStyle(fontSize: 10),
//                        ),
//                        child: IconButton(
//                          iconSize: 32,
//                          color: Colors.white,
//                          padding: EdgeInsets.all(0),
//                          icon: Icon(Icons.notifications_none),
//                          tooltip: 'Notifications',
//                          onPressed: () {/* ... */},
//                        ),
//                      ),
//                      IconButton(
//                        iconSize: 32,
//                        color: Colors.white,
//                        icon: const Icon(Icons.mic_none),
//                        tooltip: 'Voice',
//                        onPressed: () {/* ... */},
//                      ),
                    IconButton(
                      iconSize: 32,
                      color: Colors.white,
                      icon: const Icon(Icons.notifications_none),
                      tooltip: 'Notification',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NotificationPage(),
                          ),
                        );
                      },
                    ),
                    CommonOverFlowMenu(),
                  ],
                ),
              ];
            },
            body: PageView(
              onPageChanged: (int page) {
                if (_isPageViewAnimating && page != _animateTo) return;

                setState(() {
                  _scrollController.jumpTo(0.0);
                  _isPageViewAnimating = false;
                  _animateTo = page;
                  _page = page;
                });
              },
              controller: bottomNavigationController,
              children: <Widget>[
                BrandLandingPage(),
                QuizLandingPage(),
                HomePage(),
                RespimarClubLandingPage(),
                GameLandingPage(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: CurvedNavigationBar(
            height: 60,
            index: _page,
            color: Colors.white,
            backgroundColor: Colors.white,
            buttonBackgroundColor: Colors.white,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 500),
            onTap: (int index) {
              //if (index == 4) return;
              setState(() {
                _page = index;
                _isPageViewAnimating = true;
                _animateTo = index;
              });
              bottomNavigationController.animateToPage(index,
                  duration: Duration(milliseconds: 500), curve: Curves.easeIn);
            },
            items: registeredDestinations.map(bottomMenuButtonBuilder).toList(),
          ),
        ),
      ),
    );
  }

  Widget bottomMenuButtonBuilder(BarButton destination) {
    //  final buttonColor = secondaryColor;
    switch (destination.label) {
      case "Clubs":
      case "Socrates":
      case "Cerebrum":
        {
          return getButton(
              path: destination.svgPath!,
              label: destination.label,
              color: primaryColor);
        }
        break;
      case "Home":
        {
          return getButton(
            path: destination.svgPath!,
            label: destination.label,
          );
        }
        break;
      case "Brands":
        {
          return getButton(
            path: destination.svgPath!,
            label: destination.label,
          );
        }
        break;
      default:
        return Container(
          padding: EdgeInsets.only(top: 6),
          child: Column(
            children: <Widget>[
              IconButton(
                iconSize: 32,
                icon: Icon(
                  destination.icon,
                  color: primaryColor,
                ),
                onPressed: null,
              ),
              Text(destination.label!, style: TextStyle(color: secondaryColor)),
            ],
          ),
        ); //Icon(destination.icon, color: Colors.white);
    }
  }

  Future<bool> _onWillPop() {
    if (backpress == 0 && _page == 2) {
      backpress = 1;
      //_scaffoldKey.currentState.openEndDrawer();
      Fluttertoast.showToast(
          msg: "Press back again to leave",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
      // showErrorMessage(context, allTranslations.text(AppLocalizationsKey.backexit), false);
      new Future.delayed(
          const Duration(seconds: 2),
          () => setState(() {
                backpress = 0;
              }));
      return Future.value(false);
    } else if (backpress == 0 && _page != 2) {
      setState(() {
        _scrollController.jumpTo(0.0);
        _isPageViewAnimating = false;
        _animateTo = 2;
        bottomNavigationController.animateToPage(2,
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        _page = 2;
      });
    }
    if (backpress == 1) {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
      // exit(0);
      return Future.value(true);
    }
    return Future.value(false);
  }
}

Widget getButton(
    {required String path,
    required String? label,
    Color? color,
    int width = 26}) {
  return BottomNavigationButton(
    buttonColor: color,
    icon: SvgPicture.asset(path, color: color, width: 26),
    label: label,
  );
}

class BottomNavigationButton extends StatelessWidget {
  const BottomNavigationButton({
    Key? key,
    required this.buttonColor,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final Color? buttonColor;
  final Widget icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 6),
      child: Column(
        children: <Widget>[
          IconButton(
            splashColor: Colors.white70,
            color: buttonColor,
            icon: icon,
            tooltip: 'MD Club',
            onPressed: null,
          ),
          Text(label!, style: TextStyle(color: secondaryColor, fontSize: 12)),
        ],
      ),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  ProfileImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    return FutureBuilder<Object?>(
        future: profileService.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            ProfileModel profile = snapshot.data as ProfileModel;
            return Container(
              padding: EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/profile');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /*ClipRRect(
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
                    ),*/
                    Container(
                      height: 70,
                      child: FutureBuilder<Image>(
                        future: profile.getProfileImage(),
                        builder: (context, snap) {
                          if (snap.data != null) {
                            return CircleAvatar(
                              backgroundImage: snap.data!.image,
                              backgroundColor: primaryColor,
                            );
                          }
                          return Image.asset(
                              'assets/images/profile_placeholder.png');
                        },
                      ),
                    ),
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
