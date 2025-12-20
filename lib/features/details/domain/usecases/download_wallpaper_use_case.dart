import 'package:injectable/injectable.dart';
import 'package:wallpaper_hub/features/details/domain/repositories/wallpaper_downloader_repository.dart';

@injectable
class DownloadWallpaperUseCase {
  final WallpaperDownloaderRepository _repository;

  DownloadWallpaperUseCase(this._repository);

  /// Returns a stream of download progress (0.0 to 1.0)
  Stream<double> call(String imageUrl) {
    return _repository.downloadWallpaper(imageUrl);
  }
}

