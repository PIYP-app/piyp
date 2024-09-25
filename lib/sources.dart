import 'package:drift/drift.dart';
import 'package:exif/exif.dart';
import 'package:piyp/classes/image_data.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/enum.dart';
import 'package:piyp/init_db.dart';
import 'package:piyp/source.dart';
import 'package:piyp/webdav_client.dart';

class Sources {
  static final _sources = Sources._internal();
  List<Source> sources = [];

  factory Sources() {
    return _sources;
  }

  Sources._internal();

  Future<void> connectAllSources() async {
    List<ServerData> servers = await database.select(database.server).get();

    for (var server in servers) {
      if (server.serverType == ServerType.webdav.value) {
        final newClient = WebdavClient(server.id,
            uri: server.uri,
            username: server.username,
            pwd: server.pwd,
            folderPath: server.folderPath ?? '');

        await newClient.testServerConnection();

        if (newClient.isErrored) {
          return;
        }

        if (sources.indexWhere((source) => source.id == server.id) != -1) {
          return;
        }

        sources.add(WebdavClient(server.id,
            uri: server.uri,
            username: server.username,
            pwd: server.pwd,
            folderPath: server.folderPath ?? ''));
      }
    }
  }

  Future<void> retrieveAllFiles() async {
    final List<Future<void>> sourcesFileRetrieve = sources.map((source) {
      return source.retrieveFileList();
    }).toList();

    await Future.wait(sourcesFileRetrieve);
  }

  List<SourceFile> getAllFiles() {
    List<SourceFile> files = [];
    for (var source in sources) {
      files.addAll(source.files);
    }

    files.sort((a, b) => b.mTime!.compareTo(a.mTime!));

    return files;
  }

  static MediaCompanion photoDataToMediaCompanion(MediaData file) {
    final fileCompanion = MediaCompanion.insert(
      serverId: file.serverId,
      eTag: file.eTag,
      mimeType: file.mimeType,
      pathFile: file.pathFile,
      creationDate: file.creationDate,
    );

    return fileCompanion;
  }

  static MediaCompanion sourceFileToMediaCompanion(SourceFile file) {
    final fileCompanion = MediaCompanion.insert(
      serverId: file.server.id,
      eTag: file.eTag!,
      mimeType: file.mimeType!,
      pathFile: file.path!,
      creationDate: file.mTime!.toIso8601String(),
    );

    return fileCompanion;
  }

