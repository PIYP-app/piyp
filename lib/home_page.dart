import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piyp/classes/image_data.dart';
import 'package:piyp/image_card.dart';
import 'package:piyp/source.dart';
import 'package:piyp/sources.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  Sources sources = Sources();
  int _firstVisibleItemIndex = 0;
  String? errorMessage;
  List<SourceFile> files = [];

  @override
  void initState() {
    super.initState();
    initScrollController();
    initSources();
  }

  void initSources() async {
    await sources.connectAllSources();

    if (!mounted) {
      return;
    }

    final List<Future<void>> sourcesFileRetrieve =
        sources.sources.map((source) {
      return source.retrieveFileList();
    }).toList();

    await Future.wait(sourcesFileRetrieve);

    setState(() {});
  }

  void scrollListenerWithItemCount() {
    int itemCount = files.length;
    double scrollOffset = _scrollController.position.pixels;
    double viewportHeight = _scrollController.position.viewportDimension;
    double scrollRange = _scrollController.position.maxScrollExtent -
        _scrollController.position.minScrollExtent;
    int firstVisibleItemIndex =
        (scrollOffset / (scrollRange + viewportHeight) * itemCount).floor();
    if (_firstVisibleItemIndex != firstVisibleItemIndex) {
      if (mounted) {
        setState(() {
          _firstVisibleItemIndex =
              firstVisibleItemIndex < 0 ? 0 : firstVisibleItemIndex;
        });
      }
    }
  }

  void initScrollController() {
    _scrollController.addListener(scrollListenerWithItemCount);
  }

  computeDay(DateTime? dateTime) {
    final DateTime definedDateTime = dateTime ?? DateTime.now();

    if (DateFormat.MMMd().format(definedDateTime) ==
        DateFormat.MMMd().format(DateTime.now())) {
      return 'Today';
    }
    return DateFormat.MMMMd().format(definedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (sources.sources.isEmpty) {
      return const Text('No source configured yet.');
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Text(sources.sources[0].files.isNotEmpty
              ? computeDay(
                  sources.sources[0].files[_firstVisibleItemIndex].mTime)
              : ''),
          toolbarHeight: 20,
        ),
        body: Center(
          child: errorMessage != null
              ? Text(errorMessage!)
              : (sources.sources[0].files.isEmpty
                  ? const CircularProgressIndicator()
                  : GridView.builder(
                      controller: _scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2),
                      padding: const EdgeInsets.only(
                          left: 2, right: 2, bottom: 2, top: 100),
                      itemCount: sources.sources[0].files.length,
                      itemBuilder: (context, index) {
                        // client.client.read(client.files[index].path!).then(
                        //     (value) => readExifFromBytes(value).then((value) {
                        //           final test = ImageExif(
                        //             make: value['Image Make']?.printable ?? '',
                        //             model: value['Image Model']?.printable,
                        //             orientation:
                        //                 value['Image Orientation']?.printable,
                        //             xResolution: int.parse(
                        //                 value['Image XResolution']?.printable ??
                        //                     '0'),
                        //             yResolution: int.parse(
                        //                 value['Image YResolution']?.printable ??
                        //                     '0'),
                        //             resolutionUnit:
                        //                 value['Image ResolutionUnit']
                        //                     ?.printable,
                        //             software:
                        //                 value['Image Software']?.printable,
                        //             dateTime:
                        //                 value['Image DateTime']?.printable,
                        //             hostComputer:
                        //                 value['Image HostComputer']?.printable,
                        //             tileWidth:
                        //                 0, // int.parse(value['Image TileWidth']?.printable),
                        //             tileLength:
                        //                 0, // int.parse(value['Image TileLength']?.printable),
                        //             exifOffset: int.parse(
                        //                 value['Image ExifOffset']?.printable ??
                        //                     '0'),
                        //             GPS: ExifGPS(
                        //                 GPSLatitudeRef: value['GPS GPSLatitudeRef']
                        //                     ?.printable,
                        //                 GPSLatitude: value['GPS GPSLatitude']
                        //                     ?.values
                        //                     .toList() as List<Ratio>?,
                        //                 GPSLongitudeRef: value['GPS GPSLongitudeRef']
                        //                     ?.printable,
                        //                 GPSLongitude: value['GPS GPSLongitude']
                        //                     ?.values
                        //                     .toList() as List<Ratio>?,
                        //                 GPSAltitudeRef: int.parse(
                        //                     value['GPS GPSAltitudeRef']?.printable ??
                        //                         '0'),
                        //                 GPSAltitude:
                        //                     value['GPS GPSAltitude']?.printable,
                        //                 GPSTimeStamp: value['GPS GPSTimeStamp']
                        //                     ?.values
                        //                     .toList() as List<Ratio>?,
                        //                 GPSSpeedRef:
                        //                     value['GPS GPSSpeedRef']?.printable,
                        //                 GPSSpeed: value['GPS GPSSpeed']?.values.toList()[0] as Ratio?,
                        //                 GPSImgDirectionRef: value['GPS GPSImgDirectionRef']?.printable,
                        //                 GPSImgDirection: value['GPS GPSImgDirection']?.printable,
                        //                 GPSDestBearingRef: value['GPS GPSDestBearingRef']?.printable,
                        //                 GPSDestBearing: value['GPS GPSDestBearing']?.printable,
                        //                 GPSDate: value['GPS GPSDate'] != null ? DateTime.parse(value['GPS GPSDate']!.printable.replaceAll(':', '-')) : null,
                        //                 Tag0x001F: int.parse(value['Tag 0x001F']?.printable ?? '0')),
                        //             EXIF: ExifPhoto(
                        //               exposureTime:
                        //                   value['EXIF ExposureTime']?.printable,
                        //               fNumber: value['EXIF FNumber']?.printable,
                        //               exposureProgram:
                        //                   value['EXIF ExposureProgram']
                        //                       ?.printable,
                        //               isoSpeedRatings: int.parse(
                        //                   value['EXIF ISOSpeedRatings']
                        //                           ?.printable ??
                        //                       '0'),
                        //               exifVersion:
                        //                   value['EXIF ExifVersion']?.printable,
                        //               dateTimeOriginal:
                        //                   value['EXIF DateTimeOriginal']
                        //                       ?.printable,
                        //               dateTimeDigitized:
                        //                   value['EXIF DateTimeDigitized']
                        //                       ?.printable,
                        //               offsetTime:
                        //                   value['EXIF OffsetTime']?.printable,
                        //               offsetTimeOriginal:
                        //                   value['EXIF OffsetTimeOriginal']
                        //                       ?.printable,
                        //               offsetTimeDigitized:
                        //                   value['EXIF OffsetTimeDigitized']
                        //                       ?.printable,
                        //               shutterSpeedValue:
                        //                   value['EXIF ShutterSpeedValue']
                        //                       ?.printable,
                        //               apertureValue: value['EXIF ApertureValue']
                        //                   ?.printable,
                        //               brightnessValue:
                        //                   value['EXIF BrightnessValue']
                        //                       ?.printable,
                        //               exposureBiasValue:
                        //                   value['EXIF ExposureBiasValue']
                        //                       ?.printable,
                        //               meteringMode:
                        //                   value['EXIF MeteringMode']?.printable,
                        //               flash: value['EXIF Flash']?.printable,
                        //               focalLength:
                        //                   value['EXIF FocalLength']?.printable,
                        //               subjectArea: value['EXIF SubjectArea']
                        //                   ?.values
                        //                   .toList() as List<int>?,
                        //               makerNote: value['EXIF MakerNote']
                        //                   ?.values
                        //                   .toList() as List<int>?,
                        //               subSecTimeOriginal: int.parse(
                        //                   value['EXIF SubSecTimeOriginal']
                        //                           ?.printable ??
                        //                       '0'),
                        //               subSecTimeDigitized: int.parse(
                        //                   value['EXIF SubSecTimeDigitized']
                        //                           ?.printable ??
                        //                       '0'),
                        //               colorSpace:
                        //                   value['EXIF ColorSpace']?.printable,
                        //               exifImageWidth: int.parse(
                        //                   value['EXIF ExifImageWidth']
                        //                           ?.printable ??
                        //                       '0'),
                        //               exifImageLength: int.parse(
                        //                   value['EXIF ExifImageLength']
                        //                           ?.printable ??
                        //                       '0'),
                        //               sensingMethod: value['EXIF SensingMethod']
                        //                   ?.printable,
                        //               sceneType:
                        //                   value['EXIF SceneType']?.printable,
                        //               exposureMode:
                        //                   value['EXIF ExposureMode']?.printable,
                        //               whiteBalance:
                        //                   value['EXIF WhiteBalance']?.printable,
                        //               focalLengthIn35mmFilm: int.parse(
                        //                   value['EXIF FocalLengthIn35mmFilm']
                        //                           ?.printable ??
                        //                       '0'),
                        //               lensSpecification:
                        //                   value['EXIF LensSpecification']
                        //                       ?.values
                        //                       .toList() as List<Ratio>?,
                        //               lensMake:
                        //                   value['EXIF LensMake']?.printable,
                        //               lensModel:
                        //                   value['EXIF LensModel']?.printable,
                        //               tag0xA460: int.parse(
                        //                   value['Tag 0xA460']?.printable ??
                        //                       '0'),
                        //             ),
                        //           );

                        //           if (test.GPS?.GPSLatitude != null) {
                        //             print(test);
                        //           }
                        //         }));
                        return ImageCard(
                          file: sources.sources[0].files[index],
                        );
                      })),
        ));
  }
}
