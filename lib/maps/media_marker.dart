import 'dart:io';
import 'package:flutter/material.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/init_db.dart';
import 'package:piyp/thumbnail.dart';
import 'package:go_router/go_router.dart';

class MediaWithThumbnail {
  final MediaData media;
  final File thumbnail;

  MediaWithThumbnail({required this.media, required this.thumbnail});
}

class MediaMarker extends StatelessWidget {
  final String eTag;

  const MediaMarker({super.key, required this.eTag});

  Future<File?> _getThumbnail() async {
    return await Thumbnail.readThumbnail(eTag);
  }

  Future<MediaData?> _getMediaFromETag() async {
    try {
      final media = await (database.select(database.media)
            ..where((t) => t.eTag.equals(eTag)))
          .getSingle();
      return media;
    } catch (e) {
      print('Error retrieving media from eTag: $e');
      return null;
    }
  }

  Future<MediaWithThumbnail?> _getMediaWithThumbnail() async {
    final thumbnail = await _getThumbnail();
    final media = await _getMediaFromETag();

    if (thumbnail == null || media == null) {
      return null;
    }
    return MediaWithThumbnail(media: media, thumbnail: thumbnail);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MediaWithThumbnail?>(
      future: _getMediaWithThumbnail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Icon(Icons.error);
        }

        final mediaType = snapshot.data!.media.mimeType.contains('video')
            ? 'videos'
            : 'images';

        return GestureDetector(
          onTap: () {
            context.push(Uri(path: '/$mediaType/${snapshot.data!.media.eTag}')
                .toString());
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: Image.file(
                snapshot.data!.thumbnail,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
