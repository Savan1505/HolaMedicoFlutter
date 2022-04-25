import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/ProductListResModel.dart';
import 'package:pharmaaccess/models/api_status_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/models/state_list_item.dart';
import 'package:pharmaaccess/pages/cardio_module/constants.dart';
import 'package:pharmaaccess/services/brand_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/ShowSnackBar.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SampleRequestPage extends StatefulWidget {
  @override
  _SampleRequestPageState createState() => _SampleRequestPageState();
}

class _SampleRequestPageState extends State<SampleRequestPage> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController<List<ProductItemModel>?> productsStreamController =
      StreamController<List<ProductItemModel>?>.broadcast();

  StreamController<List<ProductItemModel>> selectedProductsStreamController =
      StreamController<List<ProductItemModel>>.broadcast();

  List<ProductItemModel>? listProduct;

  List<ProductItemModel> selectedListProduct = [];

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
    firebaseAnalyticsEventCall(SAMPLE_REQUEST_SCREEN,
        param: {"name": "Sample Request Screen"});
    _selectedCountry = lstCountries[0].toString();
    productListApiCall();
    super.initState();
  }

  Future<void> productListApiCall() async {
    ProfileModel? provider = await DBProvider().getProfile();
    String? countryName = provider?.countryName;

    if (countryName != null && countryName.isNotEmpty) {
      List<ProductItemModel>? prodList =
          await brandService.getProduct(countryName);
      if (prodList != null) {
        productsStreamController.add(prodList);
      } else {
        Navigator.of(context).pop();
        showSnackBar(context, INTERNAL_SERVER_ERROR);
      }
    } else {
      Navigator.of(context).pop();
      showSnackBar(context, "Please select Country first");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Sample Request'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 7, top: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[200]!),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product : ',
                                  style: kTitleTextStyle,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                StreamBuilder<List<ProductItemModel>?>(
                                  initialData: listProduct,
                                  stream: productsStreamController.stream,
                                  builder: (_, snapshot) {
                                    return snapshot.data == null
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : getSearchableDropdown(snapshot.data);
                                  },
                                ),
                                StreamBuilder<List<ProductItemModel>>(
                                  initialData: selectedListProduct,
                                  stream:
                                      selectedProductsStreamController.stream,
                                  builder: (_, snapshot) => Wrap(
                                    children: selectedListProduct
                                        .map((e) => Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(e.name!),
                                                  Spacer(),
                                                  GestureDetector(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 15,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      selectedListProduct
                                                          .remove(e);
                                                      selectedProductsStreamController
                                                          .add(
                                                              selectedListProduct);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                )
                              ],
                            ),
                          ),
                          /*Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Container(
                          child: RoundedLoadingButton(
                              borderRadius: 6,
                              height: 60,
                              onPressed: () async {
                                if (selectedListProduct.isEmpty) {
                                  _scaffoldKey.currentState!.showSnackBar(
                                    SnackBar(
                                      backgroundColor: primaryColor,
                                      content: Text('Please select product',
                                          style: styleNormalBodyText.copyWith(
                                              color: Colors.white)),
                                    ),
                                  );
                                  _btnController.reset();
                                  return;
                                }

                                var brandService = BrandService();
                                var status =
                                    await brandService.requestProductSample(
                                        selectedListProduct[0].id, 1);
                                if (status.apiStatus == API_STATUS.success) {
                                  _btnController.success();
                                  _scaffoldKey.currentState!
                                      .showSnackBar(SnackBar(
                                    backgroundColor: primaryColor,
                                    content: Text(status.message!,
                                        style: styleNormalBodyText.copyWith(
                                            color: Colors.white)),
                                  ));
                                  Timer(Duration(milliseconds: 2000), () {
                                    Navigator.pop(context);
                                  });
                                } else {
                                  _btnController.error();
                                  _scaffoldKey.currentState!.showSnackBar(
                                    SnackBar(
                                      backgroundColor: primaryColor,
                                      content: Text(
                                        status.message!,
                                        style: styleNormalBodyText.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              color: primaryColor,
                              animateOnTap: true,
                              controller: _btnController,
                              child: Text(
                                "SUBMIT",
                                style: Theme.of(context)
                                    .textTheme
                                    .display1!
                                    .apply(
                                      color: Colors.white,
                                    )
                                    .copyWith(fontWeight: FontWeight.w600),
                              )),
                        ),
                      ),
                    )*/
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(7),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[200]!),
                              color: Colors.white,
                            ),
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
                                            MediaQuery.of(context).size.width *
                                                .25,
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey[200]!),
                                          color: isByMail
                                              ? primaryColor
                                              : Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isByMail
                                                  ? lstByMail[selectedByMail]
                                                  : 'By Mail',
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
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey[200]!),
                                          color: isCinfaPersonal
                                              ? primaryColor
                                              : Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'By Cinfa Professional',
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
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isByMail,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 27.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FormFieldWidget(
                              controller: streetTextEditingController,
                              hintText: 'Street...',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FormFieldWidget(
                              controller: street2TextEditingController,
                              hintText: 'Street 2...',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FormFieldWidget(
                              controller: cityTextEditingController,
                              hintText: 'City',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            /*FormFieldWidget(
                              controller: stateTextEditingController,
                              hintText: 'State',
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
                            FormFieldWidget(
                              controller: zipTextEditingController,
                              hintText: 'ZIP',
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            dropDownDynamicCountryWrapper(
                              labelText: "Country*",
                              items: lstCountries.map<DropdownMenuItem<String>>(
                                  (String? value) {
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
                                  } else if (_selectedCountry ==
                                      "Saudi Arabia") {
                                    countryIdIndex = 2;
                                  } else if (_selectedCountry ==
                                      "United Arab Emirates") {
                                    countryIdIndex = 3;
                                  }
                                  _getCountryToStateList();
                                });
                              },
                              selectedValue: _selectedCountry ??
                                  lstCountries[0].toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Container(
                        child: RoundedLoadingButton(
                            borderRadius: 6,
                            height: 60,
                            onPressed: () async {
                              if (selectedListProduct.isEmpty) {
                                /*_scaffoldKey.currentState!.showSnackBar(
                                  SnackBar(
                                    backgroundColor: primaryColor,
                                    content: Text('Please select product',
                                        style: styleNormalBodyText.copyWith(
                                            color: Colors.white)),
                                  ),
                                );*/
                                _btnController.reset();
                                showDialogSuccess("Please select product.");
                                return;
                              }

                              if (!isByMail && !isCinfaPersonal) {
                                _btnController.reset();
                                showDialogSuccess(
                                    "Please select delivery method.");
                                return;
                              }

                              if (isByMail) {
                                if (streetTextEditingController.text
                                    .trim()
                                    .isEmpty) {
                                  _btnController.reset();
                                  showDialogSuccess("Please enter street.");
                                  return;
                                }

                                if (street2TextEditingController.text
                                    .trim()
                                    .isEmpty) {
                                  _btnController.reset();
                                  showDialogSuccess("Please enter street2.");
                                  return;
                                }
                                if (cityTextEditingController.text
                                    .trim()
                                    .isEmpty) {
                                  _btnController.reset();
                                  showDialogSuccess("Please enter city.");
                                  return;
                                }
                                /*if (stateTextEditingController.text
                                    .trim()
                                    .isEmpty) {
                                  _btnController.reset();
                                  showDialogSuccess("Please enter state.");
                                  return;
                                }*/
                                if (_selectedState.toString().trim().isEmpty) {
                                  _btnController.reset();
                                  showDialogSuccess("Please enter state.");
                                  return;
                                }
                                if (zipTextEditingController.text
                                    .trim()
                                    .isEmpty) {
                                  _btnController.reset();
                                  showDialogSuccess("Please enter zip.");
                                  return;
                                }

                                /*if (_selectedCountry
                                    .toString()
                                    .trim()
                                    .isEmpty) {
                                  _btnController.reset();
                                  showDialogSuccess(
                                      "Please select the country.");
                                  return;
                                }*/
                              }

                              var brandService = BrandService();
                              var status =
                                  await brandService.requestProductSample(
                                selectedByMail,
                                selectedListProduct[0].id,
                                1,
                                isByMail ? "mail" : "person",
                                isByMail
                                    ? streetTextEditingController.text
                                    : "",
                                isByMail
                                    ? street2TextEditingController.text
                                    : "",
                                isByMail ? cityTextEditingController.text : "",
                                isByMail
                                    ? _selectedState?.id.toString() ?? ""
                                    : "",
                                isByMail
                                    ? lstCountriesId[countryIdIndex].toString()
                                    : "",
                                isByMail ? zipTextEditingController.text : "",
                              );
                              if (status.apiStatus == API_STATUS.success) {
                                _btnController.success();
                                /*_scaffoldKey.currentState!
                                    .showSnackBar(SnackBar(
                                  backgroundColor: primaryColor,
                                  content: Text(status.message!,
                                      style: styleNormalBodyText.copyWith(
                                          color: Colors.white)),
                                ));*/
                                isSuccessMsg = true;
                                showDialogSuccess(status.message!);
                                /*Timer(Duration(milliseconds: 2000), () {
                                  Navigator.pop(context);
                                });*/
                              } else {
                                _btnController.reset();
                                isSuccessMsg = false;
                                showDialogSuccess(status.message!);
                                /*_scaffoldKey.currentState!.showSnackBar(
                                  SnackBar(
                                    backgroundColor: primaryColor,
                                    content: Text(
                                      status.message!,
                                      style: styleNormalBodyText.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );*/
                              }
                            },
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  Widget getSearchableDropdown(List<ProductItemModel>? productList) => InkWell(
        onTap: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (ctx) {
              return Container(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.5,
                  maxChildSize: 0.8,
                  expand: false,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 10, left: 15, right: 15),
                          child: Text(
                            "Select Product",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: productList?.length,
                            itemBuilder: (context, index) {
                              var model = productList![index];
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  selectedListProduct = [model];
                                  selectedProductsStreamController
                                      .add(selectedListProduct);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: (index == 0) ? 15 : 8,
                                      bottom:
                                          (index == (productList.length - 1))
                                              ? 15
                                              : 8),
                                  child: Text(model.name!),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
              // return ListView.builder(
              //     itemCount: productList!.length,
              //     itemBuilder: (context, index) {
              //       var model = productList[index];
              //       return Text(model.name!);
              //     },);
              // return MultiSelectBottomSheet(
              //   items: productList!
              //       .map((item) =>
              //           MultiSelectItem<ProductItemModel>(item, item.name!))
              //       .toList(),
              //   listType: MultiSelectListType.LIST,
              //   initialValue: selectedListProduct,
              //   onConfirm: (values) {
              //     selectedListProduct = values as List<ProductItemModel>;
              //     selectedProductsStreamController.add(selectedListProduct);
              //   },
              //   maxChildSize: 0.8,
              // );
            },
          );
        },
        child: Row(
          children: [
            Text(
              "Select Product",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            Spacer(),
            Icon(
              Icons.arrow_drop_down,
              size: 35,
              color: primaryColor,
            )
          ],
        ),
      );

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
    });
  }
}
