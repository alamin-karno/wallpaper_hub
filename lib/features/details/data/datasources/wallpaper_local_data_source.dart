import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:wallpaper_hub/core/permissions/permission_handler.dart';
import 'package:wallpaper_hub/features/details/data/models/download_progress.dart';

@singleton
class WallpaperLocalDataSource {
  final Dio dio;

  WallpaperLocalDataSource(@Named("Download") this.dio);

  Stream<DownloadProgress> downloadImageWithProgress(String imageUrl) async* {
    final hasPermission =
        await AppPermissionHandler.requestImageSavePermission();

    if (!hasPermission) {
      throw Exception('Permission denied');
    }

    final List<int> bytes = [];

    await dio.get(
      imageUrl,
      options: Options(responseType: ResponseType.stream),
      onReceiveProgress: (received, total) async* {
        yield DownloadProgress(received, total);
      },
    ).then((response) async {
      final stream = response.data.stream;
      await for (final chunk in stream) {
        bytes.addAll(chunk);
      }

      await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(bytes),
      );
    });
  }
}
