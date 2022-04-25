import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/main.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/services/auth_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final username = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final description = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String? _selectedSubject;
  List<String> _subjects = [
    "Medical Information Request",
    "Brand Feedback",
    "Other Feedback",
    "Other Request"
  ];

  @override
  void initState() {
    super.initState();
    _selectedSubject = _subjects[0];
    firebaseAnalyticsEventCall(CONTACT_CINFA_SCREEN,
        param: {"name": "Contact Cinfa Screen"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Contact Cinfa'),
      ),
      body: FutureBuilder<ProfileModel?>(
          future: AuthService().getProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var profile = snapshot.data!;
              username.text = profile.name;
              email.text = profile.email;
              phone.text = profile.phone;
              return Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * .9,
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
                            FormFieldWidget(
                                controller: username,
                                hintText: 'Name',
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
                            FormFieldWidget(
                                controller: phone,
                                hintText: 'Mobile',
                                suffixIcon: IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.mobileAlt,
                                    color: Colors.grey[200]!,
                                  ),
                                  onPressed: null,
                                )),
                            //                    FormFieldWidget(
                            //                      controller: title,
                            //                      hintText: 'Subject',
                            //                      suffixIcon: Container(
                            //                        margin: EdgeInsets.all(16),
                            //                        child: Icon(
                            //                          Icons.vpn_key,
                            //                          color: Colors.grey[200],
                            //                        ),
                            //                      ),
                            //                    ),
                            Container(
                              margin: EdgeInsets.only(top: 6, bottom: 12),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: DropdownButton<String>(
                                value: _selectedSubject,
                                icon: Icon(Icons.arrow_downward,
                                    color: Colors.grey[200]),
                                // iconSize: 24,
                                // elevation: 16,
                                // style: TextStyle(color: Colors.grey[500]),
                                isExpanded: true,
                                underline: Container(
                                    // height: 2,
                                    // color: Colors.deepPurpleAccent,
                                    ),

                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedSubject = newValue;
                                  });
                                },
                                items: _subjects.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            TextField(
                              controller: description,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              cursorColor: Colors.amber,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.edit,
                                  color: Colors.grey[200],
                                ),
                                hintText: 'Description',
                                hintStyle: TextStyle(
                                  color: Colors.grey[200],
                                ),
                                border: inputBorder,
                                enabledBorder: inputBorder,
                                focusedBorder: focusedBorder,
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
                                            description.text.trim().isEmpty) {
                                          _scaffoldKey.currentState!
                                              .showSnackBar(SnackBar(
                                            backgroundColor: primaryColor,
                                            content: Text(
                                                'Please fill in all required fields.',
                                                style: styleNormalBodyText
                                                    .copyWith(
                                                        color: Colors.white)),
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
                                              style:
                                                  styleNormalBodyText.copyWith(
                                                      color: Colors.white),
                                            ),
                                          ));
                                          _btnController.reset();
                                          return;
                                        }
                                        var p;
                                        try {
                                          p = await authService
                                              .authProvider.client
                                              .callController(
                                            '/app/contact_us',
                                            {
                                              'username': username.text,
                                              'token': profile.token,
                                              'email': email.text,
                                              'aemail': profile.email,
                                              'subject': _selectedSubject,
                                              'description': description.text
                                            },
                                          );
                                        } catch (e) {
                                          feedbackRequestError();
                                        }
                                        if (p == null ||
                                            p.getResult() == false) {
                                          feedbackRequestError();
                                        } else {
                                          await firebaseAnalyticsEventCall(
                                              FEEDBACK_FORM,
                                              param: {
                                                'username': username.text,
                                                'token': profile.token,
                                                'email': email.text,
                                                'aemail': profile.email,
                                                'subject': _selectedSubject,
                                                'description': description.text
                                              });
                                          _btnController.success();
                                          Timer(Duration(milliseconds: 1500),
                                              () {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    '/',
                                                    (Route<dynamic> route) =>
                                                        false);
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
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
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
              );
            }
            return Container();
          }),
    );
  }

  void feedbackRequestError() {
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

  @override
  void dispose() {
    // TODO: implement dispose
    username.dispose();
    email.dispose();
    phone.dispose();
    description.dispose();
    super.dispose();
  }

  List<Widget> _buildSubjects() {
    return _subjects
        .map((val) => MySelectionItem(
              title: val,
            ))
        .toList();
  }
}

class MySelectionItem extends StatelessWidget {
  final String? title;
  final bool isForList;

  const MySelectionItem({Key? key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: FittedBox(
          child: Text(
        title!,
      )),
    );
  }
}
