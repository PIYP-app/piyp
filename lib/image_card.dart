import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/source.dart';
import 'package:piyp/sources.dart';
import 'package:piyp/thumbnail.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({super.key, required this.file});

  final MediaCompanion file;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  Uint8List? compressedImage;
  Sources sources = Sources();
  late SourceFile? media;

  @override
  void initState() {
    super.initState();

    final indexMedia = sources.sources
        .firstWhere((source) => source.id == widget.file.serverId.value)
        .files
        .indexWhere((file) => file.eTag == widget.file.eTag.value);

    media = indexMedia != -1
        ? sources.sources
            .firstWhere((source) => source.id == widget.file.serverId.value)
            .files[indexMedia]
        : null;

    getOrCreateMedia();
    retrieveThumbnail();
  }

  Future<void> getOrCreateMedia() async {
    if (media == null) {
      return;
    }

    final newMedia = await media!.readExifFromFile();

    await Sources.saveMediaInDatabase(newMedia);
  }

  Future<void> retrieveThumbnail() async {
    compressedImage =
        await Thumbnail.getOrCreateThumbnail(widget.file.eTag.value, media);

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (compressedImage == null) {
      return Container(
        color: Colors.grey,
      );
    }

    final mediaType =
        widget.file.mimeType.value.contains('video') ? 'videos' : 'images';

    return InkWell(
        onTap: () {
          context.push(
              Uri(path: '/$mediaType/${widget.file.eTag.value}').toString());
        }, // Handle your callback
        child: PhotoView.customChild(
          heroAttributes: PhotoViewHeroAttributes(
              tag: widget.file.eTag.value, transitionOnUserGestures: true),
          child: Container(
              decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.memory(compressedImage!).image,
              fit: BoxFit.cover,
            ),
          )),
        ));
  }
}
