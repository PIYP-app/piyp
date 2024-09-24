import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:piyp/source.dart';
import 'package:piyp/sources.dart';
import 'package:piyp/thumbnail.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required this.eTag});

  final String? eTag;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  File? compressedImage;
  Sources sources = Sources();
  late final Player player = Player();
  late final controller = VideoController(player);
  late List<SourceFile> files;
  bool loaded = false;
  late SourceFile selectedFile;

  @override
  void initState() {
    super.initState();
    selectedFile =
        sources.getAllFiles().firstWhere((file) => file.eTag == widget.eTag);
    _loadMedia();
    _retrieveCompressedImage();
  }

  _retrieveCompressedImage() async {
    compressedImage = await Thumbnail.readThumbnail(widget.eTag!);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  _loadMedia() async {
    player.stream.width.listen((event) {
      if (event != null) {
        loaded = true;

        if (mounted) {
          setState(() {});
        }
      }
    });

    await player.open(
        Media('${selectedFile.server.getBaseUrl()}/${selectedFile.name}',
            httpHeaders: {
              'Authorization': 'Basic ${base64Encode(
                utf8.encode(
                    '${selectedFile.server..username}:${selectedFile.server..pwd}'),
              )}'
            }),
        play: false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      Video(controller: controller),
      compressedImage != null && !loaded
          ? Image.file(
              compressedImage!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fitWidth,
            )
          : const SizedBox(),
      !loaded
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : const SizedBox()
    ]);
  }
}
