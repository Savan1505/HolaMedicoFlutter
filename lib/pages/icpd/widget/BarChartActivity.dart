import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:pharmaaccess/models/icpd_activity_resp_model.dart';

class GroupedBarChartActivity extends StatelessWidget {
  final ScrollController _scrollController = new ScrollController();
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;
  final List<ActivityListItem> alActivityListItem;
  final String selectedDate;

  GroupedBarChartActivity(
    this.seriesList, {
    required this.animate,
    required this.selectedDate,
    required this.alActivityListItem,
  });

  factory GroupedBarChartActivity.withSampleData(
      {required String currentDate,
      required List<ActivityListItem> alActivityList}) {
    return GroupedBarChartActivity(
      _createSampleData(currentDate, alActivityList),
      animate: false,
      selectedDate: currentDate,
      alActivityListItem: alActivityList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 2.9 * 100 * seriesList.first.data.length,
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
      String selectedDate, List<ActivityListItem> alActivityList) {
    var dateFormat = new DateFormat('yyyy-MM-dd');
    var dateTimeStart;

    List<ActivityListItem> alActivityDraft = [];
    List<ActivityListItem> alActivityDone = [];
    for (ActivityListItem activityItem in alActivityList) {
      dateTimeStart = DateTime.parse(activityItem.start ?? "");
      var startDate = dateFormat.format(dateTimeStart);
      if (startDate == selectedDate) {
        if (activityItem.state == "draft") {
          alActivityDraft.add(activityItem);
        } else {
          alActivityDone.add(activityItem);
        }
      }
    }
    final targetPlanCategory = [
      ChartData('', alActivityDraft.length),
    ];

    final currentPlanCategory = [
      ChartData('', alActivityDone.length),
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
    ];
  }
}

class ChartData {
  final String xLabel;
  final int sales;

  ChartData(this.xLabel, this.sales);
}
