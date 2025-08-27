import '../../models/event.dart';
import 'event_repository.dart';
import '../../../../core/network/http_client.dart';

class EventRepositoryRemote implements EventRepository {
  final ApiClient client;
  EventRepositoryRemote({required this.client});

  @override
  Future<Event?> byId(String id) async {
    final res = await client.getJson('/events/$id');
    if (res.isErr || res.data is! Map) return null;
    final m = res.data as Map;
    return _fromMap(m);
  }

  @override
  Future<List<Event>> list({DateTime? from, DateTime? to}) async {
    final res = await client.getJson('/events', query: {
      if (from != null) 'from': from.toIso8601String(),
      if (to != null) 'to': to.toIso8601String(),
    });
    if (res.isErr || res.data is! List) return <Event>[];
    return (res.data as List).whereType<Map>().map(_fromMap).toList();
  }

  Event _fromMap(Map m) {
    return Event(
      id: (m['id'] ?? '').toString(),
      title: (m['title'] ?? '') as String,
      dateTime: DateTime.tryParse(m['dateTime'] as String? ?? '') ?? DateTime.now(),
      venue: (m['venue'] ?? '') as String,
      imageUrl: m['imageUrl'] as String?,
      ageRestriction: (m['ageRestriction'] as bool?) ?? false,
    );
  }
}
