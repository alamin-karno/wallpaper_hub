import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_hub/core/services/notification_service.dart';
import 'package:wallpaper_hub/features/details/presentation/cubit/download_wallpaper_cubit.dart';
import 'package:wallpaper_hub/features/home/domain/entities/src_data.dart';
import 'package:wallpaper_hub/features/home/domain/entities/wallpaper_data.dart';

import '../../../../core/shared/shared.dart';

class BottomActionBar extends StatefulWidget {
  const BottomActionBar({super.key, required this.wallpaper});

  final WallpaperData wallpaper;

  @override
  State<BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<BottomActionBar> {
  final ReceivePort _port = ReceivePort();
  double _downloadProgress = 0.0;
  bool _isDownloading = false;
  late final NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _notificationService.initialize();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      final progress = data[2];
      if (progress is int) {
        setState(() {
          _downloadProgress = progress / 100;
          if (_downloadProgress == 1.0) {
            _isDownloading = false;
          }
        });
      }
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  Future<void> _downloadImage(String url, String fileName) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        setState(() {
          _isDownloading = true;
          _downloadProgress = 0.0;
        });
        final taskId = await FlutterDownloader.enqueue(
          url: url,
          savedDir: externalDir.path,
          fileName: fileName,
          showNotification: true,
          openFileFromNotification: true,
          saveInPublicStorage: true,
        );
        if (taskId != null) {
          _notificationService.showDownloadNotification(
              _downloadProgress, fileName);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DownloadWallpaperCubit, DownloadWallpaperState>(
      listener: (context, state) {
        if (state is DownloadWallpaperLoading) {
          // Optional: show overlay progress
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Downloading: ${state.progress}'),
          ));
        }
        if (state is DownloadWallpaperSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wallpaper saved')),
          );
        }
      },
      builder: (blocContext, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ActionButton(
              icon: CupertinoIcons.info,
              label: 'Info',
              onPressed: () {
                // TODO: Implement info functionality.
              },
            ),
            SizedBox(width: 30),
            _ActionButton(
              icon: Icons.download_rounded,
              label: 'Save',
              onPressed: () =>
                  _showResolutionSheet(context, widget.wallpaper.src),
            ),
            SizedBox(width: 30),
            _ActionButton(
              icon: Icons.wallpaper_outlined,
              label: 'Apply',
              onPressed: () {
                // TODO: Implement apply functionality.
              },
            ),
          ],
        );
      },
    );
  }

  void _showResolutionSheet(BuildContext blocContext, SrcData src) {
    final resolutions = src.toResolutionMap();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: BlocProvider.of<DownloadWallpaperCubit>(blocContext),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Choose Resolution',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: resolutions.length,
                itemBuilder: (context, index) {
                  final entry = resolutions.entries.elementAt(index);
                  return ListTile(
                    leading: const Icon(Icons.image),
                    title: Text(entry.key.toUpperCase()),
                    onTap: () {
                      Navigator.pop(context);
                      context
                          .read<DownloadWallpaperCubit>()
                          .download(entry.value);
                      // _downloadImage(entry.value, fileName);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconButton(
          icon: icon,
          onPressed: onPressed,
        ),
        const SizedBox(height: 4),
        Text(label, style: textStyle),
      ],
    );
  }
}
