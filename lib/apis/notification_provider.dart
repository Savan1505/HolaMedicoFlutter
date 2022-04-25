import 'package:pharmaaccess/models/NotificationModel.dart';

import './auth_provider.dart';

class NotificationProvider {
  final AuthProvider authProvider = AuthProvider();

  Future<List<NotificationModel>?> getNotificationList() async {
    try {
      var response =
          await authProvider.client.callController("/app/notification", {});

      if (response == null) {
        return null;
      }
      if (!response.hasError()) {
        var result = response.getResult();

        var notificationList = result.map<NotificationModel>((json) {
          return NotificationModel.fromJson(json);
        }).toList();
        return notificationList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
