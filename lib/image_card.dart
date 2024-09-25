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
    getOrCreateThumbnail();

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
  }

  getOrCreateMedia() async {
    if (media == null) {
      return;
    }

    final newMedia = await Sources.readExifFromFile(media!);

    await Sources.saveMediaInDatabase(newMedia);
  }

  getOrCreateThumbnail() async {
    final retrievedThumbnail =
        await Thumbnail.readThumbnail(widget.file.eTag.value);
    compressedImage = retrievedThumbnail != null
        ? await retrievedThumbnail.readAsBytes()
        : null;
    if (compressedImage == null && media != null) {
      if (media!.mimeType!.contains('video')) {
        compressedImage = await Thumbnail.generateVideoThumbnail(media!);
      } else {
        try {
          List<int> fileByte = await media!.server.read(media!.path!);
          compressedImage = await Thumbnail.generatePhotoThumbnail(
              Uint8List.fromList(fileByte), media!.eTag!);
        } catch (e) {
          print('Error generating thumbnail: $e');
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compressedImage == null) {
      return Container(
        color: Colors.grey,
      );
    }

    final mediaType =
        widget.file.mimeType.value.contains('video') ? 'videos' : 'photos';

    return InkWell(
        onTap: () {
          context.push(
              Uri(path: '/$mediaType/${widget.file.eTag.value}').toString());
        }, // Handle your callback
        child: PhotoView.customChild(
          heroAttributes: PhotoViewHeroAttributes(
              tag: widget.file.eTag.value ?? '',
              transitionOnUserGestures: true),
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
