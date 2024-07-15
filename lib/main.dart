import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:piyp/image_card.dart';
import 'package:piyp/thumbnail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdav_client/webdav_client.dart';

setSharedPreferences() async {
  try {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('webdav_uri', '');
    await preferences.setString('webdav_user', '');
    await preferences.setString('webdav_password', '');
  } catch (error) {
    print('Error setting shared preferences: $error');
  }
}

void main() {
  runApp(const MyApp());
  Thumbnail.initThumbnailFolder();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File>? files;
  Client? client;

  @override
  void initState() {
    super.initState();
    initWebdavClient();
  }

  initWebdavClient() async {
    await setSharedPreferences();
    final preferences = await SharedPreferences.getInstance();

    client = Client(
      uri: preferences.getString('webdav_uri')!,
      c: WdDio(),
      auth: BasicAuth(
          user: preferences.getString('webdav_user')!,
          pwd: preferences.getString('webdav_password')!),
    );

    await retrieveFileList();
  }

  retrieveFileList() async {
    client!.setHeaders({'Accept-Charset': 'utf-8'});
    client!.setConnectTimeout(8000);
    client!.setSendTimeout(8000);
    client!.setReceiveTimeout(8000);

    var list = await client!.readDir('/Photos');

    setState(() {
      files = list;
      files!.sort((a, b) => b.mTime!.compareTo(a.mTime!));
    });
  }

  void _incrementCounter() {
    retrieveFileList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: files != null
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  padding: const EdgeInsets.all(2),
                  itemCount: files!.length,
                  itemBuilder: (context, index) {
                    // client.read(files![index].path!).then((value) =>
                    //     readExifFromBytes(value).then((value) {
                    //       final test = ImageExif(
                    //         make: value['Image Make']?.printable ?? '',
                    //         model: value['Image Model']?.printable,
                    //         orientation: value['Image Orientation']?.printable,
                    //         xResolution: int.parse(
                    //             value['Image XResolution']?.printable ?? '0'),
                    //         yResolution: int.parse(
                    //             value['Image YResolution']?.printable ?? '0'),
                    //         resolutionUnit:
                    //             value['Image ResolutionUnit']?.printable,
                    //         software: value['Image Software']?.printable,
                    //         dateTime: value['Image DateTime']?.printable,
                    //         hostComputer:
                    //             value['Image HostComputer']?.printable,
                    //         tileWidth:
                    //             0, // int.parse(value['Image TileWidth']?.printable),
                    //         tileLength:
                    //             0, // int.parse(value['Image TileLength']?.printable),
                    //         exifOffset: int.parse(
                    //             value['Image ExifOffset']?.printable ?? '0'),
                    //         GPS: ExifGPS(
                    //             GPSLatitudeRef:
                    //                 value['GPS GPSLatitudeRef']?.printable,
                    //             GPSLatitude: value['GPS GPSLatitude']?.values.toList()
                    //                 as List<Ratio>?,
                    //             GPSLongitudeRef:
                    //                 value['GPS GPSLongitudeRef']?.printable,
                    //             GPSLongitude: value['GPS GPSLongitude']?.values.toList()
                    //                 as List<Ratio>?,
                    //             GPSAltitudeRef: int.parse(
                    //                 value['GPS GPSAltitudeRef']?.printable ??
                    //                     '0'),
                    //             GPSAltitude:
                    //                 value['GPS GPSAltitude']?.printable,
                    //             GPSTimeStamp: value['GPS GPSTimeStamp']
                    //                 ?.values
                    //                 .toList() as List<Ratio>?,
                    //             GPSSpeedRef:
                    //                 value['GPS GPSSpeedRef']?.printable,
                    //             GPSSpeed: value['GPS GPSSpeed']?.values.toList()[0]
                    //                 as Ratio?,
                    //             GPSImgDirectionRef:
                    //                 value['GPS GPSImgDirectionRef']?.printable,
                    //             GPSImgDirection: value['GPS GPSImgDirection']?.printable,
                    //             GPSDestBearingRef: value['GPS GPSDestBearingRef']?.printable,
                    //             GPSDestBearing: value['GPS GPSDestBearing']?.printable,
                    //             GPSDate: value['GPS GPSDate'] != null ? DateTime.parse(value['GPS GPSDate']!.printable.replaceAll(':', '-')) : null,
                    //             Tag0x001F: int.parse(value['Tag 0x001F']?.printable ?? '0')),
                    //         EXIF: ExifPhoto(
                    //           exposureTime:
                    //               value['EXIF ExposureTime']?.printable,
                    //           fNumber: value['EXIF FNumber']?.printable,
                    //           exposureProgram:
                    //               value['EXIF ExposureProgram']?.printable,
                    //           isoSpeedRatings: int.parse(
                    //               value['EXIF ISOSpeedRatings']?.printable ??
                    //                   '0'),
                    //           exifVersion: value['EXIF ExifVersion']?.printable,
                    //           dateTimeOriginal:
                    //               value['EXIF DateTimeOriginal']?.printable,
                    //           dateTimeDigitized:
                    //               value['EXIF DateTimeDigitized']?.printable,
                    //           offsetTime: value['EXIF OffsetTime']?.printable,
                    //           offsetTimeOriginal:
                    //               value['EXIF OffsetTimeOriginal']?.printable,
                    //           offsetTimeDigitized:
                    //               value['EXIF OffsetTimeDigitized']?.printable,
                    //           shutterSpeedValue:
                    //               value['EXIF ShutterSpeedValue']?.printable,
                    //           apertureValue:
                    //               value['EXIF ApertureValue']?.printable,
                    //           brightnessValue:
                    //               value['EXIF BrightnessValue']?.printable,
                    //           exposureBiasValue:
                    //               value['EXIF ExposureBiasValue']?.printable,
                    //           meteringMode:
                    //               value['EXIF MeteringMode']?.printable,
                    //           flash: value['EXIF Flash']?.printable,
                    //           focalLength: value['EXIF FocalLength']?.printable,
                    //           subjectArea: value['EXIF SubjectArea']
                    //               ?.values
                    //               .toList() as List<int>?,
                    //           makerNote: value['EXIF MakerNote']
                    //               ?.values
                    //               .toList() as List<int>?,
                    //           subSecTimeOriginal: int.parse(
                    //               value['EXIF SubSecTimeOriginal']?.printable ??
                    //                   '0'),
                    //           subSecTimeDigitized: int.parse(
                    //               value['EXIF SubSecTimeDigitized']
                    //                       ?.printable ??
                    //                   '0'),
                    //           colorSpace: value['EXIF ColorSpace']?.printable,
                    //           exifImageWidth: int.parse(
                    //               value['EXIF ExifImageWidth']?.printable ??
                    //                   '0'),
                    //           exifImageLength: int.parse(
                    //               value['EXIF ExifImageLength']?.printable ??
                    //                   '0'),
                    //           sensingMethod:
                    //               value['EXIF SensingMethod']?.printable,
                    //           sceneType: value['EXIF SceneType']?.printable,
                    //           exposureMode:
                    //               value['EXIF ExposureMode']?.printable,
                    //           whiteBalance:
                    //               value['EXIF WhiteBalance']?.printable,
                    //           focalLengthIn35mmFilm: int.parse(
                    //               value['EXIF FocalLengthIn35mmFilm']
                    //                       ?.printable ??
                    //                   '0'),
                    //           lensSpecification: value['EXIF LensSpecification']
                    //               ?.values
                    //               .toList() as List<Ratio>?,
                    //           lensMake: value['EXIF LensMake']?.printable,
                    //           lensModel: value['EXIF LensModel']?.printable,
                    //           tag0xA460: int.parse(
                    //               value['Tag 0xA460']?.printable ?? '0'),
                    //         ),
                    //       );
                    //     }));
                    return Padding(
                        padding: const EdgeInsets.all(0),
                        child: ImageCard(
                          file: files![index],
                          webdavClient: client!,
                        ));
                  })
              : const SizedBox()),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
