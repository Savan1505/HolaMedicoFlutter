import 'package:pharmaaccess/util/Constants.dart';

class CardioVascularBrain {
  CardioVascularBrain({this.optionSelected, this.type});

  String result = "",
      bleeds_per_year = "",
      use_of_negotiation = "",
      recommendations = "";
  int? type;
  int index = 0;

  String getResult() {
    int _bmi = 0;
    optionSelected!.forEach((element) {
      _bmi = _bmi + element.point!;
    });
    index = _bmi;
    String data = "";
    if (type == CHADCS2 || type == CHADCS2_VASC) {
      result =
          type == CHADCS2 ? riskStrokeList[_bmi] : riskStrokeListVasc[_bmi];
      if (_bmi == 0) {
        recommendations = "No antithrombotic therapy is recommended";
      } else if (_bmi == 1) {
        recommendations = "May consider anticoagulant or antiplatelet";
      } else {
        recommendations = "Oral anticoagulant is recommended";
      }
    } else {}
    if (type == HAS_BLED_SCORE) {
      int index = _bmi < 6 ? _bmi : hasBledResult.length - 1;
      if (index == 6) {
        bleeds_per_year = ": ";
      } else {
        bleeds_per_year = "= ";
      }
      bleeds_per_year += hasBledResult[index][0];
      use_of_negotiation = hasBledResult[index][1];
    } else if (type == DASH_SCORE) {
      String endString = _bmi > 1
          ? continuing_acnticoagulation
          : discontinuing_anticoagulation;
      result = dashScoreResult[_bmi]! +
          " % annual risk of VTE recurrence." +
          endString;
    }
    data = _bmi.toString();
    return data;
  }

  List<CardioVascularModel> listCardio = [];
  List<List<String>> hasBledResult = [
    [
      "1.13",
      "Anticoagulation should be considered. Patient has a relatively low risk for major bleeding"
    ],
    [
      "1.02",
      "Anticoagulation should be considered. Patient has a relatively low risk for major bleeding"
    ],
    [
      "1.88",
      "Anticoagulation can be considered, however patient does have moderate risk for major bleeding"
    ],
    [
      "3.74",
      "Alternatives to anticoagulation should be considered. Patient is at high risk for major bleeding"
    ],
    [
      "8.7",
      "Alternatives to anticoagulation should be considered. Patient is at high risk for major bleeding"
    ],
    [
      "12.5",
      "Alternatives to anticoagulation should be considered. Patient is at high risk for major bleeding"
    ],
    [
      "Scores greater than 5 were too rare to determine risk, but are likely over 10%",
      "Alternatives to anticoagulation should be considered. Patient is at high risk for major bleeding"
    ]
  ];

  List<String> riskStrokeList = [
    "1.9 % ",
    "2.8 % ",
    "4 % ",
    "5.9 % ",
    "8.5 % ",
    "12.5 % ",
    "18.2 % "
  ];

  List<String> riskStrokeListVasc = [
    "0 % ",
    "1.3 % ",
    "2.2 % ",
    "3.2 % ",
    "4.0 % ",
    "6.7 % ",
    "9.8 % ",
    "9.6 % ",
    "6.7 % ",
    "15.2 % ",
  ];

  List<CardioVascularOptions>? optionSelected = [];

  List<CardioVascularModel> getVascularList(int? type) {
    if (type == CHADCS2) {
      getCardioVascularList();
    } else if (type == CHADCS2_VASC) {
      getCardioVascularListVasc();
    } else if (type == HAS_BLED_SCORE) {
      getCardioVascularListHasBled();
    } else if (type == DASH_SCORE) {
      getCardioVascularListDashScore();
    }

    return listCardio;
  }

