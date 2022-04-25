import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/icpd_cme_plan_model.dart';
import 'package:pharmaaccess/pages/icpd/cme_catalog.dart';
import 'package:pharmaaccess/widgets/icon_full_button.dart';

class CmeCatalog extends StatelessWidget {
  final int? planTypeIndex;
  final List<PlanList>? planTypeItem;
  final String? countryName;
  final String? titleName;

  const CmeCatalog(
      {Key? key,
      this.planTypeIndex,
      this.titleName,
      this.countryName,
      this.planTypeItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconFullButton(
      label: titleName ?? "CME Catalog",
      iconPath: "assets/icon/catalog_icon.png",
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => CmeCatalogPage(
              titleName: titleName,
              planTypeItem: planTypeItem,
              countryName: countryName,
              planTypeIndex: planTypeIndex,
            ),
          ),
        );
      },
    );
  }
}
