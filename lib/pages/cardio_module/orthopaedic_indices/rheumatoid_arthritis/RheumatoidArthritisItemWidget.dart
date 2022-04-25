import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/pages/cardio_module/orthopaedic_indices/rheumatoid_arthritis/models/RheumatoidArthritisQuestionModel.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/theme.dart';

import 'rheumatoid_arthritis_form_widget.dart';

class RheumatoidArthritisItemWidget extends StatefulWidget {
  final Function? onItemSelected;
  final int? index;
  final RheumatoidArthritisQuestionModel? questionModel;
  final MyScreenUtil? screenUtil;

  const RheumatoidArthritisItemWidget(
      {Key? key,
      this.onItemSelected,
      this.questionModel,
      this.index,
      this.screenUtil})
      : super(key: key);

  @override
  _RheumatoidArthritisItemWidgetState createState() =>
      _RheumatoidArthritisItemWidgetState();
}

class _RheumatoidArthritisItemWidgetState
    extends State<RheumatoidArthritisItemWidget> {
  ScrollController _scrollController = new ScrollController();
  StreamController<String?> answerStreamController =
      StreamController<String?>.broadcast();

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(widget.screenUtil?.setHeight(15) as double),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: widget.screenUtil?.setWidth(15) as double,
                  right: widget.screenUtil?.setWidth(15) as double,
                  top: widget.screenUtil?.setHeight(15) as double,
                  bottom: widget.screenUtil?.setHeight(10) as double,
                ),
                child: Text(
                  "${widget.index! + 1}) ${widget.questionModel!.question}",
                  style: styleBoldSmallBodyText,
                ),
              ),
              if (widget.questionModel!.desc.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.screenUtil?.setWidth(15) as double,
                    right: widget.screenUtil?.setWidth(15) as double,
                    bottom: widget.screenUtil?.setHeight(10) as double,
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
                        widget.questionModel!.listAns[index].answerTitle,
                        widget.questionModel!.listAns[index]),
                  ),
                  itemCount: widget.questionModel!.listAns.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              )
            ],
          ),
        ),
      );

  String? selectedAnswer = "";

  Widget addRadioButton(String? title, AnswerModel answerModel) =>
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
                ansSelected(title, answerModel);
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
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: title, style: styleSmallBodyText),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 16,
                          width: 16,
                          color: title == selectedAnswer
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

  void ansSelected(String? title, AnswerModel answerModel) {
    selectedAnswer = title;
    answerStreamController.add(title);
    widget.onItemSelected!(
        AnswerModels(ansId: widget.index, point: answerModel.points));
  }
}
