import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as Img;
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmaaccess/SharedPref.dart';
import 'package:pharmaaccess/apis/auth_provider.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsConstants.dart';
import 'package:pharmaaccess/firebase_analytics/FirebaseAnalyticsEventCall.dart';
import 'package:pharmaaccess/main.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/services/profile_service.dart';
import 'package:pharmaaccess/theme.dart';
import 'package:pharmaaccess/util/helper_functions.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final AuthProvider authProvider = AuthProvider();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnOkController =
      RoundedLoadingButtonController();
  StreamController<bool> updateDataController =
      StreamController<bool>.broadcast();
  TabController? _controller;
  final picker = ImagePicker();
  Image? _image;
  bool hideToken = true;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final countryCountryController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? base64Image;

  String versionName = "";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _controller = new TabController(length: 1, vsync: this);
    firebaseAnalyticsEventCall(PROFILE_SCREEN,
        param: {"name": "Profile Screen"});
    getProfileData();
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        versionName = info.version;
      });
    });
  }

  Future<void> getProfileData() async {
    var profileData = await authService.fetchProfile();
    await ProfileService().saveName(profileData["name"] is bool
        ? ""
        : profileData["name"].toString().isNotEmpty &&
                profileData["name"] != null
            ? profileData["name"]
            : "");
    await ProfileService().savePhoneNumber(profileData["phone"] is bool
        ? ""
        : profileData["phone"].toString().isNotEmpty &&
                profileData["phone"] != null
            ? profileData["phone"]
            : "");
    base64Image = profileData["image"] is bool
        ? ""
        : profileData["image"].toString().isNotEmpty &&
                profileData["image"] != null
            ? profileData["image"].toString().replaceAll("\n", "")
            : "";
    await ProfileService().saveProfilePicture(base64Image, "resized_img");
    setState(() {
      _loading = false;
    });
  }

  ProfileModel? profile;

  @override
  Widget build(BuildContext context) {
    ProfileService profileService = Provider.of<ProfileService>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: _loading
              ? Center(child: CircularProgressIndicator())
              : FutureBuilder(
                  future: profileService.getProfile(),
                  builder: (BuildContext context,
                      AsyncSnapshot<ProfileModel?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data != null) {
                        profile = snapshot.data;
                        return StreamBuilder<bool>(
                            stream: updateDataController.stream,
                            builder: (_, snapshot) {
                              return Stack(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        height: 220,
                                        alignment: Alignment.center,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            FutureBuilder<Object>(
                                                future:
                                                    profile?.getProfileImage(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState ==
                                                          ConnectionState
                                                              .done &&
                                                      snapshot.data != null) {
                                                    profile!.image =
                                                        profile!.profilePicture;
                                                    return snapshot.data
                                                        as Widget;
                                                  }
                                                  return Image.asset(
                                                      'assets/images/profile_placeholder.png');
                                                }),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.white38,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  _popupDialog(context);
                                                },
                                                child: Icon(Icons.edit,
                                                    size: 32,
                                                    color: Colors.white60),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: new BoxDecoration(
                                                color: Color(0xfff5f5f5)),
                                            child: new TabBar(
                                              controller: _controller,
                                              labelColor: primaryColor,
                                              unselectedLabelColor:
                                                  Color(0xFF8A8A8A),
                                              tabs: [
                                                new Tab(
                                                  text: 'General Information',
                                                ),
//                                  new Tab(
//                                    text: 'Interests',
//                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: new TabBarView(
                                          controller: _controller,
                                          children: <Widget>[
                                            Container(
                                                alignment: Alignment.topLeft,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                                child: ListView(
                                                  children: <Widget>[
                                                    ProfileField(
                                                      label: 'Name',
                                                      fieldValue: titleCase(
                                                          profile!.name),
                                                      fieldName: "name",
                                                      onPressed: () {
                                                        usernameController
                                                                .text =
                                                            profile!.name;
                                                        showEditDialogBox(
                                                            context,
                                                            "Edit Name",
                                                            usernameController,
                                                            () async {
                                                          if (usernameController
                                                              .text
                                                              .trim()
                                                              .isEmpty) {
                                                            _scaffoldKey
                                                                .currentState!
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              backgroundColor:
                                                                  primaryColor,
                                                              content: Text(
                                                                  'Please fill in required field',
                                                                  style: styleNormalBodyText
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.white)),
                                                            ));
                                                          } else {
                                                            var provider =
                                                                AuthProvider()
                                                                    .dbProvider;
                                                            bool saved = await provider
                                                                .saveName(
                                                                    usernameController
                                                                        .text);
                                                            Timer(
                                                                Duration(
                                                                    milliseconds:
                                                                        1500),
                                                                () {
                                                              // setState(() {});
                                                              // Navigator.of(context)
                                                              //     .pop();
                                                              // usernameController
                                                              //     .clear();
                                                              // setState(() {});

                                                              profile!.name =
                                                                  usernameController
                                                                      .text;
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              usernameController
                                                                  .clear();

                                                              updateScreen();
                                                            });
                                                          }
                                                        });
                                                        // setState(() {});
                                                      },
                                                    ),
                                                    ProfileField(
                                                      label: 'Email',
                                                      fieldValue:
                                                          profile!.email,
                                                      fieldName: "email",
                                                      editValue: false,
                                                      onPressed: () {
                                                        emailController.text =
                                                            profile!.email;
                                                        showEditDialogBox(
                                                            context,
                                                            "Edit email",
                                                            emailController,
                                                            () async {
                                                          if (emailController
                                                              .text
                                                              .trim()
                                                              .isEmpty) {
                                                            _scaffoldKey
                                                                .currentState!
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              backgroundColor:
                                                                  primaryColor,
                                                              content: Text(
                                                                  'Please fill in required field',
                                                                  style: styleNormalBodyText
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.white)),
                                                            ));
                                                          } else {
                                                            var provider =
                                                                AuthProvider()
                                                                    .dbProvider;
                                                            bool saved = await provider
                                                                .saveEamil(
                                                                    emailController
                                                                        .text);
                                                            Timer(
                                                                Duration(
                                                                    milliseconds:
                                                                        1500),
                                                                () {
                                                              // setState(() {});
                                                              // Navigator.of(context)
                                                              //     .pop();
                                                              // emailController.clear();
                                                              // setState(() {});

                                                              profile!.email =
                                                                  emailController
                                                                      .text;
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              emailController
                                                                  .clear();

                                                              updateScreen();
                                                            });
                                                          }
                                                        });
                                                        // setState(() {});
                                                      },
                                                    ),
                                                    ProfileField(
                                                      label: 'Mobile',
                                                      fieldValue:
                                                          profile!.phone.isEmpty
                                                              ? ""
                                                              : profile!.phone,
                                                      fieldName: "mobile",
                                                      onPressed: () {
                                                        phoneController.text =
                                                            profile!.phone;
                                                        showEditDialogBox(
                                                            context,
                                                            "Edit phone number",
                                                            phoneController,
                                                            () async {
                                                          if (phoneController
                                                              .text
                                                              .trim()
                                                              .isEmpty) {
                                                            _scaffoldKey
                                                                .currentState!
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              backgroundColor:
                                                                  primaryColor,
                                                              content: Text(
                                                                  'Please fill in required field',
                                                                  style: styleNormalBodyText
                                                                      .copyWith(
                                                                          color:
                                                                              primaryColor)),
                                                            ));
                                                          } else {
                                                            var provider =
                                                                AuthProvider()
                                                                    .dbProvider;
                                                            bool saved = await provider
                                                                .savePhoneNumber(
                                                                    phoneController
                                                                        .text);
                                                            Timer(
                                                                Duration(
                                                                    milliseconds:
                                                                        1500),
                                                                () {
                                                              profile!.phone =
                                                                  phoneController
                                                                      .text;
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              phoneController
                                                                  .clear();

                                                              updateScreen();
                                                            });
                                                          }
                                                        });
                                                        // setState(() {});
                                                      },
                                                    ),
                                                    /*  ProfileField(
                                                  label: 'Country',
                                                  fieldValue: profile.countryName == null
                                                      ? ""
                                                      : profile.countryName,
                                                  fieldName: "countryName",
                                                  onPressed: () {
                                                    showEditDialogBox(
                                                        context, "Edit Country", country,
                                                        () async {
                                                      if (country.text.trim().isEmpty) {
                                                        _scaffoldKey.currentState
                                                            .showSnackBar(SnackBar(
                                                          backgroundColor: primaryColor,
                                                          content: Text(
                                                              'Please fill in required field',
                                                              style: styleNormalBodyText
                                                                  .copyWith(
                                                                      color:
                                                                          Colors.white)),
                                                        ));
                                                      } else {
                                                        var provider =
                                                            AuthProvider().dbProvider;
                                                        bool saved = await provider
                                                            .saveCountry(country.text);
                                                        Timer(
                                                            Duration(milliseconds: 1500),
                                                            () {
                                                          setState(() {});
                                                          Navigator.of(context).pop();
                                                          country.clear();
                                                          setState(() {});
                                                        });
                                                      }
                                                    });
                                                    setState(() {});
                                                  },
                                                ), */
                                                    ProfileField(
                                                      label: 'Password',
                                                      fieldValue:
                                                          profile!.token.isEmpty
                                                              ? ""
                                                              : profile!.token,
                                                      fieldName: "Password",
                                                      // hideValue: hideToken,
                                                      onPressed: () {
                                                        passwordController
                                                                .text =
                                                            profile!.token;
                                                        showEditDialogBox(
                                                            context,
                                                            "Edit Password",
                                                            passwordController,
                                                            () async {
                                                          if (passwordController
                                                              .text
                                                              .trim()
                                                              .isEmpty) {
                                                            _scaffoldKey
                                                                .currentState!
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              backgroundColor:
                                                                  primaryColor,
                                                              content: Text(
                                                                  'Please fill in required field',
                                                                  style: styleNormalBodyText
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.white)),
                                                            ));
                                                          } else {
                                                            Timer(
                                                                Duration(
                                                                    milliseconds:
                                                                        1500),
                                                                () {
                                                              // setState(() {});
                                                              // Navigator.of(context)
                                                              //     .pop();
                                                              // passwordController
                                                              //     .clear();
                                                              // setState(() {});

                                                              profile!.token =
                                                                  passwordController
                                                                      .text;
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              passwordController
                                                                  .clear();

                                                              updateScreen();
                                                            });
                                                          }
                                                        });
                                                        // setState(() {});
                                                      },
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: SizedBox(
                                                        height: 60,
                                                        width: double.infinity,
                                                        child: Container(
                                                          child:
                                                              RoundedLoadingButton(
                                                                  borderRadius:
                                                                      6,
                                                                  height: 60,
                                                                  onPressed:
                                                                      () async {
                                                                    if (profile!
                                                                            .name
                                                                            .trim()
                                                                            .isEmpty ||
                                                                        profile!
                                                                            .email
                                                                            .trim()
                                                                            .isEmpty ||
                                                                        //  _searchText.isEmpty ||
                                                                        profile!
                                                                            .token
                                                                            .trim()
                                                                            .isEmpty) {
                                                                      _scaffoldKey
                                                                          .currentState!
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        backgroundColor:
                                                                            primaryColor,
                                                                        content: Text(
                                                                            'Please fill in all required fields.',
                                                                            style:
                                                                                styleNormalBodyText.copyWith(color: Colors.white)),
                                                                      ));
                                                                      _btnController
                                                                          .reset();
                                                                      return;
                                                                    }
                                                                    bool emailValid = RegExp(
                                                                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                                                        .hasMatch(profile!
                                                                            .email
                                                                            .trim());
                                                                    if (emailValid ==
                                                                        false) {
                                                                      _scaffoldKey
                                                                          .currentState!
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        backgroundColor:
                                                                            primaryColor,
                                                                        content: Text(
                                                                            'Please enter valid email.',
                                                                            style:
                                                                                styleNormalBodyText.copyWith(color: Colors.white)),
                                                                      ));
                                                                      _btnController
                                                                          .reset();
                                                                      return;
                                                                    }
                                                                    final outputRegisterProfile =
                                                                        await authService
                                                                            .updateProfile(profile!);

                                                                    outputRegisterProfile
                                                                        .fold(
                                                                            (failureModel) {
                                                                      final snackBar =
                                                                          SnackBar(
                                                                        backgroundColor:
                                                                            primaryColor,
                                                                        content: Text(
                                                                            failureModel.message == null
                                                                                ? 'Error Updating, Please retry'
                                                                                : failureModel.message!,
                                                                            style: styleNormalBodyText.copyWith(color: Colors.white)),
                                                                        action:
                                                                            SnackBarAction(
                                                                          label:
                                                                              'OK',
                                                                          onPressed:
                                                                              () {
                                                                            // Some code to undo the change.
                                                                          },
                                                                        ),
                                                                      );
                                                                      _scaffoldKey
                                                                          .currentState!
                                                                          .showSnackBar(
                                                                              snackBar);
                                                                      _btnController
                                                                          .reset();
                                                                      Timer(
                                                                          Duration(
                                                                              milliseconds: 2000),
                                                                          () {
                                                                        _btnController
                                                                            .reset();
                                                                      });
                                                                    }, (successModel) {
                                                                      _btnController
                                                                          .reset();
                                                                      showDialogSuccess(
                                                                          "Profile successfully updated.",
                                                                          context);
                                                                      Timer(
                                                                          Duration(
                                                                              milliseconds: 500),
                                                                          () {});
                                                                    });
                                                                  },
                                                                  color:
                                                                      primaryColor,
                                                                  animateOnTap:
                                                                      true,
                                                                  controller:
                                                                      _btnController,
                                                                  child: Text(
                                                                    "SUBMIT",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline4!
                                                                        .apply(
                                                                          color:
                                                                              Colors.white,
                                                                        )
                                                                        .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                  )),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        String tokenStore =
                                                            await SharedPref()
                                                                .getString(
                                                                    "TokenStore");
                                                        showDialogSuccess(
                                                            tokenStore,
                                                            context);
                                                      },
                                                      child: Visibility(
                                                        visible: kReleaseMode,
                                                        child: Text(
                                                          "Version : " +
                                                              versionName,
                                                          style:
                                                              styleBoldSmallBodyText,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
//                              ProfileField(
//                                label: 'interests',
//                                fieldValue: "UI guidelines back-end also",
//                                fieldName: "email",
//                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: AppBar(
                                      title: Text(''),
                                      // You can add title here
                                      leading: IconButton(
                                        icon: Icon(Icons.arrow_back,
                                            color: Colors.grey),
                                        onPressed: () {
                                          // Navigator.of(context).pop(),
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      actions: [
                                        IconButton(
                                          icon: Icon(Icons.qr_code_rounded,
                                              color: Colors.grey),
                                          onPressed: () {
                                            onClickQRCode();
                                          },
                                        )
                                      ],
                                      backgroundColor:
                                          Colors.blue.withOpacity(0.0),
                                      //You can make this transparent
                                      elevation: 0.0, //No shadow
                                    ),
                                  ),
                                ],
                              );
                            });
                      } else {
                        return Center(
                          child: Text('Cannot display profile information',
                              style: stylePrimaryColorHeadline2),
                        );
                      }
                    } else {
                      return Center(
                        child: Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }

  void updateScreen() {
    updateDataController.add(true);
  }

  void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Picture'),
            content: Text('Select Profile picture from camera or gallery?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    var file = await getCamera();
                    if (file != null) {
                      final img = Img.decodeImage(file.readAsBytesSync());
                      Img.Image thumbnail = Img.copyResize(
                        img!,
                        width: 512,
                      );
                      final dir = await getTemporaryDirectory();
                      File resizedFile = File('${dir.path}/resized_img.jpg')
                        ..writeAsBytesSync(Img.encodeJpg(thumbnail));
                      List<int> imageBytes = await resizedFile.readAsBytes();
                      base64Image = base64Encode(imageBytes);
                      ProfileService()
                          .saveProfilePicture(base64Image, "resized_img");
                      setState(() {
                        _image = Image.file(file);
                      });
                    }
                    return;
                  },
                  child: Text('Camera')),
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    var file = await getGallery();
                    if (file != null) {
                      final img = Img.decodeImage(file.readAsBytesSync());
                      Img.Image thumbnail = Img.copyResize(
                        img!,
                        width: 512,
                      );
                      final dir = await getTemporaryDirectory();
                      File resizedFile = File('${dir.path}/resized_img.jpg')
                        ..writeAsBytesSync(Img.encodeJpg(thumbnail));
                      List<int> imageBytes = await resizedFile.readAsBytes();
                      String base64Image = base64Encode(imageBytes);
                      ProfileService()
                          .saveProfilePicture(base64Image, "resized_img");
                      setState(() {
                        _image = Image.file(file);
                      });
                    }
                    return;
                  },
                  child: Text('Gallery')),
            ],
          );
        });
  }

  Future<File?> getCamera() async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  Future<File?> getGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  void showEditDialogBox(BuildContext context, String title, final controller,
      Function onPressed) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
          ),
        ),
        content: TextFormField(
          controller: controller,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check_circle,
              color: primaryColor,
            ),
            onPressed: onPressed as void Function()?,
          )
        ],
      ),
    );
  }

  onClickQRCode() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImage(
                  data:
                      "${profile!.id.toString()}\n${profile!.name.toString()}\n${profile!.email.toString()}",
                  version: QrVersions.auto,
                  size: MediaQuery.of(context).size.width / 1.5,
                ),
              ],
            ),
          );
        });
  }

  void showDialogSuccess(String message, BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: Column(
                  children: [
                    Text(
                      "Token : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RoundedLoadingButton(
                  borderRadius: 6,
                  height: 40,
                  onPressed: () {
                    Navigator.pop(context);
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String? label;
  final String? fieldValue;
  final String? fieldName;
  final bool? hideValue;
  final bool? editValue;
  final Function? onPressed;

  ProfileField(
      {this.label,
      this.fieldValue,
      this.fieldName,
      this.hideValue,
      this.editValue = true,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    String? value = "";
    if (hideValue == true) {
      value = value.padLeft(fieldValue!.length, '*');
    } else {
      value = fieldValue;
    }
    return Card(
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(label!, style: mutedText),
                  Text(value!, style: Theme.of(context).textTheme.headline4),
                ],
              ),
            ),
            Visibility(
              visible: editValue ?? true,
              child: IconButton(
                onPressed: onPressed as void Function()?,
                icon: Icon(
                  Icons.mode_edit,
                  color: Color(0xFFDADADA),
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
