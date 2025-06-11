import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/image_card.dart';
import 'package:piyp/places_page.dart';

class PlaceDetailPage extends StatefulWidget {
  final String placeName;
  final PlaceGroup place;

  const PlaceDetailPage({
    super.key,
    required this.placeName,
    required this.place,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  final ScrollController _scrollController = ScrollController();
  List<MediaCompanion> files = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadPhotos() {
    // Convert MediaData to MediaCompanion for compatibility with ImageCard
    files =
        widget.place.photos.map((media) => media.toCompanion(false)).toList();

    // Sort by creation date (newest first)
    files.sort((a, b) => DateTime.parse(b.creationDate.value)
        .compareTo(DateTime.parse(a.creationDate.value)));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.placeName,
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '${files.length} photo${files.length > 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              // Navigate to map view focused on this location
              context.push(
                  '/maps?lat=${widget.place.latitude}&lng=${widget.place.longitude}');
            },
            tooltip: 'View on map',
          ),
        ],
      ),
      body: files.isEmpty
          ? const Center(
              child: Text('No photos found for this location'),
            )
          : GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              padding: const EdgeInsets.all(2),
              itemCount: files.length,
              itemBuilder: (context, index) {
                return ImageCard(file: files[index]);
              },
            ),
    );
  }
}
