import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/main.dart';
import 'package:piyp/thumbnail.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required this.eTag, required this.name});

  final String? eTag;
  final String? name;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  Uint8List? compressedImage;
  late final Player player = Player();
  late final controller = VideoController(player);
  bool loaded = false;

  @override
  void initState() {
    super.initState();
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
    final List<ServerData> servers =
        await database.select(database.server).get();

    player.stream.width.listen((event) {
      if (event != null) {
        loaded = true;

        if (mounted) {
          setState(() {});
        }
      }
    });

    await player.open(
        Media('${servers[0].uri}${servers[0].folderPath}/${widget.name}',
            httpHeaders: {
              'Authorization': webdav.BasicAuth(
                      user: servers[0].username, pwd: servers[0].pwd)
                  .authorize('', '')
            }),
        play: false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      Video(controller: controller),
      compressedImage != null && !loaded
          ? Image.memory(
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
