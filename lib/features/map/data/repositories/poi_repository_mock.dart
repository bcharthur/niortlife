import 'package:latlong2/latlong.dart';
import '../../models/poi.dart';
import '../../models/poi_category.dart';
import 'poi_repository.dart';

class POIRepositoryMock implements POIRepository {
  @override
  Future<List<POI>> fetchAll({
    bool bars = true,
    bool restos = true,
    bool bus = true,
    bool events = true,
    bool deals = true,
  }) async {
    final out = <POI>[];
    if (bars) {
      out.addAll([
        POI(id: 'bar1', title: 'Le Camion', category: POICategory.bar, position: const LatLng(46.321, -0.462), openNow: true),
        POI(id: 'bar2', title: 'Le Pilori', category: POICategory.bar, position: const LatLng(46.324, -0.459)),
      ]);
    }
    if (restos) {
      out.add(POI(id: 'rest1', title: 'Burger Spot', category: POICategory.restaurant, position: const LatLng(46.325, -0.465)));
    }
    if (bus) {
      out.add(POI(id: 'bus1', title: 'Arrêt Place de la Brèche', category: POICategory.bus, position: const LatLng(46.323, -0.463)));
    }
    if (events) {
      out.add(POI(id: 'evt1', title: 'Concert Jazz', category: POICategory.event, position: const LatLng(46.327, -0.46)));
    }
    if (deals) {
      out.add(POI(id: 'deal1', title: 'Happy Hour Étudiant', category: POICategory.deal, position: const LatLng(46.319, -0.468)));
    }
    return out;
  }

  @override
  Future<List<POI>> searchNearby({
    required double lat,
    required double lng,
    double radiusMeters = 1500,
    Set<POICategory>? categories,
  }) async {
    final all = await fetchAll();
    final user = LatLng(lat, lng);
    final d = const Distance();
    return all.where((p) {
      if (categories != null && categories.isNotEmpty && !categories.contains(p.category)) return false;
      return d.as(LengthUnit.Meter, user, p.position) <= radiusMeters;
    }).toList();
  }
}
