import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/PopupItem.dart';
import 'package:pharmaaccess/models/icpd_catalog_resp_model.dart';
import 'package:pharmaaccess/models/icpd_cme_plan_model.dart';
import 'package:pharmaaccess/pages/icpd/EventDetailScreen.dart';
import 'package:pharmaaccess/pages/icpd/recommend_cme_activity.dart';
import 'package:pharmaaccess/services/icpd_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/widgets/icon_full_button.dart';

class CmeCatalogPage extends StatefulWidget {
  final int? planTypeIndex;
  final List<PlanList>? planTypeItem;
  final String? titleName;
  final String? countryName;

  const CmeCatalogPage(
      {Key? key,
      this.planTypeIndex,
      this.titleName,
      this.countryName,
      this.planTypeItem})
      : super(key: key);

  @override
  _CmeCatalogPageState createState() => _CmeCatalogPageState();
}

class _CmeCatalogPageState extends State<CmeCatalogPage> {
  ScrollController _scrollController = new ScrollController();
  IcpdService icpdService = IcpdService();
  Widget futureWidget = Container();
  List<PopupItem> filterMenuItem = [
    PopupItem("1", "Cost Only"),
    PopupItem("2", "Free of Cost"),
    // PopupItem("3", "Points Categories"),
    PopupItem("3", "Type"),
    PopupItem("4", "Target Audience"),
    PopupItem("5", "Date"),
  ];
  List<String> alTargetAudience = [];
  List<CatalogList> alCatalog = [];
  List<CatalogList> alCatalogCost = [];
  List<CatalogList> alCatalogFree = [];
  List<CatalogList> alCatalogTargetAudience = [];
  List<CatalogList> alCatalogFilterTargetAudience = [];
  bool _loading = true;
  bool isAscDate = true;
  int selectedTargetAudience = 0;
  StreamController<int> selectedTargetAudiStreamController =
      StreamController<int>.broadcast();

