import 'dart:core';

import 'CustomFirebaseAnalyticsObserver.dart';

Future<void> firebaseAnalyticsEventCall(String eventName,
    {Map<String, dynamic> param = const {}}) async {
  await medicoFirebaseAnalytics.logEvent(
    name: eventName,
    parameters: param,
  );
}
