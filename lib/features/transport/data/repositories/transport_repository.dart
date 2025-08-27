import '../../models/bus_stop.dart';

abstract class TransportRepository {
  Future<List<BusStop>> stopsNearby(double lat, double lng, {double radiusMeters = 1200});
}
