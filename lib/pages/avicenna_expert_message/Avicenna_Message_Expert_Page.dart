import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/components/app_webview.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/news_item_model.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/services/news_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/util/screen_shot.dart';
import 'package:pharmaaccess/widgets/news_headline.dart';

class AvicennaMessageExpertPage extends StatefulWidget {
  final String? titleName;
  final int? categoryId;

  const AvicennaMessageExpertPage({
    Key? key,
    this.titleName,
    this.categoryId,
  }) : super(key: key);

  @override
  _AvicennaMessageExpertPageState createState() =>
      _AvicennaMessageExpertPageState();
}

class _AvicennaMessageExpertPageState extends State<AvicennaMessageExpertPage> {
  ScrollController _scrollController = new ScrollController();
  late NewsService newsService;
  StreamController<bool> showProgressStreamController =
      StreamController.broadcast();
  StreamController<NewsData?> newsListStreamController =
      StreamController<NewsData?>.broadcast();
  StreamController<bool> newsErrorStreamController =
      StreamController<bool>.broadcast();
  bool isErrorInNewsFetching = false;
  int scrollProgress = 0;
  bool loadNextPage = false;
  MyScreenUtil? myScreenUtil;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsService = NewsService();
    newsListStreamController = StreamController<NewsData?>.broadcast();
    newsErrorStreamController = StreamController<bool>.broadcast();
    callAPI();
  }

  @override
  Widget build(BuildContext context) {
    myScreenUtil = getScreenUtilInstance(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          widget.titleName ?? "Avicenna",
        ),
      ),
      body: Column(
        children: [
          avicennaHeaderMessage(),
          Expanded(
            child: StreamBuilder<bool>(
              initialData: isErrorInNewsFetching,
              stream: newsErrorStreamController.stream,
              builder: (context, snapshot) {
                return isErrorInNewsFetching
                    ? newsError()
                    : StreamBuilder<NewsData?>(
                        stream: newsListStreamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return newsList(
                              snapshot.data!.newsModel,
                              snapshot.data!.total,
                            );
                          } else {
                            return loading();
                          }
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget newsError() => Center(
      child: Text(widget.categoryId == 1
          ? "Cannot fetch avicenna"
          : "Cannot fetch message from expert"));

  Widget avicennaHeaderMessage() => Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to ", style: TextStyle(fontSize: 16)),
            Text(widget.categoryId == 1 ? "Avicenna" : "Message from Expert",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      );

  Widget newsList(List<NewsModel>? data, int total) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        int progress = 0;
        if (notification.metrics.pixels != 0 &&
            notification.metrics.maxScrollExtent != 0) {
          progress = ((notification.metrics.pixels /
                      notification.metrics.maxScrollExtent) *
                  100)
              .toInt();
        }

        if (progress != scrollProgress) {
          scrollProgress = progress;
          if (data != null) {
            setLastPage(data, total);
          }
          if (loadNextPage && scrollProgress == 100) {
            callAPI();
          }
        }
        return true;
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ...data!
                    .map(
                      (news) => Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: NewsHeadlineItem(news, () async {
                          await firebaseAnalyticsEventCall(
                              NEWS_AVICENNA_VISIT_EVENT,
                              param: {"name": "Healthcare Visit"});
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => MyWebView(
                                title: "Healthcare News",
                                selectedUrl: news.externalUrl,
                              ),
                            ),
                          );
                        }, (GlobalKey _globalKey) async {
                          if (await PermissionUtil.getStoragePermission(
                            context: context,
                            screenUtil: myScreenUtil,
                          )) {
                            String filePath =
                                await saveScreenShot(_globalKey, news.title!);
                            shareOption(filePath,
                                news.title! + "\n" + news.externalUrl!);
                          }
                        }, () {}),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<bool>(
              initialData: loadNextPage,
              stream: showProgressStreamController.stream,
              builder: (context, snapshot) => Padding(
                padding: const EdgeInsets.only(bottom: 45.0),
                child: getLoadingPaginationWidget(snapshot),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loading() {
    return Center(
      child: Container(
        height: 80,
        width: 80,
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      ),
    );
  }

  void setLastPage(List<NewsModel>? data, int total) {
    loadNextPage = (total > data!.length);
    if (!showProgressStreamController.isClosed) {
      showProgressStreamController.add(loadNextPage);
    }
  }

  void callAPI() async {
    int pageNo = 0;
    NewsData? newsModel = widget.categoryId == 1
        ? await newsService.getNewsForAvicenna(++pageNo, widget.categoryId ?? 1)
        : await newsService.getNewsForMessageExpert(
            ++pageNo, widget.categoryId ?? 1);
    if (newsModel != null && !newsListStreamController.isClosed) {
      newsListStreamController.add(newsModel);
    } else {
      isErrorInNewsFetching = true;
      if (!newsErrorStreamController.isClosed) {
        newsErrorStreamController.add(isErrorInNewsFetching);
      }
    }
  }

  Widget getLoadingPaginationWidget(AsyncSnapshot<bool> snapshot) {
    if (!snapshot.data!) {
      return SizedBox();
    }
    return Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }
}
