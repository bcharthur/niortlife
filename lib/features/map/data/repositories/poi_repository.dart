import '../../models/poi.dart';
import '../../models/poi_category.dart';

abstract class POIRepository {
  Future<List<POI>> fetchAll({
    bool bars = true,
    bool restos = true,
    bool bus = true,
    bool events = true,
    bool deals = true,
  });

  Future<List<POI>> searchNearby({
    required double lat,
    required double lng,
    double radiusMeters = 1500,
    Set<POICategory>? categories,
  });
}
