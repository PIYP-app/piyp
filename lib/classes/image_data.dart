import 'package:exif/exif.dart';

class ExifGPS {
  String? GPSLatitudeRef;
  List<Ratio>? GPSLatitude;
  String? GPSLongitudeRef;
  List<Ratio>? GPSLongitude;
  int? GPSAltitudeRef;
  String? GPSAltitude;
  List<Ratio>? GPSTimeStamp;
  String? GPSSpeedRef;
  Ratio? GPSSpeed;
  String? GPSImgDirectionRef;
  String? GPSImgDirection;
  String? GPSDestBearingRef;
  String? GPSDestBearing;
  DateTime? GPSDate;
  int? Tag0x001F;

  ExifGPS({
    this.GPSLatitudeRef,
    this.GPSLatitude,
    this.GPSLongitudeRef,
    this.GPSLongitude,
    this.GPSAltitudeRef,
    this.GPSAltitude,
    this.GPSTimeStamp,
    this.GPSSpeedRef,
    this.GPSSpeed,
    this.GPSImgDirectionRef,
    this.GPSImgDirection,
    this.GPSDestBearingRef,
    this.GPSDestBearing,
    this.GPSDate,
    this.Tag0x001F,
  });
}

class ExifPhoto {
  String? exposureTime;
  String? fNumber;
  String? exposureProgram;
  int? isoSpeedRatings;
  String? exifVersion;
  String? dateTimeOriginal;
  String? dateTimeDigitized;
  String? offsetTime;
  String? offsetTimeOriginal;
  String? offsetTimeDigitized;
  String? shutterSpeedValue;
  String? apertureValue;
  String? brightnessValue;
  String? exposureBiasValue;
  String? meteringMode;
  String? flash;
  String? focalLength;
  List<int>? subjectArea;
  List<int>? makerNote;
  int? subSecTimeOriginal;
  int? subSecTimeDigitized;
  String? colorSpace;
  int? exifImageWidth;
  int? exifImageLength;
  String? sensingMethod;
  String? sceneType;
  String? exposureMode;
  String? whiteBalance;
  int? focalLengthIn35mmFilm;
  List<Ratio>? lensSpecification;
  String? lensMake;
  String? lensModel;
  int? tag0xA460;

  ExifPhoto({
    this.exposureTime,
    this.fNumber,
    this.exposureProgram,
    this.isoSpeedRatings,
    this.exifVersion,
    this.dateTimeOriginal,
    this.dateTimeDigitized,
    this.offsetTime,
    this.offsetTimeOriginal,
    this.offsetTimeDigitized,
    this.shutterSpeedValue,
    this.apertureValue,
    this.brightnessValue,
    this.exposureBiasValue,
    this.meteringMode,
    this.flash,
    this.focalLength,
    this.subjectArea,
    this.makerNote,
    this.subSecTimeOriginal,
    this.subSecTimeDigitized,
    this.colorSpace,
    this.exifImageWidth,
    this.exifImageLength,
    this.sensingMethod,
    this.sceneType,
    this.exposureMode,
    this.whiteBalance,
    this.focalLengthIn35mmFilm,
    this.lensSpecification,
    this.lensMake,
    this.lensModel,
    this.tag0xA460,
  });
}

class ImageExif {
  String? make;
  String? model;
  String? orientation;
  int? xResolution;
  int? yResolution;
  String? resolutionUnit;
  String? software;
  String? dateTime;
  String? hostComputer;
  int? tileWidth;
  int? tileLength;
  int? exifOffset;
  ExifGPS? GPS;
  ExifPhoto? EXIF;
  // Map<String, dynamic> MakerNote = {
  //   'Tag0x0001': 14,
  //   'Tag0x0002': [
  //     64, 0, 193, 0, 134, 0, 93, 0, 72, 0, 118, 0, 214, 0, 64, 0, 54, 0, 42, 0
  //     // More elements...
  //   ],
  //   'Tag0x0003': [
  //     6, 7, 8, 85, 102, 108, 97, 103, 115, 85, 118, 97, 108, 117, 101, 89, 116,
  //     105, 109, 101
  //     // More elements...
  //   ],
  //   // More tags...
  // };

  ImageExif({
    this.make,
    this.model,
    this.orientation,
    this.xResolution,
    this.yResolution,
    this.resolutionUnit,
    this.software,
    this.dateTime,
    this.hostComputer,
    this.tileWidth,
    this.tileLength,
    this.exifOffset,
    this.GPS,
    this.EXIF,
    // required this.MakerNote,
  });
}
