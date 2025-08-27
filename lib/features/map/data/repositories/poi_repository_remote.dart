import 'package:latlong2/latlong.dart';
import '../../models/poi.dart';
import '../../models/poi_category.dart';
import 'poi_repository.dart';
import '../../../../core/network/http_client.dart';

class POIRepositoryRemote implements POIRepository {
  final ApiClient client;
  POIRepositoryRemote({required this.client});

  @override
  Future<List<POI>> fetchAll({
    bool bars = true,
    bool restos = true,
    bool bus = true,
    bool events = true,
    bool deals = true,
  }) async {
    // TODO: implement aggregation of multiple sources (bars, deals, bus, events)
    return <POI>[];
  }

  @override
  Future<List<POI>> searchNearby({
    required double lat,
    required double lng,
    double radiusMeters = 1500,
    Set<POICategory>? categories,
  }) async {
    final res = await client.getJson('/pois', query: {
      'lat': '$lat',
      'lng': '$lng',
      'radius': '$radiusMeters',
      if (categories != null) 'categories': categories.map((e) => e.name).join(','),
    });
    if (res.isErr) return <POI>[];

    final data = res.data;
    if (data is List) {
      return data.whereType<Map>().map((m) {
        final cat = _parseCategory(m['category'] as String?);
        return POI(
          id: (m['id'] ?? '').toString(),
          title: (m['title'] ?? '') as String,
          category: cat,
          position: LatLng(
            (m['lat'] as num?)?.toDouble() ?? 0.0,
            (m['lng'] as num?)?.toDouble() ?? 0.0,
          ),
          // ⬇⬇ ICI : remplace `json` par `m` + valeur par défaut
          openNow: (m['open_now'] as bool?) ?? false,

          address: m['address'] as String?,
          imageUrl: m['imageUrl'] as String?,
          extras: m as Map<String, dynamic>?,
        );
      }).toList();

    }
    return <POI>[];
  }

  POICategory _parseCategory(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'bar': return POICategory.bar;
      case 'restaurant': return POICategory.restaurant;
      case 'bus': return POICategory.bus;
      case 'event': return POICategory.event;
      case 'deal': return POICategory.deal;
      default: return POICategory.other;
    }
  }
}
