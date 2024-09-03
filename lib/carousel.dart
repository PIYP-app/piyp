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
  DateTime? fileTime;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        viewportFraction: 1,
        initialPage:
            client.files.indexWhere((element) => element.eTag == widget.eTag));
    fileTime =
        client.files.firstWhere((element) => element.eTag == widget.eTag).mTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: visibility
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.black,
        appBar: FadingAppBar(
          visibility: visibility,
          fileTime: fileTime,
        ),
        bottomNavigationBar: const CarouselBottomBar(),
        body: PageView.builder(
            controller: _pageController,
            itemCount: client.files.length,
            pageSnapping: true,
            onPageChanged: (pagePosition) {
              setState(() {
                fileTime = client.files[pagePosition].mTime;
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
                  child: Container(
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
