

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmaaccess/models/api_status_model.dart';
import 'package:pharmaaccess/models/score_model.dart';
import 'package:pharmaaccess/services/score_service.dart';
import 'package:pharmaaccess/widgets/text_field_widget.dart';

import '../../theme.dart';

class PromoCodePage extends StatefulWidget {

  @override
  _PromoCodePageState createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {
  final promoCodeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Enter Promotion Code"),
      ),
      body: FutureBuilder<PartnerScoreModel?>(
          future: ScoreService().getScore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Container(
                  color: Color(0xFFFAFAFA),
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 120,
                        padding:
                        EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        decoration: softCardShadow.copyWith(
                            borderRadius: BorderRadius.circular(0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              snapshot.data!.score.toString().padLeft(4,'0'),
                              style: styleBlackHeadline1.copyWith(fontSize: 52),
                            ),
                            Text(
                                '1 point = 1 MCP (Medical Contribution Points)',
                                style: styleMutedTextMedium),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 40, right: 40, top: 26, bottom: 16),
                        child: Text("Extra MCP points with Promo Code.", style: TextStyle(height: 1,fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30, right: 30, bottom: 12),
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: "By submitting promo code, you'll ",
                                style: TextStyle(
                                  color: Color(0xEE6F706F),
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: "earn extra Medical Contribution Points, ",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              TextSpan(
                                text: "once processed MCPs will automatically be credited to your account.",
                                style: TextStyle(
                                  color: Color(0xEE6F706F),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 50,
                        ),
                        child: FormFieldWidget(
                          controller: promoCodeController,
                          hintText: 'Enter Promo Code',
                          suffixIcon: Icon(
                            Icons.attach_money,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                      Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: RaisedButton(
                            color: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "SUBMIT REQUEST",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .apply(
                                color: Colors.white,
                              )
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            onPressed: () async {
                              try {
                                var status = await ScoreService().claimPromoCode(promoCodeController.text);
                                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                  backgroundColor: primaryColor,
                                  content: Text(
                                      status.message!,
                                      style: styleNormalBodyText.copyWith(
                                          color: Colors.white)),
                                ));
                                if (status.apiStatus != API_STATUS.fail) {
                                  ScoreService().refreshScore();
                                  Future.delayed(const Duration(seconds: 2),() {
                                    Navigator.of(context).pop();
                                  });
                                }
                              } on Exception catch (e) {
                                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                  backgroundColor: primaryColor,
                                  content: Text(
                                      'Error processing promo code.',
                                      style: styleNormalBodyText.copyWith(
                                          color: Colors.white)),
                                ));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ));
            } else {
              return Container();
            }
          }),
    );
  }
}
