
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_hub/core/services/notification_service.dart';
import 'package:wallpaper_hub/features/details/domain/usecases/download_wallpaper_use_case.dart';

part 'download_wallpaper_state.dart';

class DownloadWallpaperCubit extends Cubit<DownloadWallpaperState> {
  final DownloadWallpaperUseCase _useCase;
  final NotificationService _notificationService;

  DownloadWallpaperCubit(this._useCase,this._notificationService)
      : super(DownloadWallpaperInitial());

  Future<void> download(String imageUrl) async {
    try {
      //_notificationService.showInitialDownloadNotification();

      await for (final progress in _useCase.call(imageUrl)) {
        emit(DownloadWallpaperLoading(progress: progress));

        _notificationService.showDownloadNotification((progress * 100).toDouble(), '');
        /*_notificationService.updateDownloadProgress(
          (progress * 100).toInt(),
        );*/
      }

      // _notificationService.showDownloadCompleted();
      emit(DownloadWallpaperSuccess());
    } catch (e) {
      // _notificationService.showDownloadFailed();
      emit(DownloadWallpaperFailure(message: e.toString()));
    }
  }
}
