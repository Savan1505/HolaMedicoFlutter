import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/theme.dart';

class CMEGuideLinesForUAE extends StatefulWidget {
  final String? countryName;

  const CMEGuideLinesForUAE({Key? key, this.countryName}) : super(key: key);

  @override
  _CMEGuideLinesForUAEState createState() => _CMEGuideLinesForUAEState();
}

class _CMEGuideLinesForUAEState extends State<CMEGuideLinesForUAE> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAnalyticsEventCall(ICPD_CME_GUIDELINES_SCREEN,
        param: {"name": "iCPD CME Guidelines Screen"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text(
          "CME Guide Lines for ${widget.countryName}",
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset('assets/images/temp_cme.png'),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/calender_icon.png',
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Last Updated: 1/Aug/2021",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff525151),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                style: TextStyle(
                  color: Color(0xff525151),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/link_icon.png',
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Link To The Source",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff525151),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
