import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/brand/product_insurance_model.dart';

import '../../theme.dart';

class InsuranceCompanyListWidget extends StatefulWidget {
  final List<ProductInsuranceModel>? insuranceList;

  InsuranceCompanyListWidget({Key? key, this.insuranceList}) : super(key: key);
  @override
  _InsuranceCompanyListWidgetState createState() => _InsuranceCompanyListWidgetState();

}


class _InsuranceCompanyListWidgetState extends State<InsuranceCompanyListWidget> {
  TextEditingController searchController = TextEditingController();
  List<ProductInsuranceModel>? availableList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availableList = widget.insuranceList;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      dividerColor: Color(0x00FFFFF),
      primaryColor: bodyTextColor,
      accentColor: bodyTextColor,
    );

    return Scaffold(
      appBar: AppBar(
        title:  Text("Select Insurance Company"),
        backgroundColor: primaryColor,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                onChanged: (value) {
                  if (value.length == 0) {
                    setState(() {
                      availableList = widget.insuranceList;
                    });
                  }
                  else if (value.length > 1) {
                    var currentList = widget.insuranceList!.where((p) => p.insuranceCompanyName!.toLowerCase().contains(value.toLowerCase())).toList();
                    setState(() {
                      availableList = currentList;
                    });
                  }
                },
                controller: searchController,
                cursorColor: Colors.amber,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  hintText: "Search insurance company",
                  hintStyle: TextStyle(
                    color: Colors.grey[300],
                  ),
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: focusedBorder,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableList!.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: softCardShadow,
                    margin: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                    child: Theme(
                      data: theme,
                      child: ExpansionTile(
                        title: Text('${availableList![index].insuranceCompanyName}'),
                        children: availableList![index].packages!.map<Widget>(
                          (package)=> InsurancePackageWidget(package: package,),
                        ).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}


class InsurancePackageWidget extends StatelessWidget {
  final Map<String,dynamic>? package;

  InsurancePackageWidget({Key? key, this.package}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(package!['package_name']),
          Text(package!['status'], style: TextStyle(color: primaryColor))
        ],
      )
    );
  }
}
