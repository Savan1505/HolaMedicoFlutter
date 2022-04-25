import 'package:flutter/material.dart';
import 'package:pharmaaccess/pages/cardio_module/orthopaedic_indices/gout_classification/GoutAnswerItemWidget.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/theme.dart';

import 'models/GoutClassificationQuestionModel.dart';

class GoutClassificationItemWidget extends StatefulWidget {
  final int? index;
  final GoutClassificationQuestionModel? questionModel;
  final MyScreenUtil? screenUtil;

  const GoutClassificationItemWidget({
    Key? key,
    this.questionModel,
    this.index,
    this.screenUtil,
  }) : super(key: key);

  @override
  _GoutClassificationItemWidgetState createState() =>
      _GoutClassificationItemWidgetState();
}

class _GoutClassificationItemWidgetState
    extends State<GoutClassificationItemWidget> {
  ScrollController _scrollController = new ScrollController();

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
                  "${widget.questionModel!.title}",
                  style: getTextStylePrimaryTextBigTitle(widget.screenUtil),
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.questionModel!.questionModels.length,
                  itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(
                            top: 0,
                            bottom: widget.screenUtil?.setHeight(15) as double),
                        child: GoutAnswerItemWidget(
                          questionModel:
                              widget.questionModel!.questionModels[index],
                          index: index,
                          screenUtil: widget.screenUtil,
                        ),
                      )),
            ],
          ),
        ),
      );
}
