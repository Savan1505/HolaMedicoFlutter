import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/brand/specialModel.dart';

import 'drop_down_widget.dart';

class LocationBottomSheet extends BottomSheetMultiSelection<SpecialModel> {
  final List<SpecialModel> originalList;
  final SpecialModel? selectedDisplayList;
  Function onListSelected;

  LocationBottomSheet(
      {Key? key,
      required this.originalList,
      required this.selectedDisplayList,
      required this.onListSelected})
      : super(
            key: key,
            originalList: originalList,
            selectedDisplayList: selectedDisplayList,
            title: "Specialization",
            onListSelected: onListSelected);

  @override
  LocationBottomSheetState createState() => LocationBottomSheetState();
}

class LocationBottomSheetState
    extends BottomSheetMultiSelectionState<SpecialModel> {
  @override
  void initState() {
    super.initState();
    selectedList = widget.selectedDisplayList;
  }

  Widget getWidgetRow(int index) {
    SpecialModel locationData = displayList[index];
    return GestureDetector(
      onTap: () {
        selectedList = locationData;
        displayListController.add(displayList);
        widget.onListSelected(selectedList);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
        child: Text(locationData.name!),
      ),
    );
  }

  @override
  void dispose() {
    displayListController.close();
    super.dispose();
  }

  searchText(String value) {
    super.searchText(value);
    displayList = widget.originalList
        .where((e) => e.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    displayListController.add(displayList);
  }
}
