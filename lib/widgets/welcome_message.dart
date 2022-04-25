import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/models/profile_model.dart';

class WelcomeMessageWidget extends StatelessWidget {
  WelcomeMessageWidget({
    Key? key,
  }) : super(key: key);
  final dbProvider = DBProvider();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dbProvider.getProfile(),
        builder: (BuildContext context, AsyncSnapshot<ProfileModel?> snapshot) {
          if (snapshot.hasData) {
            return Container(
              alignment: Alignment.bottomLeft,
              color: const Color(0xffdfeab2),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22.0,22, 22,32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Hola Dr. ${snapshot.data!.name}',style: TextStyle(fontSize: 18,)),
                    Text("Let's connect"),
                    Text("Let's Learn"),
                    Text("Let's evolve!"),
                    Text("This is the promise of Hola Cinfa!"),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
