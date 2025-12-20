part of 'download_wallpaper_cubit.dart';

abstract class DownloadWallpaperState {}

class DownloadWallpaperInitial extends DownloadWallpaperState {}

class DownloadWallpaperLoading extends DownloadWallpaperState {
  final double progress;

  DownloadWallpaperLoading({required this.progress});
}

class DownloadWallpaperSuccess extends DownloadWallpaperState {}

class DownloadWallpaperFailure extends DownloadWallpaperState {
  final String? message;

  DownloadWallpaperFailure({this.message});
}
