import 'package:flutter/material.dart';
import 'package:piyp/carousel_bottom_bar.dart';
import 'package:piyp/fading_app_bar.dart';
import 'package:piyp/photo_page.dart';
import 'package:piyp/video_page.dart';
import 'package:piyp/webdav_client.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key, required this.eTag});

  final String? eTag;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _pageController;
  WebdavClient client = WebdavClient();
  bool visibility = true;
  int indexFile = 0;

  @override
  void initState() {
    super.initState();
    indexFile =
        client.files.indexWhere((element) => element.eTag == widget.eTag);
    _pageController =
        PageController(viewportFraction: 1, initialPage: indexFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: FadingAppBar(
          visibility: visibility,
          fileTime: client.files[indexFile].mTime,
        ),
        bottomNavigationBar: CarouselBottomBar(
          visibility: visibility,
          fileName: client.files[indexFile].name,
        ),
        body: PageView.builder(
            controller: _pageController,
            itemCount: client.files.length,
            pageSnapping: true,
            onPageChanged: (pagePosition) {
              setState(() {
                indexFile = pagePosition;
              });
            },
            itemBuilder: (context, pagePosition) {
              return GestureDetector(
                  onTap: () {
                    if (!mounted) {
                      return;
                    }

                    setState(() {
                      visibility = !visibility;
                    });
                  },
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      color: visibility
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Colors.black,
                      child:
                          client.files[pagePosition].mimeType!.contains('video')
                              ? VideoPage(
                                  eTag: client.files[pagePosition].eTag,
                                  name: client.files[pagePosition].name)
                              : PhotoPage(
                                  eTag: client.files[pagePosition].eTag,
                                  name: client.files[pagePosition].name)));
            }));
  }
}
