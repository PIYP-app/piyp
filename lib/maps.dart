import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/init_db.dart';
import 'package:piyp/maps/media_marker.dart';
import 'package:go_router/go_router.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class MediaWithGeoPoint {
  final MediaData media;
  final GeoPoint geoPoint;

  MediaWithGeoPoint({required this.media, required this.geoPoint});
}

class _MapPageState extends State<MapPage> with OSMMixinObserver {
  late MapController _mapController;
  List<MediaWithGeoPoint> _imageLocations = [];
  bool mapIsDisposed = false;
  List<StaticPositionGeoPoint> staticPoints = <StaticPositionGeoPoint>[];
  ValueNotifier<bool> showFab = ValueNotifier(true);
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _mapController = MapController.withUserPosition();
    _mapController.addObserver(this);
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    await _loadImageLocations();
  }

  Future<void> _loadImageLocations() async {
    try {
      final medias = await database.select(database.media).get();
      setState(() {
        _imageLocations = medias
            .where((img) => img.latitude != null && img.longitude != null)
            .map((img) => MediaWithGeoPoint(
                media: img,
                geoPoint: GeoPoint(
                  latitude: img.latitude!,
                  longitude: img.longitude!,
                )))
            .toList();
      });
      await _addMarkers();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading image locations: $e');
      }
    }
  }

  Future<void> _addMarkers() async {
    for (final location in _imageLocations) {
      if (mapIsDisposed) {
        return;
      }
      try {
        await _mapController.addMarker(location.geoPoint,
            markerIcon: MarkerIcon(
              iconWidget: MediaMarker(eTag: location.media.eTag),
            ));
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error adding marker: $e');
        }
      }
    }
  }

  MediaWithGeoPoint? _findImageLocationFromGeoPoint(GeoPoint geoPoint) {
    return _imageLocations.firstWhereOrNull(
      (location) =>
          location.geoPoint.latitude == geoPoint.latitude &&
          location.geoPoint.longitude == geoPoint.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Locations'),
      ),
      body: OSMFlutter(
          controller: _mapController,
          onMapIsReady: mapIsReady,
          onGeoPointClicked: (geoPoint) {
            final retrievedMedia = _findImageLocationFromGeoPoint(geoPoint);

            if (retrievedMedia != null) {
              final mediaType = retrievedMedia.media.mimeType.contains('video')
                  ? 'videos'
                  : 'images';

              context.push(Uri(path: '/$mediaType/${retrievedMedia.media.eTag}')
                  .toString());
            }
          },
          osmOption: const OSMOption(
            userTrackingOption: UserTrackingOption(
              enableTracking: false,
            ),
            zoomOption: ZoomOption(
              initZoom: 2,
              minZoomLevel: 2,
              maxZoomLevel: 18,
              stepZoom: 1.0,
            ),
          )),
    );
  }

  @override
  void dispose() {
    if (!mapIsDisposed) {
      _mapController.dispose();
      mapIsDisposed = true;
    }
    super.dispose();
  }
}
