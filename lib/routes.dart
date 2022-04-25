import 'package:flutter/cupertino.dart';
import 'package:pharmaaccess/pages/guest_main_screen.dart';
import 'package:pharmaaccess/pages/icpd/icpd_page.dart';
import 'package:pharmaaccess/pages/index.dart';
import 'package:pharmaaccess/pages/profile/profile_page.dart';
import 'package:pharmaaccess/pages/registered_main_screen.dart';

final registeredRoutes = {
  '/': (BuildContext context) => RegisteredMainScreen(),
  '/login': (BuildContext context) => WelcomePage(),
  '/profile': (BuildContext context) => ProfilePage(),
  '/icpd': (BuildContext context) => IcpdPage(),
};

final guestRoutes = {
  '/': (BuildContext context) => GuestMainScreen(),
  '/login': (BuildContext context) => WelcomePage(),
  '/profile': (BuildContext context) => ProfilePage(),
  '/icpd': (BuildContext context) => IcpdPage(),
};
