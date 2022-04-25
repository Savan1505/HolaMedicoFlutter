import 'package:pharmaaccess/pages/brand/side_effects_widget.dart';
import 'package:pharmaaccess/util/SideEffectsList.dart';

class SideEffectsModel {
  String? sideEffect;
  String? occurrence;
  int sequence = 0;

  SideEffectsModel({this.sideEffect, this.occurrence});

  SideEffectsModel.fromJson(Map<String, dynamic> json) {
    sideEffect = json['side_effect'];
    occurrence = json['occurrence'];
    sequence = fetchData(0, occurrence!).sortNumber;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['side_effect'] = this.sideEffect;
    data['occurrence'] = this.occurrence;
    return data;
  }
}
