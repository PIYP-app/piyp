import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:piyp/source.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
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

  static Future<Uint8List?> generateVideoThumbnail(SourceFile file) async {
    try {
      final fileBytes = await VideoThumbnail.thumbnailData(
        video: file.server.getBaseUrl() + file.path!,
        headers: {
          'Authorization': 'Basic ${base64Encode(
            utf8.encode('${file.server.username}:${file.server.pwd}'),
          )}'
        },
        imageFormat: ImageFormat.JPEG,
        maxHeight: 500,
        quality: 1,
      );

      if (fileBytes == null) {
        return null;
      }

      await saveThumbnail(file.eTag!, fileBytes);

      return fileBytes;
    } catch (error) {
      ByteData data = await rootBundle.load("assets/video.png");
      var fileBytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await saveThumbnail(file.eTag!, fileBytes);

      return fileBytes;
    }
  }

  static Future<Uint8List?> getOrCreateThumbnail(
      String eTag, SourceFile? file) async {
    Uint8List? compressedImage;
    final retrievedThumbnail = await Thumbnail.readThumbnail(eTag);
    compressedImage = retrievedThumbnail != null
        ? await retrievedThumbnail.readAsBytes()
        : null;
    if (compressedImage == null && file != null) {
      if (file.mimeType!.contains('video')) {
        compressedImage = await Thumbnail.generateVideoThumbnail(file);
      } else {
        try {
          List<int> fileByte = await file.server.read(file.path!);
          compressedImage = await Thumbnail.generatePhotoThumbnail(
              Uint8List.fromList(fileByte), file.eTag!);
        } catch (e) {
          print('Error generating thumbnail: $e');
        }
      }
    }

    return compressedImage;
  }

  static Future<File?> readThumbnail(String eTag) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/thumbnails/$eTag');

    if (!await file.exists()) return null;

    return file;
  }
}
