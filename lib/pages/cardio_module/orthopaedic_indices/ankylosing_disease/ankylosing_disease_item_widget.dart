import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';

import '../../../../theme.dart';
import 'models/ankylosing_disease_model.dart';

class AnkylosingDiseaseItemWidget extends StatefulWidget {
  final MyScreenUtil? screenUtil;
  final AnkylosingDiseaseQuestionModel? model;
  final int? index;

  AnkylosingDiseaseItemWidget({
    Key? key,
    this.screenUtil,
    this.model,
    this.index,
  }) : super(key: key);

  @override
  _AnkylosingDiseaseItemWidgetState createState() =>
      _AnkylosingDiseaseItemWidgetState();
}

class _AnkylosingDiseaseItemWidgetState
    extends State<AnkylosingDiseaseItemWidget> {
  final List<AnkylosingDiseaseModel> list = [
    AnkylosingDiseaseModel("0: least severe", "0", 0),
    AnkylosingDiseaseModel("1", "+1", 1),
    AnkylosingDiseaseModel("2", "+2", 2),
    AnkylosingDiseaseModel("3", "+3", 3),
    AnkylosingDiseaseModel("4", "+4", 4),
    AnkylosingDiseaseModel("5", "+5", 5),
    AnkylosingDiseaseModel("6", "+6", 6),
    AnkylosingDiseaseModel("7", "+7", 7),
    AnkylosingDiseaseModel("8", "+8", 8),
    AnkylosingDiseaseModel("9", "+9", 9),
    AnkylosingDiseaseModel("10: most severe", "+10", 10),
  ];

  StreamController<AnkylosingDiseaseModel?> modelStreamController =
      StreamController<AnkylosingDiseaseModel?>.broadcast();

  AnkylosingDiseaseModel? currentDropDownModel;

  @override
  void initState() {
    super.initState();
    currentDropDownModel = list[widget.model!.selectedDiseaseIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: widget.screenUtil?.setWidth(30) as double,
            right: widget.screenUtil?.setWidth(30) as double,
            bottom: widget.screenUtil?.setHeight(10) as double,
          ),
          child: Text(
            "${widget.index! + 1}) ${widget.model!.title}",
            style: styleBoldSmallBodyText,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: widget.screenUtil?.setWidth(30) as double,
            right: widget.screenUtil?.setWidth(30) as double,
            bottom: widget.screenUtil?.setHeight(10) as double,
          ),
          child: Text(
            widget.model!.desc,
            style: getTextStylePrimaryTextSmall(widget.screenUtil),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: widget.screenUtil?.setWidth(30) as double,
            right: widget.screenUtil?.setWidth(30) as double,
            bottom: widget.screenUtil?.setHeight(10) as double,
          ),
          child: StreamBuilder<AnkylosingDiseaseModel?>(
              stream: modelStreamController.stream,
              initialData: currentDropDownModel,
              builder: (context, snapshot) {
                return Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(
                        widget.screenUtil?.setHeight(15) as double),
                  ),
                  child: DropdownButton<AnkylosingDiseaseModel?>(
                    isExpanded: true,
                    isDense: false,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    underline: Container(),
                    dropdownColor: primaryColor,
                    value: snapshot.data,
                    items: list.map(
                      (val) {
                        return DropdownMenuItem<AnkylosingDiseaseModel?>(
                          value: val,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: widget.screenUtil?.setWidth(10) as double,
                              right: widget.screenUtil?.setWidth(10) as double,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    val.name,
                                    style: getTextStylePrimaryTextSmallWhite(
                                        widget.screenUtil),
                                  ),
                                ),
                                Text(
                                  val.point,
                                  style: getTextStylePrimaryTextSmallWhite(
                                      widget.screenUtil),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (val) {
                      widget.model!.selectedDiseaseIndex = val!.score;
                      currentDropDownModel = val;
                      modelStreamController.add(currentDropDownModel);
                    },
                  ),
                );
              }),
        )
      ],
    );
  }

  @override
  void dispose() {
    modelStreamController.close();
    super.dispose();
  }
}
