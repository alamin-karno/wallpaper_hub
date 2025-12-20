import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_hub/model/wallpaper_model.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';

class ImageView extends StatefulWidget {
  ImageView({
    required this.imgUrl,
    required this.imgUrlLarge,
    required this.wallpapers,
  });

  final String imgUrl, imgUrlLarge;
  final List<WallpaperModel> wallpapers;

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  String _wallpaper = 'Set Wallpaper';
  bool isDownloaded = false;
  bool isWallpaperSet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.imgUrl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: CachedNetworkImageProvider(widget.imgUrl),
                fit: BoxFit.cover,
              ),
              /*Builder(
                  builder: (context) {
                    final double height = MediaQuery.of(context).size.height;
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: height,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                      ),
                      items: widget.wallpapers.map((e) => Container(
                        child: Image(
                          image: CachedNetworkImageProvider(e.src.portrait),
                          fit: BoxFit.cover,
                        ),
                      )).toList(),

                    );
                  },
                ),*/
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FocusedMenuHolder(
                  menuWidth: MediaQuery.of(context).size.width / 2,
                  animateMenuItems: true,
                  blurSize: 5,
                  duration: Duration(microseconds: 100),
                  blurBackgroundColor: Colors.black54,
                  openWithTap: true,
                  menuOffset: 10.0,
                  bottomOffsetHeight: 10,
                  menuItems: [
                    FocusedMenuItem(
                        title: Text('Set on HomeScreen'),
                        onPressed: () {
                          isWallpaperSet
                              ? setState(() {
                                  _wallpaper = 'Already Set';
                                })
                              : _setWallpaper(WallpaperManagerPlus.homeScreen);
                        }),
                    FocusedMenuItem(
                        title: Text('Set on LockScreen'),
                        onPressed: () {
                          isWallpaperSet
                              ? setState(() {
                                  _wallpaper = 'Already Set';
                                })
                              : _setWallpaper(WallpaperManagerPlus.lockScreen);
                        }),
                    FocusedMenuItem(
                        title: Text('Set on Both'),
                        onPressed: () {
                          isWallpaperSet
                              ? setState(() {
                                  _wallpaper = 'Already Set';
                                })
                              : _setWallpaper(WallpaperManagerPlus.bothScreens);
                        }),
                  ],
                  onPressed: () {},
                  child: Stack(
                    children: [
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: Color(0xff1C1B1B).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54, width: 1),
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ])),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.white54,
                              highlightColor: Colors.black87,
                              child: Text(
                                _wallpaper,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white54, width: 1),
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xff1C1B1B).withOpacity(0.5),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        isDownloaded
                            ? setState(() {
                                _wallpaper = 'Already Downloaded';
                              })
                            : kIsWeb
                                ? _openNewTap()
                                : _save();
                      },
                      icon: Icon(
                        Icons.file_download,
                        color: Colors.white54,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _shareImageLink();
                  },
                  icon: Icon(
                    Icons.ios_share,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _shareImageLink() {
    kIsWeb
        ? Share.share(widget.imgUrlLarge, subject: 'Share Wallpaper Link')
        : Share.share(widget.imgUrl, subject: 'Share Wallpaper Link');
  }

  _save() async {
    setState(() {
      _wallpaper = 'Downloading...';
    });

    if (Platform.isAndroid || Platform.isIOS) {
      await _askPermission();
    }
    var response = await Dio()
        .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(response.data));

    print(result);

    if (result['isSuccess'] == false) {
      setState(() {
        isDownloaded = false;
        _wallpaper = 'Wallpaper not saved';
      });
    } else {
      setState(() {
        isDownloaded = true;
        _wallpaper = 'Wallpaper saved';
      });
    }
  }

  Future<void> _setWallpaper(int wallpaperType) async {
    if (kIsWeb) {
      _showAlertDialog('Desktop');
    } else if (Platform.isAndroid) {
      setState(() {
        _wallpaper = 'Setting Wallpaper ...';
      });

      String? result;

      var file = await DefaultCacheManager().getSingleFile(widget.imgUrl);

      print(file.path);

      try {
        result = await WallpaperManagerPlus().setWallpaper(
          File(file.path),
          wallpaperType,
        );

        setState(() {
          isWallpaperSet = true;
        });
      } on PlatformException {
        result = "Wallpaper failed to set.";
        setState(() {
          isWallpaperSet = false;
        });
      }

      if (!mounted) return;
      setState(() {
        _wallpaper = result ?? 'Wallpaper not set';
      });
    } else if (Platform.isIOS) {
      _showAlertDialog('iOS');
    }
  }

  _showAlertDialog(String query) {
    CupertinoAlertDialog alertDialog = CupertinoAlertDialog(
      title: Text('Wallpaper not set'),
      content: Text(
          'You can not set wallpaper for $query. Download the image and set wallpaper manually.'),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  _openNewTap() async {
    if (await canLaunch(widget.imgUrlLarge)) {
      await launch(
        widget.imgUrlLarge,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not lunch ${widget.imgUrlLarge}';
    }
  }

  _askPermission() async {
    if (Platform.isIOS) {
      Map<Permission, PermissionStatus> permissions = await [
        Permission.photos,
      ].request();
      print(permissions[Permission.photos]);
    } else {
      Map<Permission, PermissionStatus> permissions = await [
        Permission.storage,
      ].request();
      print(permissions[Permission.storage]);
    }
  }
}
