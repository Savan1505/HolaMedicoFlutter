import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../theme.dart';

class FormFieldWidget extends StatelessWidget {
  final Widget? suffixIcon;
  final String? hintText;
  final bool _obscureText;
  final TextEditingController? controller;
  final TextInputType textInputType;
  final int lines;
  final int maxLines;
  FocusNode? focusNode;
  final List<TextInputFormatter>? formatters;

  FormFieldWidget({
    this.hintText,
    this.suffixIcon,
    this.controller,
    bool? obscureText,
    this.formatters,
    this.maxLines = 1,
    this.focusNode,
    this.lines = 1,
    this.textInputType: TextInputType.name,
    bool? readonly,
  }) : _obscureText = obscureText != null ? obscureText : false;

  // FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: textInputType == TextInputType.number
          ? TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: _obscureText,
              keyboardType: textInputType,
              cursorColor: Colors.amber,
              minLines: lines,
              maxLines: maxLines,
              inputFormatters: formatters,
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                hintText: hintText,
                alignLabelWithHint: true,
                hintStyle: TextStyle(
                  color: Colors.grey[300],
                ),
                labelText: hintText,
                labelStyle: TextStyle(
                  color: Colors.grey[300],
                ),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
              ),
            )
          : TextField(
              controller: controller,
              obscureText: _obscureText,
              keyboardType: textInputType,
              cursorColor: Colors.amber,
              minLines: lines,
              maxLines: maxLines,
              inputFormatters: formatters,
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                hintText: hintText,
                alignLabelWithHint: true,
                hintStyle: TextStyle(
                  color: Colors.grey[300],
                ),
                labelText: hintText,
                labelStyle: TextStyle(
                  color: Colors.grey[300],
                ),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: focusedBorder,
              ),
            ),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField(
      {this.controller,
      // this.focusNode,
      this.hintText,
      this.searchBar,
      this.list});

  final TextEditingController? controller;

  // final FocusNode focusNode;
  final String? hintText;
  final Widget? searchBar;
  final Widget? list;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child:
            searchBar /* Column(
          children: [searchBar, list],
        ) */
        );
  }
}
