import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmaaccess/pages/brand/pharma_covigilance_page.dart';
import 'package:pharmaaccess/pages/contact/contact_us_page.dart';
import 'package:pharmaaccess/pages/sample_request/sample_request_page.dart';

class CommonOverFlowMenu extends StatefulWidget {
  @override
  _CommonOverFlowMenuState createState() => _CommonOverFlowMenuState();
}

class _CommonOverFlowMenuState extends State<CommonOverFlowMenu> {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          // PopupMenuItem(
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (_) => NotificationPage(),
          //         ),
          //       );
          //     },
          //     child: Icon(
          //       Icons.notifications,
          //       size: 20,
          //     ),
          //   ),
          // ),
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert_outlined),
            onSelected: (index) async {

              print(index);
              switch (index) {
                case 0:
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return ContactPage();
                      },
                    ),
                  );
                  break;
                case 1:
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PharmaCovigilancePage(
                          // products: widget.brand.products,
                          ),
                    ),
                  );
                  break;
                case 2:
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SampleRequestPage(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: getOption(
                    iconWidget: SvgPicture.asset(
                      "assets/images/contact_us.svg",
                      color: Colors.black,
                      width: 16,
                      height: 16,
                    ),
                    title: "FeedBack",
                    index: 0),
              ),
              PopupMenuItem(
                child: getOption(
                    iconWidget: SvgPicture.asset(
                      "assets/images/contact_us.svg",
                      color: Colors.black,
                      width: 16,
                      height: 16,
                    ),
                    title: "Pharmacovigilance",
                    index: 1),
              ),
              PopupMenuItem(
                child: getOption(
                    iconWidget: SvgPicture.asset(
                      "assets/images/contact_us.svg",
                      color: Colors.black,
                      width: 16,
                      height: 16,
                    ),
                    title: "Sample Request",
                    index: 2),
              ),
            ],
          ),
          // PopupMenuButton(
          //   icon: Icon(Icons.more_vert, color: Colors.white), // add this line
          //   itemBuilder: (_) => <PopupMenuItem<String>>[
          // getOption(
          //     iconWidget: SvgPicture.asset(
          //       "assets/images/contact_us.svg",
          //       color: Colors.black,
          //       width: 16,
          //       height: 16,
          //     ),
          //     title: "Survey",
          //     onClick: () {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(
          //           builder: (_) {
          //             return ContactPage();
          //           },
          //         ),
          //       );
          //     }),
          // ],
          // ),
        ],
      );

  PopupMenuItem<int> getOption(
          {required String title, Widget? iconWidget, required int? index}) =>
      PopupMenuItem<int>(
          child: Row(
            children: [
              if (iconWidget != null) ...[
                iconWidget,
                SizedBox(
                  width: 5,
                ),
              ],
              Text(title)
            ],
          ),
          value: index);
}
