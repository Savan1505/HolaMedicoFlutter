import 'package:pharmaaccess/util/Constants.dart';

class ChildPughScoreBrain {
  ChildPughScoreBrain(
      {this.albuminUnit = MG_DL,
      this.bilirubinUnit = MG_DL,
      this.inr,
      this.encephalopathyList,
      this.ascites,
      this.albumin,
      this.bilirubin});

  int albuminUnit, bilirubinUnit;
  double? albumin, inr, bilirubin;
  PughUnitClass? ascites, encephalopathyList;

  int calculatePughScore() {
    int? _bmi = 0;
    _bmi = ascites!.index;
    _bmi = _bmi! + encephalopathyList!.value!;

    if (bilirubinUnit == MG_DL) {
      if (bilirubin! > 3) {
        _bmi = _bmi + 3;
      } else if (bilirubin! >= 2 && bilirubin! <= 3) {
        _bmi = _bmi + 2;
      } else if (bilirubin! < 2) {
        _bmi = _bmi + 1;
      }
    } else if (bilirubinUnit == UM_OL_L) {
      if (bilirubin! > 51.3) {
        _bmi = _bmi + 3;
      } else if (bilirubin! >= 34.2 && bilirubin! <= 51.3) {
        _bmi = _bmi + 2;
      } else if (bilirubin! < 34.2) {
        _bmi = _bmi + 1;
      }
    }

    if (albuminUnit == G_DL) {
      if (albumin! > 3.5) {
        _bmi = _bmi + 1;
      } else if (albumin! >= 2.8 && albumin! <= 3.5) {
        _bmi = _bmi + 2;
      } else if (albumin! < 2.8) {
        _bmi = _bmi + 3;
      }
    } else if (albuminUnit == G_L) {
      if (albumin! > 35) {
        _bmi = _bmi + 1;
      } else if (albumin! >= 28 && albumin! <= 35) {
        _bmi = _bmi + 2;
      } else if (albumin! < 28) {
        _bmi = _bmi + 3;
      }
    }

    if (inr! > 2.2) {
      _bmi = _bmi + 3;
    } else if (inr! >= 1.7 && inr! <= 2.2) {
      _bmi = _bmi + 2;
    } else if (inr! < 1.7) {
      _bmi = _bmi + 1;
    }

    return _bmi;
  }

  String getResult() {
    int _bmi = calculatePughScore();
    int index = 0;
    if (_bmi >= 10 && _bmi <= 15) {
      index = 2;
    } else if (_bmi >= 7 && _bmi <= 9) {
      index = 1;
    } else if (_bmi >= 5 && _bmi <= 6) {
      index = 0;
    }
    return resultList[index];
  }

  List<String> resultList = ["Child-Pugh A", "Child-Pugh B", "Child-Pugh C"];

  List<PughUnitClass> ascitesList = [
    PughUnitClass(title: TITLE_ABSENT, index: 1),
    PughUnitClass(title: TITLE_SLIGHT, index: 2),
    PughUnitClass(title: TITLE_MODERATE, index: 3)
  ];

  List<PughUnitClass> encephalopathy = [
    PughUnitClass(title: "None", index: 0, value: 1),
    PughUnitClass(title: "Grade 1", index: 1, value: 2),
    PughUnitClass(title: "Grade 2", index: 2, value: 2),
    PughUnitClass(title: "Grade 3", index: 3, value: 3),
    PughUnitClass(title: "Grade 4", index: 4, value: 3)
  ];
}

class PughUnitClass {
  final String? title;
  final int? index, value;

  PughUnitClass({this.title, this.index, this.value});
}
