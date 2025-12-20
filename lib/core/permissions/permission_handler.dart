import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AppPermissionHandler {
  AppPermissionHandler._();

  static Future<bool> requestImageSavePermission() async {
    // 🌐 Web: no permission needed
    if (kIsWeb) {
      return true;
    }

    // 🍎 iOS
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted || status.isLimited;
    }

    // 🤖 Android
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      // Android 13+
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.photos.request();
        return status.isGranted;
      }

      // Android 12 and below
      final status = await Permission.storage.request();
      return status.isGranted;
    }

    return false;
  }
}
