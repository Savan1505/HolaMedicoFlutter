import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/theme.dart';

import 'models/GoutClassificationQuestionModel.dart';

class GoutAnswerItemWidget extends StatefulWidget {
  final int? index;
  final QuestionModel? questionModel;
  final MyScreenUtil? screenUtil;

  const GoutAnswerItemWidget({
    Key? key,
    this.questionModel,
    this.index,
    this.screenUtil,
  }) : super(key: key);

  @override
  _GoutAnswerItemWidgetState createState() => _GoutAnswerItemWidgetState();
}

class _GoutAnswerItemWidgetState extends State<GoutAnswerItemWidget> {
  StreamController<String?> answerStreamController =
      StreamController<String?>.broadcast();

  @override
  void initState() {
    super.initState();

    if (widget.questionModel!.selectedIndex > -1) {
      selectedAnswer = widget.questionModel!
          .answerModels[widget.questionModel!.selectedIndex].answerTitle;
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: widget.screenUtil?.setWidth(15) as double,
              right: widget.screenUtil?.setWidth(15) as double,
              top: widget.screenUtil?.setHeight(0) as double,
              bottom: widget.screenUtil?.setHeight(5) as double,
            ),
            child: Text(
              "${widget.index! + 1}) ${widget.questionModel!.question}",
              style: getTextStylePrimaryTextMediumTitle(widget.screenUtil),
            ),
          ),
          if (widget.questionModel!.desc.isNotEmpty) ...[
            SizedBox(
              height: widget.screenUtil?.setHeight(3) as double,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: widget.screenUtil?.setWidth(15) as double,
                right: widget.screenUtil?.setWidth(15) as double,
                bottom: widget.screenUtil?.setHeight(5) as double,
              ),
              child: Text(
                widget.questionModel!.desc,
                style: getTextStylePrimaryTextSmall(widget.screenUtil),
              ),
            ),
          ],
          StreamBuilder<String?>(
            initialData: selectedAnswer,
            stream: answerStreamController.stream,
            builder: (_, snapshot) => ListView.builder(
              itemBuilder: (_, index) => Padding(
                padding: EdgeInsets.only(
                  top: (index == 0)
                      ? 0
                      : widget.screenUtil?.setWidth(5) as double,
                ),
                child: addRadioButton(
                    index, widget.questionModel!.answerModels[index]),
              ),
              itemCount: widget.questionModel!.answerModels.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      );

  String? selectedAnswer = "";

  Widget addRadioButton(int index, AnswerModel answerModel) =>
      StreamBuilder<String?>(
        initialData: selectedAnswer,
        stream: answerStreamController.stream,
        builder: (_, snapshot) {
          return Container(
            margin: EdgeInsets.only(
              left: widget.screenUtil?.setWidth(15) as double,
              right: widget.screenUtil?.setWidth(15) as double,
            ),
            child: InkWell(
              onTap: () {
                widget.questionModel?.selectedIndex = index;
                ansSelected(answerModel);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 6,
                ),
                decoration: softCardShadow.copyWith(color: Color(0xFFF5F5F5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Text(answerModel.answerTitle,
                            style: styleSmallBodyText)),
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 16,
                          width: 16,
                          color: answerModel.answerTitle == selectedAnswer
                              ? primaryColor
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );

  void ansSelected(AnswerModel answerModel) {
    selectedAnswer = answerModel.answerTitle;
    answerStreamController.add(answerModel.answerTitle);
  }
}
