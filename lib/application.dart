import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pharmaaccess/services/auth_service.dart';
import 'package:pharmaaccess/services/profile_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:provider/provider.dart';

import 'firebase_analytics/CustomFirebaseAnalyticsObserver.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class Application extends StatelessWidget {
  Application({Key? key, this.initialRoute, this.authService, this.routes})
      : super(key: key);
  final AuthService? authService;
  final String? initialRoute;
  final Map<String, WidgetBuilder>? routes;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => authService!),
        Provider<ProfileService>(create: (_) => ProfileService()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hola Medico',
          navigatorObservers: [routeObserver, firebaseAnalyticsObserver],
          theme: ThemeData(
            primaryColor: Color(0xFF6F706F),
            accentColor: primaryColor,
            backgroundColor: Colors.white,
            fontFamily: 'Roboto',
            textTheme: ThemeData(
                    textTheme: TextTheme(
                        headline4: TextStyle(
                          fontSize: 20,
                        ),
                        headline3: TextStyle(
                          fontSize: 26,
                        ))).textTheme.apply(
                  bodyColor: Color(0xff525151),
                  displayColor: Color(0xff525151),
                ),
          ),
          initialRoute: initialRoute,
          routes: routes!,
        ),
      ),
    );
  }
}
