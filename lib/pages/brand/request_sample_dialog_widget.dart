import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/api_status_model.dart';
import 'package:pharmaaccess/models/brand/product_model.dart';
import 'package:pharmaaccess/models/state_list_item.dart';
import 'package:pharmaaccess/pages/cardio_module/constants.dart';
import 'package:pharmaaccess/services/brand_service.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../theme.dart';

class RequestSampleDialog extends StatefulWidget {
  final ProductModel? product;

  RequestSampleDialog({Key? key, this.product}) : super(key: key);

  @override
  _RequestSampleDialogState createState() => _RequestSampleDialogState();
}

class _RequestSampleDialogState extends State<RequestSampleDialog> {
  ScrollController _scrollController = new ScrollController();
  final quantity = TextEditingController();
  final message = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final BrandService brandService = BrandService();
  List<String> lstByMail = ['Work Address', 'Home Address', 'Other Address'];
  int selectedByMail = 0;
  StreamController<int> selectedByMailStreamController =
      StreamController<int>.broadcast();
  bool isByMail = false;
  bool isCinfaPersonal = false;

  TextEditingController streetTextEditingController = TextEditingController();
  TextEditingController street2TextEditingController = TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();
  TextEditingController zipTextEditingController = TextEditingController();
  final RoundedLoadingButtonController _btnOkController =
      RoundedLoadingButtonController();
  bool isSuccessMsg = false;
  int countryIdIndex = 0;
  List<int?> lstCountriesId = [
    123,
    188,
    194,
    2,
  ];

  List<String?> lstCountries = [
    'Kuwait',
    'Qatar',
    'Saudi Arabia',
    'United Arab Emirates',
  ];
  String? _selectedCountry;

  List<StateItem> lstStateItem = [];
  StateItem? _selectedState;

  @override
  void initState() {
    _selectedCountry = lstCountries[0].toString();
    firebaseAnalyticsEventCall(SAMPLE_REQUEST_EVENT,
        param: {"Brand Sample": widget.product!.name});
    super.initState();
  }

  @override
  void dispose() {
    quantity.dispose();
    super.dispose();
  }

