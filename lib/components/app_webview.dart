import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../theme.dart';

class MyWebView extends StatelessWidget {
  final String? title;
  final String? selectedUrl;
  final bool? isQuizLanding;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  MyWebView(
      {required this.title, required this.selectedUrl, this.isQuizLanding});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
        backgroundColor: primaryColor,
      ),
      body: WebView(
        initialUrl: selectedUrl!,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var questions = await QuizService().getQuestions("Internal Medicine");
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (BuildContext context) =>
      //             QuizPage(category: "Internal Medicine", questions: questions),
      //       ),
      //     );
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
