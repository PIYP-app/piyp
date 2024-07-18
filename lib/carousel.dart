import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        viewportFraction: 1,
        initialPage:
            client.files.indexWhere((element) => element.eTag == widget.eTag));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: PageView.builder(
            controller: _pageController,
            itemCount: client.files.length,
            pageSnapping: true,
            itemBuilder: (context, pagePosition) {
              return Container(
                  margin: const EdgeInsets.all(10),
                  child: client.files[pagePosition].mimeType!.contains('video')
                      ? VideoPage(
                          eTag: client.files[pagePosition].eTag,
                          name: client.files[pagePosition].name)
                      : PhotoPage(
                          eTag: client.files[pagePosition].eTag,
                          name: client.files[pagePosition].name));
            }));
  }
}
