import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pharmaaccess/SharedPref.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/ActivityExpItem.dart';
import 'package:pharmaaccess/models/MyIcpdCreateActivityRequest.dart';
import 'package:pharmaaccess/models/MyIcpdUpdateActivityRequest.dart';
import 'package:pharmaaccess/models/icpd_activity_attachment_model.dart';
import 'package:pharmaaccess/models/icpd_activity_resp_model.dart';
import 'package:pharmaaccess/models/icpd_key_value_data.dart';
import 'package:pharmaaccess/models/icpd_common_model.dart';
import 'package:pharmaaccess/models/icpd_event_category_model.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/screen_utils/ScreenUtil.dart';
import 'package:pharmaaccess/services/icpd_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/util/PermissionUtil.dart';
import 'package:pharmaaccess/widgets/date_picker.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';

class AddMyPlanActivities extends StatefulWidget {
  final int? planTypeIndex;
  final int planId;
  final ActivityListItem? activityListItem;
  final bool isEditActivity;
  final String titleName;
  final String planProcessingClass;

  const AddMyPlanActivities(
      {Key? key,
      this.titleName = "",
      this.planTypeIndex = 0,
      this.planId = 0,
      this.activityListItem,
      this.planProcessingClass = "td",
      this.isEditActivity = false})
      : super(key: key);

  @override
  _AddMyPlanActivitiesState createState() => _AddMyPlanActivitiesState();
}

class _AddMyPlanActivitiesState extends State<AddMyPlanActivities> {
  ScrollController _scrollController = new ScrollController();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();
  TextEditingController pointsTextEditingController = TextEditingController();
  TextEditingController commentsTextEditingController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnOkController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnDeleteController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnAttachController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnNoController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnDownloadNoController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnDownloadYesController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnFolderNoController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnFolderYesController =
      RoundedLoadingButtonController();

  DateTime selectedDate = DateTime.now();
  bool isDateChange = false;
  IcpdService icpdService = IcpdService();
  bool isSuccessMsg = false;
  File file = File("");
  MyScreenUtil? myScreenUtil;

  // String? selectedCmeType;

  // String? selectedType;
  List<EventCategory> alEventCategoryList = [];
  EventCategory? eventCategoryItem;

  List<EventAttachment> alAttachmentItemList = [];

  // EventCategory? eventCategoryItem;

  List<ICPDKeyValueData> alCategoryTypeList = [];
  ICPDKeyValueData? categoryTypeItem;

  List<ICPDKeyValueData> alStatusList = [];
  ICPDKeyValueData? statusItem;

  bool _loading = true;

  //File
  List<File>? _attachFileList = [];
  String fileExtension = "";
  String base64Attach = "";

  int eventId = 0;

  set _attachFile(File? value) {
    _attachFileList = value == null ? null : [value];
  }

  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  bool isDateChangeStatus = false;
  Map<String, dynamic> mapActivityExpDate = Map();
  List<String> lstActivityExpItem = [];

  // Widget futureWidget = Container();

  @override
  void initState() {
    firebaseAnalyticsEventCall(ICPD_PLAN_ACTIVITY_SCREEN,
        param: {"name": "iCPD Plan Activity Screen"});
    _loading = true;
    _getAlICPDKeyValueDataList();
    _getAlICPDKeyValueStatusList();
    _getAllEventCategoryList();
    _getSharePreferenceActivityExpDate();
    /*futureWidget = FutureBuilder<List<EventCategory>?>(
        future: icpdService.getCMEEventCategoryList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return getBodyEventTypeList(snapshot.data);
          }
          return Center(child: CircularProgressIndicator());
        });*/
    if (widget.isEditActivity && widget.activityListItem != null) {
      titleTextEditingController.text = widget.activityListItem?.name ?? "";
      DateTime beforeDateFormat = new DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(widget.activityListItem?.start ?? "");
      selectedDate = beforeDateFormat;
      dateTextEditingController.text =
          DateFormat('yyyy/MM/dd').format(beforeDateFormat);
      pointsTextEditingController.text =
          (widget.activityListItem?.score.toString() == "null"
                  ? ""
                  : widget.activityListItem?.score.toString()) ??
              "";
      if (beforeDateFormat.difference(DateTime.now()).inDays < 0 ||
          DateFormat("yyyy-MM-dd").format(beforeDateFormat) ==
              DateFormat("yyyy-MM-dd").format(DateTime.now())) {
        isDateChangeStatus = true;
      } else {
        isDateChangeStatus = false;
      }
      /*statusItem = ICPDKeyValueData(
          key: widget.activityListItem?.state ?? "",
          value: widget.activityListItem?.state == "draft"
              ? "In Progress"
              : "Complete");*/
      commentsTextEditingController.text =
          (widget.activityListItem?.description == "null"
                  ? ""
                  : widget.activityListItem?.description) ??
              "";
    }
    super.initState();
  }

