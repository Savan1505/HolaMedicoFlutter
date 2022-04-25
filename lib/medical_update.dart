import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmaaccess/models/news_item_model.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/screen_shot.dart';
import 'package:pharmaaccess/widgets/news_headline.dart';

import 'components/app_webview.dart';
import 'firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'firebase_analytics/FirebaseAnalyticsEventCall.dart';

class MedicalUpdate extends StatefulWidget {
  List<NewsModel> listNews;
  MyScreenUtil? myScreenUtil;

  MedicalUpdate({Key? key, required this.listNews, required this.myScreenUtil})
      : super(key: key);

  @override
  _MedicalUpdateState createState() => _MedicalUpdateState();
}

class _MedicalUpdateState extends State<MedicalUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: widget.listNews.length,
          itemBuilder: (BuildContext context, int index) {
            var news = widget.listNews[index];
            return Padding(
              padding: EdgeInsets.only(
                  top: (index == 0) ? 0 : 8,
                  bottom: (index == widget.listNews.length - 1) ? 0 : 8),
              child: NewsHeadlineItem(news, () async {
                await firebaseAnalyticsEventCall(NEWS_VISIT_EVENT,
                    param: {"name": "Medical Update"});
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => MyWebView(
                          title: "Healthcare News",
                          selectedUrl: news.externalUrl,
                        )));
              }, (GlobalKey _globalKey) async {
                if (await PermissionUtil.getStoragePermission(
                  context: context,
                  screenUtil: widget.myScreenUtil,
                )) {
                  var formatter = new DateFormat('MMMM dd, yyyy');
                  String filePath =
                      await saveScreenShot(_globalKey, news.title!);
                  shareOption(filePath, news.title!);
                }
              }, () {}),
            );
          }),
    );
  }
}
