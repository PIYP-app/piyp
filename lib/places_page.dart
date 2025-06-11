import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:piyp/database/database.dart';
import 'package:piyp/init_db.dart';
import 'package:piyp/thumbnail.dart';
import 'package:http/http.dart' as http;

class PlaceGroup {
  final String placeId;
  final String name;
  final List<MediaData> photos;
  final double latitude;
  final double longitude;
  final String? country;

  PlaceGroup({
    required this.placeId,
    required this.name,
    required this.photos,
    required this.latitude,
    required this.longitude,
    this.country,
  });
}

class PlacesPage extends StatefulWidget {
  const PlacesPage({super.key});

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  List<PlaceGroup> places = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // First, process any media without placeId
      _processMediaWithoutPlaceId();

      // Then load places from database
      await _loadPlacesFromDatabase();
    } catch (e) {
      debugPrint('Failed to load places: $e');
      setState(() {
        errorMessage = 'Failed to load places: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _processMediaWithoutPlaceId() async {
    // Get all media with location but no placeId
    final mediaWithoutPlaceId = await (database.select(database.media)
          ..where((m) =>
              m.latitude.isNotNull() &
              m.longitude.isNotNull() &
              m.placeId.isNull()))
        .get();

    if (mediaWithoutPlaceId.isEmpty) return;

    debugPrint(
        'Processing ${mediaWithoutPlaceId.length} media items without placeId');

    for (final media in mediaWithoutPlaceId) {
      try {
        final placeData =
            await _getPlaceData(media.latitude!, media.longitude!);

        // Insert or update place in database
        await database.insertOrUpdatePlace(
          placeData['id'],
          placeData['name'],
          placeData['latitude'],
          placeData['longitude'],
          placeData['country'],
        );

        // Update media with placeId
        await (database.update(database.media)
              ..where((m) => m.id.equals(media.id)))
            .write(MediaCompanion(placeId: Value(placeData['id'])));

        await _loadPlacesFromDatabase();
      } catch (e) {
        debugPrint('Failed to process media ${media.id}: $e');
        // Continue with next media item
      }
    }
  }

  Future<void> _loadPlacesFromDatabase() async {
    // Get all places with their media count
    const query = '''
      SELECT p.id, p.name, p.latitude, p.longitude, p.country, COUNT(m.id) as photo_count
      FROM Places p
      LEFT JOIN Media m ON p.id = m.placeId
      GROUP BY p.id, p.name, p.latitude, p.longitude, p.country
      HAVING photo_count > 0
      ORDER BY photo_count DESC
    ''';

    try {
      final result = await database.customSelect(query).get();

      final List<PlaceGroup> loadedPlaces = [];

      for (final row in result) {
        final placeId = row.read<String>('id');
        final name = row.read<String>('name');
        final latitude = row.read<double>('latitude');
        final longitude = row.read<double>('longitude');
        final country = row.read<String?>('country');

        // Get photos for this place
        final photos = await (database.select(database.media)
              ..where((m) => m.placeId.equals(placeId))
              ..orderBy([(m) => OrderingTerm.desc(m.creationDate)]))
            .get();

        if (photos.isNotEmpty) {
          loadedPlaces.add(PlaceGroup(
            placeId: placeId,
            name: name,
            photos: photos,
            latitude: latitude,
            longitude: longitude,
            country: country,
          ));
        }
      }

      setState(() {
        places = loadedPlaces;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to load places: $e');
    }
  }

  Future<Map<String, dynamic>> _getPlaceData(
      double latitude, double longitude) async {
    try {
      // Use OpenStreetMap Nominatim API for reverse geocoding
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=10&addressdetails=1',
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'PIYP Flutter App/1.0 (contact@example.com)',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Extract place name and create unique ID
        final placeName = _extractPlaceNameFromNominatim(data);
        final placeId = _generatePlaceId(data);
        final country = _extractCountry(data);

        return {
          'id': placeId,
          'name': placeName,
          'latitude': latitude,
          'longitude': longitude,
          'country': country,
        };
      }
    } catch (e) {
      debugPrint('Geocoding failed for $latitude, $longitude: $e');
    }

    // Fallback to coordinate-based data
    final latDirection = latitude >= 0 ? 'N' : 'S';
    final lonDirection = longitude >= 0 ? 'E' : 'W';
    final coordName =
        '${latitude.abs().toStringAsFixed(2)}°$latDirection, ${longitude.abs().toStringAsFixed(2)}°$lonDirection';

    return {
      'id':
          'coord_${latitude.toStringAsFixed(6)}_${longitude.toStringAsFixed(6)}',
      'name': coordName,
      'latitude': latitude,
      'longitude': longitude,
      'country': null,
    };
  }

  String _generatePlaceId(Map<String, dynamic> data) {
    // Create a unique ID based on OSM osm_id or combination of city/country
    if (data['osm_id'] != null) {
      return 'osm_${data['osm_id']}';
    }

    final address = data['address'] as Map<String, dynamic>?;
    if (address != null) {
      final city = address['city'] ??
          address['town'] ??
          address['village'] ??
          address['suburb'];
      final country = address['country'];
      if (city != null && country != null) {
        return 'place_${city.toString().toLowerCase().replaceAll(' ', '_')}_${country.toString().toLowerCase().replaceAll(' ', '_')}';
      }
    }

    // Fallback to coordinates
    final lat = data['lat']?.toString() ?? '';
    final lon = data['lon']?.toString() ?? '';
    return 'coord_${lat}_$lon';
  }

  String _extractPlaceNameFromNominatim(Map<String, dynamic> data) {
    try {
      final address = data['address'] as Map<String, dynamic>?;
      if (address == null) {
        return _fallbackFromDisplayName(data['display_name'] as String?);
      }

      List<String> nameParts = [];

      // Prefer city/town over village/hamlet
      if (address['city']?.toString().isNotEmpty == true) {
        nameParts.add(address['city'].toString());
      } else if (address['town']?.toString().isNotEmpty == true) {
        nameParts.add(address['town'].toString());
      } else if (address['village']?.toString().isNotEmpty == true) {
        nameParts.add(address['village'].toString());
      } else if (address['suburb']?.toString().isNotEmpty == true) {
        nameParts.add(address['suburb'].toString());
      } else if (address['municipality']?.toString().isNotEmpty == true) {
        nameParts.add(address['municipality'].toString());
      }

      // Always add country if available
      if (address['country']?.toString().isNotEmpty == true) {
        nameParts.add(address['country'].toString());
      }

      // If we have parts, join them
      if (nameParts.isNotEmpty) {
        return nameParts.join(', ');
      }

      // Fallback to display name parsing
      return _fallbackFromDisplayName(data['display_name'] as String?);
    } catch (e) {
      return _fallbackFromDisplayName(data['display_name'] as String?);
    }
  }

  String? _extractCountry(Map<String, dynamic> data) {
    try {
      final address = data['address'] as Map<String, dynamic>?;
      return address?['country']?.toString();
    } catch (e) {
      return null;
    }
  }

  String _fallbackFromDisplayName(String? displayName) {
    if (displayName?.isNotEmpty != true) {
      return 'Unknown Location';
    }

    // Split the display name and extract meaningful parts
    final parts = displayName!.split(',').map((s) => s.trim()).toList();

    if (parts.length >= 2) {
      // Usually we want to skip house numbers and roads, get city and country
      final meaningfulParts = <String>[];

      for (final part in parts.reversed.take(3)) {
        // Skip parts that look like postal codes
        if (RegExp(r'^\d{4,5}$').hasMatch(part.trim())) continue;

        meaningfulParts.add(part);
        if (meaningfulParts.length >= 2) break;
      }

      if (meaningfulParts.isNotEmpty) {
        return meaningfulParts.reversed.join(', ');
      }
    }

    return parts.isNotEmpty ? parts.last : 'Unknown Location';
  }

  Future<void> _refreshPlaces() async {
    await _loadPlaces();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No places found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Photos with GPS location data will appear here',
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
            onPressed: _loadPlaces,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(PlaceGroup place) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to a filtered view of photos for this place
          context.push('/places/${Uri.encodeComponent(place.name)}',
              extra: place);
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section - dynamic photo layout
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: _buildPhotoGrid(place.photos),
              ),
            ),
            // Text section - fixed height to prevent overflow
            Container(
              height: 72, // Fixed height to prevent overflow
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      place.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${place.photos.length} photo${place.photos.length > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(List<MediaData> photos) {
    // Take up to 4 photos for the grid
    final displayPhotos = photos.take(4).toList();

    if (displayPhotos.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.location_on,
            size: 48,
            color: Colors.grey,
          ),
        ),
      );
    }

    // Handle different numbers of photos with appropriate layouts
    switch (displayPhotos.length) {
      case 1:
        return _buildSinglePhoto(displayPhotos[0]);
      case 2:
        return _buildTwoPhotosLayout(displayPhotos);
      case 3:
        return _buildThreePhotosLayout(displayPhotos);
      default: // 4 or more photos
        return _buildFourPhotosLayout(displayPhotos);
    }
  }

  Widget _buildSinglePhoto(MediaData photo) {
    return FutureBuilder<File?>(
      future: Thumbnail.readThumbnail(photo.eTag),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.existsSync()) {
          return Image.file(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        } else {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                size: 48,
                color: Colors.grey,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTwoPhotosLayout(List<MediaData> photos) {
    return Row(
      children: [
        Expanded(
          child: _buildPhotoWidget(photos[0]),
        ),
        const SizedBox(width: 1),
        Expanded(
          child: _buildPhotoWidget(photos[1]),
        ),
      ],
    );
  }

  Widget _buildThreePhotosLayout(List<MediaData> photos) {
    return Row(
      children: [
        // First photo takes half the width
        Expanded(
          child: _buildPhotoWidget(photos[0]),
        ),
        const SizedBox(width: 1),
        // Second and third photos share the other half vertically
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _buildPhotoWidget(photos[1]),
              ),
              const SizedBox(height: 1),
              Expanded(
                child: _buildPhotoWidget(photos[2]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFourPhotosLayout(List<MediaData> photos) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildPhotoWidget(photos[index]);
      },
    );
  }

  Widget _buildPhotoWidget(MediaData photo) {
    return FutureBuilder<File?>(
      future: Thumbnail.readThumbnail(photo.eTag),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.existsSync()) {
          return Image.file(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        } else {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                size: 24,
                color: Colors.grey,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Places',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (!isLoading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshPlaces,
              tooltip: 'Refresh places',
            ),
        ],
      ),
      body: errorMessage != null
          ? _buildErrorState()
          : isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading places...'),
                    ],
                  ),
                )
              : places.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _refreshPlaces,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          return _buildPlaceCard(places[index]);
                        },
                      ),
                    ),
    );
  }
}