  void _getAllEventAttachment(int eventActId) async {
    alAttachmentItemList =
        await icpdService.getCMEEventAttachmentCertificateList(eventActId) ??
            [];
    downloadAttachmentCertificate(false);
    setState(() {
      _loading = false;
    });
  }

  void _getSharePreferenceActivityExpDate() async {
    lstActivityExpItem = await SharedPref().getListData('pendingActivityDate');
  }

  void _getAllEventCategoryList() async {
    alEventCategoryList = await icpdService.getCMEEventCategoryList() ?? [];
    if (widget.isEditActivity && alEventCategoryList.length > 0) {
      for (EventCategory eventCategory in alEventCategoryList) {
        if (widget.activityListItem?.eventCategoryId?[1] ==
            eventCategory.name) {
          eventCategoryItem = eventCategory;
          eventId = eventCategory.id ?? 0;
        }
      }
    }
    if (widget.isEditActivity && widget.activityListItem != null) {
      _getAllEventAttachment(widget.activityListItem?.id ?? 0);
    } else {
      if (alEventCategoryList.isNotEmpty && alEventCategoryList.length > 0) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _getAlICPDKeyValueDataList() async {
    alCategoryTypeList
        .add(ICPDKeyValueData(key: "category1", value: "Category I"));
    alCategoryTypeList
        .add(ICPDKeyValueData(key: "category2", value: "Category II"));
    alCategoryTypeList
        .add(ICPDKeyValueData(key: "category3", value: "Category III"));
  }

  void _getAlICPDKeyValueStatusList() async {
    alStatusList.add(ICPDKeyValueData(key: "draft", value: "In Progress"));
    alStatusList.add(ICPDKeyValueData(key: "open", value: "Complete"));
  }

  @override
  Widget build(BuildContext context) {
    myScreenUtil = getScreenUtilInstance(context);
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        // title: Text('Add/Modify My Plan Activities'),
        title: Text(widget.titleName.isNotEmpty
            ? widget.titleName
            : widget.isEditActivity && widget.activityListItem != null
                ? 'Update to My Plan Activities'
                : 'Add to My Plan Activities'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : getBodyEventTypeList(),
    );
  }

  Icon dropDownIcon() {
    return Icon(
      Icons.arrow_drop_down,
      color: Colors.grey[200],
      size: 30,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await datePicker(context, selectedDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        isDateChange = true;
        selectedDate = picked;
        if (selectedDate.difference(DateTime.now()).inDays < 0) {
          isDateChangeStatus = true;
        } else {
          isDateChangeStatus = false;
        }
        dateTextEditingController.text =
            DateFormat('yyyy/MM/dd').format(selectedDate);
      });
  }

  Widget dropDownWrapper({
    required String hintText,
    required List<DropdownMenuItem<String>> items,
    required String? selectedValue,
    required onChange(String? newValue),
  }) =>
      Container(
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
        child: DropdownButton<String>(
          value: selectedValue,
          icon: dropDownIcon(),
          isExpanded: true,
          hint: Text(
            hintText,
            style: TextStyle(
              color: Colors.grey[300],
            ),
          ),
          underline: Container(),
          onChanged: (String? newValue) {
            onChange(newValue);
          },
          items: items,
        ),
      );

  Widget dropDownDynamicEventCategoryWrapper({
    // required String hintText,
    required String labelText,
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
            value: widget.isEditActivity &&
                    widget.activityListItem != null &&
                    widget.activityListItem?.eventCategoryId?[1] != null
                ? eventCategoryItem
                : eventCategoryItem,
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
              labelText: labelText,
            ),
            icon: dropDownIcon(),
            isExpanded: true,
            /*hint: Text(
              widget.activityListItem?.eventCategoryId?[1] ?? "",
              style: TextStyle(
                color: widget.isEditActivity &&
                        widget.activityListItem != null &&
                        widget.activityListItem?.eventCategoryId?[1] != null
                    ? Colors.black87
                    : Colors.grey[300],
              ),
            ),*/
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
            widget.activityListItem?.eventCategoryId?[1] ?? hintText,
            style: TextStyle(
              color: widget.isEditActivity &&
                      widget.activityListItem != null &&
                      widget.activityListItem?.eventCategoryId?[1] != null
                  ? Colors.black87
                  : Colors.grey[300],
            ),
          ),
          underline: Container(),
          onChanged: (EventCategory? newValue) {
            onChange(newValue);
          },
          items: items,
        ),
      );*/