  static Future<MediaCompanion> readExifFromFile(SourceFile file) async {
    final List<int> fileData = await file.server.read(file.path!);
    final Map<String, IfdTag> value = await readExifFromBytes(fileData);
    final test = ImageExif(
      make: value['Image Make']?.printable ?? '',
      model: value['Image Model']?.printable,
      orientation: value['Image Orientation']?.printable,
      xResolution: int.parse(value['Image XResolution']?.printable ?? '0'),
      yResolution: int.parse(value['Image YResolution']?.printable ?? '0'),
      resolutionUnit: value['Image ResolutionUnit']?.printable,
      software: value['Image Software']?.printable,
      dateTime: value['Image DateTime']?.printable,
      hostComputer: value['Image HostComputer']?.printable,
      tileWidth: 0, // int.parse(value['Image TileWidth']?.printable),
      tileLength: 0, // int.parse(value['Image TileLength']?.printable),
      exifOffset: int.parse(value['Image ExifOffset']?.printable ?? '0'),
      GPS: ExifGPS(
          GPSLatitudeRef: value['GPS GPSLatitudeRef']?.printable,
          GPSLatitude:
              value['GPS GPSLatitude']?.values.toList() as List<Ratio>?,
          GPSLongitudeRef: value['GPS GPSLongitudeRef']?.printable,
          GPSLongitude:
              value['GPS GPSLongitude']?.values.toList() as List<Ratio>?,
          GPSAltitudeRef:
              int.parse(value['GPS GPSAltitudeRef']?.printable ?? '0'),
          GPSAltitude: value['GPS GPSAltitude']?.printable,
          GPSTimeStamp:
              value['GPS GPSTimeStamp']?.values.toList() as List<Ratio>?,
          GPSSpeedRef: value['GPS GPSSpeedRef']?.printable,
          GPSSpeed: value['GPS GPSSpeed']?.values.toList()[0] as Ratio?,
          GPSImgDirectionRef: value['GPS GPSImgDirectionRef']?.printable,
          GPSImgDirection: value['GPS GPSImgDirection']?.printable,
          GPSDestBearingRef: value['GPS GPSDestBearingRef']?.printable,
          GPSDestBearing: value['GPS GPSDestBearing']?.printable,
          GPSDate: value['GPS GPSDate'] != null
              ? DateTime.parse(
                  value['GPS GPSDate']!.printable.replaceAll(':', '-'))
              : null,
          Tag0x001F: int.parse(value['Tag 0x001F']?.printable ?? '0')),
      EXIF: ExifPhoto(
        exposureTime: value['EXIF ExposureTime']?.printable,
        fNumber: value['EXIF FNumber']?.printable,
        exposureProgram: value['EXIF ExposureProgram']?.printable,
        isoSpeedRatings:
            int.parse(value['EXIF ISOSpeedRatings']?.printable ?? '0'),
        exifVersion: value['EXIF ExifVersion']?.printable,
        dateTimeOriginal: value['EXIF DateTimeOriginal']?.printable,
        dateTimeDigitized: value['EXIF DateTimeDigitized']?.printable,
        offsetTime: value['EXIF OffsetTime']?.printable,
        offsetTimeOriginal: value['EXIF OffsetTimeOriginal']?.printable,
        offsetTimeDigitized: value['EXIF OffsetTimeDigitized']?.printable,
        shutterSpeedValue: value['EXIF ShutterSpeedValue']?.printable,
        apertureValue: value['EXIF ApertureValue']?.printable,
        brightnessValue: value['EXIF BrightnessValue']?.printable,
        exposureBiasValue: value['EXIF ExposureBiasValue']?.printable,
        meteringMode: value['EXIF MeteringMode']?.printable,
        flash: value['EXIF Flash']?.printable,
        focalLength: value['EXIF FocalLength']?.printable,
        subjectArea: value['EXIF SubjectArea']?.values.toList() as List<int>?,
        makerNote: value['EXIF MakerNote']?.values.toList() as List<int>?,
        subSecTimeOriginal:
            int.parse(value['EXIF SubSecTimeOriginal']?.printable ?? '0'),
        subSecTimeDigitized:
            int.parse(value['EXIF SubSecTimeDigitized']?.printable ?? '0'),
        colorSpace: value['EXIF ColorSpace']?.printable,
        exifImageWidth:
            int.parse(value['EXIF ExifImageWidth']?.printable ?? '0'),
        exifImageLength:
            int.parse(value['EXIF ExifImageLength']?.printable ?? '0'),
        sensingMethod: value['EXIF SensingMethod']?.printable,
        sceneType: value['EXIF SceneType']?.printable,
        exposureMode: value['EXIF ExposureMode']?.printable,
        whiteBalance: value['EXIF WhiteBalance']?.printable,
        focalLengthIn35mmFilm:
            int.parse(value['EXIF FocalLengthIn35mmFilm']?.printable ?? '0'),
        lensSpecification:
            value['EXIF LensSpecification']?.values.toList() as List<Ratio>?,
        lensMake: value['EXIF LensMake']?.printable,
        lensModel: value['EXIF LensModel']?.printable,
        tag0xA460: int.parse(value['Tag 0xA460']?.printable ?? '0'),
      ),
    );

    double? latitude;
    double? longitude;

    if (test.GPS?.GPSLatitude != null) {
      latitude = (test.GPS!.GPSLatitudeRef == 'N' ? 1 : -1) *
          (test.GPS!.GPSLatitude![0].toDouble() +
              test.GPS!.GPSLatitude![1].toDouble() / 60 +
              test.GPS!.GPSLatitude![2].toDouble() / 3600);
      longitude = (test.GPS!.GPSLongitudeRef == 'E' ? 1 : -1) *
          (test.GPS!.GPSLongitude![0].toDouble() +
              test.GPS!.GPSLongitude![1].toDouble() / 60 +
              test.GPS!.GPSLongitude![2].toDouble() / 3600);
    }

    return MediaCompanion(
        serverId: Value(file.server.id),
        pathFile: Value(file.path!),
        mimeType: Value(file.mimeType!.contains('image')
            ? MediaMimeType.image.value
            : MediaMimeType.video.value),
        eTag: Value(file.eTag!),
        creationDate: Value(file.mTime!.toIso8601String()),
        latitude: Value(latitude),
        longitude: Value(longitude));
  }

  static Future<void> saveMediaInDatabase(MediaCompanion media) async {
    await database.insertMediaOnConflictUpdateEtag(
        media.serverId.value,
        media.eTag.value,
        media.mimeType.value,
        media.pathFile.value,
        media.creationDate.value,
        media.latitude.value,
        media.longitude.value);
  }
}
