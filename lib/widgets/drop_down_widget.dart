import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/brand/specialModel.dart';

abstract class BottomSheetMultiSelection<T> extends StatefulWidget {
  String title;
  final List<T> originalList;
  final SpecialModel? selectedDisplayList;
  Function onListSelected;

  BottomSheetMultiSelection(
      {Key? key,
      required this.originalList,
      required this.selectedDisplayList,
      required this.title,
      required this.onListSelected})
      : super(key: key);

  // const BottomSheetMultiSelection({Key? key}) : super(key: key);
  @override
  BottomSheetMultiSelectionState createState() =>
      BottomSheetMultiSelectionState<T>();
}

class BottomSheetMultiSelectionState<T>
    extends State<BottomSheetMultiSelection<T>> {
  SpecialModel? selectedList;
  List<T> displayList = [];
  StreamController<List<T>> displayListController =
      StreamController<List<T>>.broadcast();
  StreamController<bool> isApplyAllEmabledController =
      StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void didUpdateWidget(covariant BottomSheetMultiSelection<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    initData();
  }

  void initData() {
    displayList = widget.originalList;
    selectedList = widget.selectedDisplayList;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 15, right: 25, top: 10, bottom: 10),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  Spacer(),
                  InkWell(
                    child: Icon(Icons.close),
                    onTap: () {
                      closeScreen();
                    },
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 40,
              padding: EdgeInsets.only(
                left: 15,
                right: 30,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  hintText: "Search",
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  searchText(value);
                },
              ),
            ),
            Container(
              height: 300,
              child: StreamBuilder<List<T>>(
                  initialData: displayList,
                  stream: displayListController.stream,
                  builder: (context, snapshot) {
                    // isApplyAllEmabledController.add(selectedList.isNotEmpty);
                    return ListView.builder(
                      itemBuilder: (_, index) {
                        return getWidgetRow(index);
                      },
                      itemCount: snapshot.data!.length,
                    );
                  }),
            ),
          ],
        ),
      );

  void closeScreen() {
    Navigator.of(context).pop();
  }

  Widget getWidgetRow(int index) {
    return Text("");
  }

  void searchText(String value) {}

  void clearAll() {
    // selectedList.clear();
    displayListController.add(displayList);
    widget.onListSelected(selectedList);
  }

  void applyAll() {
    widget.onListSelected(selectedList);
    closeScreen();
  }

  @override
  void dispose() {
    displayListController.close();
    isApplyAllEmabledController.close();
    super.dispose();
  }
}
