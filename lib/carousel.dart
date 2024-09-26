import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:piyp/carousel_bottom_bar.dart';
import 'package:piyp/fading_app_bar.dart';
import 'package:piyp/source.dart';
import 'package:piyp/sources.dart';
import 'package:piyp/thumbnail.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key, required this.eTag});

  final String? eTag;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _pageController;
  Sources sources = Sources();
  bool visibility = true;
  int indexFile = 0;
  File? compressedImage;
  late List<SourceFile> files;

  @override
  void initState() {
    super.initState();
    files = sources.getAllFiles();
    indexFile = files.indexWhere((element) => element.eTag == widget.eTag);
    _pageController =
        PageController(viewportFraction: 1, initialPage: indexFile);
    double previousPage = _pageController.page ?? 0.0;
    String scrollDirection = '';

    _pageController.addListener(() {
      if (!mounted) {
        return;
      }

      double currentPage = _pageController.page ?? 0.0;
      setState(() {
        scrollDirection = currentPage > previousPage ? 'right' : 'left';
      });
      previousPage = currentPage;

      final int futureIndexFile =
          scrollDirection == 'right' ? currentPage.ceil() : currentPage.floor();

      if (futureIndexFile != indexFile) {
        setState(() {
          compressedImage = null;
          indexFile = futureIndexFile;
        });
        _retrieveCompressedImage();
      }
    });

    _retrieveCompressedImage();
  }

  _retrieveCompressedImage() async {
    compressedImage =
        await Thumbnail.readThumbnail(files[indexFile].eTag ?? '');

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: FadingAppBar(
          visibility: visibility,
          fileTime: files[indexFile].mTime,
        ),
        bottomNavigationBar: CarouselBottomBar(
          visibility: visibility,
          file: files[indexFile],
        ),
        body: PhotoViewGestureDetectorScope(
            axis: Axis.horizontal,
            child: PhotoViewGallery.builder(
                backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                pageController: _pageController,
                itemCount: files.length,
                pageSnapping: true,
                loadingBuilder: (context, event) {
                  return compressedImage != null
                      ? Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Image.file(
                            compressedImage!,
                            fit: BoxFit.contain,
                          ))
                      : const CircularProgressIndicator();
                },
                builder: (context, pagePosition) {
                  return PhotoViewGalleryPageOptions(
                      heroAttributes: PhotoViewHeroAttributes(
                          transitionOnUserGestures: true,
                          tag: files[pagePosition].eTag ?? ''),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: 20.0,
                      imageProvider: CachedNetworkImageProvider(
                        '${files[pagePosition].server.getBaseUrl()}/${files[pagePosition].name}',
                        headers: {
                          'Authorization': 'Basic ${base64Encode(
                            utf8.encode(
                                '${files[pagePosition].server.username}:${files[pagePosition].server.pwd}'),
                          )}'
                        },
                      ),
                      onTapDown: (context, tapDown, controllerValue) {
                        if (!mounted) {
                          return;
                        }

                        setState(() {
                          visibility = !visibility;
                        });
                      });
                })));
  }
}
