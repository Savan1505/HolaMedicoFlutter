import 'package:flutter/material.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/theme.dart';

class IcpdProfileWidget extends StatelessWidget {
  final double size, innerBorderWidth, outerBorderWidth;
  late DBProvider dbProvider;
  late Future<ProfileModel?> profileFuture;

  IcpdProfileWidget({
    Key? key,
    this.size: 120,
    this.innerBorderWidth: 6,
    this.outerBorderWidth: 9,
  }) : super(key: key) {
    dbProvider = DBProvider();
    profileFuture = dbProvider.getProfile();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<ProfileModel?>(
        future: profileFuture,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: outerBorderWidth,
                    ),
                  ),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor,
                        width: innerBorderWidth,
                      ),
                    ),
                    child: FutureBuilder<Image>(
                      future: snapshot.data!.getProfileImage(),
                      builder: (context, snap) {
                        if (snap.data != null) {
                          return CircleAvatar(
                            backgroundImage: snap.data!.image,
                            backgroundColor: primaryColor,
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Hello Dr.${snapshot.data!.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff525151),
                  ),
                ),
              ],
            );
          }
          return CircularProgressIndicator(
            color: primaryColor,
          );
        },
      );
}
