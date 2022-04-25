import 'package:flutter/material.dart';

class MemoryCellsPage extends StatefulWidget {
  @override
  _MemoryCellsPageState createState() => _MemoryCellsPageState();
}

class _MemoryCellsPageState extends State<MemoryCellsPage> {
  int _crossAxisCount = 4;
  int _itemCount=14;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Time 0", style: Theme.of(context).textTheme.headline3,),
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: _itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount,
              ),
              itemBuilder: (context,index) {
                  return MemoryCell(index+1, (index+1) % 3 == 0);
              },
            ),
          ],
        )
      )
    );
  }
}

class MemoryCell extends StatefulWidget {
  final int index;
  final bool selected;
  const MemoryCell(this.index, this.selected, {
    Key? key,
  }) : super(key: key);

  @override
  _MemoryCellState createState() => _MemoryCellState();
}

class _MemoryCellState extends State<MemoryCell> {
  Color _color = Colors.deepOrange.withOpacity(0.3);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      color: _color,
      child: OutlineButton (
        color: Colors.red,
        onPressed: () {
          Color _newColor;
          if (widget.selected == true) {
            _newColor = Colors.green;
          } else {
            _newColor = Colors.blue;
          }
          setState(() {
            _color = _newColor;
          });
        },
      ),
    );
  }
}
