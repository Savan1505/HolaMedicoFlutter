import 'package:pharmaaccess/util/Constants.dart';

import 'CardioVascularBrain.dart';

class CVDMortalityBrain {
  CVDMortalityBrain(
      {this.optionSelected,
      this.selectedMap,
      this.cholestrolVal,
      this.unit = MG_DL});

  String result = "";
  int unit;

  double? cholestrolVal;
  Map<int?, int?>? selectedMap = {};

  void calculate() {
    int? age = selectedMap![2];
    bool isSmoker = selectedMap![1] == 21;
    int maxLength = 0, minlength = 0;
    int? perfectIndex = selectedMap![3];
    int foundIndex = 0, bottomIndex = 3;
    List<int> newList = [];
    if (age == 36) {
      minlength = 0;
      maxLength = 4;
    } else if (age == 35) {
      minlength = 4;
      maxLength = 8;
    } else if (age == 34) {
      minlength = 8;
      maxLength = 12;
    } else if (age == 33) {
      minlength = 12;
      maxLength = 16;
    } else if (age == 32) {
      minlength = 16;
      maxLength = 20;
    } else if (age == 31) {
      minlength = 20;
      maxLength = 24;
    }
    if (perfectIndex == 54) {
      foundIndex = 0;
    } else if (perfectIndex == 53) {
      foundIndex = 1;
    } else if (perfectIndex == 52) {
      foundIndex = 2;
    } else if (perfectIndex == 51) {
      foundIndex = 3;
    }
    double? n = cholestrolVal;
    if (unit != UM_OL_L) {
      n = n! / 38.6;
    }

    CVDModelClass modelClass;
    if (n! <= 4) {
      bottomIndex = 0;
    } else if (n <= 5) {
      bottomIndex = 1;
    } else if (n <= 6) {
      bottomIndex = 2;
    }
    if (selectedMap![0] == 11) {
      //male
      if (isSmoker) {
        modelClass = arrayCVDSmokerMen[bottomIndex];
      } else {
        modelClass = arrayCVDNonSmokerMen[bottomIndex];
      }
    } else {
      //female
      if (isSmoker) {
        modelClass = arrayCVDSmokerWomen[bottomIndex];
      } else {
        modelClass = arrayCVDNonSmokerWomen[bottomIndex];
      }
    }
    for (int i = minlength; i < maxLength; i++) {
      newList.add(modelClass.dataList![i]);
    }
    var ans = newList[foundIndex];
    result = ans.toString();
    // return newList[perfectIndex].toString();
  }

  List<CardioVascularModel> listCardio = [];
  List<CVDModelClass> arrayCVDNonSmokerWomen = [
    CVDModelClass(index: 4, dataList: [
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      1,
      1,
      1,
      1,
      2,
      1,
      2,
      3,
      4,
      3,
      4,
      5,
      7,
      7,
      8,
      10,
      12
    ]),
    CVDModelClass(index: 5, dataList: [
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      1,
      1,
      1,
      2,
      2,
      1,
      2,
      3,
      4,
      3,
      4,
      6,
      8,
      7,
      9,
      11,
      13
    ]),
    CVDModelClass(index: 6, dataList: [
      0,
      0,
      0,
      1,
      0,
      1,
      1,
      2,
      1,
      1,
      2,
      3,
      2,
      2,
      3,
      5,
      4,
      5,
      6,
      8,
      8,
      10,
      12,
      14
    ]),
    CVDModelClass(index: 7, dataList: [
      0,
      0,
      0,
      1,
      0,
      1,
      1,
      2,
      1,
      1,
      2,
      3,
      2,
      3,
      4,
      5,
      4,
      5,
      7,
      9,
      9,
      10,
      13,
      15
    ]),
  ];
  List<CVDModelClass> arrayCVDSmokerWomen = [
    CVDModelClass(index: 4, dataList: [
      0,
      0,
      1,
      1,
      1,
      1,
      2,
      3,
      1,
      2,
      3,
      5,
      3,
      4,
      5,
      7,
      5,
      7,
      9,
      11,
      10,
      12,
      14,
      17
    ]),
    CVDModelClass(index: 5, dataList: [
      0,
      0,
      1,
      1,
      1,
      1,
      2,
      3,
      1,
      2,
      3,
      5,
      3,
      4,
      6,
      8,
      5,
      7,
      9,
      12,
      10,
      13,
      15,
      19
    ]),
    CVDModelClass(index: 6, dataList: [
      0,
      0,
      1,
      2,
      1,
      1,
      2,
      4,
      2,
      2,
      4,
      6,
      3,
      4,
      6,
      9,
      6,
      8,
      10,
      13,
      11,
      14,
      16,
      20
    ]),
    CVDModelClass(index: 7, dataList: [
      0,
      1,
      1,
      2,
      1,
      2,
      3,
      4,
      2,
      3,
      4,
      7,
      3,
      5,
      7,
      10,
      7,
      9,
      11,
      15,
      12,
      15,
      18,
      21
    ]),
  ];

