import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pharmaaccess/theme.dart';

class QuizQuotaWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Divider(height: 52, color: Color(0x00FFFFFF),),
              Image.asset("assets/images/quiz_result.png", width: 180),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Divider(height: 20, color: Color(0x00FFFFFF)),
                    Text("Thank you for participating in the quiz", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Divider(height: 20, color: Color(0x00FFFFFF)),
                    Text("Looking forward to see you tomorrow", style: TextStyle(fontSize: 18, color: bodyTextColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
