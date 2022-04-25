import 'package:flutter/material.dart';
import 'package:pharmaaccess/widgets/bottombar/button.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Punam'),
            accountEmail: Text('punam@pharmaaccess.com',),
            currentAccountPicture: CircleAvatar(
              child: Text("P", style: TextStyle(fontSize: 40)),
            ),
          ),
          Column(
            children: drawerItems.map((BarButton menuItem) {
                  return ListTile(
                    title: Text(menuItem.label!),
                    leading: Icon(menuItem.icon),
                    onTap: () {},
                  );
              }).toList(),
          ),
        ],
      )
    );
  }
}