  Widget dropDownDynamicICPDKeyValueDataWrapper({
    // required String hintText,
    required String labelText,
    required List<DropdownMenuItem<ICPDKeyValueData>> items,
    required ICPDKeyValueData selectedValue,
    required onChange(ICPDKeyValueData? newValue),
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
          child: DropdownButtonFormField<ICPDKeyValueData>(
            value: widget.isEditActivity && widget.activityListItem != null
                ? widget.activityListItem?.scoreCategory == "category1"
                    ? alCategoryTypeList[0]
                    : widget.activityListItem?.scoreCategory == "category2"
                        ? alCategoryTypeList[1]
                        : alCategoryTypeList[2]
                : categoryTypeItem,
            // value: categoryTypeItem,
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
              labelText: labelText,
            ),
            icon: dropDownIcon(),
            isExpanded: true,
            /*hint: Text(
              categoryTypeItem?.value ?? "",
              style: TextStyle(
                color: widget.isEditActivity && categoryTypeItem != null
                    ? Colors.black87
                    : Colors.grey[300],
              ),
            ),*/
            // underline: Container(),
            onChanged: (ICPDKeyValueData? newValue) {
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
        child: DropdownButton<ICPDKeyValueData>(
          value: categoryTypeItem,
          icon: dropDownIcon(),
          isExpanded: true,
          hint: Text(
            categoryTypeItem?.value ?? hintText,
            style: TextStyle(
              color: widget.isEditActivity && categoryTypeItem != null
                  ? Colors.black87
                  : Colors.grey[300],
            ),
          ),
          underline: Container(),
          onChanged: (ICPDKeyValueData? newValue) {
            onChange(newValue);
          },
          items: items,
        ),
      );*/

  Widget dropDownDynamicICPDKeyValueDataStatusWrapper({
    // required String hintText,
    required String labelText,
    required List<DropdownMenuItem<ICPDKeyValueData>> items,
    required ICPDKeyValueData selectedValue,
    required onChange(ICPDKeyValueData? newValue),
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
          child: DropdownButtonFormField<ICPDKeyValueData>(
            value: widget.isEditActivity && widget.activityListItem != null
                ? widget.activityListItem?.state == "draft"
                    ? alStatusList[0]
                    : alStatusList[1]
                : statusItem,
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
              labelText: labelText,
            ),
            icon: dropDownIcon(),
            isExpanded: isDateChangeStatus,
            /*hint: Text(
              hintText,
              style: TextStyle(
                color: widget.isEditActivity && widget.activityListItem != null
                    ? Colors.black87
                    : Colors.grey[300],
              ),
            ),*/
            // underline: Container(),
            onChanged: widget.isEditActivity && widget.activityListItem != null
                ? isDateChangeStatus
                    ? (ICPDKeyValueData? newValue) {
                        onChange(newValue);
                      }
                    : null
                : (ICPDKeyValueData? newValue) {
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
        child: DropdownButton<ICPDKeyValueData>(
          value: statusItem,
          icon: dropDownIcon(),
          isExpanded: true,
          hint: Text(
            widget.isEditActivity && widget.activityListItem != null
                ? widget.activityListItem?.state == "draft"
                    ? "In Progress"
                    : "Complete"
                : hintText,
            style: TextStyle(
              color: widget.isEditActivity && widget.activityListItem != null
                  ? Colors.black87
                  : Colors.grey[300],
            ),
          ),
          underline: Container(),
          onChanged: (ICPDKeyValueData? newValue) {
            onChange(newValue);
          },
          items: items,
        ),
      );*/

  Widget getBodyEventTypeList() {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
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
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: FormFieldWidget(
                      controller: dateTextEditingController,
                      hintText: 'Date*',
                      readonly: true,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/gray_calender_icon.png',
                            height: 22,
                            width: 22,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                dropDownDynamicEventCategoryWrapper(
                  // hintText: "Type*",
                  labelText: "Type*",
                  items: alEventCategoryList.map((EventCategory eventCategory) {
                    return DropdownMenuItem<EventCategory>(
                      value: eventCategory,
                      child: Text(
                        eventCategory.name ?? "",
                      ),
                    );
                  }).toList(),
                  onChange: (EventCategory? newValue) {
                    setState(() {
                      eventId = newValue?.id ?? 0;
                      eventCategoryItem = newValue ?? EventCategory();
                    });
                  },
                  selectedValue: eventCategoryItem ?? EventCategory(),
                ),
                Visibility(
                  visible: widget.planProcessingClass == "td",
                  child: FormFieldWidget(
                    controller: pointsTextEditingController,
                    hintText: 'Points*',
                    textInputType: TextInputType.number,
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.planProcessingClass == "td",
                  child: dropDownDynamicICPDKeyValueDataWrapper(
                    // hintText: "CME Type*",
                    labelText: "CME Type*",
                    items: alCategoryTypeList
                        .map((ICPDKeyValueData icpdKeyValueData) {
                      return DropdownMenuItem<ICPDKeyValueData>(
                        value: icpdKeyValueData,
                        child: Text(
                          icpdKeyValueData.value ?? "",
                        ),
                      );
                    }).toList(),
                    onChange: (ICPDKeyValueData? newValue) {
                      setState(() {
                        categoryTypeItem = newValue ?? ICPDKeyValueData();
                      });
                    },
                    selectedValue: categoryTypeItem ?? ICPDKeyValueData(),
                  ),
                ),
                dropDownDynamicICPDKeyValueDataStatusWrapper(
                  // hintText: "Status*",
                  labelText: "Status*",
                  items: alStatusList.map((ICPDKeyValueData icpdKeyValueData) {
                    return DropdownMenuItem<ICPDKeyValueData>(
                      value: icpdKeyValueData,
                      child: Text(
                        icpdKeyValueData.value ?? "",
                      ),
                    );
                  }).toList(),
                  onChange: (ICPDKeyValueData? newValue) {
                    setState(() {
                      statusItem = newValue ?? ICPDKeyValueData();
                    });
                  },
                  selectedValue: statusItem ?? ICPDKeyValueData(),
                ),
                /*dropDownWrapper(
              hintText: "Status",
              items: [
                DropdownMenuItem<String>(
                  value: "draft",
                  child: Text("In Progress"),
                ),
                DropdownMenuItem<String>(
                  value: "open",
                  child: Text("Complete"),
                ),
              ],
              onChange: (String? newValue) {
                setState(() {
                  selectedStatus = newValue;
                });
              },
              selectedValue: selectedStatus,
            ),*/
                GestureDetector(
                  /*onTap: () {
                    /*alAttachmentItemList.length > 0
                        ? alAttachmentItemList[0].eventAttachmentId != null
                            ? _showAttachmentDownloadDialog()
                            : _showImagePickerDialog(context)
                        : _showImagePickerDialog(context);*/
                  },*/
                  onTap: _showImagePickerDialog,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: [
                        Text(
                          "Attach Certificate",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff686767),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Image.asset(
                          'assets/images/upload_icon.png',
                          height: 30.0,
                          width: 30.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Visibility(
                          visible: widget.isEditActivity ||
                              _attachFileList!.length > 0,
                          child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Text(
                                  widget.isEditActivity &&
                                          alAttachmentItemList[0]
                                                  .eventAttachmentId !=
                                              null
                                      ? "Attach_${DateFormat("yyyyMMdd").format(DateTime.parse(widget.activityListItem!.start ?? ""))}\n.png"
                                      : _attachFileList!.length > 0
                                          ? "Attach_${DateFormat("yyyyMMdd").format(DateTime.now())}\n$fileExtension"
                                          : "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff686767),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Visibility(
                                  visible: widget.isEditActivity &&
                                      alAttachmentItemList[0]
                                              .eventAttachmentId !=
                                          null,
                                  child: InkWell(
                                    onTap: () async {
                                      if (await PermissionUtil
                                          .getStoragePermission(
                                        context: context,
                                        screenUtil: myScreenUtil,
                                      )) {
                                        _showAttachmentDownloadDialog();
                                      }
                                    },
                                    child: Icon(
                                      Icons.download,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                /*Image.asset(
                                  'assets/images/upload_icon.png',
                                  height: 30.0,
                                  width: 30.0,
                                ),*/
                              ],
                            ),
                          ),
                        )
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
                /* LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 60,
                      width: constraints.biggest.width / 2 - 5,
                      onPressed: () async {
                        _btnController.reset();
                        if (dateTextEditingController.text.trim().isEmpty ||
                            titleTextEditingController.text.trim().isEmpty ||
                            pointsTextEditingController.text.trim().isEmpty ||
                            commentsTextEditingController.text.trim().isEmpty) {
                          _btnController.reset();
                          showSnackBar(
                              context, "Please fill in all required fields.");
                          return;
                        }
                        MyIcpdCreateActivityRequest
                            myIcpdCreateActivityRequest =
                            MyIcpdCreateActivityRequest(
                                planId: widget.planId,
                                name: titleTextEditingController.text,
                                description: commentsTextEditingController.text,
                                start: DateFormat('yyyy-MM-dd')
                                        .format(selectedDate) +
                                    " " +
                                    DateFormat('hh:mm:ss')
                                        .format(DateTime.now()),
                                stop: DateFormat('yyyy-MM-dd')
                                        .format(selectedDate) +
                                    " " +
                                    DateFormat('hh:mm:ss')
                                        .format(DateTime.now()),
                                score:
                                    int.parse(pointsTextEditingController.text),
                                eventCategoryId: eventCategoryItem?.id,
                                scoreCategory: categoryTypeItem?.key,
                                state: statusItem?.key);

                        CommonResultMessage? icpdCommonModel = await icpdService
                            .createMyActivity(myIcpdCreateActivityRequest);
                        if (icpdCommonModel == null) {
                          showSnackBar(context, INTERNAL_SERVER_ERROR);
                          // _btnController.error();
                          _btnController.reset();
                        } else {
                          if (icpdCommonModel.isSuccess ?? false) {
                            showSnackBar(
                                context,
                                icpdCommonModel.message ??
                                    "Successfully Changed.",
                                isSuccess: true);
                            _btnController.success();
                            Future.delayed(
                              const Duration(seconds: 1),
                                  () => Navigator.of(context).pop(),
                            );
                          } else {
                            showSnackBar(
                                context,
                                icpdCommonModel.message ??
                                    INTERNAL_SERVER_ERROR);
                            _btnController.reset();
                          }
                        }
                      },
                      color: primaryColor,
                      animateOnTap: true,
                      controller: _btnController,
                      child: Text(
                        "Add/Modify",
                        style: Theme.of(context)
                            .textTheme
                            .display1!
                            .apply(
                              color: Colors.white,
                            )
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 60,
                      width: constraints.biggest.width / 2 - 5,
                      onPressed: () async {
                        _deleteBtnController.reset();
                      },
                      color: primaryColor,
                      animateOnTap: true,
                      controller: _deleteBtnController,
                      child: Text(
                        // "Delete Activity",
                        "Delete",
                        style: Theme.of(context)
                            .textTheme
                            .display1!
                            .apply(
                              color: Colors.white,
                            )
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                );
              },
            ),*/
                SizedBox(
                  height: 60,
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
                  child: Row(
                    mainAxisAlignment: widget.isEditActivity
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.center,
                    children: [
                      RoundedLoadingButton(
                        borderRadius: 6,
                        height: 60,
                        width: constraints.biggest.width / 2.5 - 5,
                        onPressed: () async {
                          /*if (dateTextEditingController.text.trim().isEmpty ||
                              titleTextEditingController.text.trim().isEmpty ||
                              pointsTextEditingController.text.trim().isEmpty ||
                              commentsTextEditingController.text
                                  .trim()
                                  .isEmpty ||
                              base64Attach.isEmpty) {
                            _btnController.reset();
                            isSuccessMsg = false;
                            showDialogSuccess(
                                "Please fill in all required fields.");
                            // showSnackBar(
                            //     context, "Please fill in all required fields.");
                            return;
                          }*/
                          if (titleTextEditingController.text.trim().isEmpty) {
                            _btnController.reset();
                            isSuccessMsg = false;
                            showDialogSuccess("Please enter the title.");
                            return;
                          }
                          if (dateTextEditingController.text.trim().isEmpty) {
                            _btnController.reset();
                            isSuccessMsg = false;
                            showDialogSuccess("Please select the date.");
                            return;
                          }
                          if (eventId == 0) {
                            _btnController.reset();
                            isSuccessMsg = false;
                            showDialogSuccess("Please select the type.");
                            return;
                          }
                          if (widget.planProcessingClass == "td") {
                            if (pointsTextEditingController.text
                                .trim()
                                .isEmpty) {
                              _btnController.reset();
                              isSuccessMsg = false;
                              showDialogSuccess("Please enter the points.");
                              return;
                            }
                            if (categoryTypeItem?.key == null &&
                                widget.activityListItem == null) {
                              _btnController.reset();
                              isSuccessMsg = false;
                              showDialogSuccess("Please select the CME type.");
                              return;
                            }
                          }
                          if (statusItem?.key == null &&
                              widget.activityListItem == null) {
                            _btnController.reset();
                            isSuccessMsg = false;
                            showDialogSuccess("Please select the status.");
                            return;
                          }
                          /*if (base64Attach.isEmpty) {
                            _btnController.reset();
                            isSuccessMsg = false;
                            showDialogSuccess(
                                "Please select the attachment certificate.");
                            return;
                          }*/
                          /*if (commentsTextEditingController.text
                              .trim()
                              .isEmpty) {
                            _btnController.reset();
                            isSuccessMsg = false;
                            showDialogSuccess("Please enter the comments.");
                            return;
                          }*/
                          if (!widget.isEditActivity &&
                              statusItem?.key != "open") {
                            print("widget.planId : ${widget.planTypeIndex}");
                            ActivityExpItem activityExpItem = ActivityExpItem(
                                planTypeIndex: widget.planTypeIndex,
                                activityName:
                                    titleTextEditingController.text.toString(),
                                activityExpDate: DateFormat('yyyy-MM-dd')
                                    .format(selectedDate));

                            mapActivityExpDate = {
                              'planTypeIndex': activityExpItem.planTypeIndex,
                              'activityName': activityExpItem.activityName,
                              'activityExpDate': activityExpItem.activityExpDate
                            };
                            String rawJson = jsonEncode(mapActivityExpDate);

                            lstActivityExpItem.add(rawJson);

                            await SharedPref.setListData(
                                "pendingActivityDate", lstActivityExpItem);
                          }
                          MyIcpdCreateActivityRequest
                              myIcpdCreateActivityRequest =
                              MyIcpdCreateActivityRequest(
                                  planId: widget.planId,
                                  name: titleTextEditingController.text,
                                  description:
                                      commentsTextEditingController.text,
                                  start: DateFormat('yyyy-MM-dd')
                                          .format(selectedDate) +
                                      " " +
                                      DateFormat('hh:mm:ss')
                                          .format(DateTime.now()),
                                  stop: DateFormat('yyyy-MM-dd')
                                          .format(selectedDate) +
                                      " " +
                                      DateFormat('hh:mm:ss')
                                          .format(DateTime.now()),
                                  score: widget.planProcessingClass == "td"
                                      ? double.parse(
                                          pointsTextEditingController.text)
                                      : 0.0,
                                  eventCategoryId: eventId,
                                  scoreCategory:
                                      widget.planProcessingClass == "td"
                                          ? categoryTypeItem?.key != null
                                              ? categoryTypeItem?.key
                                              : widget.activityListItem
                                                  ?.scoreCategory
                                          : "",
                                  state: statusItem?.key != null
                                      ? statusItem?.key
                                      : widget.activityListItem?.state);

                          if (widget.isEditActivity &&
                              statusItem?.key == "open") {
                            await icpdService.updateMarkAsCompleteMyActivity(
                                widget.activityListItem?.id ?? 0);
                          }

                          MyIcpdUpdateActivityRequest
                              myIcpdUpdateActivityRequest =
                              MyIcpdUpdateActivityRequest(
                                  id: widget.activityListItem?.id,
                                  name: titleTextEditingController.text,
                                  description:
                                      commentsTextEditingController.text,
                                  start: DateFormat('yyyy-MM-dd')
                                          .format(selectedDate) +
                                      " " +
                                      DateFormat('hh:mm:ss').format(isDateChange
                                          ? DateTime.now()
                                          : selectedDate),
                                  stop: DateFormat('yyyy-MM-dd')
                                          .format(selectedDate) +
                                      " " +
                                      DateFormat('hh:mm:ss').format(isDateChange
                                          ? DateTime.now()
                                          : selectedDate),
                                  score: widget.planProcessingClass == "td"
                                      ? double.parse(
                                          pointsTextEditingController.text)
                                      : 0.0,
                                  eventCategoryId: eventId,
                                  scoreCategory:
                                      widget.planProcessingClass == "td"
                                          ? categoryTypeItem?.key != null
                                              ? categoryTypeItem?.key
                                              : widget.activityListItem
                                                  ?.scoreCategory
                                          : "",
                                  /*scoreCategory:
                                      widget.planProcessingClass == "td"
                                          ? categoryTypeItem?.key
                                          : "",*/
                                  state: statusItem?.key ??
                                      widget.activityListItem?.state);

                          CommonResultMessage? icpdCommonModel = widget
                                  .isEditActivity
                              ? await icpdService
                                  .updateMyActivity(myIcpdUpdateActivityRequest)
                              : await icpdService.createMyActivity(
                                  myIcpdCreateActivityRequest);
                          if (icpdCommonModel == null) {
                            // showSnackBar(context, INTERNAL_SERVER_ERROR);
                            // _btnController.error();
                            _btnController.reset();
                            isSuccessMsg = false;
                            showDialogSuccess(INTERNAL_SERVER_ERROR);
                          } else {
                            if (icpdCommonModel.isSuccess ?? false) {
                              /*showSnackBar(
                                  context,
                                  icpdCommonModel.message ??
                                      "Successfully Changed.",
                                  isSuccess: true);
                              _btnController.success();
                              Future.delayed(
                                const Duration(seconds: 1),
                                () => Navigator.of(context).pop(),
                              );*/
                              if (base64Attach.isNotEmpty) {
                                if (widget.isEditActivity) {
                                  showDialogAttachmentConfirm(
                                      "${icpdCommonModel.message} Would you like to replace an attachment a certificate to this activity?",
                                      icpdCommonModel.data?.planId ??
                                          widget.activityListItem?.id ??
                                          0);
                                } else {
                                  btnAttachmentToActivity(
                                      icpdCommonModel.data?.planId ??
                                          widget.activityListItem?.id ??
                                          0);
                                }
                              } else {
                                _btnController.success();
                                isSuccessMsg = true;
                                showDialogSuccess(icpdCommonModel.message ??
                                    "Successfully Changed.");
                              }
                              /* _btnController.success();
                              isSuccessMsg = true;
                              showDialogSuccess(icpdCommonModel.message ??
                                  "Successfully Changed.");*/
                            } else {
                              // showSnackBar(
                              //     context,
                              //     icpdCommonModel.message ??
                              //         INTERNAL_SERVER_ERROR);
                              // _btnController.error();
                              _btnController.reset();
                              isSuccessMsg = false;
                              showDialogSuccess(icpdCommonModel.message ??
                                  INTERNAL_SERVER_ERROR);
                            }
                          }
                        },
                        color: primaryColor,
                        animateOnTap: true,
                        controller: _btnController,
                        child: Text(
                          widget.isEditActivity &&
                                  widget.activityListItem != null
                              ? "Update"
                              : "Add",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .apply(
                                color: Colors.white,
                              )
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Visibility(
                        visible: widget.isEditActivity,
                        child: RoundedLoadingButton(
                          borderRadius: 6,
                          height: 60,
                          width: constraints.biggest.width / 2.5 - 5,
                          onPressed: () async {
                            showDialogDeleteActivity(
                                "Would you like to delete a activity?",
                                widget.activityListItem?.id ?? 0);
                          },
                          color: primaryColor,
                          animateOnTap: true,
                          controller: _btnDeleteController,
                          child: Text(
                            // "Delete Activity",
                            "Delete",
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
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  void _onAttachCertificateClick(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );
      setState(() {
        _attachFile = File(pickedFile!.path);
        fileExtension = p.extension(_attachFileList![0].path);
        List<int> attachBytes = _attachFileList![0].readAsBytesSync();
        base64Attach = base64Encode(attachBytes);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> _showImagePickerDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Attachment Certificate !!!'),
            actions: <Widget>[
              TextButton(
                  child: const Text('CAMERA'),
                  onPressed: () {
                    _onAttachCertificateClick(ImageSource.camera);
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: const Text('GALLERY'),
                  onPressed: () {
                    _onAttachCertificateClick(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _showAttachmentDownloadDialog() {
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
                  "Do you want to download the attachment certificate?",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 4,
                      onPressed: submitRequest,
                      color: mutedTextColor,
                      animateOnTap: true,
                      controller: _btnDownloadNoController,
                      child: Text(
                        "No",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .apply(
                              color: Colors.white,
                            )
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 4,
                      onPressed: () {
                        downloadAttachmentCertificate(true);
                      },
                      color: primaryColor,
                      animateOnTap: true,
                      controller: _btnDownloadYesController,
                      child: Text(
                        "Yes",
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
            ],
          ),
        ),
      ),
    );
  }

  void showDialogAttachmentConfirm(String message, int eventId) {
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
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 4,
                      onPressed: () {
                        _btnNoAttachment(true);
                      },
                      color: mutedTextColor,
                      animateOnTap: true,
                      controller: _btnNoController,
                      child: Text(
                        "No",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .apply(
                              color: Colors.white,
                            )
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 4,
                      onPressed: () {
                        btnAttachmentToActivity(eventId);
                      },
                      color: primaryColor,
                      animateOnTap: true,
                      controller: _btnAttachController,
                      child: Text(
                        "Yes",
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
            ],
          ),
        ),
      ),
    );
  }

  void showDialogDeleteActivity(String message, int activityId) {
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
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 4,
                      onPressed: () {
                        _btnNoAttachment(false);
                      },
                      color: mutedTextColor,
                      animateOnTap: true,
                      controller: _btnNoController,
                      child: Text(
                        "No",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .apply(
                              color: Colors.white,
                            )
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 4,
                      onPressed: () {
                        btnDeleteToActivity(activityId);
                      },
                      color: primaryColor,
                      animateOnTap: true,
                      controller: _btnAttachController,
                      child: Text(
                        "Yes",
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
            ],
          ),
        ),
      ),
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
                onPressed: submitRequest,
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

  void _btnNoAttachment(bool isAttachment) async {
    if (isAttachment) {
      _btnController.success();
    } else {
      _btnDeleteController.reset();
    }
    isSuccessMsg = isAttachment;
    await submitRequest();
  }

  void btnAttachmentToActivity(int eventId) async {
    CommonResultMessage? icpdCommonAttachModel =
        await icpdService.createMyActivityAttachment(eventId, base64Attach);
    if (icpdCommonAttachModel == null) {
      _btnController.reset();
      isSuccessMsg = false;
      showDialogSuccess(INTERNAL_SERVER_ERROR);
    } else {
      if (icpdCommonAttachModel.isSuccess ?? false) {
        _btnController.success();
        isSuccessMsg = true;
        if (widget.isEditActivity) {
          Navigator.of(context).pop();
        }
        showDialogSuccess(
            icpdCommonAttachModel.message ?? "Successfully Changed.");
      } else {
        _btnController.reset();
        isSuccessMsg = false;
        showDialogSuccess(
            icpdCommonAttachModel.message ?? INTERNAL_SERVER_ERROR);
      }
    }
  }

  void btnDeleteToActivity(int activityId) async {
    CommonResultMessage? icpdCommonAttachModel =
        await icpdService.deleteMyActivity(activityId);
    if (icpdCommonAttachModel == null) {
      _btnDeleteController.reset();
      isSuccessMsg = false;
      showDialogSuccess(INTERNAL_SERVER_ERROR);
    } else {
      if (icpdCommonAttachModel.isSuccess ?? false) {
        _btnDeleteController.success();
        isSuccessMsg = true;
        if (widget.isEditActivity) {
          Navigator.of(context).pop();
        }
        showDialogSuccess(
            icpdCommonAttachModel.message ?? "Successfully Changed.");
      } else {
        _btnController.reset();
        isSuccessMsg = false;
        showDialogSuccess(
            icpdCommonAttachModel.message ?? INTERNAL_SERVER_ERROR);
      }
    }
  }

  Future<void> submitRequest() async {
    if (isSuccessMsg) {
      Navigator.of(context).pop();
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context);
    }
  }

  void _showDownloadDirDialog(String filePath) {
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
                  "Certificates attached to this plan have been saved to\n$filePath",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /*RoundedLoadingButton(
                          borderRadius: 6,
                          height: 40,
                          width: constraints.biggest.width / 2.5 - 5,
                          onPressed: submitRequest,
                          color: mutedTextColor,
                          animateOnTap: true,
                          controller: _btnFolderNoController,
                          child: Text(
                            "No",
                            style: Theme.of(context)
                                .textTheme
                                .display1!
                                .apply(
                                  color: Colors.white,
                                )
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),*/
                    RoundedLoadingButton(
                      borderRadius: 6,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 4,
                      onPressed: submitRequest,
                      color: primaryColor,
                      animateOnTap: true,
                      controller: _btnFolderYesController,
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> downloadAttachmentCertificate(bool isDownload) async {
    if (alAttachmentItemList.isNotEmpty && alAttachmentItemList.length > 0) {
      if (alAttachmentItemList[0].eventAttachmentId != null) {
        /*base64Attach = alAttachmentItemList[0].eventAttachmentId ?? "";
        if (isDownload) {
          Uint8List decoded = base64Decode(alAttachmentItemList[0]
              .eventAttachmentId
              .toString()
              .replaceAll("\n", ""));
          String dir = (await getApplicationSupportDirectory()).path;
          File file = File("$dir/" +
              "Attach_${DateFormat("yyyyMMdd").format(
                  DateTime.parse(widget.activityListItem!.start ?? ""))}" +
              ".png");
          await file.writeAsBytes(decoded);*/
        if (isDownload) {
          final directory = Directory("storage/emulated/0/hola medico");
          directory.create(recursive: true);
          if ((await directory.exists())) {
            // TODO:
            print("exist");
          } else {
            // TODO:
            print("not exist");
            directory.create();
          }
          String path = directory.path;
          print(path);
          file = File("/$path/" +
              "Attach_Activity_${widget.activityListItem!.id ?? 0}" +
              ".png");
          await file.create(recursive: true);
          Uint8List decoded = base64Decode(alAttachmentItemList[0]
              .eventAttachmentId
              .toString()
              .replaceAll("\n", ""));
          await file.writeAsBytes(decoded);
          Navigator.pop(context);
          _showDownloadDirDialog(file.absolute.path);
        }
      }
    }
  }
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);
