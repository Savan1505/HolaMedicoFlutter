import 'package:flutter/material.dart';

class BarButton {
  const BarButton({this.label, this.icon, this.color, this.svgPath});
  final String? label;
  final IconData? icon;
  final Color? color;
  final String? svgPath;
}

const List<BarButton> guestDestinations = <BarButton>[
  BarButton(label: 'Home', svgPath: 'assets/images/icon_homepage.svg'),
  BarButton(label: 'Brands', svgPath: 'assets/images/icon_brand.svg'),
  BarButton(label: 'Socrates', svgPath: 'assets/images/icon_quiz.svg'),
  BarButton(label: 'Cerebrum', svgPath: 'assets/images/icon_game.svg'),
  //BarButton(title: 'Search', Icons.search,Colors.red),
  //BarButton(title: 'More', Icons.more_horiz, Colors.red),
];

const List<BarButton> registeredDestinations = <BarButton>[
  BarButton(label: 'Brands', svgPath: 'assets/images/icon_brand.svg'),
  BarButton(label: 'Socrates', svgPath: 'assets/images/icon_quiz.svg'),
  BarButton(label: 'Home', svgPath: 'assets/images/icon_homepage.svg'),
  BarButton(label: 'Clubs', svgPath: 'assets/images/icon_club.svg'),
  BarButton(label: 'Cerebrum', svgPath: 'assets/images/icon_game.svg'),
  //BarButton(title: 'Search', Icons.search,Colors.red),
  //BarButton(title: 'More', Icons.more_horiz, Colors.red),
];

const List<BarButton> drawerItems = <BarButton>[
  BarButton(label: "Home", icon: Icons.home),
  BarButton(
    label: "Profile",
    icon: Icons.person_outline,
  ),
  BarButton(label: "Contact us", icon: Icons.send),
];
