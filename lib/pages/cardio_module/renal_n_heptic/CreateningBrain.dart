import 'package:pharmaaccess/util/Constants.dart';

class CreatenineBrain {
  CreatenineBrain(
      {this.weight = 0,
      this.age = 0,
      this.gender = MALE_Gender,
      this.unit = MG_DL,
      this.creatinine = 0.0});

  double weight = 0;
  int? gender, unit;
  double creatinine = 0.0;
  int age = 0;

  double calculateDoubleCreatenine() {
    double _bmi = ((140 - age) * weight) / (creatinine * 72);

    if (gender == FEMALE_Gender) {
      _bmi = _bmi * 0.85;
    }

    if (unit == UM_OL_L) {
      _bmi = _bmi * 88.4;
    }

    return _bmi;
  }

  List<String> getResult() {
    List<String> data;
    double _bmi = calculateDoubleCreatenine();
    int index = 4;
    if (_bmi >= 90) {
      index = 0;
    } else if (_bmi >= 60 && _bmi < 90) {
      index = 1;
    } else if (_bmi >= 30 && _bmi < 60) {
      index = 2;
    } else if (_bmi >= 15 && _bmi < 30) {
      index = 3;
    }
    data = bodyFatList[index];
    return data;
  }

  List<List<String>> bodyFatList = [
    ["Stage 1", "Normal Renal Function"],
    ["Stage 2", "Mild Renal Impairment"],
    ["Stage 3", "Moderate Renal Impairment"],
    ["Stage 4", "Severe Renal Impairment"],
    ["Stage 5", "End-Stage Renal Disease"]
  ];
}
