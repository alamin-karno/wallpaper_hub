import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wallpaper_hub/core/helper/app_helper.dart';
import 'package:wallpaper_hub/features/home/domain/entities/wallpaper_data.dart';

import '../../../../core/shared/shared.dart';

class TopActionBar extends StatelessWidget {
  const TopActionBar({super.key, required this.wallpaper});

  final WallpaperData wallpaper;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconButton(
            icon: Icons.arrow_back_ios_new_outlined,
            color: wallpaper.avgColor,
            onPressed: () => context.pop(),
          ),
          CustomIconButton(
            icon: Icons.ios_share,
            color: wallpaper.avgColor,
            onPressed: () {
              AppHelper.shareWallpaper(context: context, wallpaper: wallpaper);
            },
          ),
        ],
      ),
    );
  }
}