  List<CVDModelClass> arrayCVDNonSmokerMen = [
    CVDModelClass(index: 4, dataList: [
      0,
      0,
      1,
      2,
      1,
      2,
      2,
      4,
      2,
      3,
      4,
      6,
      4,
      5,
      7,
      10,
      7,
      9,
      12,
      15,
      13,
      16,
      20,
      24
    ]),
    CVDModelClass(index: 5, dataList: [
      0,
      1,
      1,
      2,
      1,
      2,
      3,
      5,
      2,
      3,
      5,
      7,
      4,
      6,
      8,
      11,
      8,
      11,
      14,
      17,
      15,
      18,
      22,
      26
    ]),
    CVDModelClass(index: 6, dataList: [
      0,
      1,
      1,
      2,
      1,
      2,
      3,
      6,
      3,
      4,
      6,
      9,
      5,
      7,
      10,
      13,
      10,
      12,
      16,
      20,
      17,
      21,
      25,
      30
    ]),
    CVDModelClass(index: 7, dataList: [
      1,
      1,
      2,
      3,
      2,
      3,
      4,
      7,
      3,
      5,
      7,
      10,
      6,
      8,
      11,
      15,
      11,
      14,
      18,
      23,
      20,
      24,
      28,
      33
    ]),
  ];
  List<CVDModelClass> arrayCVDSmokerMen = [
    CVDModelClass(index: 4, dataList: [
      1,
      1,
      2,
      4,
      2,
      3,
      5,
      8,
      4,
      5,
      8,
      11,
      6,
      9,
      12,
      16,
      11,
      14,
      18,
      23,
      19,
      23,
      27,
      33
    ]),
    CVDModelClass(index: 5, dataList: [
      1,
      1,
      2,
      4,
      2,
      4,
      6,
      9,
      4,
      6,
      9,
      13,
      7,
      10,
      14,
      19,
      13,
      16,
      21,
      26,
      22,
      26,
      31,
      36
    ]),
    CVDModelClass(index: 6, dataList: [
      1,
      2,
      3,
      5,
      3,
      5,
      7,
      11,
      5,
      7,
      11,
      16,
      9,
      12,
      16,
      22,
      15,
      19,
      24,
      30,
      25,
      29,
      34,
      40
    ]),
    CVDModelClass(index: 7, dataList: [
      1,
      2,
      4,
      7,
      4,
      6,
      9,
      13,
      6,
      9,
      13,
      18,
      10,
      14,
      19,
      25,
      17,
      22,
      27,
      34,
      28,
      33,
      39,
      45
    ]),
  ];
  List<CardioVascularOptions>? optionSelected = [];

  List<CardioVascularModel> getCardioVascularListHasBled() {
    listCardio = [
      CardioVascularModel(title: "Gender", listOptions: [
        CardioVascularOptions(title: "Male", point: 0, index: 11),
        CardioVascularOptions(title: "Female", point: 0, index: 12),
      ]),
      CardioVascularModel(title: "Smoking", listOptions: [
        CardioVascularOptions(title: "Smoker", point: 1, index: 21),
        CardioVascularOptions(title: "Non Smoker", point: 1, index: 22),
      ]),
      CardioVascularModel(title: "Age", listOptions: [
        CardioVascularOptions(title: "≥70 years", point: 2, index: 31),
        CardioVascularOptions(title: "65-69 years", point: 2, index: 32),
        CardioVascularOptions(title: "60-64 years", point: 2, index: 33),
        CardioVascularOptions(title: "55-59 years", point: 2, index: 34),
        CardioVascularOptions(title: "50-54  years", point: 2, index: 35),
        CardioVascularOptions(title: "40-49 years", point: 2, index: 36),
      ]),
      CardioVascularModel(title: "Systolic Blood Pressure", listOptions: [
        CardioVascularOptions(title: "≥180", point: 3, index: 51),
        CardioVascularOptions(title: "160-179", point: 3, index: 52),
        CardioVascularOptions(title: "140-159", point: 3, index: 53),
        CardioVascularOptions(title: "120-139", point: 3, index: 54),
      ])
    ];
    return listCardio;
  }
}

class CVDModelClass {
  final int? index;
  final List<int>? dataList;

  CVDModelClass({this.index, this.dataList});
}