  List<CardioVascularModel> getCardioVascularList() {
    listCardio = [
      CardioVascularModel(title: "Congestive Heart Failure", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 11),
        CardioVascularOptions(title: no, point: 0, index: 12),
      ]),
      CardioVascularModel(title: "Hypertension", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 21),
        CardioVascularOptions(title: no, point: 0, index: 22),
      ]),
      CardioVascularModel(title: "Age", listOptions: [
        CardioVascularOptions(title: ">75 years", point: 1, index: 31),
        CardioVascularOptions(title: "<75 years", point: 0, index: 32),
      ]),
      CardioVascularModel(title: "Diabetes", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 41),
        CardioVascularOptions(title: no, point: 0, index: 42),
      ]),
      CardioVascularModel(title: "Previous Stroke or TIA", listOptions: [
        CardioVascularOptions(title: yes, point: 2, index: 54),
        CardioVascularOptions(title: no, point: 0, index: 55),
      ])
    ];
    return listCardio;
  }

  List<CardioVascularModel> getCardioVascularListVasc() {
    listCardio = [
      CardioVascularModel(title: "Congestive Heart Failure", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 11),
        CardioVascularOptions(title: no, point: 0, index: 12),
      ]),
      CardioVascularModel(title: "Hypertension", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 21),
        CardioVascularOptions(title: no, point: 0, index: 22),
      ]),
      CardioVascularModel(title: "Age", listOptions: [
        CardioVascularOptions(title: "<65 years", point: 0, index: 31),
        CardioVascularOptions(title: "65-74 years", point: 1, index: 32),
        CardioVascularOptions(title: ">=75 years", point: 2, index: 33),
      ]),
      CardioVascularModel(title: "Diabetes", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 41),
        CardioVascularOptions(title: no, point: 0, index: 42),
      ]),
      CardioVascularModel(
          title: "Previous Stroke/TIA Thromboembolism",
          listOptions: [
            CardioVascularOptions(title: yes, point: 2, index: 51),
            CardioVascularOptions(title: no, point: 0, index: 52),
          ]),
      CardioVascularModel(
          title:
              "History of Vascular Disease (Prior MI, peripheral artery disease, or aortic plaque",
          listOptions: [
            CardioVascularOptions(title: yes, point: 1, index: 61),
            CardioVascularOptions(title: no, point: 0, index: 62),
          ]),
      CardioVascularModel(title: "Gender", listOptions: [
        CardioVascularOptions(title: "Male", point: 0, index: 71),
        CardioVascularOptions(title: "Female", point: 1, index: 72),
      ])
    ];
    return listCardio;
  }

  List<CardioVascularModel> getCardioVascularListHasBled() {
    listCardio = [
      CardioVascularModel(
          title: "Hypertension Uncontrolled, >160 mmHg systolic",
          listOptions: [
            CardioVascularOptions(title: yes, point: 1, index: 11),
            CardioVascularOptions(title: no, point: 0, index: 12),
          ]),
      CardioVascularModel(
          title:
              "Renal disease Dialysis, transplant, Cr >2.26 mg/dL or >200 µmol/L",
          listOptions: [
            CardioVascularOptions(title: yes, point: 1, index: 21),
            CardioVascularOptions(title: no, point: 0, index: 22),
          ]),
      CardioVascularModel(
          title:
              "Liver disease Cirrhosis or bilirubin >2x normal with AST/ALT/AP >3x normal",
          listOptions: [
            CardioVascularOptions(title: yes, point: 1, index: 31),
            CardioVascularOptions(title: no, point: 0, index: 32),
          ]),
      CardioVascularModel(title: "Stroke history", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 51),
        CardioVascularOptions(title: no, point: 0, index: 52),
      ]),
      CardioVascularModel(
          title: "Prior major bleeding or predisposition to bleeding",
          listOptions: [
            CardioVascularOptions(title: yes, point: 1, index: 61),
            CardioVascularOptions(title: no, point: 0, index: 62),
          ]),
      CardioVascularModel(
          title:
              "Labile INR Unstable/high INRs, time in therapeutic range <60%",
          listOptions: [
            CardioVascularOptions(title: yes, point: 1, index: 71),
            CardioVascularOptions(title: no, point: 0, index: 72),
          ]),
      CardioVascularModel(title: "Age >65", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 81),
        CardioVascularOptions(title: no, point: 0, index: 82),
      ]),
      CardioVascularModel(
          title:
              "Medication usage predisposing to bleeding Aspirin, clopidogrel, NSAIDs",
          listOptions: [
            CardioVascularOptions(title: yes, point: 1, index: 91),
            CardioVascularOptions(title: no, point: 0, index: 92),
          ]),
      CardioVascularModel(title: "Alcohol use ≥8 drinks/week", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 101),
        CardioVascularOptions(title: no, point: 0, index: 102),
      ]),
    ];
    return listCardio;
  }

  List<CardioVascularModel> getCardioVascularListDashScore() {
    listCardio = [
      CardioVascularModel(
          title: "D-dimer abnormal, Measured~ after stopping anticoagulation",
          listOptions: [
            CardioVascularOptions(title: yes, point: 2, index: 11),
            CardioVascularOptions(title: no, point: 0, index: 12),
          ]),
      CardioVascularModel(title: "Age ≤ 50 years", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 21),
        CardioVascularOptions(title: no, point: 0, index: 22),
      ]),
      CardioVascularModel(title: "Male patient", listOptions: [
        CardioVascularOptions(title: yes, point: 1, index: 31),
        CardioVascularOptions(title: no, point: 0, index: 32),
      ]),
      CardioVascularModel(
          title:
              "Hormone use at VTE onset (if female) If male patient, select “No”",
          listOptions: [
            CardioVascularOptions(title: yes, point: -2, index: 41),
            CardioVascularOptions(title: no, point: 0, index: 42),
          ]),
    ];
    return listCardio;
  }

  String continuing_acnticoagulation = "Consider continuing anticoagulation.",
      discontinuing_anticoagulation = "Consider discontinuing anticoagulation.";
  Map<int, String> dashScoreResult = {
    -2: "1.8",
    -1: "1.0",
    0: "2.4",
    1: "3.9",
    2: "6.3",
    3: "10.8",
    4: "19.9"
  };
}

String yes = "Yes", no = "No";

class CardioVascularModel {
  final String? title;
  final List<CardioVascularOptions>? listOptions;

  CardioVascularModel({this.title, this.listOptions});
}

class CardioVascularOptions {
  final String? title;
  final int? point;
  final int? index;

  CardioVascularOptions({this.title, this.point, this.index});
}
