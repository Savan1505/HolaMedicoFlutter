import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/brand/product_insurance_model.dart';
import 'package:pharmaaccess/models/brand/product_model.dart';
import 'package:pharmaaccess/pages/brand/insurance_company_list_widget.dart';
import 'package:pharmaaccess/pages/brand/request_sample_dialog_widget.dart';

import '../../theme.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6),
      decoration: tileShadow,
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Expanded(
              child: FadeInImage.assetNetwork(
            image: product.thumbnailUrl!,
            placeholder: "assets/images/cinfa_hexagon_small.png",
            imageErrorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset("assets/images/cinfa_hexagon_small.png");
            },
            placeholderErrorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset("assets/images/cinfa_hexagon_small.png");
            },
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(product.price!,
                    style: TextStyle(color: primaryColor, fontSize: 12)),
              ),
              Text(product.name!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              var insuranceCompanies = productInsuranceList
                                  .where((p) => p.productId == product.id)
                                  .toList();
                              return InsuranceCompanyListWidget(
                                insuranceList:
                                    product.insurances, //insuranceCompanies,
                              );
                            },
                          ),
                        );
                      },
                      padding: EdgeInsets.all(6),
                      child: Text(
                        "Insurance",
                        style: TextStyle(
                            fontSize: 14,
                            color: bodyTextColor), //Color(0xFFC2BDBD)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (_) => RequestSampleDialog(
                            product: product,
                          ),
                        );
                      },
                      padding: EdgeInsets.all(6),
                      child: Text(
                        "Samples",
                        style: TextStyle(fontSize: 14, color: bodyTextColor),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
