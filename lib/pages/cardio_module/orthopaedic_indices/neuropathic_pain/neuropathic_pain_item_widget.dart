import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';
import 'package:pharmaaccess/util/Constants.dart';

import '../../../../theme.dart';
import 'models/neuropatic_pain_model.dart';

class NeuropathicPainItemWidget extends StatefulWidget {
  final MyScreenUtil? screenUtil;
  final NeuropaticOptionModel? model;
  final int? index;

  NeuropathicPainItemWidget({
    Key? key,
    this.screenUtil,
    this.model,
    this.index,
  }) : super(key: key);

  @override
  _NeuropathicPainItemWidgetState createState() =>
      _NeuropathicPainItemWidgetState();
}

class _NeuropathicPainItemWidgetState extends State<NeuropathicPainItemWidget> {
  StreamController<bool> selectionStreamController =
      StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.screenUtil?.setWidth(30) as double,
        right: widget.screenUtil?.setWidth(30) as double,
        bottom: widget.screenUtil?.setHeight(10) as double,
      ),
      child: StreamBuilder<bool>(
          initialData: widget.model!.isSelectedYes,
          stream: selectionStreamController.stream,
          builder: (context, snapshot) {
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "- " + widget.model!.title,
                    style:
                        getTextStylePrimaryTextMediumTitle(widget.screenUtil),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: addRadioButtonUnit(
                      widget.model!.isSelectedYes, TITLE_YES, () {
                    widget.model!.isSelectedYes = true;
                    selectionStreamController.add(true);
                  }, true),
                ),
                Expanded(
                  flex: 1,
                  child: addRadioButtonUnit(
                      !widget.model!.isSelectedYes, TITLE_NO, () {
                    widget.model!.isSelectedYes = false;
                    selectionStreamController.add(false);
                  }, true),
                ),
              ],
            );
          }),
    );
  }

  Widget addRadioButtonUnit(
          bool btnValue, String title, Function onClick, bool groupValue) =>
      GestureDetector(
        onTap: () {
          onClick();
        },
        child: AbsorbPointer(
          child: Padding(
            padding: EdgeInsets.only(
              top: widget.screenUtil?.setHeight(3) as double,
              left: widget.screenUtil?.setWidth(3) as double,
              right: widget.screenUtil?.setWidth(3) as double,
              bottom: widget.screenUtil?.setHeight(3) as double,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: widget.screenUtil?.setWidth(10) as double,
                ),
                SizedBox(
                  width: widget.screenUtil?.setWidth(8) as double,
                  height: widget.screenUtil?.setHeight(8) as double,
                  child: Radio<bool>(
                    activeColor: Theme.of(context).primaryColor,
                    value: btnValue,
                    groupValue: groupValue,
                    onChanged: (dynamic value) {
                      onClick();
                    },
                  ),
                ),
                SizedBox(
                  width: widget.screenUtil?.setWidth(10) as double,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: widget.screenUtil?.setSp(10) as double),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  @override
  void dispose() {
    selectionStreamController.close();
    super.dispose();
  }
}
