import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
final FirebaseAnalytics medicoFirebaseAnalytics = FirebaseAnalytics.instance;
final CustomFirebaseAnalyticsObserver firebaseAnalyticsObserver =
    CustomFirebaseAnalyticsObserver(analytics: medicoFirebaseAnalytics);

class CustomFirebaseAnalyticsObserver
    extends RouteObserver<PageRoute<dynamic>> {
  CustomFirebaseAnalyticsObserver({
    required this.analytics,
  });

  final FirebaseAnalytics analytics;

  void _sendScreenView(PageRoute<dynamic> route) {
    final String? screenName = route.settings.name;
    if (screenName != null) {
      analytics.setCurrentScreen(
          screenName: screenName, screenClassOverride: screenName);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
