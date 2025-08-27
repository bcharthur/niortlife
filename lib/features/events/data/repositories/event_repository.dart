import '../../models/event.dart';

abstract class EventRepository {
  Future<List<Event>> list({DateTime? from, DateTime? to});
  Future<Event?> byId(String id);
}
