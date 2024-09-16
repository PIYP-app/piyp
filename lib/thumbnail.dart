import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/init_db.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:flutter/services.dart' show ByteData, rootBundle;

class Thumbnail {
  static initThumbnailFolder() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final thumbnailDirectory = Directory('${directory.path}/thumbnails');
      if (!await thumbnailDirectory.exists()) {
        await thumbnailDirectory.create();
      }

      print('thumbnail folder created at: ${directory.path}/thumbnails');
    } catch (e) {
      print(e);
    }
  }

  static Future<File> generateFilePath(String eTag) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/thumbnails/$eTag');
  }

  static saveThumbnail(String eTag, Uint8List bytes) async {
    final file = await generateFilePath(eTag);
    await file.writeAsBytes(bytes);
  }

  static Future<Uint8List> generatePhotoThumbnail(
      Uint8List fileByte, String eTag) async {
    final fileBytes = await FlutterImageCompress.compressWithList(
      fileByte,
      minWidth: 300,
      minHeight: 300,
      quality: 1,
    );

    await saveThumbnail(eTag, fileBytes);

    return fileBytes;
  }

  static Future<Uint8List?> generateVideoThumbnail(
      String url, String eTag) async {
    try {
      final List<ServerData> servers =
          await database.select(database.server).get();

      final fileBytes = await VideoThumbnail.thumbnailData(
        video: '${servers[0].uri}/$url',
        headers: {
          'Authorization':
              webdav.BasicAuth(user: servers[0].username, pwd: servers[0].uri)
                  .authorize('', '')
        },
        imageFormat: ImageFormat.JPEG,
        maxHeight: 500,
        quality: 1,
      );

      if (fileBytes == null) {
        return null;
      }

      await saveThumbnail(eTag, fileBytes);

      return fileBytes;
    } catch (error) {
      ByteData data = await rootBundle.load("assets/video.png");
      var fileBytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await saveThumbnail(eTag, fileBytes);

      return fileBytes;
    }
  }

  static Future<File?> readThumbnail(String eTag) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/thumbnails/$eTag');

    if (!await file.exists()) return null;

    return file;
  }
}
