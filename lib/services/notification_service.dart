import 'package:pharmaaccess/apis/notification_provider.dart';
import 'package:pharmaaccess/models/NotificationModel.dart';

class NotificationService {
  final notificationProvider = NotificationProvider();

  Future<List<NotificationModel>?> getNotificationList() async {
    return await notificationProvider.getNotificationList();
  }
}
