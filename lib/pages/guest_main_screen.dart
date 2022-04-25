import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmaaccess/pages/index.dart';
import 'package:pharmaaccess/pages/quiz/quiz_landing_page.dart';
import 'package:pharmaaccess/widgets/CommonOverflowMenu.dart';
import 'package:pharmaaccess/widgets/bottombar/button.dart';

import '../theme.dart';
import 'game/game_landing_page.dart';
import 'notification/notification_page.dart';
import 'registered_main_screen.dart';

class GuestMainScreen extends StatefulWidget {
  @override
  _GuestMainScreenState createState() => _GuestMainScreenState();
  GuestMainScreen({Key? key}) : super(key: key);
}

class _GuestMainScreenState extends State<GuestMainScreen>
    with TickerProviderStateMixin<GuestMainScreen> {
  int _page = 0;
  PageController _controller = PageController(initialPage: 0);
  ScrollController _scrollController = new ScrollController();
  bool _isPageViewAnimating = false;
  int _animateTo = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _firebaseMessaging
      ..requestPermission(sound: true, badge: true, alert: true);
  }

  ProfileImageWidget? profileWidget;

  @override
  Widget build(BuildContext context) {
    final String? pageName =
        ModalRoute.of(context)!.settings.arguments as String?;
    if (pageName == 'quiz') {
      _page = 2;
      _controller = PageController(initialPage: 2);
    } else {
      if (_controller.initialPage != 0) {
        _controller = PageController(initialPage: 0);
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      //endDrawer: AppDrawer(),
      body: SafeArea(
        top: false,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            if (profileWidget == null) {
              profileWidget = ProfileImageWidget();
            }
            return <Widget>[
              SliverAppBar(
                leading: profileWidget,
                primary: true,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Image.asset(
                    'assets/images/app_logo_small.png',
                    height: 32,
                  ),
                ),
                titleSpacing: 0,
                backgroundColor: primaryColor,
                actions: <Widget>[
                  // Badge(
                  //   showBadge: true,
                  //   borderRadius: 0,
                  //   position: BadgePosition.topRight(top: 8, right: 4),
                  //   badgeColor: Colors.white,
                  //   badgeContent: Text(
                  //     '3',
                  //     style: TextStyle(fontSize: 10),
                  //   ),
                  //   child: IconButton(
                  //     iconSize: 32,
                  //     color: Colors.white,
                  //     padding: EdgeInsets.all(0),
                  //     icon: Icon(Icons.notifications_none),
                  //     tooltip: 'Notifications',
                  //     onPressed: () {/* ... */},
                  //   ),
                  // ),
                  // IconButton(
                  //   iconSize: 32,
                  //   color: Colors.white,
                  //   icon: const Icon(Icons.mic_none),
                  //   tooltip: 'Voice',
                  //   onPressed: () {/* ... */},
                  // ),
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
                _isPageViewAnimating = false;
                _animateTo = page;
                _page = page;
              });
            },
            controller: _controller,
            children: <Widget>[
              HomePage(),
              BrandLandingPage(),
              QuizLandingPage(),
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
            _controller.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          },
          items: guestDestinations.map(bottomMenuButtonBuilder).toList(),
        ),
      ),
    );
  }

  Widget bottomMenuButtonBuilder(BarButton destination) {
    final buttonColor = secondaryColor;
    switch (destination.label) {
      case "Cinfa Club":
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
              path: destination.svgPath!, label: destination.label);
        }
        break;
      default:
        return Container(
          padding: EdgeInsets.only(top: 6),
          child: Column(
            children: <Widget>[
              IconButton(
                iconSize: 32,
                icon: Icon(destination.icon, color: buttonColor),
                onPressed: null,
              ),
              Text(destination.label!, style: TextStyle(color: secondaryColor)),
            ],
          ),
        ); //Icon(destination.icon, color: Colors.white);
    }
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
            color: primaryColor,
            icon: icon,
            tooltip: 'MD Club',
            onPressed: null,
          ),
          Text(label!, style: TextStyle(color: secondaryColor)),
        ],
      ),
    );
  }
}
