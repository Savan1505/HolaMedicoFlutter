import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/brand/drug_interaction_model.dart';

import '../../theme.dart';

class DrugInteractionWidget extends StatelessWidget {
  final List<DrugInteractionModel>? drugInteractions;
  DrugInteractionWidget({Key? key, required this.drugInteractions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        itemCount: drugInteractions!.length,
        itemBuilder: (BuildContext context, int index) {
          var drugInteraction = drugInteractions![index];
          return DrugInteractionItemWidget(drugInteraction: drugInteraction);
        }),
    );
  }
}


class DrugInteractionItemWidget extends StatelessWidget {
  final DrugInteractionModel drugInteraction;
  DrugInteractionItemWidget({Key? key, required this.drugInteraction}) : super(key: key);

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
          key: PageStorageKey<DrugInteractionModel>(drugInteraction),
          title: Text(drugInteraction.molecule!),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 16, right: 16, left: 16),
              child: Text(drugInteraction.description!),
            ),
          ],
        ),
      ),

    );
  }
}
