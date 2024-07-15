import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

class Thumbnail {
  static initThumbnailFolder() async {
    final directory = await getApplicationDocumentsDirectory();
    final thumbnailDirectory = Directory('${directory.path}/thumbnails');
    if (!await thumbnailDirectory.exists()) {
      await thumbnailDirectory.create();
    }

    print('thumbnail folder created at: ${directory.path}/thumbnails');
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
      minWidth: 500,
      minHeight: 500,
      quality: 1,
    );

    await saveThumbnail(eTag, fileBytes);

    return fileBytes;
  }

  static Future<Uint8List?> generateVideoThumbnail(
      String url, String eTag) async {
    final preferences = await SharedPreferences.getInstance();

    final fileBytes = await VideoThumbnail.thumbnailData(
      video: '${preferences.getString('webdav_uri')}/$url',
      headers: {
        'Authorization': webdav.BasicAuth(
                user: preferences.getString('webdav_user') ?? '',
                pwd: preferences.getString('webdav_password') ?? '')
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
  }

  static Future<Uint8List?> readThumbnail(String eTag) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/thumbnails/$eTag');

    if (!await file.exists()) return null;

    final bytes = await file.readAsBytes();
    return bytes;
  }
}
