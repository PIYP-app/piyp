class ExifGPS {
  String GPSLatitudeRef;
  List<double> GPSLatitude;
  String GPSLongitudeRef;
  List<double> GPSLongitude;
  int GPSAltitudeRef;
  String GPSAltitude;
  List<double> GPSTimeStamp;
  String GPSSpeedRef;
  int GPSSpeed;
  String GPSImgDirectionRef;
  String GPSImgDirection;
  String GPSDestBearingRef;
  String GPSDestBearing;
  DateTime GPSDate;
  int Tag0x001F;

  ExifGPS({
    required this.GPSLatitudeRef,
    required this.GPSLatitude,
    required this.GPSLongitudeRef,
    required this.GPSLongitude,
    required this.GPSAltitudeRef,
    required this.GPSAltitude,
    required this.GPSTimeStamp,
    required this.GPSSpeedRef,
    required this.GPSSpeed,
    required this.GPSImgDirectionRef,
    required this.GPSImgDirection,
    required this.GPSDestBearingRef,
    required this.GPSDestBearing,
    required this.GPSDate,
    required this.Tag0x001F,
  });
}

class ExifPhoto {
  String exposureTime;
  String fNumber;
  String exposureProgram;
  int isoSpeedRatings;
  String exifVersion;
  String dateTimeOriginal;
  String dateTimeDigitized;
  String offsetTime;
  String offsetTimeOriginal;
  String offsetTimeDigitized;
  String shutterSpeedValue;
  String apertureValue;
  String brightnessValue;
  String exposureBiasValue;
  String meteringMode;
  String flash;
  String focalLength;
  List<int> subjectArea;
  List<int> makerNote;
  int subSecTimeOriginal;
  int subSecTimeDigitized;
  String colorSpace;
  int exifImageWidth;
  int exifImageLength;
  String sensingMethod;
  String sceneType;
  String exposureMode;
  String whiteBalance;
  int focalLengthIn35mmFilm;
  List<String> lensSpecification;
  String lensMake;
  String lensModel;
  int tag0xA460;

  ExifPhoto({
    required this.exposureTime,
    required this.fNumber,
    required this.exposureProgram,
    required this.isoSpeedRatings,
    required this.exifVersion,
    required this.dateTimeOriginal,
    required this.dateTimeDigitized,
    required this.offsetTime,
    required this.offsetTimeOriginal,
    required this.offsetTimeDigitized,
    required this.shutterSpeedValue,
    required this.apertureValue,
    required this.brightnessValue,
    required this.exposureBiasValue,
    required this.meteringMode,
    required this.flash,
    required this.focalLength,
    required this.subjectArea,
    required this.makerNote,
    required this.subSecTimeOriginal,
    required this.subSecTimeDigitized,
    required this.colorSpace,
    required this.exifImageWidth,
    required this.exifImageLength,
    required this.sensingMethod,
    required this.sceneType,
    required this.exposureMode,
    required this.whiteBalance,
    required this.focalLengthIn35mmFilm,
    required this.lensSpecification,
    required this.lensMake,
    required this.lensModel,
    required this.tag0xA460,
  });
}

class ImageExif {
  String make;
  String model;
  String orientation;
  int xResolution;
  int yResolution;
  String resolutionUnit;
  String software;
  String dateTime;
  String? hostComputer;
  int tileWidth;
  int tileLength;
  int exifOffset;
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
    required this.make,
    required this.model,
    required this.orientation,
    required this.xResolution,
    required this.yResolution,
    required this.resolutionUnit,
    required this.software,
    required this.dateTime,
    this.hostComputer,
    required this.tileWidth,
    required this.tileLength,
    required this.exifOffset,
    this.GPS,
    this.EXIF,
    // required this.MakerNote,
  });
}
