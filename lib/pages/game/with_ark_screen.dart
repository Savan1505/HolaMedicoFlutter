import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class WithARkitScreen extends StatefulWidget {
  @override
  _WithARkitScreenState createState() => _WithARkitScreenState();
}

class _WithARkitScreenState extends State<WithARkitScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  //UnityWidgetController _unityWidgetController;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(
            "Mentile",
            style: new TextStyle(color: Colors.white),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Text("Hello"),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }
}
