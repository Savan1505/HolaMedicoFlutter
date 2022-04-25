import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/pages/cardio_module/cardio_vascular_indices/CardioVascularBrain.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';

import '../../../theme.dart';

class OptionWidgetCardioVascular extends StatefulWidget {
  final bool isVertical;
  final CardioVascularModel? model;
  final Function? onClick;
  final MyScreenUtil? screenUtil;

  const OptionWidgetCardioVascular(
      {Key? key,
      this.model,
      this.onClick,
      this.isVertical = false,
      this.screenUtil})
      : super(key: key);

  @override
  _OptionWidgetCardioVascuaState createState() =>
      _OptionWidgetCardioVascuaState();
}

class _OptionWidgetCardioVascuaState extends State<OptionWidgetCardioVascular> {
  StreamController<CardioVascularOptions?> selectedAnsStreamController =
      StreamController<CardioVascularOptions?>.broadcast();

  MyScreenUtil? screenUtil;

  @override
  void initState() {
    super.initState();
    screenUtil = widget.screenUtil;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.all((screenUtil == null) ? 10 : screenUtil!.setHeight(10) as double),
      padding: EdgeInsets.only(
        bottom: (screenUtil == null) ? 15 : screenUtil!.setHeight(15) as double,
        left: (screenUtil == null) ? 7 : screenUtil!.setWidth(7) as double,
        top: (screenUtil == null) ? 15 : screenUtil!.setHeight(15) as double,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            (screenUtil == null) ? 10 : screenUtil!.setHeight(10) as double),
        border: Border.all(color: Colors.grey[200]!),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '${widget.model!.title} : ',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: (screenUtil == null) ? 15 : screenUtil!.setSp(10) as double?),
        ),
        SizedBox(
          height: (screenUtil == null) ? 5 : screenUtil!.setHeight(5) as double?,
        ),
        StreamBuilder<CardioVascularOptions?>(
            stream: selectedAnsStreamController.stream,
            builder: (_, snapshot) {
              if (widget.isVertical) {
                return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: widget.model!.listOptions!
                        .map(
                          (e) => Row(
                            children: [
                              Expanded(
                                child: lifetStyleRadioButton(e, () {
                                  selectedModel = e;
                                  selectedAnsStreamController
                                      .add(selectedModel);
                                  widget.onClick!(selectedModel);
                                }),
                              ),
                            ],
                          ),
                        )
                        .toList());
              }
              return Row(
                  children: widget.model!.listOptions!
                      .map(
                        (e) => Expanded(
                          child: lifetStyleRadioButton(e, () {
                            selectedModel = e;
                            selectedAnsStreamController.add(selectedModel);
                            widget.onClick!(selectedModel);
                          }),
                        ),
                      )
                      .toList());
            }),
      ]),
    );
  }

  CardioVascularOptions? selectedModel;

  Widget lifetStyleRadioButton(CardioVascularOptions model, Function onClick) {
    bool isSelected =
        selectedModel != null && selectedModel!.index == model.index;
    // print(
    //     'maintitle : ${widget.model.title} title : ${selectedModel.title} index : ${selectedModel.index}');
    return Padding(
      padding:
          EdgeInsets.all((screenUtil == null) ? 10 : screenUtil!.setHeight(10) as double),
      child: GestureDetector(
        onTap: () {
          onClick();
        },
        child: Column(
          children: [
            InkWell(
              onTap: () {
                onClick();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical:
                      (screenUtil == null) ? 10 : screenUtil!.setHeight(10) as double,
                  horizontal: (screenUtil == null) ? 6 : screenUtil!.setWidth(6) as double,
                ),
                decoration: softCardShadow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right: (screenUtil == null)
                              ? 8
                              : screenUtil!.setWidth(8) as double),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: (screenUtil == null)
                              ? 14
                              : screenUtil!.setHeight(14) as double?,
                          width: (screenUtil == null)
                              ? 14
                              : screenUtil!.setWidth(14) as double?,
                          color: isSelected
                              ? primaryColor
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(model.title!.toUpperCase(),
                          style: getTextStylePrimaryTextMedium(screenUtil)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