  void _submitRequest() async {
//    Timer(Duration(seconds: 3), () {
//      _btnController.success();
//      Timer(Duration(milliseconds: 700),() {
//        Navigator.pop(context);
//      });
//    });
    if (!isByMail && !isCinfaPersonal) {
      _btnController.reset();
      showDialogSuccess("Please select delivery method.");
      return;
    }

    if (isByMail) {
      if (streetTextEditingController.text.trim().isEmpty) {
        _btnController.reset();
        showDialogSuccess("Please enter street.");
        return;
      }

      if (street2TextEditingController.text.trim().isEmpty) {
        _btnController.reset();
        showDialogSuccess("Please enter street2.");
        return;
      }
      if (cityTextEditingController.text.trim().isEmpty) {
        _btnController.reset();
        showDialogSuccess("Please enter city.");
        return;
      }
      if (_selectedState.toString().trim().isEmpty) {
        _btnController.reset();
        showDialogSuccess("Please enter state.");
        return;
      }
      if (zipTextEditingController.text.trim().isEmpty) {
        _btnController.reset();
        showDialogSuccess("Please enter zip.");
        return;
      }
    }
    print("_submitRequest _selectedState is : ${_selectedState?.id}");
    var brandService = BrandService();
    var status = await brandService.requestProductSample(
      selectedByMail,
      widget.product!.id,
      1,
      isByMail ? "mail" : "person",
      isByMail ? streetTextEditingController.text : "",
      isByMail ? street2TextEditingController.text : "",
      isByMail ? cityTextEditingController.text : "",
      isByMail ? _selectedState?.id.toString() ?? "" : "",
      isByMail ? lstCountriesId[countryIdIndex].toString() : "",
      isByMail ? zipTextEditingController.text : "",
    );

    if (status.apiStatus == API_STATUS.success) {
      _btnController.success();
      isSuccessMsg = true;
      showDialogSuccess(status.message!);
      /*setState(() {
          message.text = status.message!;
        });
        Timer(Duration(milliseconds: 2000), () {
          Navigator.pop(context);
        });*/
    } else {
      /*_btnController.error();
        setState(() {
          message.text = status.message!;
        });*/
      _btnController.reset();
      isSuccessMsg = false;
      showDialogSuccess(status.message!);
    }
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
                onPressed: _submitDialogSuccess,
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

  void _submitDialogSuccess() async {
    if (isSuccessMsg) {
      Navigator.of(context).pop();
      Navigator.pop(context, true);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text("Sample Request", style: Theme.of(context).textTheme.headline4),
      content: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                bottom: 8,
              ),
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFEDEDED),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.product!.name!,
                style: TextStyle(color: mutedTextColor, fontSize: 18),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[200]!),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Delivery Method',
                            style: kBodyTextStyle,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showSelectByMail();
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * .23,
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                    color:
                                        isByMail ? primaryColor : Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        isByMail
                                            ? lstByMail[selectedByMail]
                                            : 'By Mail',
                                        textAlign: TextAlign.center,
                                        style: isByMail
                                            ? kTextStyleWhite
                                            : kTextStyleBlack,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isCinfaPersonal = true;
                                    isByMail = false;
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * .32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                    color: isCinfaPersonal
                                        ? primaryColor
                                        : Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'By Cinfa Professional',
                                        textAlign: TextAlign.center,
                                        style: isCinfaPersonal
                                            ? kTextStyleWhite
                                            : kTextStyleBlack,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isByMail,
              child: Container(
                margin: EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FormFieldWidget(
                      controller: streetTextEditingController,
                      hintText: 'Street...',
                    ),
                    /*SizedBox(
                      height: 10,
                    ),*/
                    FormFieldWidget(
                      controller: street2TextEditingController,
                      hintText: 'Street 2...',
                    ),
                    FormFieldWidget(
                      controller: cityTextEditingController,
                      hintText: 'City',
                    ),
                    /*SizedBox(
                      height: 10,
                    ),*/
                    Visibility(
                      visible: lstStateItem.length > 0,
                      child: dropDownDynamicStateWrapper(
                        labelText: "State*",
                        items: lstStateItem.map((StateItem stateItem) {
                          return DropdownMenuItem<StateItem>(
                            value: stateItem,
                            child: Text(stateItem.name ?? ""),
                          );
                        }).toList(),
                        onChange: (StateItem? newValue) {
                          setState(() {
                            _selectedState = newValue;
                          });
                        },
                        selectedValue: _selectedState ?? StateItem(),
                      ),
                    ),
                    /*SizedBox(
                      height: 10,
                    ),*/
                    FormFieldWidget(
                      controller: zipTextEditingController,
                      hintText: 'ZIP',
                    ),
                    /*SizedBox(
                      height: 10,
                    ),*/
                    dropDownDynamicCountryWrapper(
                      labelText: "Country*",
                      items: lstCountries
                          .map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value!),
                        );
                      }).toList(),
                      onChange: (String? newValue) {
                        setState(() {
                          _selectedCountry = newValue;
                          if (_selectedCountry == "Kuwait") {
                            countryIdIndex = 0;
                          } else if (_selectedCountry == "Qatar") {
                            countryIdIndex = 1;
                          } else if (_selectedCountry == "Saudi Arabia") {
                            countryIdIndex = 2;
                          } else if (_selectedCountry ==
                              "United Arab Emirates") {
                            countryIdIndex = 3;
                          }
                          _getCountryToStateList();
                        });
                      },
                      selectedValue:
                          _selectedCountry ?? lstCountries[0].toString(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RoundedLoadingButton(
                borderRadius: 6,
                height: 60,
                onPressed: _submitRequest,
                color: primaryColor,
                animateOnTap: true,
                controller: _btnController,
                child: Text(
                  "SUBMIT",
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .apply(
                        color: Colors.white,
                      )
                      .copyWith(fontWeight: FontWeight.w600),
                )),
//          Container(
//            margin: EdgeInsets.all(12),
//            child: Center(
//              child: Text("Or email us at", style: mutedText),
//            ),
//          ),
//          Container(
//            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//            decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(8),
//              border: Border.all(color: primaryColor, width: 4),
//            ),
//            child: Row(
//              children: <Widget>[
//                FaIcon(FontAwesomeIcons.mobileAlt, color: primaryColor),
//                Padding(
//                  padding: EdgeInsets.only(left: 8),
//                  child: Text("00 971 4 4329857", style: TextStyle(color: primaryColor, fontSize: 18)),
//                ),
//              ],
//            ),
//          ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: message.text.isEmpty
                  ? Container()
                  : Text(message.text,
                      style: styleSmallBodyText.copyWith(color: primaryColor)),
            ),
          ],
        )),
      ),
    );
  }

  showSelectByMail() {
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
                      "By Mail",
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
                  height: 10.0,
                ),
                StreamBuilder<int>(
                  initialData: selectedByMail,
                  stream: selectedByMailStreamController.stream,
                  builder: (context, snap) {
                    return Column(
                      children: [
                        for (int index = 0; index < lstByMail.length; index++)
                          customRadioButton(
                              lstByMail[index], index, snap.data!),
                      ],
                    );
                  },
                ),
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
              Navigator.of(context).pop();
              setState(() {
                _getAddressDataAPI(index);
                _getCountryToStateList();
                isByMail = true;
                isCinfaPersonal = false;
                selectedByMail = index;
                selectedByMailStreamController.add(index);
              });
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

  void _getAddressDataAPI(int selectedIndex) async {
    var addressItem = await brandService.getSampleRequestAddress(selectedIndex);
    if (addressItem != null) {
      setState(() {
        streetTextEditingController.text = addressItem.address1Street ?? "";
        street2TextEditingController.text = addressItem.address1Street2 ?? "";
        cityTextEditingController.text = addressItem.address1City ?? "";
        _selectedState = StateItem(
            id: addressItem.address1State?.id,
            name: addressItem.address1State?.name);
        zipTextEditingController.text = addressItem.address1Zip ?? "";
        _selectedCountry = addressItem.address1Country?.name ?? "";
      });
    } else {
      setState(() {
        streetTextEditingController.text = "";
        street2TextEditingController.text = "";
        cityTextEditingController.text = "";
        _selectedState = StateItem();
        zipTextEditingController.text = "";
        _selectedCountry = lstCountries[0].toString();
      });
    }
    print("_getAddressDataAPI _selectedState is : ${_selectedState?.id}");
  }

  Widget dropDownDynamicCountryWrapper({
    required String labelText,
    required List<DropdownMenuItem<String>> items,
    required String selectedValue,
    required onChange(String? newValue),
  }) {
    return Container(
      margin: EdgeInsets.only(top: 6, bottom: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _selectedCountry != null && _selectedCountry!.isNotEmpty
              ? _selectedCountry
              : lstCountries[0],
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
          onChanged: (String? newValue) {
            onChange(newValue);
          },
          items: items,
        ),
      ),
    );
  }

  Widget dropDownDynamicStateWrapper({
    required String labelText,
    required List<DropdownMenuItem<StateItem>> items,
    required StateItem selectedValue,
    required onChange(StateItem? newValue),
  }) =>
      Container(
        margin: EdgeInsets.only(top: 6, bottom: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<StateItem>(
            value: lstStateItem != null && lstStateItem.length > 0
                ? lstStateItem[0]
                : _selectedState,
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
            onChanged: (StateItem? newValue) {
              onChange(newValue);
            },
            items: items,
          ),
        ),
      );

  Icon dropDownIcon() {
    return Icon(
      Icons.arrow_drop_down,
      color: Colors.grey[200],
      size: 30,
    );
  }

  void _getCountryToStateList() async {
    lstStateItem = await brandService
            .getCountryWiseState(lstCountriesId[countryIdIndex]) ??
        [];
    setState(() {
      if (lstStateItem.length > 0) {
        _selectedState =
            StateItem(id: lstStateItem[0].id, name: lstStateItem[0].name);
      } else {
        _selectedState = StateItem();
      }
      print("_getCountryToStateList _selectedState is : ${_selectedState?.id}");
    });
  }
}
