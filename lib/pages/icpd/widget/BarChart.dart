import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pharmaaccess/models/icpd_cme_plan_model.dart';

class GroupedBarChart extends StatelessWidget {
  final ScrollController _scrollController = new ScrollController();
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;
  final PlanList planListItem;

  GroupedBarChart(this.seriesList,
      {required this.animate, required this.planListItem});

  factory GroupedBarChart.withSampleData({required PlanList planList}) {
    return GroupedBarChart(
      _createSampleData(planList),
      animate: false,
      planListItem: planList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 1.9 * 40 * seriesList.first.data.length,
        child: charts.BarChart(
          seriesList,
          animate: animate,
          domainAxis: charts.OrdinalAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              labelStyle: charts.TextStyleSpec(fontSize: 10),
            ),
          ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              labelStyle: charts.TextStyleSpec(fontSize: 12),
            ),
          ),
          barGroupingType: charts.BarGroupingType.grouped,
          defaultRenderer: charts.BarRendererConfig(
            maxBarWidthPx: 10,
          ),
        ),
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<ChartData, String>> _createSampleData(
      PlanList planList) {
    final targetPlanCategory = [
      ChartData('Category i', planList.targetCategory1Points?.round() ?? 0),
      ChartData('Category ii', planList.targetCategory2Points?.round() ?? 0),
      ChartData('Category iii', planList.targetCategory3Points?.round() ?? 0),
    ];

    final currentPlanCategory = [
      ChartData('Category i', planList.currentCategory1Points?.round() ?? 0),
      ChartData('Category ii', planList.currentCategory2Points?.round() ?? 0),
      ChartData('Category iii', planList.currentCategory3Points?.round() ?? 0),
    ];

    final cappedPlanCategory = [
      ChartData('Category i', planList.cappedCategory1Points?.round() ?? 0),
      ChartData('Category ii', planList.cappedCategory2Points?.round() ?? 0),
      ChartData('Category iii', planList.cappedCategory3Points?.round() ?? 0),
    ];

    return [
      charts.Series<ChartData, String>(
        id: 'Target Plan Category',
        domainFn: (ChartData sales, _) => sales.xLabel,
        measureFn: (ChartData sales, _) => sales.sales,
        data: targetPlanCategory,
        colorFn: (ChartData sales, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff61A0D7)),
      ),
      charts.Series<ChartData, String>(
        id: 'Current Plan Category',
        domainFn: (ChartData sales, _) => sales.xLabel,
        measureFn: (ChartData sales, _) => sales.sales,
        data: currentPlanCategory,
        colorFn: (ChartData sales, index) =>
            charts.ColorUtil.fromDartColor(Color(0xffEE8336)),
      ),
      charts.Series<ChartData, String>(
        id: 'Capped Plan Category',
        domainFn: (ChartData sales, _) => sales.xLabel,
        measureFn: (ChartData sales, _) => sales.sales,
        data: cappedPlanCategory,
        colorFn: (ChartData sales, index) =>
            charts.ColorUtil.fromDartColor(Color(0xffDFDFDF)),
      ),
    ];
  }
}

class ChartData {
  final String xLabel;
  final int sales;

  ChartData(this.xLabel, this.sales);
}
