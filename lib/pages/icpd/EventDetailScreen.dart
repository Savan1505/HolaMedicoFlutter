import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/MyIcpdPaticipateRequest.dart';
import 'package:pharmaaccess/models/icpd_catalog_resp_model.dart';
import 'package:pharmaaccess/models/icpd_cme_plan_model.dart';
import 'package:pharmaaccess/models/icpd_common_model.dart';
import 'package:pharmaaccess/pages/icpd/icpd_structure.dart';
import 'package:pharmaaccess/services/icpd_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/icon_full_button.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatefulWidget {
  final CatalogList? catalogList;
  final List<PlanList>? planTypeItem;
  final int? planTypeIndex;
  final String? countryName;

  const EventDetailScreen(
      {Key? key,
      this.catalogList,
      this.countryName,
      this.planTypeIndex,
      this.planTypeItem})
      : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  ScrollController _scrollController = new ScrollController();
  final RoundedLoadingButtonController _btnCancelController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnConfirmController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnOkController =
      RoundedLoadingButtonController();
  List<String> planTypes = [
    'License Renewal CME',
    'General Medical Education',
    'Personal Development'
  ];
  StreamController<int> selectedPlanStreamController =
      StreamController<int>.broadcast();
  int selectedPlan = 0;
  int activityId = 0;
  IcpdService icpdService = IcpdService();

  @override
  void initState() {
    firebaseAnalyticsEventCall(ICPD_EVENT_DETAIL_SCREEN,
        param: {"name": "iCPD Event Detail Screen"});
    selectedPlan = widget.planTypeIndex ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    selectedPlanStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          widget.catalogList?.name ?? "Event Detail",
          maxLines: 2,
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*SizedBox(
              height: 10.0,
            ),*/
            Center(
              child: Column(
                children: [
                  Image.network(
                    widget.catalogList?.bannerUrl != null
                        ? widget.catalogList?.bannerUrl ??
                            "https://content.pharmaaccess.com/static/icpd/CME.jpg"
                        : "https://content.pharmaaccess.com/static/icpd/CME.jpg",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Text(
                      'Organized by ${widget.catalogList?.organizerName ?? "- NA -"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff525151),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // IconFullButton(
            //   label: "Add to My Plan",
            //   iconPath: "assets/icon/add_icon.png",
            //   onPressed: () {},
            // ),
            // IcpdSpacer(),
            // IconFullButton(
            //   label: "Registration Link",
            //   iconPath: "assets/icon/link_white_icon.png",
            //   onPressed: () {},
            // ),
            // IcpdSpacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  contentRow("Target Audience:",
                      "${widget.catalogList?.targetAudience ?? "- NA -"}"),
                  SizedBox(
                    height: 10.0,
                  ),
                  contentRow("Accereditation:",
                      "${widget.catalogList?.score} CME Credits"),
                  SizedBox(
                    height: 10.0,
                  ),
                  contentRow(
                      "Cost:", "\$ ${widget.catalogList!.cost.toString()}"),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Description:",
                    style: titleTextStyle(),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(widget.catalogList!.description ?? "- NA -"),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Registration Link : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff525151),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      String registerLinkUrl =
                          widget.catalogList?.organizerUrl ?? "";
                      if (registerLinkUrl.isNotEmpty) {
                        if (await canLaunch(registerLinkUrl)) {
                          await launch(registerLinkUrl);
                        } else {
                          throw 'Could not launch $registerLinkUrl';
                        }
                      }
                    },
                    child: Text(
                      widget.catalogList?.organizerUrl ?? "- NA -",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: answerBoxColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  IconFullButton(
                    // label: "Register / Add to My Plan",
                    label: "Add to My Plan",
                    iconPath: "assets/icon/add_icon.png",
                    onPressed: () {
                      showSelectPlan();
                    },
                  ),
                  IcpdSpacer(),
                  Visibility(
                    visible: widget.catalogList!.isAttendee ?? false,
                    child: IconFullButton(
                      label: "Sponsor Me Request",
                      iconPath: "assets/icon/sponsor.png",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              Center(child: CircularProgressIndicator()),
                        );
                        if (activityId > 0) {
                          callSponsorMeRequest(context, activityId, true);
                        } else {
                          Navigator.of(context).pop();
                          showDialogSuccess(context,
                              "Please add first plan into Activity to click on \"Add To My Plan\"");
                        }
                      },
                    ),
                  ),
                  IcpdSpacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox spacer() {
    return SizedBox(
      height: 15.0,
    );
  }

  Widget contentRow(String title, String content) => Row(
        children: [
          Text(
            title,
            style: titleTextStyle(),
          ),
          SizedBox(
            width: 4.0,
          ),
          Text(content),
        ],
      );

  TextStyle titleTextStyle() {
    return TextStyle(
      color: Color(0xff525151),
      fontWeight: FontWeight.bold,
    );
  }

  showSelectPlan() {
    // selectedPlan = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Plan Type",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xff525151),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
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
                  initialData: selectedPlan,
                  stream: selectedPlanStreamController.stream,
                  builder: (context, snap) {
                    return Column(
                      children: [
                        for (int index = 0; index < planTypes.length; index++)
                          customRadioButton(
                              planTypes[index], index, snap.data!),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Container(
                    child: RaisedButton(
                      color: primaryColor,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Save",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .apply(
                              color: Colors.white,
                            )
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        /*Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddMyPlanActivities(
                                    planId:
                                        widget.planTypeItem![selectedPlan].id ??
                                            0),
                          ),
                        );*/

                        showDialogConfirmation(
                            "Do you want to add", "to your plan?");

                        /*Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CreateMyIcpdTarget(
                              planId: widget.catalogList?.id,
                              selectPlanIndex: selectedPlan,
                              planName: planTypes[selectedPlan],
                              planType: selectedPlan == 0 ? "td" : "ac",
                              planTypeItem: widget.planTypeItem ?? [],
                            ),
                          ),
                        );*/
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget customRadioButton(String title, int index, int selectedIndex) =>
      Column(
        children: [
          GestureDetector(
            onTap: () {
              selectedPlan = index;
              selectedPlanStreamController.add(index);
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

  void showDialogConfirmation(String message, String message2) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: RichText(
                  text: TextSpan(
                    text: message,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            " \"${widget.catalogList?.name ?? "Event Detail"}\" ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: message2,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RoundedLoadingButton(
                        borderRadius: 6,
                        height: 40,
                        width: MediaQuery.of(context).size.width / 4,
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        color: Colors.white,
                        animateOnTap: true,
                        controller: _btnCancelController,
                        child: Text(
                          "CANCEL",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .apply(
                                color: primaryColor,
                              )
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RoundedLoadingButton(
                        borderRadius: 6,
                        height: 40,
                        width: MediaQuery.of(context).size.width / 3,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (_) =>
                                Center(child: CircularProgressIndicator()),
                          );
                          callParticipateEventAndPlan(true);
                        },
                        color: primaryColor,
                        animateOnTap: true,
                        controller: _btnConfirmController,
                        child: Text(
                          "CONFIRM",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .apply(
                                color: Colors.white,
                              )
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogSuccess(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: Text(
                  message,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: Container(
                  child: RoundedLoadingButton(
                    borderRadius: 6,
                    height: 40,
                    width: MediaQuery.of(context).size.width / 4,
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    color: primaryColor,
                    animateOnTap: true,
                    controller: _btnOkController,
                    child: Text(
                      "OK",
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .apply(
                            color: Colors.white,
                          )
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDialogBoldSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                /*child: Text(
                  message,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),*/
                child: Text.rich(
                  TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style:
                        TextStyle(color: Color(0xff525151), wordSpacing: 1.0),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              'You have no active iCPD plan created as yet, Please start creating your plan and tracking progress by selecting'),
                      TextSpan(
                          text: widget.planTypeIndex == 0
                              ? ' \"CPD Planner and Tracker\"'
                              : ' \"Activity Tracker\"',
                          style: new TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: Container(
                  child: RoundedLoadingButton(
                    borderRadius: 6,
                    height: 40,
                    width: MediaQuery.of(context).size.width / 4,
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    color: primaryColor,
                    animateOnTap: true,
                    controller: _btnOkController,
                    child: Text(
                      "OK",
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .apply(
                            color: Colors.white,
                          )
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void callParticipateEventAndPlan(bool isPopDialog) async {
    if (widget.planTypeItem != null &&
        widget.planTypeItem!.isNotEmpty &&
        widget.planTypeItem!.length > 0 &&
        widget.catalogList.toString().isNotEmpty) {
      for (PlanList planList in widget.planTypeItem!) {
        if (selectedPlan >= 0) {
          MyIcpdPaticipateRequest myIcpdPaticipateRequest;
          CommonResultMessage? icpdCommonModel;
          if (planList.name == planTypes[selectedPlan]) {
            myIcpdPaticipateRequest = MyIcpdPaticipateRequest(
                planId: planList.id, eventId: widget.catalogList!.id);

            icpdCommonModel = await icpdService
                .addCatalogEventPlanParticipate(myIcpdPaticipateRequest);
            if (isPopDialog) {
              Navigator.of(context).pop();
            }
            if (icpdCommonModel == null) {
              showDialogSuccess(context, INTERNAL_SERVER_ERROR);
            } else {
              activityId = icpdCommonModel.data?.planId ?? 0;
              if (icpdCommonModel.isSuccess ?? false) {
                showDialogSuccess(context,
                    icpdCommonModel.message ?? "Successfully Changed.");
              } else {
                showDialogSuccess(
                    context, icpdCommonModel.message ?? INTERNAL_SERVER_ERROR);
              }
            }
            return;
          } else if (selectedPlan == 1 &&
              planList.name == "General Media Education") {
            myIcpdPaticipateRequest = MyIcpdPaticipateRequest(
                planId: planList.id, eventId: widget.catalogList!.id);
            icpdCommonModel = await icpdService
                .addCatalogEventPlanParticipate(myIcpdPaticipateRequest);
            if (isPopDialog) {
              Navigator.of(context).pop();
            }
            if (icpdCommonModel == null) {
              showDialogSuccess(context, INTERNAL_SERVER_ERROR);
            } else {
              activityId = icpdCommonModel.data?.planId ?? 0;
              if (icpdCommonModel.isSuccess ?? false) {
                showDialogSuccess(context,
                    icpdCommonModel.message ?? "Successfully Changed.");
              } else {
                showDialogSuccess(
                    context, icpdCommonModel.message ?? INTERNAL_SERVER_ERROR);
              }
            }
            return;
          }
        }
      }
      if (isPopDialog) {
        Navigator.of(context).pop();
      }
      // showSnackBar(context,
      //     "You have no plan, Please Select CPD Planner And Tracker to Start.");
      // Navigator.of(context).pop();
      showDialogBoldSuccess(context);
      /*if (widget.planTypeItem!.length > selectedPlan &&
          widget.planTypeItem![selectedPlan].name == planTypes[selectedPlan]) {
        MyIcpdPaticipateRequest myIcpdPaticipateRequest =
            MyIcpdPaticipateRequest(
                planId: widget.planTypeItem![selectedPlan].id,
                eventId: widget.catalogList!.id);

        CommonResultMessage? icpdCommonModel = await icpdService
            .addCatalogEventPlanParticipate(myIcpdPaticipateRequest);
        if (isPopDialog) {
          Navigator.of(context).pop();
        }
        if (icpdCommonModel == null) {
          showDialogSuccess(context, INTERNAL_SERVER_ERROR);
        } else {
          if (icpdCommonModel.isSuccess ?? false) {
            showDialogSuccess(
                context, icpdCommonModel.message ?? "Successfully Changed.");
          } else {
            showDialogSuccess(
                context, icpdCommonModel.message ?? INTERNAL_SERVER_ERROR);
          }
        }
      } else {
        if (isPopDialog) {
          Navigator.of(context).pop();
        }
        // showSnackBar(context,
        //     "You have no plan, Please Select CPD Planner And Tracker to Start.");
        // Navigator.of(context).pop();
        showDialogBoldSuccess(context);
      }*/
    } else {
      if (isPopDialog) {
        Navigator.of(context).pop();
      }
      // showSnackBar(context,
      //     "You have no plan, Please Select CPD Planner And Tracker to Start.");
      // Navigator.of(context).pop();
      showDialogBoldSuccess(context);
    }
  }

  void callSponsorMeRequest(
      BuildContext context, int activityId, bool isPopDialog) async {
    if (widget.catalogList.toString().isNotEmpty) {
      CommonResultMessage? icpdCommonModel =
          await icpdService.sponsorMeRequestEvent(activityId.toString());
      if (isPopDialog) {
        Navigator.of(context).pop();
      }
      if (icpdCommonModel == null) {
        showDialogSuccess(context, INTERNAL_SERVER_ERROR);
      } else {
        if (icpdCommonModel.isSuccess ?? false) {
          showDialogSuccess(
              context, icpdCommonModel.message ?? "Successfully Changed.");
        } else {
          showDialogSuccess(
              context, icpdCommonModel.message ?? INTERNAL_SERVER_ERROR);
        }
      }
    } else {
      if (isPopDialog) {
        Navigator.of(context).pop();
      }
      showDialogBoldSuccess(context);
    }
  }
}
