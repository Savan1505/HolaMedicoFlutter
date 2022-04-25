import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

extension WidgetPadding on Widget {
  Widget doneKeyBoard(FocusNode node, BuildContext context,
          {Function? onPressed, isReadOnly = false}) =>
      isReadOnly
          ? this
          : KeyboardActions(
              autoScroll: false,
              config: KeyboardActionsConfig(
                  keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
                  nextFocus: false,
                  actions: [
                    KeyboardActionsItem(focusNode: node, toolbarButtons: [
                      (node) {
                        return InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (onPressed != null) {
                              onPressed();
                            }
                          },
                          child: getDoneWidget(
                            context,
                          ),
                        );
                      }
                    ]),
                  ]),
              child: this);

  Widget doneKeyBoardTwo(
    List<FocusNode> nodeLists,
    BuildContext context,
  ) =>
      KeyboardActions(
          autoScroll: false,
          config: KeyboardActionsConfig(
              keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
              nextFocus: true,
              actions: nodeLists
                  .map(
                      (e) => KeyboardActionsItem(focusNode: e, toolbarButtons: [
                            (node) {
                              return InkWell(
                                onTap: () => FocusScope.of(context)
                                    .requestFocus(FocusNode()),
                                child: getDoneWidget(context),
                              );
                            }
                          ]))
                  .toList()),
          child: this);
}

Padding getDoneWidget(BuildContext context) => Padding(
      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
      child: Text("Done"),
    );
