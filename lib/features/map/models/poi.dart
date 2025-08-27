import 'package:latlong2/latlong.dart';
import 'poi_category.dart';

class POI {
  final String id;
  /// Canonical title of the POI. Backward-compat: [name] maps to [title].
  final String title;
  final POICategory category;
  final LatLng position;
  final bool openNow;
  final String address;
  final String subtitle;
  final List<String> tags;
  final String price;
  final String? imageUrl;
  final Map<String, dynamic>? extras;

  const POI({
    this.id = '',
    String? title,
    String? name,
    required this.category,
    required this.position,
    this.openNow = false,
    String? address,
    String? subtitle,
    this.tags = const <String>[],
    String? price,
    this.imageUrl,
    this.extras,
  })  : title = title ?? name ?? '',
        address = address ?? '',
        subtitle = subtitle ?? '',
        price = price ?? '';

  /// Backward compatibility: many widgets use `poi.name`
  String get name => title;
}
