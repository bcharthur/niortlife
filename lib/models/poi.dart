
import 'package:latlong2/latlong.dart';

enum POICategory { bar, restaurant, busStop, event, discount }

class POI {
  final String id;
  final String name;
  final String subtitle;
  final String address;
  final LatLng position;
  final POICategory category;
  final bool openNow;
  final List<String> tags;
  final String? price; // e.g. "€€" or "20% OFF"

  const POI({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.address,
    required this.position,
    required this.category,
    required this.openNow,
    this.tags = const [],
    this.price,
  });
}
