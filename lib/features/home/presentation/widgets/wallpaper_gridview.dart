import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_hub/features/home/presentation/cubit/wallpaper_cubit.dart';

import '../../../../core/shared/shared.dart';
import 'wallpaper_view.dart';

class WallpaperGridview extends StatelessWidget {
  const WallpaperGridview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WallpaperCubit, WallpaperState>(
      builder: (context, state) {
        if (state is WallpaperLoadingState) {
          return LoadingWidget();
        } else if (state is WallpaperLoadedState) {
          final wallpapers = state.data.photos;

          if (wallpapers.isEmpty) {
            return SizedBox();
          }

          return MasonryGridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 6,right: 6, bottom: 20),
            itemCount: wallpapers.length,
            itemBuilder: (context, index) {
              return WallpaperView(
                index: index,
                wallpaper: wallpapers[index],
              );
            },
          );
        }

        return SizedBox();
      },
    );
  }
}
