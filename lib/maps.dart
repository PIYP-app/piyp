import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:piyp/init_db.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController _mapController;
  List<GeoPoint> _imageLocations = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController.withUserPosition();
    _loadImageLocations();
  }

  Future<void> _loadImageLocations() async {
    final medias = await database.select(database.media).get();
    setState(() {
      _imageLocations = medias
          .where((img) => img.latitude != null && img.longitude != null)
          .map((img) => GeoPoint(
                latitude: img.latitude!,
                longitude: img.longitude!,
              ))
          .toList();
    });
    _addMarkers();
  }

  Future<void> _addMarkers() async {
    for (final location in _imageLocations) {
      await _mapController.addMarker(
        location,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.photo,
            color: Colors.white,
            size: 48,
          ),
        ),
      );
    }
    if (_imageLocations.isNotEmpty) {
      await _mapController.setZoom(zoomLevel: 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Locations'),
      ),
      body: OSMFlutter(
          controller: _mapController,
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
    _mapController.dispose();
    super.dispose();
  }
}
