import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pharmaaccess/models/NotificationModel.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/services/notification_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/ShowSnackBar.dart';

class NotificationPage extends StatefulWidget {
  String? countryName;

  NotificationPage({Key? key, this.countryName}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late MyScreenUtil screenUtil;
  StreamController<List<NotificationModel>?> notificationStreamController =
      StreamController<List<NotificationModel>?>.broadcast();

  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    getNotificationApiCall();
  }

  Future<void> getNotificationApiCall() async {
    List<NotificationModel>? notificationList =
        await notificationService.getNotificationList();
    if (notificationList != null) {
      notificationStreamController.add(notificationList);
    } else {
      showSnackBar(context, INTERNAL_SERVER_ERROR);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenUtil = getScreenUtilInstance(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Notification'),
      ),
      body: StreamBuilder<List<NotificationModel>?>(
        stream: notificationStreamController.stream,
        initialData: [],
        builder: (context, snapshot) => ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: (index == 0) ? 15 : 5,
                bottom: (index == (snapshot.data!.length - 1)) ? 15 : 5,
              ),
              child: getItem(snapshot.data![index]),
            );
          },
        ),
      ),
    );
  }

  Widget getItem(NotificationModel model) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenUtil.setHeight(10) as double),
        color: Colors.white,
      ),
      child: Material(
        child: InkWell(
          borderRadius:
              BorderRadius.circular(screenUtil.setHeight(10) as double),
          onTap: () async {
            if (model.data != null && model.data!.isNotEmpty) {
              await canLaunch(model.data!.first.value!)
                  ? await launch(model.data!.first.value!)
                  : showSnackBar(
                      context,
                      'Could not launch ${model.data!.first.value}',
                    );
            }
          },
          child: Container(
            padding: EdgeInsets.only(
              bottom: screenUtil.setHeight(10) as double,
              left: screenUtil.setWidth(10) as double,
              top: screenUtil.setHeight(10) as double,
              right: screenUtil.setWidth(10) as double,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(screenUtil.setHeight(10) as double),
              border: Border.all(color: Colors.grey[200]!),
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title!,
                  style: styleBoldBodyText,
                ),
                SizedBox(
                  height: screenUtil.setHeight(5) as double?,
                ),
                Text(
                  model.body!,
                  style: getTextStyleMutedTextSmall(screenUtil),
                ),
                // SizedBox(
                //   height: screenUtil.setHeight(3) as double?,
                // ),
                // Text(
                //   DateFormat('dd MMM yyyy h:mm a').format(DateTime.now()),
                //   style: getTextStyleMutedTextSmall(screenUtil),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM  hh:mm a').format(now);
    return formattedDate;
  }

  @override
  void dispose() {
    notificationStreamController.close();
    super.dispose();
  }
}
