import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:wallpaper_hub/data/data.dart';
import 'package:wallpaper_hub/view/image_view.dart';
import 'package:wallpaper_hub/view/search_page.dart';
import 'models/photos_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PreloadPageController> controllers = [];
  List<Hits> hits;

  getWallpapers() async {
    var imageModel = await Data().getImages(49);
    hits = imageModel.hits;
    setState(() {});
  }

  @override
  void initState() {
    getWallpapers();
    controllers = [
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: PreloadPageView.builder(
        controller:
            PreloadPageController(viewportFraction: 0.7, initialPage: 3),
        itemCount: 7,
        preloadPagesCount: 7,
        itemBuilder: (context, mainIndex) {
          return PreloadPageView.builder(
            itemCount: 7,
            preloadPagesCount: 7,
            controller: controllers[mainIndex],
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              var hitIndex = (mainIndex * 7) + index;
              var hit;
              if (hits != null) {
                hit = hits[hitIndex];
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (hits != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageView(model: hit),
                        ),
                      );
                    }
                  },
                  child: Container(
                    // width: double.infinity,
                    // height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(4, 6),
                          blurRadius: 3,
                        ),
                      ],
                      image: (hit?.webformatURL != null)
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                hit?.webformatURL,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.search, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(),
            ),
          );
        },
      ),
    );
  }
}
