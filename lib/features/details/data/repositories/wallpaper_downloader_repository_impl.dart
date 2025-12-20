import 'package:injectable/injectable.dart';
import 'package:wallpaper_hub/features/details/data/datasources/wallpaper_local_data_source.dart';
import 'package:wallpaper_hub/features/details/domain/repositories/wallpaper_downloader_repository.dart';

@Injectable(as: WallpaperDownloaderRepository)
class WallpaperDownloaderRepositoryImpl
    implements WallpaperDownloaderRepository {
  final WallpaperLocalDataSource _localDataSource;

  WallpaperDownloaderRepositoryImpl(this._localDataSource);

  @override
  Stream<double> downloadWallpaper(String imageUrl) async* {
    await for (final progress
        in _localDataSource.downloadImageWithProgress(imageUrl)) {
      yield progress.percent;
    }
  }
}
