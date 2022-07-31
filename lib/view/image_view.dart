import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaper_hub/models/photos_model.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class ImageView extends StatefulWidget {
  final Hits model;

  ImageView({this.model});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: GestureDetector(
                onTap: () {
                  if (controller.isCompleted) {
                    controller.reverse();
                  } else {
                    controller.forward();
                  }
                },
                child: Image.network(
                  widget.model.largeImageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: Offset(0, -controller.value * 64),
                    child: Container(
                      height: 64.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12, right: 12),
                            child: GestureDetector(
                              onTap: () {
                                setWallpaperDialog(context);
                              },
                              child: Text(
                                'Set as wallpaper',
                                style: GoogleFonts.sarabun(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setWallpaperDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  'Home Screen',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.home_filled, color: Colors.black),
                onTap: () => setWallpaper(1),
              ),
              ListTile(
                title: Text(
                  'Lock Screen',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.lock_outline_rounded, color: Colors.black),
                onTap: () => setWallpaper(2),
              ),
              ListTile(
                title: Text(
                  'Both',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.phone_android_rounded, color: Colors.black),
                onTap: () => setWallpaper(3),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> setWallpaper(int index) async {
    String url = widget.model.largeImageURL;
    int location;
    try {
      if (index == 1) {
        location = WallpaperManager.HOME_SCREEN;
      } else if (index == 2) {
        location = WallpaperManager.LOCK_SCREEN;
      } else {
        location = WallpaperManager.BOTH_SCREENS;
      }
      var file = await DefaultCacheManager().getSingleFile(url);
      final String result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
    } on PlatformException catch (e) {
      print("Failed to set wallpaper: '${e.message}");
    }

    Fluttertoast.showToast(
        msg: "Wallpaper set successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}
