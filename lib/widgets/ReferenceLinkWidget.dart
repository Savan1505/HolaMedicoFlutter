import 'package:flutter/material.dart';
import 'package:pharmaaccess/util/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferenceLinkWidget extends StatefulWidget {
  @override
  _ReferenceLinkWidgetState createState() => _ReferenceLinkWidgetState();
}

class _ReferenceLinkWidgetState extends State<ReferenceLinkWidget> {
  ScrollController _scrollController = new ScrollController();
  List<LinkModel> links = [
    LinkModel(TITLE_BMI, BMI_REFER_LINK),
    LinkModel(TITLE_LEAN_BODY_MASS, LEAN_BODY_MASS_REFER_LINK),
    LinkModel(TITLE_BODY_FAT_PER, BODY_FAT_PER_REFER_LINK),
    LinkModel(TITLE_BASAL_META_RATE, BASAL_META_RATE_REFER_LINK),
    LinkModel(TITLE_CALORIE_CALCULATOR, CALORIE_CALC_REFER_LINK),
    LinkModel(
        TITLE_DIABETES_RISK_ASSESSMENT, DIABETES_RISK_ASSESSMENT_REFER_LINK),
    LinkModel(TITLE_CHADSC2, CHADS2_SCORE_REFER_LINK),
    LinkModel(TITLE_CHADSC2_VASC, CHA2DS2_VASC_SCORE_REFER_LINK),
    LinkModel(TITLE_HAS_BLED_SCORE, HAS_BLED_REFER_LINK),
    LinkModel(TITLE_DASH_SCORE, DASH_SCORE_REFER_LINK),
    LinkModel(TITLE_LIPID_UNIT_CONVERSION, LIPID_UNIT_CONVER_REFER_LINK),
    LinkModel(TITLE_CVD_MORTALITY_RISK, CVD_MORTALITY_RISK_SCORE_REFER_LINK),
    LinkModel(TITLE_HG_STAGING, ACC_HF_STAGING_REFER_LINK),
    LinkModel(TITLE_CREATININE, CREATININE_REFER_LINK),
    LinkModel(TITLE_CHILD_PUGH, CHILD_PUGH_SCORE_REFER_LINK),
    LinkModel(TITLE_ACR_EULAR_RHEUMATOID_ARTHRITIS_CLASSIFICATION,
        RHEUMATOID_ARTHRITIS_REFER_LINK),
    LinkModel(
        TITLE_ACR_EULAR_GOUT_CLASSIFICATION, GOUT_CLASSIFICATION_REFER_LINK),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("References", style: Theme.of(context).textTheme.headline4),
      content: Container(
        width: 250,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: links.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        launch(links[index].link);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          links[index].title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkModel {
  String title;
  String link;

  LinkModel(this.title, this.link);
}
