import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/image_card.dart';
import 'package:piyp/init_db.dart';
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
  List<MediaCompanion> files = [];

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

    setState(() {});

    List<MediaData> dbMedias = await database.select(database.media).get();

    List<MediaCompanion> dbMediasCompanion =
        dbMedias.map((media) => media.toCompanion(false)).toList();

    dbMediasCompanion.sort((a, b) => DateTime.parse(b.creationDate.value)
        .compareTo(DateTime.parse(a.creationDate.value)));

    setState(() {
      files = dbMediasCompanion;
    });

    await sources.retrieveAllFiles();
    final sourcesMedias = sources.getAllFiles();

    List<MediaCompanion> sourcesMediasCompanion =
        sourcesMedias.map((media) => media.toCompanion()).toList();

    sourcesMediasCompanion.removeWhere((media) =>
        dbMediasCompanion.indexWhere((dbMedia) => dbMedia.eTag == media.eTag) !=
        -1);

    dbMediasCompanion.addAll(sourcesMediasCompanion);

    dbMediasCompanion.sort((a, b) => DateTime.parse(b.creationDate.value)
        .compareTo(DateTime.parse(a.creationDate.value)));

    setState(() {
      files = dbMediasCompanion;
    });
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
          title: Text(files.isNotEmpty
              ? computeDay(DateTime.parse(
                  files[_firstVisibleItemIndex].creationDate.value))
              : ''),
          toolbarHeight: 20,
        ),
        body: Center(
          child: errorMessage != null
              ? Text(errorMessage!)
              : (files.isEmpty
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
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        return ImageCard(
                          file: files[index],
                        );
                      })),
        ));
  }
}
