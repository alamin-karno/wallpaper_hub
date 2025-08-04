import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_hub/features/home/domain/entities/src_data.dart';
import 'package:wallpaper_hub/features/home/domain/entities/wallpaper_data.dart';

import '../../../../core/shared/shared.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.wallpaper});

  final WallpaperData wallpaper;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconButton(
              icon: CupertinoIcons.info,
              onPressed: () {},
            ),
            Text('Info', style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(width: 20),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconButton(
              icon: Icons.download_rounded,
              onPressed: () => _showResolutionSheet(context, wallpaper.src),
            ),
            Text('Save', style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(width: 20),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconButton(
              icon: Icons.wallpaper_outlined,
              onPressed: () {},
            ),
            Text('Apply', style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}

void _showResolutionSheet(BuildContext context, SrcData src) {
  final resolutions = src.toResolutionMap();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Choose Resolution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...resolutions.entries.map((entry) {
            return ListTile(
              leading: Icon(Icons.image),
              title: Text(entry.key),
              onTap: () {
                Navigator.pop(context);
                //_downloadImage(context, entry.key, entry.value);
              },
            );
          }).toList(),
        ],
      );
    },
  );
}
