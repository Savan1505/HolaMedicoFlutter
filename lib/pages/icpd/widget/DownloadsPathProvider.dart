import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class DownloadsPathProvider {
  static const MethodChannel _channel =
      const MethodChannel('downloads_path_provider');

  static Future<Directory> get downloadsDirectory async {
    final String path = await _channel.invokeMethod('getDownloadsDirectory');
    if (path.isNotEmpty) {
      return Directory(path);
    }
    return Directory("");
  }
}
