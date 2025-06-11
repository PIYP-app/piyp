import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/init_db.dart';
import 'package:piyp/thumbnail.dart';
import 'package:http/http.dart' as http;

class PlaceGroup {
  final String name;
  final List<MediaData> photos;
  final double latitude;
  final double longitude;
  final String? thumbnailPath;

  PlaceGroup({
    required this.name,
    required this.photos,
    required this.latitude,
    required this.longitude,
    this.thumbnailPath,
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
      // Get all photos with location data
      final allMedias = await database.select(database.media).get();

      // Filter photos with location data and sort by creation date
      final photosWithLocation = allMedias
          .where((media) => media.latitude != null && media.longitude != null)
          .toList()
        ..sort((a, b) => DateTime.parse(b.creationDate)
            .compareTo(DateTime.parse(a.creationDate)));

      if (photosWithLocation.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Group photos by approximate location (within ~5km)
      final List<PlaceGroup> groupedPlaces = [];

      for (final photo in photosWithLocation) {
        bool addedToExisting = false;

        // Check if this photo belongs to an existing place group
        for (final place in groupedPlaces) {
          final distance = _calculateDistance(
            photo.latitude!,
            photo.longitude!,
            place.latitude,
            place.longitude,
          );

          // If within 5km, add to existing group
          if (distance <= 5.0) {
            place.photos.add(photo);
            addedToExisting = true;
            break;
          }
        }

        // If not added to existing group, create new one
        if (!addedToExisting) {
          final placeName =
              await _getPlaceName(photo.latitude!, photo.longitude!);
          groupedPlaces.add(PlaceGroup(
            name: placeName,
            photos: [photo],
            latitude: photo.latitude!,
            longitude: photo.longitude!,
          ));
        }
      }

      // Remove duplicates based on place names and merge photos
      final Map<String, PlaceGroup> uniquePlaces = {};
      for (final place in groupedPlaces) {
        if (uniquePlaces.containsKey(place.name)) {
          // Merge photos into existing place
          uniquePlaces[place.name]!.photos.addAll(place.photos);
        } else {
          uniquePlaces[place.name] = place;
        }
      }

      // Convert back to list and sort places by number of photos (most photos first)
      final List<PlaceGroup> finalPlaces = uniquePlaces.values.toList();
      finalPlaces.sort((a, b) => b.photos.length.compareTo(a.photos.length));

      // Load thumbnails for the first photo of each place
      for (final place in finalPlaces) {
        if (place.photos.isNotEmpty) {
          // Thumbnail will be loaded when needed in the UI
          place.photos.first; // Keep reference for UI
        }
      }

      setState(() {
        places = finalPlaces;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load places: $e';
        isLoading = false;
      });
    }
  }

  // Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Use OSM Nominatim API for reverse geocoding
  Future<String> _getPlaceName(double latitude, double longitude) async {
    try {
      // Use OpenStreetMap Nominatim API for reverse geocoding
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=10&addressdetails=1',
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent':
              'PIYP Flutter App/1.0 (contact@example.com)', // Required by Nominatim policy
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Extract place name from the response
        String placeName = _extractPlaceNameFromNominatim(data);

        if (placeName.isNotEmpty && placeName != 'Unknown Location') {
          return placeName;
        }
      }
    } catch (e) {
      // If geocoding fails, fall back to coordinates
      debugPrint('Geocoding failed for $latitude, $longitude: $e');
    }

    // Fallback to coordinate-based name
    final latDirection = latitude >= 0 ? 'N' : 'S';
    final lonDirection = longitude >= 0 ? 'E' : 'W';
    return '${latitude.abs().toStringAsFixed(2)}°$latDirection, ${longitude.abs().toStringAsFixed(2)}°$lonDirection';
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

      // Skip state/region to keep names shorter and more readable
      // This prevents long names like "Tours, Centre-Val de Loire, France"

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
            // Image section - 2x2 grid of photos
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
                          childAspectRatio:
                              0.75, // Adjusted for better proportions
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
