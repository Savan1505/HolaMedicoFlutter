import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pharmaaccess/CommonExtension.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/models/ProductListResModel.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/services/brand_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/ShowSnackBar.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../main.dart';

class PharmaCovigilancePage extends StatefulWidget {
  String? countryName;

  PharmaCovigilancePage({Key? key, this.countryName}) : super(key: key);

  @override
  _PharmaCovigilancePageState createState() => _PharmaCovigilancePageState();
}

class _PharmaCovigilancePageState extends State<PharmaCovigilancePage> {
  final username = TextEditingController();
  final ageController = TextEditingController();
  FocusNode ageFocusNode = FocusNode();
  final sideEffectsController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController<List<ProductItemModel>?> productsStreamController =
      StreamController<List<ProductItemModel>?>.broadcast();

  StreamController<List<ProductItemModel>> selectedProductsStreamController =
      StreamController<List<ProductItemModel>>.broadcast();

  StreamController<String?> genderStreamController =
      StreamController<String?>.broadcast();

  List gender = ["Male", "Female"];
  String selectedGender = "m";
  List<ProductItemModel>? listProduct;

  List<ProductItemModel> selectedListProduct = [];

  String? select;
  final BrandService brandService = BrandService();

  @override
  void initState() {
    firebaseAnalyticsEventCall(PHARMA_COVIGILANCE,
        param: {"name": "Pharmacovigilance Screen"});
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
        title: Text('Pharmacovigilance'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 26.0, horizontal: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FormFieldWidget(
                      controller: username,
                      hintText: 'Patient Initials/Identification number',
                      suffixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.grey[200],
                      ),
                    ),
                    FormFieldWidget(
                      focusNode: ageFocusNode,
                      controller: ageController,
                      hintText: 'Patient Age',
                      textInputType: TextInputType.number,
                      formatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.person_outline,
                          color: Colors.grey[200],
                        ),
                        onPressed: null,
                      ),
                    ).doneKeyBoard(ageFocusNode, context),
                    FormFieldWidget(
                      controller: sideEffectsController,
                      hintText: 'Adverse drug reaction & any treatment given',
                      lines: 4,
                      maxLines: 6,
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.only(bottom: 15, left: 7, top: 15),
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
                              'Gender : ',
                              style: getTitleStyle(),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(child: addRadioButton(0, gender[0])),
                                Expanded(child: addRadioButton(1, gender[1])),
                              ],
                            ),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
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
                            style: getTitleStyle(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<List<ProductItemModel>?>(
                            initialData: listProduct,
                            stream: productsStreamController.stream,
                            builder: (_, snapshot) {
                              return snapshot.data == null
                                  ? CircularProgressIndicator()
                                  : getSearchableDropdown(snapshot.data);
                            },
                          ),
                          StreamBuilder<List<ProductItemModel>>(
                            initialData: selectedListProduct,
                            stream: selectedProductsStreamController.stream,
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
                                                padding: EdgeInsets.all(10),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 15,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              onTap: () {
                                                selectedListProduct.remove(e);
                                                selectedProductsStreamController
                                                    .add(selectedListProduct);
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
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Submission Date: ',
                          style: getTitleStyle(),
                        ),
                        Text(
                          getCurrentDate(),
                        ),
                      ],
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
                                if (username.text.trim().isEmpty ||
                                    ageController.text.trim().isEmpty) {
                                  _scaffoldKey.currentState!
                                      .showSnackBar(SnackBar(
                                    backgroundColor: primaryColor,
                                    content: Text(
                                        'Please fill in all required fields.',
                                        style: styleNormalBodyText.copyWith(
                                            color: Colors.white)),
                                  ));
                                  _btnController.reset();
                                  return;
                                }
                                var p;
                                ProfileModel? profile;
                                try {
                                  profile = await authService.getProfile();
                                  Map<String, dynamic> params = {
                                    // 'username': username.text,
                                    'token': profile?.token,
                                    'email': profile?.email,
                                    'aemail': profile?.email,
                                    'subject': "",
                                    'patient_name': username.text,
                                    'patient_age': ageController.text,
                                    'gender': selectedGender,
                                    'product_ids': selectedListProduct
                                        .map((e) => e.id)
                                        .toList(),
                                    'description': sideEffectsController.text
                                  };
                                  p = await authService.authProvider.client
                                      .callController(
                                          '/app/contact_us', params);
                                } catch (e) {
                                  requestApiError();
                                }
                                if (p == null ||
                                    p.getResult() == null ||
                                    p.getResult() == false) {
                                  requestApiError();
                                } else {
                                  await firebaseAnalyticsEventCall(
                                      PHARMA_COVIGILANCE,
                                      param: {
                                        "token": profile?.token,
                                        'email': profile?.email,
                                        'aemail': profile?.email,
                                        'subject': "",
                                        'patient_name': username.text,
                                        'patient_age': ageController.text,
                                        'gender': selectedGender,
                                        'product_ids': selectedListProduct
                                            .map((e) => e.id.toString())
                                            .toList()
                                            .join(","),
                                        'description':
                                            sideEffectsController.text
                                      });

                                  _btnController.success();
                                  Timer(Duration(milliseconds: 1500), () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/',
                                            (Route<dynamic> route) => false);
                                  });
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
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void requestApiError() {
    final snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Text('Error Submitting Feedback, Please retry',
          style: styleNormalBodyText.copyWith(color: Colors.white)),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBar);
    _btnController.error();
    Timer(Duration(milliseconds: 2000), () {
      _btnController.reset();
    });
  }

  Widget getSearchableDropdown(List<ProductItemModel>? newsList) {
    // List<DropdownMenuItem<ProductItemModel>> items = [];
    // for (int i = 0; i < newsList.length; i++) {
    //   items.add(new DropdownMenuItem<ProductItemModel>(
    //     child: new Text(
    //       newsList[i].name,
    //       style: TextStyle(color: Colors.grey),
    //     ),
    //     value: newsList[i],
    //   ));
    // }
    return InkWell(
      onTap: () async {
        await showModalBottomSheet(
          isScrollControlled: true, // required for min/max child size
          context: context,
          builder: (ctx) {
            return MultiSelectBottomSheet(
              items: newsList!
                  .map((item) =>
                      MultiSelectItem<ProductItemModel>(item, item.name!))
                  .toList(),
              initialValue: selectedListProduct,
              onConfirm: (values) {
                selectedListProduct = values as List<ProductItemModel>;
                selectedProductsStreamController.add(selectedListProduct);
              },
              maxChildSize: 0.8,
            );
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
            color: Colors.green,
          )
        ],
      ),
    );
  }

  Widget addRadioButton(int btnValue, String title) => StreamBuilder<String?>(
      initialData: gender[0],
      stream: genderStreamController.stream,
      builder: (_, snapshot) => GestureDetector(
            onTap: () {
              selectedGender = btnValue == 0 ? 'm' : 'f';
              genderStreamController.add(title);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 10,
                  height: 10,
                  child: Radio(
                    activeColor: Theme.of(context).primaryColor,
                    value: gender[btnValue],
                    groupValue: snapshot.data,
                    onChanged: (dynamic value) {
                      selectedGender = btnValue == 0 ? 'm' : 'f';
                      genderStreamController.add(value);
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: Text(title))
              ],
            ),
          ));

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM  hh:mm a').format(now);
    return formattedDate;
  }

  @override
  void dispose() {
    username.dispose();
    ageController.dispose();

    super.dispose();
  }
}

TextStyle getTitleStyle() =>
    TextStyle(fontWeight: FontWeight.w700, fontSize: 15);
