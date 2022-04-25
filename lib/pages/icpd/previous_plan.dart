import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/icpd_cme_plan_model.dart';
import 'package:pharmaaccess/pages/icpd/widget/BarChart.dart';
import 'package:pharmaaccess/pages/icpd/widget/DonutPieChart.dart';
import 'package:pharmaaccess/services/icpd_service.dart';
import 'package:pharmaaccess/theme.dart';

class PreviousPlan extends StatefulWidget {
  const PreviousPlan({
    Key? key,
  }) : super(key: key);

  @override
  _PreviousPlanState createState() => _PreviousPlanState();
}

class _PreviousPlanState extends State<PreviousPlan> {
  IcpdService icpdService = IcpdService();
  List<PlanList> alPlanList = [];
  bool _loading = true;
  PlanList planListItem = new PlanList();
  int remainingPoints = 0;
  String beForeDate = "";

  @override
  void initState() {
    super.initState();
    firebaseAnalyticsEventCall(ICPD_PREVIOUS_PLAN_SCREEN,
        param: {"name": "iCPD Previous Plan Screen"});
    _loading = true;
    _getPreviousPlanListAPI();
  }

  void _getPreviousPlanListAPI() async {
    List<PlanList> alPlanListData =
        await icpdService.getPreviousPlanList() ?? [];
    if (alPlanListData.isNotEmpty && alPlanListData.length > 0) {
      for (PlanList planList in alPlanListData) {
        if (planList.name == "License Renewal CME") {
          /*int? targetPoints = planList.targetPoints;
          int? currentPoints = planList.currentPoints;
          remainingPoints = targetPoints! - currentPoints!;
          DateTime beforeDateFormat =
              new DateFormat("yyyy-MM-dd").parse(planList.licenseExpiryDate!);
          beForeDate = DateFormat("dd-MMM-yy").format(beforeDateFormat);
          planListItem = planList;*/
          alPlanList = alPlanListData.reversed.toList();
        }
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("My Previous License Renewal Plan"),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : alPlanList.isNotEmpty && alPlanList.length > 0
              ? _getBodyPlanTracker()
              : Container(
                  alignment: Alignment.center,
                  child: Text(
                    "No archived plans found!",
                    style: TextStyle(
                      color: Color(0xffD3D2D2),
                    ),
                  ),
                ),
    );
  }

  Widget chart(PlanList planListItem) {
    int targetPoints = planListItem.targetPoints?.round() ?? 0;
    int currentPoints = planListItem.cappedPoints?.round() ?? 0;
    // int currentPoints = planListItem.currentPoints ?? 0;
    int remainingPoints = targetPoints - currentPoints;
    DateTime beforeDateFormat =
        new DateFormat("yyyy-MM-dd").parse(planListItem.licenseExpiryDate!);
    String beForeDate = DateFormat("dd-MMM-yy").format(beforeDateFormat);
    return Visibility(
      visible: planListItem.name == "License Renewal CME",
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                "My Previous Plan Summary",
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff525151),
                ),
              ),
              Flexible(
                flex: 4,
                child: GroupedBarChart.withSampleData(
                  planList: planListItem,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    legend(
                      "Planned",
                      Color(0xff61A0D7),
                    ),
                    legend(
                      "Achieved",
                      Color(0xffEE8336),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: DonutPieChart.withSampleData(
                    targetPoint: planListItem.targetPoints!.round().toString(),
                    currentPoint:
                        planListItem.cappedPoints!.round().toString()),
                // currentPoint: planListItem.currentPoints.toString()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Remaining Points: ",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xff525151),
                    ),
                  ),
                  Text(
                    remainingPoints.toString(),
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Text(
                "Before: $beForeDate",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff525151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*Widget chart() => Visibility(
        visible: planListItem.name == "License Renewal CME",
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Row(
                children: [
                  Flexible(
                    flex: 10,
                    child: Column(
                      children: [
                        Text(
                          "My Previous Plan Summary",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff525151),
                          ),
                        ),
                        Flexible(
                          child: GroupedBarChart.withSampleData(
                            planList: planListItem,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              legend(
                                "Planned",
                                Color(0xff61A0D7),
                              ),
                              legend(
                                "Achieved",
                                Color(0xffEE8336),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Flexible(
                    flex: 5,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 8,
                          child: DonutPieChart.withSampleData(
                              targetPoint: planListItem.targetPoints.toString(),
                              currentPoint:
                                  planListItem.currentPoints.toString()),
                        ),
                        Flexible(
                          flex: 4,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Remaining Points: ",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xff525151),
                                      ),
                                    ),
                                    Text(
                                      remainingPoints.toString(),
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Before: $beForeDate",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff525151),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );*/

  Widget legend(String text, Color color) => Row(
        children: [
          Container(
            height: 13.0,
            width: 13.0,
            color: color,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.0,
              color: Color(0xff525151),
            ),
          ),
        ],
      );

  Widget _getBodyPlanTracker() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: alPlanList.length,
      itemBuilder: (context, index) {
        planListItem = alPlanList[index];
        int targetPoints = planListItem.targetPoints?.round() ?? 0;
        int currentPoints = planListItem.cappedPoints?.round() ?? 0;
        remainingPoints = targetPoints - currentPoints;
        DateTime beforeDateFormat =
            new DateFormat("yyyy-MM-dd").parse(planListItem.licenseExpiryDate!);
        beForeDate = DateFormat("dd-MMM-yy").format(beforeDateFormat);
        return previousPlanItem(alPlanList[index]);
      },
    );
    /*return SingleChildScrollView(
      child: Container(
        child: Visibility(
          visible: planListItem.name == "License Renewal CME",
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: chart(),
                ),
              ],
            ),
          ),
        ),
      ),
    );*/
  }

  Widget previousPlanItem(PlanList planList) => InkWell(
        onTap: () async {
          await _showDialogPreviousPlan(planList);
        },
        child: Container(
          color: Color(0X66e1e1e1),
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                planListItem.name!.isEmpty
                    ? "-NA-"
                    : planListItem.name ?? "-NA-",
                style: TextStyle(
                    color: Color(0xff686767),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                DateFormat("dd-MMM-yy").format(DateFormat("yyyy-MM-dd")
                    .parse(planListItem.licenseExpiryDate!)),
                style: TextStyle(color: Color(0xff686767), fontSize: 14),
              ),
              Text(
                "Remaining Points: $remainingPoints",
                style: TextStyle(color: Color(0xff686767), fontSize: 14),
              ),
              Text(
                planListItem.comments!.isEmpty
                    ? "-NA-"
                    : planListItem.comments ?? "-NA-",
                style: TextStyle(color: Color(0xff686767), fontSize: 14),
              ),
            ],
          ),
        ),
      );

  _showDialogPreviousPlan(PlanList planListItem) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.all(10.0),
            content: Container(
              margin: EdgeInsets.only(left: 0.0, right: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 13.0, right: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: chart(planListItem)),
                  Positioned(
                    right: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
