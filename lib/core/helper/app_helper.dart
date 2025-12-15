import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallpaper_hub/features/home/domain/entities/wallpaper_data.dart';

class AppHelper {
  static final SharePlus _share = SharePlus.instance;

  static Future<void> shareWallpaper({
    required BuildContext context,
    required WallpaperData wallpaper,
  }) async {
    try {
      final RenderBox box =
      context.findRenderObject() as RenderBox;

      final String title =
          'Photo by ${wallpaper.photographer}';
      final String subject = 'WallpaperHub';
      final String text =
          'Check out this amazing wallpaper by '
          '${wallpaper.photographer}\n\n'
          '🔗 Original Photo:\n'
          '${wallpaper.src.original}';

      final ShareParams params = ShareParams(
        title: title,
        subject: subject,
        text: text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
        previewThumbnail: XFile(
          wallpaper.src.portrait,
        ),
      );

      final ShareResult result = await _share.share(params);

      log(
        'Share result: ${result.status}',
        name: 'SharePlus',
      );
    } catch (e, s) {
      log(
        'Share failed',
        error: e,
        stackTrace: s,
        name: 'SharePlus',
      );
    }
  }
}