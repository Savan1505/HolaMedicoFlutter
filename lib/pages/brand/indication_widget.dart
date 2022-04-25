import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/brand/indication_model.dart';

import '../../theme.dart';

class IndicationWidget extends StatelessWidget {
  final List<IndicationModel>? indications;
  IndicationWidget({Key? key, required this.indications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
          itemCount: indications!.length,
          itemBuilder: (BuildContext context, int index) {
            var indication = indications![index];
            return DrugInteractionItemWidget(indication: indication);
          }),
    );
  }
}




class DrugInteractionItemWidget extends StatefulWidget {
  final IndicationModel indication;
  DrugInteractionItemWidget({Key? key, required this.indication}) : super(key: key);

  @override
  _DrugInteractionItemWidgetState createState() => _DrugInteractionItemWidgetState();
}

class _DrugInteractionItemWidgetState extends State<DrugInteractionItemWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Color(0x00FFFFF));

    return Container(
      decoration: softCardShadow,
      margin: EdgeInsets.symmetric(vertical: 12,horizontal: 0),
      padding: EdgeInsets.all(8),
      child: Theme(
        data: theme,
        child: ExpansionTile(
          onExpansionChanged: (bool expanding) {
            setState(() {
              expanded = expanding;
            });
          },
          key: PageStorageKey<IndicationModel>(widget.indication),
          title: expanded ? Text("Dosage") : Text(widget.indication.indication!),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 16, right: 16, left: 16),
              child: Text(widget.indication.dosage!),
            ),
          ],
        ),
      ),

    );
  }
}
