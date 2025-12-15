import 'package:flutter/material.dart';

import '../../../../core/shared/shared.dart';
import '../../home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(title: AppNameWidget(),centerTitle: false),
          SliverToBoxAdapter(child: WallpaperGridview()),
        ],
      ),
    );
  }
}
