import 'package:flutter/material.dart';
import 'package:pharmaaccess/components/app_webview.dart';
import 'package:pharmaaccess/models/brand/clinical_trial_model.dart';
import 'package:pharmaaccess/theme.dart';

class ClinicalTrialWidget extends StatelessWidget {
  final List<ClinicalTrialModel>? trialList;
  ClinicalTrialWidget({Key? key, this.trialList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
          itemCount: trialList!.length,
          itemBuilder: (BuildContext context, int index) {
            return ClinicalTrialItemWidget(clinicalTrial: trialList![index]);
          }),
    );
  }
}


class ClinicalTrialItemWidget extends StatelessWidget {
  final ClinicalTrialModel clinicalTrial;
  ClinicalTrialItemWidget({Key? key, required this.clinicalTrial}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: softCardShadow,
        margin: EdgeInsets.symmetric(vertical: 12,horizontal: 0),
        padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(clinicalTrial.title!, style: TextStyle(color: primaryColor, fontSize: 16,)),
          Divider(height: 8, color: Color(0x00ffffff),),
          Text(clinicalTrial.description!, style: bodyText),
          Divider(height: 8, color: Color(0x00ffffff),),
          clinicalTrial.url != null ? FlatButton(
            textColor: Colors.white,
            color: primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyWebView(
                    title: clinicalTrial.title,
                    selectedUrl: clinicalTrial.url,
                  )));
            },
            child: Text("View Study"),
          ) : Container(),
        ],
      )
    );
  }
}
