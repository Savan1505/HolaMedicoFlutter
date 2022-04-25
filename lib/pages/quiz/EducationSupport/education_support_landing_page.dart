import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/components/app_webview.dart';
import 'package:pharmaaccess/services/education_support_service.dart';

import '../../../theme.dart';

class EducationSupportLandingPage extends StatelessWidget {
  final EducationSupportService educationSupportService =
      EducationSupportService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Socrates"),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 32),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 40,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Center(
                    child: Text("Please choose any one option:",
                        style: styleNormalBodyText)),
              ),
              Expanded(
                child: FutureBuilder<List<String>>(
                    future: educationSupportService
                        .getEducationSupportWebinarCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  return EducationSupportContainerMRCP(
                                    category: snapshot.data![0],
                                  );
                                }
                                return EducationSupportContainerDyslipidemia(
                                  category: snapshot.data![1],
                                );
                              }),
                        );
                      }
                      return Container();
                    }),
              ),
            ],
          )),
    );
  }
}

class EducationSupportContainerMRCP extends StatelessWidget {
  final String category;
  EducationSupportContainerMRCP({Key? key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MyWebView(
                  title: "MRCP",
                  selectedUrl:
                      'https://content.pharmaaccess.com/static/mrcp/home.html',
                )));
      },
      child: EducationSupportCategoryWidget(
        first: Text(category,
            style: TextStyle(color: bodyTextColor, fontSize: 13)),
        second: Text(""),
      ),
    );
  }
}

class EducationSupportContainerDyslipidemia extends StatelessWidget {
  final String category;
  EducationSupportContainerDyslipidemia({Key? key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MyWebView(
                  title: "Dyslipidemia",
                  selectedUrl:
                      'https://content.pharmaaccess.com/static/dyslipidemia/Dyslipidemia.html',
                )));
      },
      child: EducationSupportCategoryWidget(
        first: Text(category,
            style: TextStyle(color: bodyTextColor, fontSize: 14)),
        second: Text(""),
      ),
    );
  }
}

class EducationSupportCategoryWidget extends StatelessWidget {
  final Widget? first;
  final Widget? second;

  EducationSupportCategoryWidget({
    Key? key,
    this.first,
    this.second,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 6,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 52,
      decoration: softCardShadow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          first!,
          second!,
        ],
      ),
    );
  }
}
