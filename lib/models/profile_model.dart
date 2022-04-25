import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

class ProfileModel {
  ProfileModel(
      this.name,
      this.email,
      this.token,
      this.id,
      this.title,
      this.phone,
      this.hospital,
      this.specialization,
      this.profilePicture,
      this.uid,
      this.image,
      this.countryCode,
      this.countryName,
      this.partnerId);

  int id = 0;
  String title = "";
  String name = "";
  String email = "";
  String phone = "";
  String token = "", image = "";
  String specialization = "";
  String hospital = "";
  String profilePicture = 'assets/images/profile_placeholder.png';
  String countryCode = "";
  String countryName = "";
  int uid = 0;
  int partnerId = 0;
  String oldPassword = "";

  Future<Image> getProfileImage() async {
    if (this.profilePicture.isEmpty ||
        this.profilePicture.startsWith('assets/images/')) {
      return Image.asset('assets/images/profile_placeholder.png');
    }
    return Image.memory(base64Decode(this.profilePicture));
  }

  ProfileModel.fromMap(Map<String, dynamic> map, this.image)
      : id = map.containsKey('id') ? (map['id'] ?? 0) : 0,
        title = map.containsKey('title') ? (map['title'] ?? "") : "",
        name = map.containsKey('name') ? (map['name'] ?? "") : "",
        email = map.containsKey('email') ? (map['email'] ?? "") : "",
        phone = map.containsKey('phone') ? (map['phone'] ?? "") : "",
        specialization = map.containsKey('specialization')
            ? (map['specialization'] == null ? "" : map['specialization'])
            : "",
        token = map.containsKey('token') ? (map['token'] ?? "") : "",
        hospital = map.containsKey('hospital') ? (map['hospital'] ?? "") : "",
        countryCode =
            map.containsKey('countryCode') ? (map['countryCode'] ?? "") : "",
        countryName =
            map.containsKey('countryName') ? (map['countryName'] ?? "") : "",
        profilePicture = map.containsKey('profilePictureUrl')
            ? (map['profilePictureUrl'] ?? "")
            : 'assets/images/profile_placeholder.png',
        uid = map.containsKey('uid') ? (map['uid'] ?? "") : "",
        partnerId = map.containsKey('partnerId') ? (map['partnerId'] ?? 0) : 0;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "title": title,
      "hospital": hospital,
      "name": name,
      "email": email,
      "phone": phone,
      "specialization": specialization,
      "token": token,
      "countryCode": countryCode,
      "countryName": countryName,
      "profilePictureUrl": profilePicture == null
          ? 'assets/images/profile_placeholder.png'
          : profilePicture,
      "uid": uid,
      "partnerId": partnerId,
    };
  }
}
