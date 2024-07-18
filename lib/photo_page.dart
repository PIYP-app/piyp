import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:piyp/thumbnail.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Uint8List? compressedImage;

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
    final preferences = await SharedPreferences.getInstance();

    return InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(0.0),
        minScale: 1,
        maxScale: 20,
        child: CachedNetworkImage(
          imageUrl:
              '${preferences.getString('webdav_uri')}${preferences.getString('webdav_folder_path') ?? ''}/${widget.name}',
          httpHeaders: {
            'Authorization': webdav.BasicAuth(
                    user: preferences.getString('webdav_user') ?? '',
                    pwd: preferences.getString('webdav_password') ?? '')
                .authorize('', '')
          },
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              _renderLoadingState(downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ));
  }

  _renderLoadingState(double? progress) {
    return compressedImage != null
        ? Image.memory(
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
