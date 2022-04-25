import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/pages/cardio_module/models/ChartModel.dart';
import 'package:pharmaaccess/util/Constants.dart';

class CalculatorBrain {
  CalculatorBrain(
      {this.height = 0,
      this.weight = 0,
      this.age = 0,
      this.type,
      this.gender = MALE_Gender,
      this.selectedModel});

  double height = 0;
  double weight = 0;
  int? gender;
  int? type = 0;
  int age = 0;

  LifeStyleModel? selectedModel;

  String calculateBMI() {
    if (type == BODY_FAT) {
      return calculateDoubloeBMI().toStringAsFixed(1) + "%";
    }
    return calculateDoubloeBMI().toStringAsFixed(1);
  }

  double calculateDoubloeBMI() {
    double _bmi = 0.0;
    if (type == BMI) {
      _bmi = weight / pow(height / 100, 2);
    } else if (type == LBM) {
      if (gender == FEMALE_Gender) {
        _bmi = (0.29569 * weight) + (0.41813 * height) - 43.2933;
      } else {
        _bmi = (0.32810 * weight) + (0.33929 * height) - 29.5336;
      }
    } else if (type == BODY_FAT) {
      double heightinMeter = height / 100;
      double weightHeightData = (weight / (heightinMeter * heightinMeter));
      if (gender == FEMALE_Gender) {
        _bmi = ((1.20 * weightHeightData) + (0.23 * age) - 5.4);
      } else if (gender == MALE_Gender) {
        _bmi = ((1.20 * weightHeightData) + (0.23 * age) - 16.2);
      } else if (gender == BOY_Gender) {
        _bmi = ((1.51 * weightHeightData) - (0.70 * age) - 2.2);
      } else if (gender == GIRL_Gender) {
        _bmi = ((1.51 * weightHeightData) - (0.70 * age) + 1.4);
      }
      chartModels = getChartsModel();
      chartModels.forEach((element) {
        double minValue = double.parse(element.value!.split("-")[0]);
        double maxValue = double.parse(element.value!.split("-")[1]);
        if (_bmi >= minValue && _bmi <= maxValue) {
          resultForBodyFat = element.title;
          resultColor = element.color;
        }
      });
      if (resultForBodyFat!.isEmpty) {
        resultForBodyFat = chartModels[chartModels.length - 1].title;
        resultColor = chartModels[chartModels.length - 1].color;
      }
    } else if (type == BASAL_METABOLIC_RATE) {
      _bmi = calculateBMR(_bmi);
    } else if (type == CALORIE_CALCULATOR) {
      _bmi = calculateBMR(_bmi);
      _bmi = _bmi * selectedModel!.value!;
    }
    return _bmi;
  }

  double calculateBMR(double _bmi) {
    if (gender == MALE_Gender) {
      _bmi = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      _bmi = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
    return _bmi;
  }

  String? resultForBodyFat = "";
  Color? resultColor = Colors.red;

  String getResult() {
    double _bmi = calculateDoubloeBMI();
    if (_bmi >= 30) {
      return 'Obese';
    } else if (_bmi >= 25.9) {
      return 'Over-weight';
    } else if (_bmi >= 18.5) {
      return 'Healthy weight';
    } else {
      return 'Underweight';
    }
  }

  late List<ChartModel> chartModels;

  List<ChartModel> getChartsModel() {
    List<ChartModel> models = [];
    // if (gender == MALE_Gender || gender == FEMALE_Gender) {
    models = [
      getChartModel(0),
      getChartModel(1),
      getChartModel(2),
      getChartModel(3),
    ];
    // } else if (gender == GIRL_Gender || gender == BOY_Gender) {}
    /*else if (type == GIRL_Gender) {
      models = [
        ChartModel(
            value: getValueForChartModel(),
            title: "Underfat",
            color: Colors.blue),
        ChartModel(value: "25", title: "Healthy", color: Colors.green),
        ChartModel(value: "30", title: "Overfat", color: Colors.orange),
        ChartModel(value: "50", title: "Underfat", color: Colors.red),
      ];
    } else if (type == BOY_Gender) {
      models = [
        ChartModel(
            value: getValueForChartModel(),
            title: "Underfat",
            color: Colors.blue),
        ChartModel(value: "20", title: "Healthy", color: Colors.green),
        ChartModel(value: "35", title: "Overfat", color: Colors.orange),
        ChartModel(value: "35+", title: "Underfat", color: Colors.red),
      ];
    }*/
    return models;
  }

  ChartModel getChartModel(int index) => ChartModel(
      index: index,
      value: getValueForChartModel(index),
      title: bodyFatList[index],
      color: colorBodyFatList[index]);

  String getValueForChartModel(int index) {
    if (gender == MALE_Gender || gender == FEMALE_Gender) {
      bool isMale = gender == MALE_Gender;
      if (age >= 21 && age <= 25) {
        return isMale ? leanListMale[0][index] : leanListFeMale[0][index];
      } else if (age >= 26 && age <= 30) {
        return isMale ? leanListMale[1][index] : leanListFeMale[1][index];
      } else if (age >= 31 && age <= 35) {
        return isMale ? leanListMale[2][index] : leanListFeMale[2][index];
      } else if (age >= 36 && age <= 40) {
        return isMale ? leanListMale[3][index] : leanListFeMale[3][index];
      } else if (age >= 41 && age <= 45) {
        return isMale ? leanListMale[4][index] : leanListFeMale[4][index];
      } else if (age >= 46 && age <= 50) {
        return isMale ? leanListMale[5][index] : leanListFeMale[5][index];
      } else if (age >= 51 && age <= 55) {
        return isMale ? leanListMale[6][index] : leanListFeMale[6][index];
      }
      return isMale ? leanListMale[7][index] : leanListFeMale[7][index];
    } else if (gender == BOY_Gender || gender == GIRL_Gender) {
      bool isBoy = gender == BOY_Gender;
      int indexList = age - 5;
      return isBoy
          ? bodyFatBoy[indexList][index]
          : bodyFatGirl[indexList][index];
    }
    return "";
  }

  List<String> bodyFatList = [
    "Lean",
    "Ideal",
    "Average",
    "Overfat",
  ];
  List<Color> colorBodyFatList = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];
  List<List<String>> leanListMale = [
    ["3-10", "10-15", "15-22", "23-26"],
    ["4-11", "11-16", "16-21", "21-27"],
    ["5-13", "13-17", "17-25", "25-28"],
    ["6-15", "15-20", "20-26", "26-29"],
    ["7-16", "16-22", "22-27", "27-30"],
    ["8-17", "17-23", "23-29", "29-31"],
    ["9-19", "20-25", "25-30", "31-33"],
    ["10-21", "21-26", "26-31", "31-34"],
  ];

