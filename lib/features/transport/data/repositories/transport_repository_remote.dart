import '../../models/bus_stop.dart';
import 'transport_repository.dart';
import '../../../../core/network/http_client.dart';

class TransportRepositoryRemote implements TransportRepository {
  final ApiClient client;
  TransportRepositoryRemote({required this.client});

  @override
  Future<List<BusStop>> stopsNearby(double lat, double lng, {double radiusMeters = 1200}) async {
    final res = await client.getJson('/stops', query: {'lat': '$lat', 'lng': '$lng', 'radius': '$radiusMeters'});
    if (res.isErr || res.data is! List) return const <BusStop>[];
    return (res.data as List).whereType<Map>().map((m) => BusStop(
      id: (m['id'] ?? '').toString(),
      name: (m['name'] ?? '') as String,
      lat: (m['lat'] ?? 0).toDouble(),
      lng: (m['lng'] ?? 0).toDouble(),
    )).toList();
  }
}
