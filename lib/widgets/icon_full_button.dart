import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmaaccess/theme.dart';

class IconFullButton extends StatelessWidget {
  final String label, iconPath;
  final VoidCallback onPressed;

  IconFullButton({
    Key? key,
    required this.label,
    required this.iconPath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        color: primaryColor,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 13,
          ),
          child: Row(
            children: [
              Image.asset(
                iconPath,
                width: 27,
                height: 27,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .apply(
                          color: Colors.white,
                        )
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
