import '../../models/bus_stop.dart';
import 'transport_repository.dart';

class TransportRepositoryMock implements TransportRepository {
  @override
  Future<List<BusStop>> stopsNearby(double lat, double lng, {double radiusMeters = 1200}) async {
    return const [
      BusStop(id: 's1', name: 'Place de la Brèche', lat: 46.323, lng: -0.463),
      BusStop(id: 's2', name: 'Gare SNCF', lat: 46.326, lng: -0.455),
    ];
  }
}
