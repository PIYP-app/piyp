import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:piyp/source.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Thumbnail {
  static String? _thumbnailFolderPath;

  static Future<void> initThumbnailFolder() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      _thumbnailFolderPath = '${appDocDir.path}/thumbnails';

      final Directory thumbnailDir = Directory(_thumbnailFolderPath!);
      if (!await thumbnailDir.exists()) {
        await thumbnailDir.create(recursive: true);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing thumbnail folder: $e');
      }
    }
  }

  static Future<String?> getOrCreateThumbnail(
      String eTag, SourceFile file) async {
    if (_thumbnailFolderPath == null) {
      await initThumbnailFolder();
    }

    final String thumbnailPath = '$_thumbnailFolderPath/$eTag.jpg';
    final File thumbnailFile = File(thumbnailPath);

    // Return existing thumbnail if it exists
    if (await thumbnailFile.exists()) {
      return thumbnailPath;
    }

    try {
      if (file.mimeType?.contains('image') == true) {
        return await _createImageThumbnail(file, thumbnailPath);
      } else if (file.mimeType?.contains('video') == true) {
        return await _createVideoThumbnail(file, thumbnailPath);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error creating thumbnail for ${file.path}: $e');
      }
    }

    return null;
  }

  // Legacy method for backward compatibility
  static Future<File?> readThumbnail(String eTag) async {
    if (_thumbnailFolderPath == null) {
      await initThumbnailFolder();
    }

    final String thumbnailPath = '$_thumbnailFolderPath/$eTag.jpg';
    final File thumbnailFile = File(thumbnailPath);

    if (await thumbnailFile.exists()) {
      return thumbnailFile;
    }
    return null;
  }

  static Future<String?> _createImageThumbnail(
      SourceFile file, String thumbnailPath) async {
    try {
      // Get file data if not already loaded
      file.fileData ??= await file.server.read(file.path!);

      // Convert List<int> to Uint8List if necessary
      final Uint8List imageData = file.fileData is Uint8List
          ? file.fileData as Uint8List
          : Uint8List.fromList(file.fileData!);

      // Create compressed thumbnail
      final Uint8List compressedData =
          await FlutterImageCompress.compressWithList(
        imageData,
        minHeight: 300,
        minWidth: 300,
        quality: 70,
        format: CompressFormat.jpeg,
      );

      final File thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(compressedData);
      return thumbnailPath;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error creating image thumbnail: $e');
      }
    }
    return null;
  }

  static Future<String?> _createVideoThumbnail(
      SourceFile file, String thumbnailPath) async {
    try {
      // For video files, we need a different approach
      // This is a simplified version - you might need to implement
      // video thumbnail generation from bytes
      final String? videoThumbnailPath = await VideoThumbnail.thumbnailFile(
        video: file.path!,
        thumbnailPath: thumbnailPath,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 300,
        maxWidth: 300,
        quality: 70,
        headers: {
          'Authorization': 'Basic ${base64Encode(
            utf8.encode('${file.server.username}:${file.server.pwd}'),
          )}'
        },
      );

      return videoThumbnailPath;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error creating video thumbnail: $e');
      }
    }
    return null;
  }

  static Future<void> clearThumbnailCache() async {
    if (_thumbnailFolderPath == null) return;

    try {
      final Directory thumbnailDir = Directory(_thumbnailFolderPath!);
      if (await thumbnailDir.exists()) {
        await thumbnailDir.delete(recursive: true);
        await thumbnailDir.create(recursive: true);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error clearing thumbnail cache: $e');
      }
    }
  }

  static Future<int> getThumbnailCacheSize() async {
    if (_thumbnailFolderPath == null) return 0;

    try {
      final Directory thumbnailDir = Directory(_thumbnailFolderPath!);
      if (!await thumbnailDir.exists()) return 0;

      int totalSize = 0;
      await for (final FileSystemEntity entity
          in thumbnailDir.list(recursive: true)) {
        if (entity is File) {
          final FileStat stat = await entity.stat();
          totalSize += stat.size;
        }
      }
      return totalSize;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error calculating thumbnail cache size: $e');
      }
      return 0;
    }
  }
}
