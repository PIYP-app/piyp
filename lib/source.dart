import 'package:drift/drift.dart';
import 'package:exif/exif.dart';
import 'package:piyp/classes/image_data.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/enum.dart';

class SourceFile {
  Source server;
  String? path;
  bool? isDir;
  String? name;
  String? mimeType;
  int? size;
  String? eTag;
  DateTime? cTime;
  DateTime? mTime;

  MediaCompanion toCompanion() {
    final fileCompanion = MediaCompanion.insert(
      serverId: server.id,
      eTag: eTag!,
      mimeType: mimeType!,
      pathFile: path!,
      creationDate: mTime!.toIso8601String(),
    );

    return fileCompanion;
  }

  Future<MediaCompanion> readExifFromFile() async {
    final List<int> fileData = await server.read(path!);
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
        serverId: Value(server.id),
        pathFile: Value(path!),
        mimeType: Value(mimeType!.contains('image')
            ? MediaMimeType.image.value
            : MediaMimeType.video.value),
        eTag: Value(eTag!),
        creationDate: Value(mTime!.toIso8601String()),
        latitude: Value(latitude),
        longitude: Value(longitude));
  }

  SourceFile({
    required this.server,
    this.path,
    this.isDir,
    this.name,
    this.mimeType,
    this.size,
    this.eTag,
    this.cTime,
    this.mTime,
  });
}

abstract class Source {
  final int id;
  List<SourceFile> files = [];
  bool isErrored = false;

  Source(this.id);

  get username => null;
  get pwd => null;

  String getBaseUrl();

  Future<List<int>> read(String path);
  Future<void> retrieveFileList();
  Future<void> testServerConnection();
}
