import 'dart:io';

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
  String? thumbnailPath;
  Sources sources = Sources();
  SourceFile? media;

  @override
  void initState() {
    super.initState();

    final sourceIndex = sources.sources
        .indexWhere((source) => source.id == widget.file.serverId.value);

    if (sourceIndex != -1) {
      final fileIndex = sources.sources[sourceIndex].files
          .indexWhere((file) => file.eTag == widget.file.eTag.value);

      media = fileIndex != -1
          ? sources.sources[sourceIndex].files[fileIndex]
          : null;
    }

    getOrCreateMedia();
    retrieveThumbnail();
  }

  Future<void> getOrCreateMedia() async {
    if (media == null) {
      return;
    }

    try {
      final newMedia = await media!.readExifFromFile();
      await Sources.saveMediaInDatabase(newMedia);
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> retrieveThumbnail() async {
    if (media != null) {
      thumbnailPath =
          await Thumbnail.getOrCreateThumbnail(widget.file.eTag.value, media!);
    } else {
      // Fallback: check if thumbnail already exists
      final existingThumbnail =
          await Thumbnail.readThumbnail(widget.file.eTag.value);
      thumbnailPath = existingThumbnail?.path;
    }

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (thumbnailPath == null || !File(thumbnailPath!).existsSync()) {
      return Container(
        color: Colors.grey[300],
        child: Center(
          child: Icon(
            widget.file.mimeType.value.contains('video')
                ? Icons.videocam
                : Icons.photo,
            color: Colors.grey[600],
            size: 32,
          ),
        ),
      );
    }

    final mediaType =
        widget.file.mimeType.value.contains('video') ? 'videos' : 'images';

    return InkWell(
        onTap: () {
          context.push(
              Uri(path: '/$mediaType/${widget.file.eTag.value}').toString());
        },
        child: PhotoView.customChild(
          heroAttributes: PhotoViewHeroAttributes(
              tag: widget.file.eTag.value, transitionOnUserGestures: true),
          child: Container(
              decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(thumbnailPath!)),
              fit: BoxFit.cover,
            ),
          )),
        ));
  }
}
