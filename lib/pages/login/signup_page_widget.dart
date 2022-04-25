import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmaaccess/apis/auth_provider.dart';
import 'package:pharmaaccess/components/app_webview.dart';
import 'package:pharmaaccess/config/colors.dart';
import 'package:pharmaaccess/config/config.dart';
import 'package:pharmaaccess/main.dart';
import 'package:pharmaaccess/models/brand/specialModel.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:pharmaaccess/widgets/ShowSnackBar.dart';
import 'package:pharmaaccess/widgets/location_bottom_sheet.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:random_string/random_string.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignupPageWidget extends StatefulWidget {
  final VoidCallback? callback;

  SignupPageWidget({Key? key, this.callback}) : super(key: key);

  @override
  _SignupPageWidgetState createState() => _SignupPageWidgetState();
}

class _SignupPageWidgetState extends State<SignupPageWidget> {
  final username = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final hospital = TextEditingController();
  SpecialModel? specialModel;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  VoidCallback? callback;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //var _login_failed = false;
  String? _selectedCountryCode;
  String? _selectedTitle;
  String? _selectedCountry;
  late int indexOfSelectedCountryAndCode;
  List<SpecialModel> specializationList = [];

  // StreamController<List<SpecialModel>?> specializationListController =
  //     StreamController<List<SpecialModel>?>.broadcast();
  List<String?> _countryCode = [
    "(+965)",
    "(+974)",
    "(+966)",
    "(+971)",
    "(+20)",
  ];

  List<String> _titles = [
    "Dr.",
    "Mr.",
    "Ms.",
    "Mrs.",
    "Mx.",
    "Prof.",
  ];

  List<String?> _countries = [
    'Kuwait',
    'Qatar',
    'Saudi Arabia',
    'United Arab Emirates',
    'Egypt',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._selectedTitle = _titles[0];
    this._selectedCountryCode = _countryCode[0];
    this._selectedCountry = _countries[0];
    // _getNames();

    callback = widget.callback;
    getServerData();
  }

