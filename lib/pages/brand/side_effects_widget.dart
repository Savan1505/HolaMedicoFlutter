import 'package:flutter/material.dart';
import 'package:pharmaaccess/models/SideEffectsModel.dart';

import '../../theme.dart';

class SideEffectsWidget extends StatelessWidget {
  final List<List<SideEffectsModel>>? sideEffects;

  SideEffectsWidget({Key? key, required this.sideEffects}) : super(key: key);
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          itemCount: sideEffects!.length,
          itemBuilder: (_, int index) {
            return ExpansionItemWidgetForSideEffects(
              sideEffectsList: sideEffects![index],
            );
          }),
    );
  }
}

class ExpansionItemWidgetForSideEffects extends StatefulWidget {
  final List<SideEffectsModel> sideEffectsList;

  ExpansionItemWidgetForSideEffects({Key? key, required this.sideEffectsList})
      : super(key: key);

  @override
  _ExpansionItemWidgetForSideEffectsState createState() =>
      _ExpansionItemWidgetForSideEffectsState();
}

class _ExpansionItemWidgetForSideEffectsState
    extends State<ExpansionItemWidgetForSideEffects> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Color(0x00FFFFF));
    return Container(
      decoration: softCardShadow,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      child: Theme(
        data: theme,
        child: ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fetchData(0, widget.sideEffectsList[0].occurrence!),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                fetchData(1, widget.sideEffectsList[0].occurrence!),
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 0, bottom: 16, right: 16, left: 16),
              child: ListView.builder(
                itemBuilder: (_, index) => Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.01),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text("-"),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(widget.sideEffectsList[index].sideEffect!),
                        flex: 9,
                      ),
                    ],
                  ),
                ),
                itemCount: widget.sideEffectsList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String fetchData(int index, String frequencey) {
  String data = frequencey.replaceAll("\"", "");
  var parts = data.split('(');
  return index == 1 ? "(" + parts[index].trim() : parts[index].trim();
}
