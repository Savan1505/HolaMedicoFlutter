import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/MyIcpdACRequest.dart';
import 'package:pharmaaccess/models/MyIcpdTargetRequest.dart';
import 'package:pharmaaccess/models/MyIcpdUpdateACRequest.dart';
import 'package:pharmaaccess/models/MyIcpdUpdateTargetRequest.dart';
import 'package:pharmaaccess/models/icpd_cme_plan_model.dart';
import 'package:pharmaaccess/models/icpd_common_model.dart';
import 'package:pharmaaccess/services/icpd_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/date_picker.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CreateMyIcpdTarget extends StatefulWidget {
  final int? planId;
  final int selectPlanIndex;
  final String planType;
  final String planName;
  final String countryName;
  final PlanList? planListItem;

  // final List<PlanList>? planTypeItem;

  const CreateMyIcpdTarget(
      {Key? key,
      this.planId = 0,
      this.selectPlanIndex = 0,
      this.planType = "td",
      this.countryName = "UAE",
      this.planName = "License Renewal CME",
      this.planListItem
      /*this.planTypeItem*/
      })
      : super(key: key);

  @override
  _CreateMyIcpdTargetState createState() => _CreateMyIcpdTargetState();
}

class _CreateMyIcpdTargetState extends State<CreateMyIcpdTarget> {
  ScrollController _scrollController = new ScrollController();
  TextEditingController licenseRenewalDateTextEditingController =
      TextEditingController();
  TextEditingController catOneTextEditingController = TextEditingController();
  TextEditingController catTwoTextEditingController = TextEditingController();
  TextEditingController catThreeTextEditingController = TextEditingController();
  TextEditingController commentsTextEditingController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnOkController =
      RoundedLoadingButtonController();
  bool isSuccessMsg = false;
  DateTime selectedDate = DateTime.now();
  IcpdService icpdService = IcpdService();
  MyIcpdUpdateTargetRequest myIcpdUpdateTargetRequest =
      MyIcpdUpdateTargetRequest();
  MyIcpdTargetRequest myIcpdTargetRequest = MyIcpdTargetRequest();
  MyIcpdUpdateACRequest myIcpdUpdateACRequest = MyIcpdUpdateACRequest();
  MyIcpdACRequest myIcpdACRequest = MyIcpdACRequest();
  int planId = 0;
  String? planProcessingClass;
  String planItemName = "";
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _toolTipKey = GlobalKey();

  @override
  void initState() {
    /*if (widget.planTypeItem != null && widget.planTypeItem!.length > 0) {
      for (PlanList planListItem in widget.planTypeItem!) {
        if (planListItem.name == widget.planName) {
          planId = planListItem.id ?? 0;
          planItemName = planListItem.name ?? "";
          planProcessingClass = planListItem.planProcessingClass!.isNotEmpty
              ? planListItem.planProcessingClass
              : widget.planType;
          licenseRenewalDateTextEditingController.text =
              planListItem.licenseExpiryDate ?? "";
          catOneTextEditingController.text =
              planListItem.targetCategory1Points.toString();
          catTwoTextEditingController.text =
              planListItem.targetCategory2Points.toString();
          catThreeTextEditingController.text =
              planListItem.targetCategory3Points.toString();
          commentsTextEditingController.text = planListItem.comments ?? "";
        }
      }
    }*/
    firebaseAnalyticsEventCall(ICPD_CREATE_MY_ICPD_TARGET_SCREEN,
        param: {"name": "Create My iCPD Target Screen"});
    _getPlanDataToSetUI();
    super.initState();
  }

  Future<void> _getPlanDataToSetUI() async {
    if (widget.planListItem != null &&
        widget.planListItem.toString().isNotEmpty) {
      if (widget.planListItem!.name == widget.planName) {
        planId = widget.planListItem!.id ?? 0;
        planItemName = widget.planListItem!.name ?? "";
        planProcessingClass =
            widget.planListItem!.planProcessingClass!.isNotEmpty
                ? widget.planListItem!.planProcessingClass
                : widget.planType;
        licenseRenewalDateTextEditingController.text =
            widget.planListItem!.licenseExpiryDate ?? "";
        catOneTextEditingController.text =
            widget.planListItem!.targetCategory1Points!.round().toString();
        catTwoTextEditingController.text =
            widget.planListItem!.targetCategory2Points!.round().toString();
        catThreeTextEditingController.text =
            widget.planListItem!.targetCategory3Points!.round().toString();
        commentsTextEditingController.text =
            widget.planListItem!.comments ?? "";
        selectedDate =
            DateTime.parse(licenseRenewalDateTextEditingController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.planListItem.toString().isNotEmpty &&
                planItemName == widget.planName
            ? 'Update My ICPD Plan'
            : 'Create My ICPD Plan'),
      ),
      body: getBodyCreateMyiCPDPlan(),
    );
  }

