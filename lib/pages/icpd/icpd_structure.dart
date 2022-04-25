import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaaccess/theme.dart';

class IcpdStructure extends StatelessWidget {
  final String title;
  final Widget? firstChild, footer;
  final int firstChildFlex, secondChildFlex;
  final List<Widget>? secondChild;

  const IcpdStructure({
    Key? key,
    required this.title,
    this.firstChild,
    this.secondChild,
    this.footer,
    this.firstChildFlex: 8,
    this.secondChildFlex: 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text(
          title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Column(
          children: [
            Flexible(
                flex: firstChildFlex, child: firstChild ?? SizedBox.shrink()),
            Flexible(
              flex: secondChildFlex,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [if (secondChild != null) ...secondChild!],
              ),
            ),
            Container(
              height: 60,
              child: footer ?? SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class IcpdSpacer extends StatelessWidget {
  const IcpdSpacer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 30,
      );
}
