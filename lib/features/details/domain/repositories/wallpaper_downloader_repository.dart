import 'package:cached_network_image/cached_network_image.dart';

abstract class WallpaperDownloaderRepository {
  Stream<double> downloadWallpaper(String imageUrl);
}


