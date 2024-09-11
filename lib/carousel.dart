import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:piyp/carousel_bottom_bar.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/fading_app_bar.dart';
import 'package:piyp/main.dart';
import 'package:piyp/thumbnail.dart';
import 'package:piyp/webdav_client.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

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
  ServerData? server;
  File? compressedImage;

  @override
  void initState() {
    super.initState();
    indexFile =
        client.files.indexWhere((element) => element.eTag == widget.eTag);
    _pageController =
        PageController(viewportFraction: 1, initialPage: indexFile);

    _pageController.addListener(() {
      if (!mounted) {
        return;
      }

      final int futureIndexFile = _pageController.page!.ceil();

      if (futureIndexFile != indexFile) {
        setState(() {
          compressedImage = null;
          indexFile = futureIndexFile;
        });
        _retrieveCompressedImage();
      }
    });

    retrieveServer();
    _retrieveCompressedImage();
  }

  _retrieveCompressedImage() async {
    compressedImage =
        await Thumbnail.readThumbnail(client.files[indexFile].eTag ?? '');

    if (mounted) {
      setState(() {});
    }
  }

  void retrieveServer() async {
    List<ServerData> servers = await database.select(database.server).get();

    setState(() {
      server = servers[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (server == null) {
      return const CircularProgressIndicator();
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: FadingAppBar(
          visibility: visibility,
          fileTime: client.files[indexFile].mTime,
        ),
        bottomNavigationBar: CarouselBottomBar(
          visibility: visibility,
          fileName: client.files[indexFile].name,
        ),
        body: PhotoViewGestureDetectorScope(
            axis: Axis.horizontal,
            child: PhotoViewGallery.builder(
                backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                pageController: _pageController,
                itemCount: client.files.length,
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
                          tag: client.files[pagePosition].eTag ?? ''),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: 20.0,
                      imageProvider: CachedNetworkImageProvider(
                        '${server!.uri}${server!.folderPath ?? ''}/${client.files[pagePosition].name}',
                        headers: {
                          'Authorization': webdav.BasicAuth(
                                  user: server!.username, pwd: server!.pwd)
                              .authorize('', '')
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
