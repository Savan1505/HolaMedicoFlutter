import 'package:flutter/material.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/components/hexa_container.dart';
import 'package:pharmaaccess/models/profile_model.dart';

class WelcomeProfileWidget extends StatelessWidget {
  final dbProvider = DBProvider();

  WelcomeProfileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dbProvider.getProfile(),
      builder: (BuildContext context, AsyncSnapshot<ProfileModel?> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 120,
            color: const Color(0xffdfeab2),
            child: Row(
              children: <Widget>[
                Container(
                  width: 160,
                  child: HexagonContainer(
                    borderWidth: 16,
                    borderColor: Colors.green,
                    childWidget: Image.asset('assets/images/ahmed_hassan.jpeg'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Hola',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Kalam',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        ' ${snapshot.data!.name}!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