  @override
  void dispose() {
    // specializationListController.close();
    username.dispose();
    email.dispose();
    phone.dispose();
    hospital.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/login_signup_background.jpg',
                ),
              ),
            ),
          ),
          Opacity(
            opacity: .9,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        BackGroundGradientStart,
                        BackGroundGradientEnd,
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
            ),
          ),
          SafeArea(
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/app_logo.png',
                          width: 150,
                        ),
                        Divider(
                          color: Color(0x00888888),
                          height: 20,
                        ),
                        Container(
                          height: 700,
                          width: MediaQuery.of(context).size.width * .78,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 26.0, horizontal: 36),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Sign Up",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                Divider(
                                  color: Colors.white,
                                  height: 12,
                                ),
                                FormFieldWidget(
                                    controller: username,
                                    hintText: 'Full Name',
                                    suffixIcon: Icon(
                                      Icons.person_outline,
                                      color: Colors.grey[200],
                                    )),
                                FormFieldWidget(
                                    controller: email,
                                    hintText: 'Email ID',
                                    textInputType: TextInputType.emailAddress,
                                    suffixIcon: Icon(
                                      Icons.email,
                                      color: Colors.grey[200],
                                    )),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[200]!,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: DropdownButton<String>(
                                          value: _selectedCountryCode,
                                          style: TextStyle(
                                              color: Colors.grey[500]),
                                          underline: Container(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              if (_selectedCountryCode !=
                                                  null) {
                                                _selectedCountryCode = newValue;
                                                indexOfSelectedCountryAndCode =
                                                    _countryCode.indexOf(
                                                        _selectedCountryCode);
                                                _selectedCountry = _countries[
                                                        indexOfSelectedCountryAndCode]
                                                    .toString();
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.arrow_downward,
                                              color: Colors.grey[200]),
                                          items: _countryCode
                                              .map<DropdownMenuItem<String>>(
                                                  (String? value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value!),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    Flexible(
                                      flex: 2,
                                      child: FormFieldWidget(
                                        controller: phone,
                                        hintText: 'Mobile',
                                        formatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        textInputType: TextInputType.phone,
                                        suffixIcon: Icon(
                                          Icons.phone_iphone,
                                          color: Colors.grey[200],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                /* MyTextField(
                                  searchBar: _buildBar(context),
                                  list: Container(
                                    child: _buildList(),
                                  ),
                                ), */

                                // StreamBuilder<List<SpecialModel>?>(
                                //   initialData: specializationList,
                                //   stream: specializationListController.stream,
                                //   builder: (_, snapshot) {
                                //     if (snapshot.hasData &&
                                //         snapshot.data!.isNotEmpty) {
                                //       return getSearchableDropdown(
                                //           snapshot.data!, "Specilization");
                                //     }
                                //     return Container();
                                //   },
                                // ),
                                if (specializationList.isNotEmpty) ...[
                                  GestureDetector(
                                    onTap: () {
                                      if (specializationList.isNotEmpty) {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          builder: (_) => LocationBottomSheet(
                                            originalList: specializationList,
                                            selectedDisplayList: specialModel,
                                            onListSelected:
                                                (SpecialModel selectedItems) {
                                              specialModel = selectedItems;
                                              setState(() {});
                                              // jobsSelected = selectedItems;
                                              // jobsSelectionController.add(jobsSelected);
                                            },
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: double.maxFinite,
                                      margin: EdgeInsets.only(top: 6),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 15),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text((specialModel == null)
                                                ? "Please Select"
                                                : specialModel!.name!),
                                          ),
                                          Icon(
                                            Icons.arrow_downward,
                                            color: Colors.grey[200],
                                            size: 24.0,
                                          ),
                                        ],
                                      ),
                                      // child: DropdownButton<String>(
                                      //   value: _selectedTitle,
                                      //   icon: Icon(Icons.arrow_downward,
                                      //       color: Colors.grey[200]),
                                      //   // iconSize: 24,
                                      //   // elevation: 16,
                                      //   style: TextStyle(color: Colors.grey[500]),
                                      //   isExpanded: true,
                                      //   underline: Container(
                                      //       // height: 2,
                                      //       // color: Colors.deepPurpleAccent,
                                      //       ),
                                      //
                                      //   onChanged: (String? newValue) {
                                      //     setState(() {
                                      //       _selectedTitle = newValue;
                                      //     });
                                      //   },
                                      //   items: _titles
                                      //       .map<DropdownMenuItem<String>>(
                                      //           (String value) {
                                      //     return DropdownMenuItem<String>(
                                      //       value: value,
                                      //       child: Text(value),
                                      //     );
                                      //   }).toList(),
                                      // ),
                                    ),
                                  ),
                                ] else ...[
                                  Center(child: CircularProgressIndicator()),
                                ],
                                FormFieldWidget(
                                    controller: hospital,
                                    hintText: 'Clinic / Hospital Name',
                                    suffixIcon: Icon(
                                      Icons.local_hospital,
                                      color: Colors.grey[200],
                                    )),
                                Container(
                                  margin: EdgeInsets.only(top: 6),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 2),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: DropdownButton<String>(
                                    value: _selectedCountry,
                                    icon: Icon(Icons.arrow_downward,
                                        color: Colors.grey[200]),
                                    // iconSize: 24,
                                    // elevation: 16,
                                    style: TextStyle(color: Colors.grey[500]),
                                    isExpanded: true,
                                    underline: Container(
                                        // height: 2,
                                        // color: Colors.deepPurpleAccent,
                                        ),

                                    onChanged: (String? newValue) {
                                      setState(() {
                                        // _selectedCountry = newValue;
                                        if (_selectedCountry != null) {
                                          _selectedCountry = newValue;
                                          indexOfSelectedCountryAndCode =
                                              _countries
                                                  .indexOf(_selectedCountry);

                                          _selectedCountryCode = _countryCode[
                                                  indexOfSelectedCountryAndCode]
                                              .toString();
                                          print(_selectedCountry.toString());
                                          print(
                                              _selectedCountryCode.toString());
                                        }
                                      });
                                    },
                                    items: _countries
                                        .map<DropdownMenuItem<String>>(
                                            (String? value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value!),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 6),
                                  child: RichText(
                                    text: TextSpan(
                                      style: styleMutedTextSmall,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                "By Signing up you are agreeing to "),
                                        TextSpan(
                                          text: "Terms and Conditions ",
                                          style: styleMutedTextSmall.copyWith(
                                              fontWeight: FontWeight.w700),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MyWebView(
                                                            title:
                                                                "Terms & Conditions",
                                                            selectedUrl: Config
                                                                .TERMS_CONDITIONS,
                                                          )));
                                            },
                                        ),
                                        TextSpan(text: "and"),
                                        TextSpan(
                                          text: " Privacy Policy",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          MyWebView(
                                                            title:
                                                                "Privacy Policy",
                                                            selectedUrl: Config
                                                                .PRIVACY_POLICY,
                                                          )));
                                            },
                                        ),
                                      ],
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
                                            if (username.text.trim().isEmpty ||
                                                phone.text.trim().isEmpty ||
                                                email.text.trim().isEmpty ||
                                                //  _searchText.isEmpty ||
                                                _selectedCountry!.isEmpty ||
                                                _countryCode.isEmpty ||
                                                hospital.text.isEmpty ||
                                                _selectedTitle!.isEmpty) {
                                              _scaffoldKey.currentState!
                                                  .showSnackBar(SnackBar(
                                                backgroundColor: primaryColor,
                                                content: Text(
                                                    'Please fill in all required fields.',
                                                    style: styleNormalBodyText
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
                                              ));
                                              _btnController.reset();
                                              return;
                                            }
                                            bool emailValid = RegExp(
                                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                                .hasMatch(email.text.trim());
                                            if (emailValid == false) {
                                              _scaffoldKey.currentState!
                                                  .showSnackBar(SnackBar(
                                                backgroundColor: primaryColor,
                                                content: Text(
                                                    'Please enter valid email.',
                                                    style: styleNormalBodyText
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
                                              ));
                                              _btnController.reset();
                                              return;
                                            }
                                            if (specialModel == null) {
                                              _scaffoldKey.currentState!
                                                  .showSnackBar(SnackBar(
                                                backgroundColor: primaryColor,
                                                content: Text(
                                                    'Please select specialization',
                                                    style: styleNormalBodyText
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
                                              ));
                                              _btnController.reset();
                                              return;
                                            }
                                            var profile = ProfileModel(
                                              username.text.trim(),
                                              email.text.trim(),
                                              randomString(10),
                                              0,
                                              _selectedTitle!,
                                              phone.text.trim(),
                                              hospital.text.trim(),
                                              specialModel!.name!,
                                              "",
                                              0,
                                              "",
                                              _selectedCountryCode!,
                                              _selectedCountry!,
                                              0,
                                            );
                                            final outputRegisterProfile =
                                                await authService
                                                    .registerProfile(profile);
                                            outputRegisterProfile.fold(
                                                (failureModel) {
                                              //TODO Show error registering account.
                                              final snackBar = SnackBar(
                                                backgroundColor: primaryColor,
                                                content: Text(
                                                    failureModel.message == null
                                                        ? 'Error Registering, Please retry'
                                                        : failureModel.message!,
                                                    style: styleNormalBodyText
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
                                                action: SnackBarAction(
                                                  label: 'OK',
                                                  onPressed: () {
                                                    // Some code to undo the change.
                                                  },
                                                ),
                                              );
                                              _scaffoldKey.currentState!
                                                  .showSnackBar(snackBar);
                                              _btnController.error();
                                              Timer(
                                                  Duration(milliseconds: 2000),
                                                  () {
                                                _btnController.reset();
                                              });
                                            }, (successModel) {
                                              _btnController.success();
                                              Timer(Duration(milliseconds: 500),
                                                  () {
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        '/',
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                              });
                                            });
                                          },
                                          color: primaryColor,
                                          animateOnTap: true,
                                          controller: _btnController,
                                          child: Text(
                                            "SIGN UP",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .apply(
                                                  color: Colors.white,
                                                )
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(text: "Already have an account? "),
                                TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = callback,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget getSearchableDropdown(List<SpecialModel> newsList, mapKey) {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < newsList.length; i++) {
      items.add(new DropdownMenuItem(
        child: new Text(
          newsList[i].name!,
          style: TextStyle(color: Colors.grey),
        ),
        value: newsList[i].name,
      ));
    }
    return Container(
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200]!,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      // child: new SearchableDropdown<dynamic>(
      //   items: items,
      //   value: specialization,
      //   isCaseSensitiveSearch: false,
      //   hint: new Text('Specilization',
      //       style: TextStyle(color: Colors.grey[200], fontSize: 18.0)),
      //   searchHint: new Text(
      //     'Specilization',
      //     style: new TextStyle(fontSize: 20),
      //   ),
      //   searchFn: (String keyword, List<DropdownMenuItem> items) {
      //     List<int> ret = [];
      //     if (items.isNotEmpty && keyword.isNotEmpty) {
      //       keyword.split(" ").forEach((k) {
      //         int i = 0;
      //         items.forEach((item) {
      //           if (k.isNotEmpty &&
      //               (item.value
      //                   .toString()
      //                   .toLowerCase()
      //                   .startsWith(k.toLowerCase()))) {
      //             ret.add(i);
      //           }
      //           i++;
      //         });
      //       });
      //     }
      //     if (keyword.isEmpty) {
      //       ret = Iterable<int>.generate(items.length).toList();
      //     }
      //     print("ret $ret");
      //     return (ret);
      //   },
      //   icon: Icon(
      //     Icons.arrow_downward,
      //     color: Colors.grey[200],
      //     size: 24.0,
      //   ),
      //   underline: Padding(
      //     padding: EdgeInsets.all(5),
      //   ),
      //   isExpanded: true,
      //   onChanged: (value) {
      //     print("asdf $value");
      //     specialization = value;
      //     specializationListController.add(specializationList);
      //   },
      // ),
    );
  }

  getServerData() async {
    try {
      final AuthProvider apiProvider = AuthProvider();
      var response = await apiProvider.client
          .callController("/partner/specialization", {});
      if (response == null) {
        specializationError();
      }
      var result = response.getResult();
      if (!response.hasError()) {
        specializationList = result.map<SpecialModel>((json) {
          return SpecialModel.fromJson(json);
        }).toList();
        setState(() {});
      } else {
        specializationError();
      }
    } catch (e) {
      specializationError();
    }
  }

  void specializationError() {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(INTERNAL_SERVER_ERROR),
        ),
      );
    }
  }
/*   Future<List> getServerData() async {
    String url = 'https://restcountries.eu/rest/v2/all';
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> responseBody = json.decode(response.body);
      List<String> countries = new List();
      /*  for (int i = 0; i < responseBody.length; i++) {
        countries.add(responseBody[i]['name']);
      } */
      return countries;
    } else {
      print("error from server : $response");
      throw Exception('Failed to load post');
    }
  } */

}
