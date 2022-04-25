const String EVENT_APP_LAUNCH = "app_launch";
const String EVENT_CALCULATOR = "calculator";

enum FirebaseAnalyticsEventsEnum { APP_LAUNCH, CALCULATOR }

extension EventEnumExtensions on FirebaseAnalyticsEventsEnum {
  String get name {
    switch (this) {
      case FirebaseAnalyticsEventsEnum.APP_LAUNCH:
        return EVENT_APP_LAUNCH;
      case FirebaseAnalyticsEventsEnum.CALCULATOR:
        return EVENT_CALCULATOR;
      default:
        return "";
    }
  }
}

extension EventEnumExtensionsVal on String {
  FirebaseAnalyticsEventsEnum authTypeVal() {
    switch (this) {
      case EVENT_APP_LAUNCH:
        return FirebaseAnalyticsEventsEnum.APP_LAUNCH;
      case EVENT_CALCULATOR:
        return FirebaseAnalyticsEventsEnum.CALCULATOR;

      default:
        return FirebaseAnalyticsEventsEnum.APP_LAUNCH;
    }
  }
}
