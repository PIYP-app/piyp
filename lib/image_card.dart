import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:piyp/source.dart';
import 'package:piyp/sources.dart';
import 'package:piyp/thumbnail.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({super.key, required this.file});

  final SourceFile file;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  Uint8List? compressedImage;
  Sources sources = Sources();

  @override
  void initState() {
    super.initState();
    getOrCreateThumbnail();
  }

  getOrCreateThumbnail() async {
    final retrievedThumbnail = await Thumbnail.readThumbnail(widget.file.eTag!);
    compressedImage = retrievedThumbnail != null
        ? await retrievedThumbnail.readAsBytes()
        : null;
    if (compressedImage == null) {
      if (widget.file.mimeType!.contains('video')) {
        compressedImage = await Thumbnail.generateVideoThumbnail(
            widget.file.path!, widget.file.eTag!);
      } else {
        try {
          List<int> fileByte = await sources.sources[0].read(widget.file.path!);
          compressedImage = await Thumbnail.generatePhotoThumbnail(
              Uint8List.fromList(fileByte), widget.file.eTag!);
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
        widget.file.mimeType!.contains('video') ? 'videos' : 'photos';

    return InkWell(
        onTap: () {
          context.push(
              Uri(path: '/$mediaType/${widget.file.eTag}', queryParameters: {
            'name': widget.file.name ?? '',
          }).toString());
        }, // Handle your callback
        child: PhotoView.customChild(
          heroAttributes: PhotoViewHeroAttributes(
              tag: widget.file.eTag ?? '', transitionOnUserGestures: true),
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
