import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/MyIcpdRecommendActivityRequest.dart';
import 'package:pharmaaccess/models/icpd_common_model.dart';
import 'package:pharmaaccess/models/icpd_event_category_model.dart';
import 'package:pharmaaccess/services/icpd_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/date_picker.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RecommendCmeActivity extends StatefulWidget {
  const RecommendCmeActivity({Key? key}) : super(key: key);

  @override
  _RecommendCmeActivityState createState() => _RecommendCmeActivityState();
}

class _RecommendCmeActivityState extends State<RecommendCmeActivity> {
  ScrollController _scrollController = new ScrollController();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController startDateTextEditingController =
      TextEditingController();
  TextEditingController endDateTextEditingController = TextEditingController();
  TextEditingController venueDateTextEditingController =
      TextEditingController();
  TextEditingController organizerLinkTextEditingController =
      TextEditingController();
  TextEditingController commentsTextEditingController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnOkController =
      RoundedLoadingButtonController();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  IcpdService icpdService = IcpdService();
  List<EventCategory> alEventCategoryList = [];
  EventCategory? eventCategoryItem;
  bool isSuccessMsg = false;
  bool _loading = true;
  bool isSelectedStartDate = false;
  bool isSelectedEndDate = false;

  @override
  void initState() {
    firebaseAnalyticsEventCall(ICPD_RECOMMEND_CME_ACTIVITY_SCREEN,
        param: {"name": "iCPD Recommend CME Activity Screen"});
    _getAllEventCategoryList();
    super.initState();
  }

  void _getAllEventCategoryList() async {
    alEventCategoryList = await icpdService.getCMEEventCategoryList() ?? [];
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text('Recommend Activity'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : getBodyAddRecommendWidget(),
    );
  }

