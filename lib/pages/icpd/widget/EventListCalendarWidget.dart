import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/icpd_activity_resp_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class EventListCalendarWidget extends CalendarDataSource {
  /// Creates a event data source, which used to set the appointment
  /// collection to the calendar
  EventListCalendarWidget(List<ActivityListItem> alEventActivity) {
    appointments = alEventActivity;
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(_getActivityListItem(index).start ?? "");
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(_getActivityListItem(index).start ?? "");
  }

  @override
  String getSubject(int index) {
    return _getActivityListItem(index).name ?? "";
  }

  @override
  Color getColor(int index) {
    return Colors.orange;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  ActivityListItem _getActivityListItem(int index) {
    final dynamic eventActivity = appointments![index];
    late final ActivityListItem eventActItem;
    if (eventActivity is ActivityListItem) {
      eventActItem = eventActivity;
    }
    return eventActItem;
  }
}