  List<List<String>> bodyFatGirl = [
    /*5*/ ["0-14", "14-22", "22-26", "26-35"],
    /*6*/ ["0-14", "14-23", "23-27", "27-35"],
    /*7*/ ["0-15", "15-25", "25-29", "29-35"],
    /*8*/ ["0-15", "15-26", "26-30", "30-35"],
    /*9*/ ["0-16", "16-27", "27-31", "31-35"],
    /*10*/ ["0-16", "16-28", "28-32", "32-35"],
    /*11*/ ["0-16", "16-29", "29-33", "33-35"],
    /*12*/ ["0-16", "16-29", "29-33", "33-35"],
    /*13*/ ["0-16", "16-29", "29-33", "33-35"],
    /*14*/ ["0-16", "16-30", "30-34", "34-35"],
    /*15*/ ["0-16", "16-30", "30-34", "34-35"],
    /*16*/ ["0-16", "16-30", "30-34", "34-35"],
    /*17*/ ["0-16", "16-30", "30-35", "35-35"],
    /*18*/ ["0-17", "17-31", "31-35", "35-35"],
  ];
  List<List<String>> bodyFatBoy = [
    /*5*/ ["0-12", "12-19", "19-23", "23-35"],
    /*6*/ ["0-12", "12-20", "20-24", "24-35"],
    /*7*/ ["0-13", "12-20", "20-25", "25-35"],
    /*8*/ ["0-13", "12-21", "21-26", "26-35"],
    /*9*/ ["0-13", "12-22", "22-27", "27-35"],
    /*10*/ ["0-13", "12-23", "23-28", "28-35"],
    /*11*/ ["0-13", "12-23", "23-28", "28-35"],
    /*12*/ ["0-12", "12-23", "23-28", "28-35"],
    /*13*/ ["0-12", "12-22", "22-27", "27-35"],

    /*14*/ ["0-11", "11-21", "21-26", "26-35"],

    /*15*/ ["0-10", "10-21", "21-25", "25-35"],

    /*16*/ ["0-10", "10-20", "20-24", "24-35"],
    /*17*/ ["0-10", "10-20", "20-24", "24-35"],
    /*18*/ ["0-10", "10-20", "20-24", "24-35"],
  ];
  List<List<String>> leanListFeMale = [
    ["12-19", "19-24", "24-30", "30-35"],
    ["13-20", "21-25", "25-31", "31-36"],
    ["13-21", "21-26", "26-33", "33-36"],
    ["14-22", "22-27", "27-34", "34-37"],
    ["14-23", "23-28", "28-35", "35-38"],
    ["15-24", "24-30", "30-36", "36-38"],
    ["16-26", "26-31", "31-36", "36-39"],
    ["16-27", "27-32", "32-37", "37-40"],
  ];

  String getInterpretation() {
    double _bmi = calculateDoubloeBMI();
    if (_bmi >= 30) {
      return 'Higher than normal body weight. Try to exercise more.';
    } else if (_bmi >= 25.9) {
      return 'Higher than normal body weight. Try to exercise more.';
    } else if (_bmi >= 18.5) {
      return 'Have a normal body weight. Good job!';
    } else {
      return 'Have a lower than normal body weight. You can eat a bit more.';
    }
  }

  String getRestultTitle() {
    if (gender == MALE_Gender) {
      return TITLE_A_MALE;
    } else if (gender == FEMALE_Gender) {
      return TITLE_A_FEMALE;
    } else if (gender == GIRL_Gender) {
      return TITLE_GIRL;
    } else if (gender == BOY_Gender) {
      return TITLE_BOY;
    }
    return "";
  }
}

class LifeStyleModel {
  final String? title;
  final double? value;

  LifeStyleModel({this.title, this.value});
}

List<LifeStyleModel> listLifeStyle = [
  LifeStyleModel(title: "Sedentary (little or no exercise)", value: 1.2),
  LifeStyleModel(
      title: "Lightly active (light exercise/sports 1-3 days/week)",
      value: 1.375),
  LifeStyleModel(
      title: "Moderately active (moderate exercise/sports 3-5 days/week)",
      value: 1.55),
  LifeStyleModel(
      title: "Very active (hard exercise/sports 6-7 days a week)",
      value: 1.725),
  LifeStyleModel(
      title: "Extra active (very hard exercise/sports & a physical job) ",
      value: 1.9)
];