  Widget getBodyAddRecommendWidget() {
    return Container(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormFieldWidget(
                    controller: titleTextEditingController,
                    hintText: 'Title*',
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectStartDate(context);
                    },
                    child: AbsorbPointer(
                      child: FormFieldWidget(
                        controller: startDateTextEditingController,
                        hintText: 'Start Date*',
                        readonly: true,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/gray_calender_icon.png',
                              height: 22,
                              width: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      !isSelectedStartDate
                          ? showDialogSuccess("Please select the start date.")
                          : _selectEndDate(context);
                    },
                    child: AbsorbPointer(
                      child: FormFieldWidget(
                        controller: endDateTextEditingController,
                        hintText: 'End Date',
                        readonly: true,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/gray_calender_icon.png',
                              height: 22,
                              width: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FormFieldWidget(
                    controller: venueDateTextEditingController,
                    hintText: 'Venue',
                  ),
                  /*dropDownWrapper(
                hintText: "Type",
                items: [
                  DropdownMenuItem<String>(
                    value: "1",
                    child: Text("1"),
                  ),
                  DropdownMenuItem<String>(
                    value: "2",
                    child: Text("2"),
                  ),
                ],
                onChange: (String? newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
                selectedValue: selectedType,
              ),*/
                  dropDownDynamicWrapper(
                    hintText: "Type",
                    items:
                        alEventCategoryList.map((EventCategory eventCategory) {
                      return DropdownMenuItem<EventCategory>(
                        value: eventCategory,
                        child: Text(eventCategory.name ?? ""),
                      );
                    }).toList(),
                    onChange: (EventCategory? newValue) {
                      setState(() {
                        eventCategoryItem = newValue ?? EventCategory();
                      });
                    },
                    selectedValue: eventCategoryItem ?? EventCategory(),
                  ),
                  FormFieldWidget(
                    controller: organizerLinkTextEditingController,
                    textInputType: TextInputType.url,
                    hintText: 'Organizer Link*',
                  ),
                  FormFieldWidget(
                    controller: commentsTextEditingController,
                    hintText: 'Comments',
                    textInputType: TextInputType.multiline,
                    maxLines: 5,
                    lines: 5,
                  ),
                  SizedBox(
                    height: 40,
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
                    child: RoundedLoadingButton(
                      borderRadius: 6,
                      height: 60,
                      onPressed: () async {
                        /*if (dateTextEditingController.text.trim().isEmpty ||
                      titleTextEditingController.text.trim().isEmpty ||
                      organizerLinkTextEditingController.text.trim().isEmpty */ /*||
                      commentsTextEditingController.text.trim().isEmpty*/ /*) {
                    _btnController.reset();
                    // showSnackBar(
                    //     context, "");
                    isSuccessMsg = false;
                    showDialogSuccess("Please fill in all required fields.");
                    return;
                  }*/
                        if (titleTextEditingController.text.trim().isEmpty) {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please enter the title.");
                          return;
                        }
                        if (startDateTextEditingController.text
                            .trim()
                            .isEmpty) {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please select the start date.");
                          return;
                        }
                        /*if (endDateTextEditingController.text.trim().isEmpty) {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please select the end date.");
                          return;
                        }*/
                        /*if (venueDateTextEditingController.text
                            .trim()
                            .isEmpty) {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please select the venue.");
                          return;
                        }
                        if (eventCategoryItem.toString() == "null") {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please select the type.");
                          return;
                        }*/
                        if (organizerLinkTextEditingController.text
                            .trim()
                            .isEmpty) {
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess("Please enter the organizer link.");
                          return;
                        }
                        /*
                  if (commentsTextEditingController.text
                      .trim()
                      .isEmpty) {
                    _btnController.reset();
                    isSuccessMsg = false;
                    showDialogSuccess("Please enter the comments.");
                    return;
                  }*/
                        MyIcpdRecommendActivityRequest
                            myIcpdRecommendActivityRequest =
                            MyIcpdRecommendActivityRequest(
                          name: titleTextEditingController.text,
                          description: commentsTextEditingController.text,
                          start: DateFormat('yyyy-MM-dd')
                              .format(selectedStartDate),
                          stop: DateFormat('yyyy-MM-dd').format(
                              isSelectedEndDate
                                  ? selectedEndDate
                                  : selectedStartDate),
                          venue: venueDateTextEditingController.text,
                          organizerUrl: organizerLinkTextEditingController.text,
                          eventCategoryId:
                              eventCategoryItem?.id, //Widget.category
                        );

                        CommonResultMessage? commonResultMessage =
                            await icpdService.createRecommendActivity(
                                myIcpdRecommendActivityRequest);
                        if (commonResultMessage == null) {
                          // showSnackBar(context, INTERNAL_SERVER_ERROR);
                          // _btnController.error();
                          _btnController.reset();
                          isSuccessMsg = false;
                          showDialogSuccess(INTERNAL_SERVER_ERROR);
                        } else {
                          if (commonResultMessage.isSuccess ?? false) {
                            // showSnackBar(
                            //     context,
                            //     commonResultMessage.message ??
                            //         "Successfully Changed.",
                            //     isSuccess: true);
                            _btnController.success();
                            isSuccessMsg = true;
                            showDialogSuccess(commonResultMessage.message ??
                                "Successfully Changed.");
                            // Navigator.of(context).pop();
                            /*Future.delayed(
                        const Duration(seconds: 1),
                        () => Navigator.of(context).pop(),
                      );*/
                          } else {
                            // showSnackBar(context,
                            //     commonResultMessage.message ?? INTERNAL_SERVER_ERROR);
                            _btnController.reset();
                            isSuccessMsg = false;
                            showDialogSuccess(commonResultMessage.message ??
                                INTERNAL_SERVER_ERROR);
                          }
                        }
                      },
                      color: primaryColor,
                      animateOnTap: true,
                      controller: _btnController,
                      child: Text(
                        "Send Recommendation",
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
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await datePicker(context, selectedStartDate);
    if (picked != null && picked != selectedStartDate)
      setState(() {
        isSelectedStartDate = true;
        selectedStartDate = picked;
        startDateTextEditingController.text =
            DateFormat('yyyy/MM/dd').format(selectedStartDate);
      });
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await datePicker(context, selectedEndDate);
    if (picked != null && picked != selectedEndDate)
      setState(() {
        isSelectedEndDate = true;
        selectedEndDate = picked;
        endDateTextEditingController.text =
            DateFormat('yyyy/MM/dd').format(selectedEndDate);
      });
  }

  Widget dropDownDynamicWrapper({
    required String hintText,
    required List<DropdownMenuItem<EventCategory>> items,
    required EventCategory selectedValue,
    required onChange(EventCategory? newValue),
  }) =>
      Container(
        margin: EdgeInsets.only(top: 6, bottom: 12),
        // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        /*decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200]!,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),*/
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<EventCategory>(
            value: eventCategoryItem,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                borderSide: BorderSide(
                  color: Colors.grey[200]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                borderSide: BorderSide(
                  color: Colors.grey[200]!,
                ),
              ),
              labelStyle: TextStyle(
                color: Colors.grey[300],
              ),
              labelText: hintText,
            ),
            icon: dropDownIcon(),
            isExpanded: true,
            hint: Text(
              "",
              style: TextStyle(
                color: Colors.grey[300],
              ),
            ),
            // underline: Container(),
            onChanged: (EventCategory? newValue) {
              onChange(newValue);
            },
            items: items,
          ),
        ),
      );

  /*Container(
        margin: EdgeInsets.only(top: 6, bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200]!,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: DropdownButton<EventCategory>(
          value: eventCategoryItem,
          icon: dropDownIcon(),
          isExpanded: true,
          hint: Text(
            hintText,
            style: TextStyle(
              color: Colors.grey[300],
            ),
          ),
          underline: Container(),
          onChanged: (EventCategory? newValue) {
            onChange(newValue);
          },
          items: items,
        ),
      );*/

  Icon dropDownIcon() {
    return Icon(
      Icons.arrow_drop_down,
      color: Colors.grey[200],
      size: 30,
    );
  }

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
                height: 10,
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
