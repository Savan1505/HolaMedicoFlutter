import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmaaccess/screen_utils/MyScreenUtil.dart';

import '../theme.dart';
import 'ConfirmationDialog.dart';

class PermissionUtil {
  static Future<bool> getStoragePermission({
    BuildContext? context,
    MyScreenUtil? screenUtil,
  }) async {
    PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      if (Platform.isAndroid) {
        if (status == PermissionStatus.permanentlyDenied ||
            status.isRestricted) {
          customDialog(
            context: context!,
            screenUtil: screenUtil,
          );
          return false;
        } else {
          return false;
        }
      } else if (Platform.isIOS) {
        if (status == PermissionStatus.denied ||
            status == PermissionStatus.restricted ||
            status == PermissionStatus.permanentlyDenied) {
          customDialog(
            context: context!,
            screenUtil: screenUtil,
          );
          return false;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  static Future<PermissionStatus> askNotificationPermission() async =>
      await Permission.notification.request();

  static Future<bool> getPermissionStatus(Permission permission) async {
    PermissionStatus status = await permission.status;
    return status == PermissionStatus.granted;
  }

  static customDialog({
    required BuildContext context,
    MyScreenUtil? screenUtil,
  }) {
    return ConfirmationDialog.dialog(
      context,
      title: "Permission required",
      option1: "Go to Settings",
      option2: "Cancel",
      content: "Please provide file access permission from settings",
      screenUtil: screenUtil,
      horizontalPadding: 5.0,
      mainAxisSize: MainAxisSize.max,
      textScaleFactor: 1.0,
      primaryColor: primaryColor,
      buttonTextColor: Colors.white,
    ).then((value) async {
      if (value.compareTo(ConfirmationDialog.returnSelectedOption!) == 0) {
        await openAppSettings();
      }
    });
  }
}
