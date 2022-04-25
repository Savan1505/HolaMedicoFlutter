import 'package:flutter/material.dart';
import 'package:pharmaaccess/pages/cardio_module/orthopaedic_indices/neuropathic_pain/models/neuropatic_pain_model.dart';
import 'package:pharmaaccess/pages/cardio_module/orthopaedic_indices/neuropathic_pain/neuropathic_pain_item_widget.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';

import '../../../../theme.dart';

class NeuropathicPainFormWidget extends StatefulWidget {
  final Function(List<NeuropaticQuestionModel>)? onQuizDoneClick;
  final MyScreenUtil? screenUtil;

  NeuropathicPainFormWidget({
    Key? key,
    this.onQuizDoneClick,
    this.screenUtil,
  }) : super(key: key);

  @override
  _NeuropathicPainFormWidgetState createState() =>
      _NeuropathicPainFormWidgetState();
}

class _NeuropathicPainFormWidgetState extends State<NeuropathicPainFormWidget> {
  List<NeuropaticQuestionModel> list = [
    NeuropaticQuestionModel(
      "Does the pain have one or more of the following characteristics?",
      [
        NeuropaticOptionModel("Burning"),
        NeuropaticOptionModel("Painful cold"),
        NeuropaticOptionModel("Electric shocks"),
      ],
    ),
    NeuropaticQuestionModel(
      "Is the pain associated with one or more of the following symptoms in the same area?",
      [
        NeuropaticOptionModel("Tingling"),
        NeuropaticOptionModel("Pins and needles"),
        NeuropaticOptionModel("Numbness"),
        NeuropaticOptionModel("Itching"),
      ],
    ),
    NeuropaticQuestionModel(
      "Is the pain located in an area where the physical examination may reveal one or more of the following characteristics?",
      [
        NeuropaticOptionModel("Hypoesthesia to touch"),
        NeuropaticOptionModel("Hypoesthesia to prick"),
      ],
    ),
    NeuropaticQuestionModel(
      "In the painful area, can the pain be caused or increased by:",
      [
        NeuropaticOptionModel("Brushing"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  top: widget.screenUtil?.setHeight((index == 0) ? 30 : 0)
                      as double,
                ),
                child: getItem(list[index], index),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: widget.screenUtil?.setWidth(15) as double,
            right: widget.screenUtil?.setWidth(15) as double,
            top: widget.screenUtil?.setHeight(15) as double,
            bottom: widget.screenUtil?.setHeight(15) as double,
          ),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor)),
            onPressed: onClickCalculate,
            child: Padding(
              padding: EdgeInsets.only(
                left: widget.screenUtil?.setWidth(30) as double,
                right: widget.screenUtil?.setWidth(30) as double,
              ),
              child: Text('Calculate'),
            ),
          ),
        ),
      ],
    );
  }

  Widget getItem(NeuropaticQuestionModel model, int index) {
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
            "${index + 1}) ${model.title}",
            style: getTextStylePrimaryTextMediumTitle(widget.screenUtil),
          ),
        ),
        ListView.builder(
          itemCount: model.optionList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => NeuropathicPainItemWidget(
            screenUtil: widget.screenUtil,
            model: model.optionList[index],
            index: index,
          ),
        ),
      ],
    );
  }

  onClickCalculate() {
    widget.onQuizDoneClick!(list);
  }
}
