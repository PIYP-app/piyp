import 'package:drift/drift.dart' hide Column;
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
  bool isLoading = true;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    initScrollController();
    loadMedia();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadMedia() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await initSources();
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load media: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> refreshMedia() async {
    if (isRefreshing) return;

    setState(() {
      isRefreshing = true;
      errorMessage = null;
    });

    try {
      await initSources();
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to refresh media: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isRefreshing = false;
        });
      }
    }
  }

  Future<void> initSources() async {
    try {
      await sources.connectAllSources();

      if (!mounted) return;

      // Load from database first for faster initial display
      List<MediaData> dbMedias = await (database.select(database.media)
            ..orderBy([(m) => OrderingTerm.desc(m.creationDate)]))
          .get();
      List<MediaCompanion> dbMediasCompanion =
          dbMedias.map((media) => media.toCompanion(false)).toList();

      if (mounted) {
        setState(() {
          files = dbMediasCompanion;
          isLoading = false;
        });
      }

      // Then sync with remote sources
      await sources.retrieveAllFiles();
      final sourcesMedias = sources.getAllFiles();

      List<MediaCompanion> sourcesMediasCompanion =
          sourcesMedias.map((media) => media.toCompanion()).toList();

      sourcesMediasCompanion.removeWhere((media) =>
          dbMediasCompanion
              .indexWhere((dbMedia) => dbMedia.eTag == media.eTag) !=
          -1);

      dbMediasCompanion.addAll(sourcesMediasCompanion);

      dbMediasCompanion.sort((a, b) => DateTime.parse(b.creationDate.value)
          .compareTo(DateTime.parse(a.creationDate.value)));

      if (mounted) {
        setState(() {
          files = dbMediasCompanion;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  void scrollListenerWithItemCount() {
    if (!_scrollController.hasClients) return;

    int itemCount = files.length;
    if (itemCount == 0) return;

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

  String computeDay(DateTime? dateTime) {
    final DateTime definedDateTime = dateTime ?? DateTime.now();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime fileDate = DateTime(
        definedDateTime.year, definedDateTime.month, definedDateTime.day);

    if (fileDate == today) {
      return 'Today';
    } else if (fileDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat.MMMMd().format(definedDateTime);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No photos found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a WebDAV source in settings to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.red[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'Unknown error occurred',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: loadMedia,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (sources.sources.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No sources configured',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Configure a WebDAV server in settings to start organizing your photos',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
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
        title: Text(
          files.isNotEmpty && _firstVisibleItemIndex < files.length
              ? computeDay(DateTime.parse(
                  files[_firstVisibleItemIndex].creationDate.value))
              : '',
        ),
        toolbarHeight: 20,
        actions: [
          if (!isLoading)
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: isRefreshing ? Colors.grey : Colors.white,
              ),
              onPressed: isRefreshing ? null : refreshMedia,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: errorMessage != null
          ? _buildErrorState()
          : isLoading
              ? const Center(child: CircularProgressIndicator())
              : files.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: refreshMedia,
                      child: GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        padding: const EdgeInsets.only(
                          left: 2,
                          right: 2,
                          bottom: 2,
                          top: 100,
                        ),
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          return ImageCard(file: files[index]);
                        },
                      ),
                    ),
    );
  }
}
