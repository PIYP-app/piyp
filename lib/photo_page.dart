import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/main.dart';
import 'package:piyp/thumbnail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key, required this.eTag, required this.name});

  final String? eTag;
  final String? name;

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  File? compressedImage;

  @override
  void initState() {
    super.initState();
    _retrieveCompressedImage();
  }

  _retrieveCompressedImage() async {
    compressedImage = await Thumbnail.readThumbnail(widget.eTag!);

    if (mounted) {
      setState(() {});
    }
  }

  Future<Widget> _retrievePhoto() async {
    List<ServerData> servers = await database.select(database.server).get();

    return PhotoView(
        // minScale: 1,
        // maxScale: 20,
        imageProvider: CachedNetworkImageProvider(
      '${servers[0].uri}${servers[0].folderPath ?? ''}/${widget.name}',
      headers: {
        'Authorization':
            webdav.BasicAuth(user: servers[0].username, pwd: servers[0].pwd)
                .authorize('', '')
      },
    ));
  }

  _renderLoadingState(double? progress) {
    return compressedImage != null
        ? Image.file(
            compressedImage!,
            fit: BoxFit.contain,
          )
        : CircularProgressIndicator(value: progress);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _retrievePhoto(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return _renderLoadingState(null);
        }
        return snapshot.data;
      },
    );
  }
}
