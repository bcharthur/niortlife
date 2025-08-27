
import 'package:latlong2/latlong.dart';

import '../../models/poi.dart';

/// Abstract repository to fetch POIs from various sources (Tourism, SortirNiort, Transports, etc.)
abstract class POIRepository {
  Future<List<POI>> fetchAll({
    bool bars = true,
    bool restos = true,
    bool bus = true,
    bool events = true,
    bool deals = true,
  });
}

/// Temporary mock implementation. Replace with real HTTP scrapers/APIs.
class POIRepositoryMock implements POIRepository {
  @override
  Future<List<POI>> fetchAll({
    bool bars = true,
    bool restos = true,
    bool bus = true,
    bool events = true,
    bool deals = true,
  }) async {
    final items = <POI>[];

    if (bars) {
      items.addAll([
        POI(
          id: 'bar-1',
          name: 'Le Zinc',
          subtitle: 'Bar à cocktails',
          address: '12 Rue Saint-Jean, Niort',
          position: const LatLng(46.3228, -0.4589),
          category: POICategory.bar,
          openNow: true,
          tags: const ['Jazz', 'Terrasse'],
          price: '€€',
        ),
      ]);
    }

    if (events) {
      items.addAll([
        POI(
          id: 'event-1',
          name: 'Concert Jazz au Moulin du Roc',
          subtitle: 'Culturel',
          address: 'Moulin du Roc, Niort',
          position: const LatLng(46.3264, -0.4665),
          category: POICategory.event,
          openNow: false,
          tags: const ['25 août', '20h30'],
          price: '25€',
        )
      ]);
    }

    if (bus) {
      items.addAll([
        POI(
          id: 'bus-1',
          name: 'Gare SNCF',
          subtitle: 'Arrêt · Temps réel',
          address: 'Place de la Gare, Niort',
          position: const LatLng(46.3199, -0.4638),
          category: POICategory.busStop,
          openNow: true,
          tags: const ['Quai A', '3 min'],
        ),
      ]);
    }

    if (restos) {
      items.add(
        POI(
          id: 'resto-1',
          name: 'Le Bistrot Étudiant',
          subtitle: 'Restaurant · 20% OFF',
          address: 'Rue Victor Hugo, Niort',
          position: const LatLng(46.3218, -0.4565),
          category: POICategory.restaurant,
          openNow: true,
          tags: const ['Étudiant', 'Terrasse'],
          price: '20% OFF',
        ),
      );
    }

    if (deals) {
      items.add(
        POI(
          id: 'deal-1',
          name: 'Mode & Style',
          subtitle: 'Boutique · 15% OFF',
          address: 'Centre-ville, Niort',
          position: const LatLng(46.3248, -0.4570),
          category: POICategory.discount,
          openNow: true,
          tags: const ['Étudiant'],
          price: '15% OFF',
        ),
      );
    }

    return items;
  }
}
