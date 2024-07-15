import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piyp/thumbnail.dart';
import 'package:webdav_client/webdav_client.dart';

class ImageCard extends StatefulWidget {
  ImageCard({super.key, required this.file, required this.webdavClient});

  File file;
  Client webdavClient;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  Uint8List? compressedImage;

  @override
  void initState() {
    super.initState();
    getOrCreateThumbnail();
  }

  getOrCreateThumbnail() async {
    compressedImage = await Thumbnail.readThumbnail(widget.file.eTag!);
    if (compressedImage == null) {
      if (widget.file.mimeType!.contains('video')) {
        compressedImage = await Thumbnail.generateVideoThumbnail(
            widget.file.path!, widget.file.eTag!);
      } else {
        List<int> fileByte = await widget.webdavClient.read(widget.file.path!);
        compressedImage = await Thumbnail.generatePhotoThumbnail(
            Uint8List.fromList(fileByte), widget.file.eTag!);
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
        child: Text(widget.file.name ?? ''),
      );
    }

    return InkWell(
        onTap: () {
          context
              .push(Uri(path: '/photos/${widget.file.eTag}', queryParameters: {
            'name': widget.file.name ?? '',
          }).toString());
        }, // Handle your callback
        child: Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.memory(compressedImage!).image,
            fit: BoxFit.cover,
          ),
        )));
  }
}
