import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pharmaaccess/components/app_webview.dart';
import 'package:pharmaaccess/config/colors.dart';
import 'package:pharmaaccess/models/country_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/services/auth_service.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';

class LoginPageWidget extends StatefulWidget {
  final VoidCallback? callback;

  LoginPageWidget({Key? key, this.callback}) : super(key: key);

  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final username = TextEditingController();
  final password = TextEditingController();
  late AuthService authService;
  VoidCallback? callback;

  //var _login_failed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callback = widget.callback;
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authService = Provider.of<AuthService>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: Stack(children: <Widget>[
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
          ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 90),
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
                        height: 26,
                      ),
                      Container(
                        height: 340,
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
                                "Sign In",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              Divider(
                                color: Colors.white,
                                height: 12,
                              ),
                              FormFieldWidget(
                                  controller: username,
                                  hintText: 'Email ID',
                                  textInputType: TextInputType.emailAddress,
                                  suffixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.grey[200],
                                  )),
                              FormFieldWidget(
                                controller: password,
                                textInputType: TextInputType.emailAddress,
                                obscureText: true,
                                hintText: 'Password',
                                suffixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.grey[200],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: 16,
                                  top: 6,
                                ),
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        color: primaryColor, fontSize: 16),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MyWebView(
                                                  title: "Recover Password",
                                                  selectedUrl:
                                                      "https://portal.pharmaaccess.com/web/reset_password",
                                                )));
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 60,
                                width: double.infinity,
                                child: Container(
                                  child: RaisedButton(
                                    color: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "SIGN IN",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .apply(
                                            color: Colors.white,
                                          )
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () async {
                                      var user = await authService.login(
                                          username.text, password.text);
                                      if (user != null) {
                                        //Clear saved user and save this user and navigate
                                        // var profileInfo =
                                        //     await authService.fetchProfile();
                                        Country? country;
                                        if (user.companyId != null) {
                                          country = countryList.firstWhere(
                                              (element) =>
                                                  element.countryId ==
                                                  user.companyId);
                                        }
                                        await authService
                                            .saveProfile(ProfileModel(
                                          user.name,
                                          username.text,
                                          password.text,
                                          0,
                                          "",
                                          "",
                                          "",
                                          "",
                                          "",
                                          user.uid,
                                          "",
                                          country != null
                                              ? country.countryCode!
                                              : countryList.last.countryCode!,
                                          country != null
                                              ? country.countryName!
                                              : countryList.last.countryName!,
                                          user.partnerId,
                                        ));
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/',
                                                (Route<dynamic> route) =>
                                                    false);
                                      } else {
                                        //inform user about login failure
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Login Failed.",
                                                style: styleNormalBodyText
                                                    .copyWith(
                                                        color: Colors.white)),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: primaryColor,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: "Sign Up",
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
          )
        ]),
      ),
    );
  }
}
