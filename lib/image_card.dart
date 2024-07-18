import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piyp/thumbnail.dart';
import 'package:piyp/webdav_client.dart';
import 'package:webdav_client/webdav_client.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({super.key, required this.file});

  final File file;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  Uint8List? compressedImage;
  WebdavClient webdavClient = WebdavClient();

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
        List<int> fileByte = await webdavClient.client.read(widget.file.path!);
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
      return Text(widget.file.name ?? '');
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
        child: Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.memory(compressedImage!).image,
            fit: BoxFit.cover,
          ),
        )));
  }
}
