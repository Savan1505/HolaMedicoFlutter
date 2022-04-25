import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmaaccess/models/news_item_model.dart';
import 'package:pharmaaccess/util/helper_functions.dart';

import '../theme.dart';

var formatter = new DateFormat('MMMM dd, yyyy');

class NewsHeadlineItem extends StatelessWidget {
  final NewsModel newsItem;
  final Function onPressed;
  final Function(GlobalKey) onPressedShare;
  final Function onPressedSave;

  NewsHeadlineItem(
    this.newsItem,
    this.onPressed,
    this.onPressedShare,
    this.onPressedSave,
  );

  GlobalKey _globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onPressed();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      width: double.maxFinite,
                      height: 180,
                      child: CachedNetworkImage(
                        imageUrl: newsItem.thumbnailUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          'assets/images/MedicalUpdate.jpg',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/MedicalUpdate.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    truncateWithEllipsis(80, newsItem.title!),
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    newsItem.category!.toUpperCase() +
                        " | " +
                        formatter.format(newsItem.publishDate!),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              getShareButton(),

              ///Todo: uncomment and implement save news
              //getSaveButton(),
            ],
          ),
        ],
      ));

  GestureDetector getSaveButton() => GestureDetector(
        onTap: () {
          onPressedSave();
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 10),
          child: Row(
            children: [
              Icon(
                Icons.bookmark_outline_rounded,
                color: Colors.black,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "SAVE",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );

  GestureDetector getShareButton() => GestureDetector(
        onTap: () async {
          onPressedShare(_globalKey);
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 10),
          child: Row(
            children: [
              Icon(
                Icons.share,
                color: Colors.black,
                size: 13,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "SHARE",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
}