  @override
  void initState() {
    firebaseAnalyticsEventCall(ICPD_CME_CATALOG_SCREEN,
        param: {"name": "iCPD CME Catalog Screen"});
    _loading = true;
    getAllCatalogList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColor,
          title: Text(
            widget.titleName ?? "CME Catalog",
          ),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : (alCatalogFilterTargetAudience.length > 0 ||
                        alCatalog.length > 0) &&
                    !_loading
                ? Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 0.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Events List",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff525151),
                                  ),
                                ),
                                PopupMenuButton(
                                  icon: Image.asset(
                                    "assets/icon/filter_icon.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  enabled: true,
                                  onSelected: (value) {
                                    setState(() {
                                      actionPopUpItemSelected(value.toString());
                                    });
                                  },
                                  itemBuilder: (context) {
                                    return filterMenuItem
                                        .map((PopupItem choice) {
                                      return filterCatalogListMenu(
                                          choice.key ?? "", choice.value ?? "");
                                    }).toList();
                                  },
                                  // onSelected: (String value) => actionPopUpItemSelected(valu),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 1.5,
                            child: Divider(
                              thickness: 1.5,
                              color: Color(0xffDBDBDB),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: ListView.separated(
                                padding: EdgeInsets.only(bottom: 110.0),
                                shrinkWrap: true,
                                itemCount:
                                    alCatalogFilterTargetAudience.length > 0
                                        ? alCatalogFilterTargetAudience.length
                                        : alCatalog.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        InkWell(
                                  onTap: () async {
                                    var catalogList =
                                        alCatalogFilterTargetAudience.length > 0
                                            ? alCatalogFilterTargetAudience[
                                                index]
                                            : alCatalog[index];
                                    await firebaseAnalyticsEventCall(
                                        ICPD_CME_CATALOG_SCREEN,
                                        param: {
                                          "name": "iCPD CME Catalog List"
                                        });
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EventDetailScreen(
                                          catalogList: catalogList,
                                          planTypeIndex: widget.planTypeIndex,
                                          countryName: widget.countryName,
                                          planTypeItem: widget.planTypeItem,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 20.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color(0xffF7F7F7),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                alCatalogFilterTargetAudience
                                                            .length >
                                                        0
                                                    ? alCatalogFilterTargetAudience[
                                                                index]
                                                            .name ??
                                                        ""
                                                    : alCatalog[index].name ??
                                                        "",
                                                style: TextStyle(
                                                  color: Color(0xff525151),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "\$ ${alCatalogFilterTargetAudience.length > 0 ? alCatalogFilterTargetAudience[index].cost ?? "" : alCatalog[index].cost ?? ""}",
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          alCatalogFilterTargetAudience.length >
                                                  0
                                              ? alCatalogFilterTargetAudience[
                                                          index]
                                                      .eventCategoryName ??
                                                  "- NA -"
                                              : alCatalog[index]
                                                      .eventCategoryName ??
                                                  "- NA -",
                                          style: TextStyle(
                                            color: Color(0xff525151),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          alCatalogFilterTargetAudience.length >
                                                  0
                                              ? alCatalogFilterTargetAudience[
                                                          index]
                                                      .description ??
                                                  "- NA -"
                                              : alCatalog[index].description ??
                                                  "- NA -",
                                          style: TextStyle(
                                            color: Color(0xff525151),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          getStartDate(
                                              alCatalogFilterTargetAudience
                                                          .length >
                                                      0
                                                  ? alCatalogFilterTargetAudience[
                                                              index]
                                                          .start ??
                                                      ""
                                                  : alCatalog[index].start ??
                                                      ""),
                                          style: TextStyle(
                                            color: Color(0xff525151),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: IconFullButton(
                                  label: "Recommend Activity",
                                  iconPath: "assets/icon/recommended_icon.png",
                                  onPressed: () async {
                                    await firebaseAnalyticsEventCall(
                                        ICPD_CME_CATALOG_SCREEN,
                                        param: {"name": "Recommend Activity"});
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            RecommendCmeActivity(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 0.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Events List",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff525151),
                                  ),
                                ),
                                PopupMenuButton(
                                  icon: Image.asset(
                                    "assets/icon/filter_icon.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  enabled: true,
                                  onSelected: (value) {
                                    setState(() {
                                      actionPopUpItemSelected(value.toString());
                                    });
                                  },
                                  itemBuilder: (context) {
                                    return filterMenuItem
                                        .map((PopupItem choice) {
                                      return filterCatalogListMenu(
                                          choice.key ?? "", choice.value ?? "");
                                    }).toList();
                                  },
                                  // onSelected: (String value) => actionPopUpItemSelected(valu),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 1.5,
                            child: Divider(
                              thickness: 1.5,
                              color: Color(0xffDBDBDB),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "No event!",
                                  style: TextStyle(
                                    color: Color(0xff525151),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: IconFullButton(
                                  label: "Recommend Activity",
                                  iconPath: "assets/icon/recommended_icon.png",
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            RecommendCmeActivity(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      );

  getAllCatalogList() async {
    alCatalogCost = [];
    alCatalog = await icpdService.getCMECatalogList() ?? [];
    setState(() {
      _loading = false;
    });
    /*return FutureBuilder<List<CatalogList>?>(
        future: icpdService.getCMECatalogList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 23.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Events List",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff525151),
                            ),
                          ),
                          PopupMenuButton(
                            icon: Image.asset(
                              "assets/icon/filter_icon.png",
                              height: 20,
                              width: 20,
                            ),
                            enabled: true,
                            onSelected: (value) {
                              setState(() {
                                actionPopUpItemSelected(value.toString());
                              });
                            },
                            itemBuilder: (context) {
                              return filterMenuItem.map((PopupItem choice) {
                                return filterCatalogListMenu(
                                    choice.key ?? "", choice.value ?? "");
                              }).toList();
                            },
                            // onSelected: (String value) => actionPopUpItemSelected(valu),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.5,
                      child: Divider(
                        thickness: 1.5,
                        color: Color(0xffDBDBDB),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.only(bottom: 110.0),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              InkWell(
                            onTap: () {
                              var catalogList = snapshot.data?[index];
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EventDetailScreen(
                                    catalogList: catalogList,
                                    planTypeIndex: widget.planTypeIndex,
                                    countryName: widget.countryName,
                                    planTypeItem: widget.planTypeItem,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 20.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffF7F7F7),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        snapshot.data?[index].name ?? "",
                                        style: TextStyle(
                                          color: Color(0xff525151),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "\$ ${snapshot.data?[index].cost ?? ""}",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    snapshot.data?[index].eventCategoryName ??
                                        "- NA -",
                                    style: TextStyle(
                                      color: Color(0xff525151),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    snapshot.data?[index].description ??
                                        "- NA -",
                                    style: TextStyle(
                                      color: Color(0xff525151),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    getStartDate(
                                        snapshot.data?[index].start ?? ""),
                                    style: TextStyle(
                                      color: Color(0xff525151),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: IconFullButton(
                            label: "Recommend Activity",
                            iconPath: "assets/icon/recommended_icon.png",
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RecommendCmeActivity(),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            return Center(child: Text("Can't fetch the CME Catalog events"));
          }
          return Center(child: CircularProgressIndicator());
        });*/
  }

  String getStartDate(String startDate) {
    var dateFormat = new DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dateTime = dateFormat.parse(startDate);
    String formattedDate = DateFormat('dd/MM/yyyy, hh:mm a').format(dateTime);
    return formattedDate;
  }

  PopupMenuItem filterCatalogListMenu(String value, String name) {
    return PopupMenuItem(
      value: value,
      child: Text(name),
    );
  }

  void actionPopUpItemSelected(String value) async {
    alCatalogFilterTargetAudience = [];
    if (value != "4") {
      _loading = true;
      await getAllCatalogList();
    }
    switch (value) {
      case "1":
        for (CatalogList catalogList in alCatalog) {
          if (catalogList.cost! > 0) {
            alCatalogCost.add(catalogList);
          } else {
            alCatalog = [];
          }
        }
        if (alCatalogCost.isNotEmpty && alCatalogCost.length > 0) {
          alCatalog = [];
          alCatalog.addAll(alCatalogCost);
        }
        break;
      case "2":
        for (CatalogList catalogList in alCatalog) {
          if (catalogList.cost! <= 0) {
            alCatalogFree.add(catalogList);
          } else {
            alCatalog = [];
          }
        }
        if (alCatalogFree.isNotEmpty && alCatalogFree.length > 0) {
          alCatalog = [];
          alCatalog.addAll(alCatalogFree);
        }
        break;
      case "3":
        alCatalog.sort(
            (b, a) => a.eventCategoryName!.compareTo(b.eventCategoryName!));
        break;
      case "4":
        alCatalogTargetAudience = [];
        alTargetAudience = [];
        showSelectTargetAudience();
        //alCatalog.sort((b, a) => a.cost!.compareTo(b.cost!));
        break;
      case "5":
        if (isAscDate) {
          isAscDate = false;
          alCatalog.sort((a, b) => a.start!.compareTo(b.start!));
        } else {
          isAscDate = true;
          alCatalog.sort((b, a) => a.start!.compareTo(b.start!));
        }
        break;
      /*case "6":
        alCatalog.sort((b, a) => a.cost!.compareTo(b.cost!));
        break;*/
    }
  }

  showSelectTargetAudience() {
    // selectedPlan = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        for (CatalogList catalogList in alCatalog) {
          if (catalogList.targetAudience != null) {
            alCatalogTargetAudience.add(catalogList);
            String targetAudience =
                catalogList.targetAudience.toString().replaceAll(".", "");
            alTargetAudience.addAll(targetAudience.split(","));
            alTargetAudience =
                LinkedHashSet<String>.from(alTargetAudience).toList();
          }
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Target Audience",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xff525151),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          /*Navigator.of(context, rootNavigator: true)
                              .pop('dialog');*/
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "X",
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  StreamBuilder<int>(
                    initialData: selectedTargetAudience,
                    stream: selectedTargetAudiStreamController.stream,
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return Column(
                          children: [
                            for (int index = 0;
                                index < alTargetAudience.length;
                                index++)
                              customRadioButton(
                                  alTargetAudience[index], index, snap.data!),
                          ],
                        );
                      } else if (snap.hasError) {
                        return Text(snap.error.toString());
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        );
        ;
      },
    );
  }

  Widget customRadioButton(String title, int index, int selectedIndex) =>
      Column(
        children: [
          GestureDetector(
            onTap: () async {
              Navigator.of(context).pop();
              // Navigator.of(context, rootNavigator: true).pop('dialog');
              alCatalogFilterTargetAudience = [];
              await filterTargetAudience(index);
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xff6F706F),
                    ),
                  ),
                  Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedIndex == index
                          ? primaryColor
                          : Color(0xffF4F3F3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
          ),
        ],
      );

  filterTargetAudience(int index) {
    setState(() {
      selectedTargetAudiStreamController.add(index);
      for (CatalogList catalogList in alCatalogTargetAudience) {
        if (catalogList.targetAudience != null) {
          String targetAudience =
              catalogList.targetAudience.toString().contains(".")
                  ? catalogList.targetAudience.toString().replaceAll(".", "")
                  : catalogList.targetAudience.toString().contains(",")
                      ? catalogList.targetAudience!.split(",").toString()
                      : catalogList.targetAudience.toString();
          if (targetAudience.contains(alTargetAudience[index])) {
            alCatalogFilterTargetAudience.add(catalogList);
          }
        }
      }

      /*if (alCatalogFilterTargetAudience.isNotEmpty &&
          alCatalogFilterTargetAudience.length > 0) {
        alCatalog = [];
        alCatalog.addAll(alCatalogFilterTargetAudience);
      } else {
        alCatalog = [];
      }*/
    });
  }
}
