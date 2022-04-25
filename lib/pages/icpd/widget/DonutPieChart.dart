import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DonutPieChart extends StatelessWidget {
  final List<charts.Series<LinearSales, int>> seriesList;
  final bool? animate;
  final bool? isMedicalAct;
  final String? targetPoints;
  final String? currentPoints;

  DonutPieChart(this.seriesList,
      {this.animate, this.isMedicalAct, this.targetPoints, this.currentPoints});

  /// Creates a [PieChart] with sample data and no transition.
  factory DonutPieChart.withSampleData(
      {bool isMediAct = false,
      String targetPoint = "0",
      String currentPoint = "0"}) {
    return DonutPieChart(
      _createSampleData(targetPoint, currentPoint),
      animate: true,
      isMedicalAct: isMediAct,
      targetPoints: targetPoint,
      currentPoints: currentPoint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        charts.PieChart<int>(
          seriesList,
          animate: animate,
          animationDuration: Duration(milliseconds: 500),
          defaultRenderer: charts.ArcRendererConfig(
            arcWidth: isMedicalAct! ? 10 : 5,
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${currentPoints ?? "0"} of ",
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff525151),
                ),
              ),
              Text(
                targetPoints ?? "0",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData(
      String targetPoint, String currentPoint) {
    final data = [
      LinearSales(0, int.parse(currentPoint)),
      LinearSales(
          1,
          int.parse(currentPoint) == 0 && int.parse(targetPoint) == 0
              ? 1
              : int.parse(targetPoint) - int.parse(currentPoint)),
    ];

    return [
      charts.Series<LinearSales, int>(
        id: 'Points',
        domainFn: (LinearSales sales, _) => sales.index,
        measureFn: (LinearSales sales, _) => sales.value,
        colorFn: (LinearSales sales, index) => int.parse(currentPoint) != 0 &&
                int.parse(targetPoint) != 0 &&
                int.parse(currentPoint) <= int.parse(targetPoint)
            ? index == 0
                ? charts.ColorUtil.fromDartColor(Color(0xff01A601))
                : charts.ColorUtil.fromDartColor(Color(0xffDFDFDF))
            : charts.ColorUtil.fromDartColor(Color(0xffDFDFDF)),
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int index;
  final int value;

  LinearSales(this.index, this.value);
}
