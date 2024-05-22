import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:piyp/classes/image_data.dart';
import 'package:webdav_client/webdav_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File>? files;
  var client = newClient(
    'WEBDAV_URL',
    user: 'USER',
    password: 'PASSWORD',
    debug: false,
  );

  @override
  void initState() {
    super.initState();
    retrieveFileList();
  }

  retrieveFileList() async {
    // Set the public request headers
    client.setHeaders({'accept-charset': 'utf-8'});

    // Set the connection server timeout time in milliseconds.
    client.setConnectTimeout(8000);

    // Set send data timeout time in milliseconds.
    client.setSendTimeout(8000);

    // Set transfer data time in milliseconds.
    client.setReceiveTimeout(8000);

    // try {
    //   await client.ping();
    // } catch (e) {
    //   print('$e');
    // }

    var list = await client.readDir('/Photos');

    setState(() {
      files = list;
      files!.sort((a, b) => b.mTime!.compareTo(a.mTime!));
    });
    // print(list.map((e) => e.name).toList());
  }

  void _incrementCounter() {
    retrieveFileList();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: files != null
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: files!.length,
                  itemBuilder: (context, index) {
                    // client.read(files![index].path!).then((value) =>
                    //     readExifFromBytes(value).then((value) {
                    //       print(value);
                    //       final test = ImageExif(
                    //         make: value['Image Make']!.printable,
                    //         model: value['Image Model']!.printable,
                    //         orientation: value['Image Orientation']!.printable,
                    //         xResolution: int.parse(
                    //             value['Image XResolution']!.printable),
                    //         yResolution: int.parse(
                    //             value['Image YResolution']!.printable),
                    //         resolutionUnit:
                    //             value['Image ResolutionUnit']!.printable,
                    //         software: value['Image Software']!.printable,
                    //         dateTime: value['Image DateTime']!.printable,
                    //         hostComputer:
                    //             value['Image Host Computer']?.printable,
                    //         tileWidth:
                    //             int.parse(value['Image TileWidth']!.printable),
                    //         tileLength:
                    //             int.parse(value['Image TileLength']!.printable),
                    //         exifOffset:
                    //             int.parse(value['Image ExifOffset']!.printable),
                    //         GPS: ExifGPS(GPSLatitudeRef: value['GPS GPSLatitudeRef']!.printable, GPSLatitude: GPSLatitude, GPSLongitudeRef: GPSLongitudeRef, GPSLongitude: GPSLongitude, GPSAltitudeRef: GPSAltitudeRef, GPSAltitude: GPSAltitude, GPSTimeStamp: GPSTimeStamp, GPSSpeedRef: GPSSpeedRef, GPSSpeed: GPSSpeed, GPSImgDirectionRef: GPSImgDirectionRef, GPSImgDirection: GPSImgDirection, GPSDestBearingRef: GPSDestBearingRef, GPSDestBearing: GPSDestBearing, GPSDate: GPSDate, Tag0x001F: Tag0x001F),
                    //         // EXIF: value['EXIF']!.printable,
                    //       );
                    //       print(value['GPS GPSLatitudeRef']!.printable);
                    //     }));
                    return Padding(
                        padding: const EdgeInsets.all(8),
                        child: !files![index].mimeType!.contains('video')
                            ? CachedNetworkImage(
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.width / 3,
                                fit: BoxFit.cover,
                                imageUrl: 'WEBDAV_URL${files![index].path!}',
                                httpHeaders: {
                                  'Authorization':
                                      'Basic ${base64.encode(utf8.encode('USER:PASSWORD'))}'
                                },
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : const SizedBox());
                  })
              : const SizedBox()),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