  Widget getBodyCreateMyiCPDPlan() {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Country:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff686767),
                      ),
                    ),
                    Text(
                      " ${widget.countryName}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffD3D2D2),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    tootTipCountryIcon("Selected Country"),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _selectDate(context);
                  },
                  onLongPress: () {
                    final dynamic _toolTip = _toolTipKey.currentState;
                    _toolTip.ensureTooltipVisible();
                  },
                  child: AbsorbPointer(
                    child: FormFieldWidget(
                      controller: licenseRenewalDateTextEditingController,
                      /*hintText: widget.planName == "License Renewal CME"
                        ? 'My License Renewal Date'
                        : widget.planName == "General Media Education"
                            ? 'My Medical Education Date'
                            : 'My Personal Development Date',*/
                      hintText: 'My Plan End Date*',
                      readonly: true,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          tootTipIcon("Plan Creation Selected date"),
                          SizedBox(
                            width: 12.0,
                          ),
                          Image.asset(
                            'assets/images/gray_calender_icon.png',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.planName == "License Renewal CME",
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          "CME Points Needed:",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff686767),
                          ),
                        ),
                        FormFieldWidget(
                          controller: catOneTextEditingController,
                          hintText: 'CAT I*',
                          textInputType: TextInputType.number,
                        ),
                        FormFieldWidget(
                          controller: catTwoTextEditingController,
                          hintText: 'CAT II*',
                          textInputType: TextInputType.number,
                        ),
                        FormFieldWidget(
                          controller: catThreeTextEditingController,
                          hintText: 'CAT III*',
                          textInputType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
                FormFieldWidget(
                  controller: commentsTextEditingController,
                  hintText: 'Comments',
                  textInputType: TextInputType.multiline,
                  maxLines: 6,
                  lines: 6,
                ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: RoundedLoadingButton(
                    borderRadius: 6,
                    height: 60,
                    onPressed: () async {
                      CommonResultMessage? icpdCommonModel;
                      if (widget.planName == "License Renewal CME") {
                        /*if (licenseRenewalDateTextEditingController.text
                            .trim()
                            .isEmpty ||
                        catOneTextEditingController.text.trim().isEmpty ||
                        catTwoTextEditingController.text.trim().isEmpty ||
                        catThreeTextEditingController.text.trim().isEmpty ||
                        commentsTextEditingController.text.trim().isEmpty) {
                      _btnController.reset();
                      isSuccessMsg = false;
                      // showSnackBar(
                      //     context, "Please fill in all required fields.");
                      showDialogSuccess("Please fill in all required fields.");
                      return;
                    }*/
                        if (licenseRenewalDateTextEditingController.text
                            .trim()
                            .isEmpty) {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please select the date.");
                          return;
                        }
                        if (catOneTextEditingController.text.trim().isEmpty) {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please enter the cat I.");
                          return;
                        }
                        if (catTwoTextEditingController.text.trim().isEmpty) {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please enter the cat II.");
                          return;
                        }
                        if (catThreeTextEditingController.text.trim().isEmpty) {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please enter the cat III.");
                          return;
                        }
                        /*if (commentsTextEditingController.text.trim().isEmpty) {
                      _btnController.reset();
                      isSuccessMsg = false;
                      showDialogSuccess("Please enter the comments.");
                      return;
                    }*/
                        if (widget.planListItem.toString().isNotEmpty &&
                            planItemName == widget.planName) {
                          myIcpdUpdateTargetRequest = MyIcpdUpdateTargetRequest(
                            planId: planId,
                            name: widget.planName,
                            licenseExpiryDate:
                                DateFormat('yyyy/MM/dd').format(selectedDate),
                            planProcessingClass: planProcessingClass,
                            targetCategory1Points: double.parse(
                                catOneTextEditingController.text.trim()),
                            targetCategory2Points: double.parse(
                                catTwoTextEditingController.text.trim()),
                            targetCategory3Points: double.parse(
                                catThreeTextEditingController.text.trim()),
                            comments: commentsTextEditingController.text.trim(),
                            targetPoints: getTargetPoint(),
                          );
                          icpdCommonModel =
                              await icpdService.updateMyPlanIcpdTarget(
                                  myIcpdUpdateTargetRequest,
                                  myIcpdUpdateACRequest);
                        } else {
                          myIcpdTargetRequest = MyIcpdTargetRequest(
                            name: widget.planName,
                            licenseExpiryDate:
                                DateFormat('yyyy/MM/dd').format(selectedDate),
                            planProcessingClass: widget.planType,
                            targetCategory1Points: double.parse(
                                catOneTextEditingController.text.trim()),
                            targetCategory2Points: double.parse(
                                catTwoTextEditingController.text.trim()),
                            targetCategory3Points: double.parse(
                                catThreeTextEditingController.text.trim()),
                            comments: commentsTextEditingController.text.trim(),
                            targetPoints: getTargetPoint(),
                          );
                          icpdCommonModel =
                              await icpdService.createMyPlanIcpdTarget(
                                  myIcpdTargetRequest, myIcpdACRequest);
                        }
                      } else {
                        /*if (licenseRenewalDateTextEditingController.text
                            .trim()
                            .isEmpty ||
                        commentsTextEditingController.text.trim().isEmpty) {
                      _btnController.reset();
                      isSuccessMsg = false;
                      // showSnackBar(
                      //     context, "Please fill in all required fields.");
                      showDialogSuccess("Please fill in all required fields.");
                      return;
                    }*/
                        if (licenseRenewalDateTextEditingController.text
                            .trim()
                            .isEmpty) {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please select the date.");
                          return;
                        }
                        /* if (commentsTextEditingController.text.trim().isEmpty) {
                      _btnController.reset();
                      isSuccessMsg = false;
                      showDialogSuccess("Please enter the comments.");
                      return;
                    }*/
                        if (widget.planListItem.toString().isNotEmpty &&
                            planItemName == widget.planName) {
                          myIcpdUpdateACRequest = MyIcpdUpdateACRequest(
                            planId: planId,
                            name: widget.planName,
                            licenseExpiryDate:
                                DateFormat('yyyy/MM/dd').format(selectedDate),
                            planProcessingClass: planProcessingClass,
                            comments: commentsTextEditingController.text.trim(),
                          );
                          icpdCommonModel =
                              await icpdService.updateMyPlanIcpdTarget(
                                  myIcpdUpdateTargetRequest,
                                  myIcpdUpdateACRequest);
                        } else {
                          myIcpdACRequest = MyIcpdACRequest(
                            name: widget.planName,
                            licenseExpiryDate:
                                DateFormat('yyyy/MM/dd').format(selectedDate),
                            planProcessingClass: widget.planType,
                            comments: commentsTextEditingController.text.trim(),
                          );
                          icpdCommonModel =
                              await icpdService.createMyPlanIcpdTarget(
                                  myIcpdTargetRequest, myIcpdACRequest);
                        }
                      }

                      if (icpdCommonModel == null) {
                        // showSnackBar(context, INTERNAL_SERVER_ERROR);
                        // _btnController.error();
                        _btnController.reset();
                        isSuccessMsg = false;
                        showDialogSuccess(INTERNAL_SERVER_ERROR);
                      } else {
                        if (icpdCommonModel.isSuccess ?? false) {
                          /*showSnackBar(context,
                          icpdCommonModel.message ?? "Successfully Changed.",
                          isSuccess: true);*/
                          _btnController.success();
                          isSuccessMsg = true;
                          showDialogSuccess(icpdCommonModel.message ??
                              "Successfully Changed.");
                          /* Future.delayed(
                        const Duration(seconds: 1),
                        () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddMyPlanActivities(
                                    planId: planId != 0
                                        ? planId
                                        : icpdCommonModel?.data?.planId ?? 0),
                          ),
                        ),
                      );*/
                        } else {
                          // showSnackBar(context,
                          //     icpdCommonModel.message ?? INTERNAL_SERVER_ERROR);
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess(
                              icpdCommonModel.message ?? INTERNAL_SERVER_ERROR);
                        }
                      }
                    },
                    color: primaryColor,
                    animateOnTap: true,
                    controller: _btnController,
                    child: Text(
                      widget.planListItem.toString().isNotEmpty &&
                              planItemName == widget.planName
                          ? "Update & Go To Activities"
                          : "Create & Go To Activities",
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .apply(
                            color: Colors.white,
                          )
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget tootTipIcon(String infoMessage) => Tooltip(
        message: infoMessage,
        key: _toolTipKey,
        excludeFromSemantics: true,
        child: Image.asset(
          'assets/images/tooltip_icon.png',
          height: 16,
          width: 16,
        ),
      );

  Widget tootTipCountryIcon(String infoMessage) => Tooltip(
        message: infoMessage,
        child: Image.asset(
          'assets/images/tooltip_icon.png',
          height: 16,
          width: 16,
        ),
      );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await datePicker(context, selectedDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        licenseRenewalDateTextEditingController.text =
            DateFormat('yyyy/MM/dd').format(selectedDate);
      });
  }

  double getTargetPoint() =>
      double.parse(catOneTextEditingController.text.trim()) +
      double.parse(catTwoTextEditingController.text.trim()) +
      double.parse(catThreeTextEditingController.text.trim());

  void showDialogSuccess(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        content: Container(
          width: double.maxFinite,
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
              RoundedLoadingButton(
                borderRadius: 6,
                height: 40,
                width: MediaQuery.of(context).size.width / 4,
                onPressed: _submitRequest,
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
            ],
          ),
        ),
      ),
    );
  }

  void _submitRequest() async {
    if (isSuccessMsg) {
      Navigator.of(context).pop();
      Navigator.pop(context, true);
    } else {
      Navigator.of(context).pop();
    }
  }
}
