import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

Future<String> saveScreenShot(GlobalKey globalKey, String title) async {
  String fileName = title.replaceAll(" ", "_").replaceAll("/", "_") +
      DateTime.now().millisecond.toString() +
      '.png';

  RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(pixelRatio: 3);
  ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
  Uint8List pngBytes = byteData.buffer.asUint8List();

  String filePath = "";
  if (Platform.isAndroid) {
    var directory = (await getExternalStorageDirectory())!;
    filePath = '${directory.path}/$fileName';
    var file = File(filePath);
    await file.writeAsBytes(pngBytes);
  } else {
    var directory = await getApplicationDocumentsDirectory();
    filePath = '${directory.path}/$fileName';
    var file = File(filePath);
    if (!await file.exists()) file.create();
    await file.writeAsBytes(pngBytes);
  }

  return filePath;
}
