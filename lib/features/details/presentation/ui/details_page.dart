import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_hub/features/home/domain/entities/wallpaper_data.dart';

import '../../details.dart';
import '../widgets/bottom_action_bar.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.wallpaper});

  final WallpaperData wallpaper;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            height: size.height,
            width: size.width,
            fit: BoxFit.cover,
            imageUrl: wallpaper.src.original,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.white54,
              highlightColor: Colors.white70,
              child: Container(
                height: size.height,
                width: size.width,
                child: Icon(
                  Icons.image,
                  color: Colors.grey.shade300,
                  size: size.width / 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.image,
              color: Colors.grey.shade300,
              size: size.width / 2,
            ),
          ),
          TopActionBar(wallpaper: wallpaper),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: BottomActionBar(wallpaper: wallpaper),
            ),
          ),
        ],
      ),
    );
  }
}
