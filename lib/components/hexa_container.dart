import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class HexagonContainer extends StatelessWidget {
  final Widget childWidget;
  final double? borderWidth;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPolygon(
          sides: 6,
          borderRadius: 5.0, // Default 0.0 degrees
          rotate: 90.0, // Default 0.0 degrees
          child: Container(color: borderColor),
        ),
        Container(
          margin: EdgeInsets.all(borderWidth!),
          child: ClipPolygon(
            sides: 6,
            borderRadius: 5.0, // Default 0.0 degrees
            rotate: 90.0, // Default 0.0 degrees
            child: Container(child: childWidget,),
          ),
        ),
      ],
    );
  }

  HexagonContainer({required this.childWidget,this.borderColor,this.borderWidth});
}
