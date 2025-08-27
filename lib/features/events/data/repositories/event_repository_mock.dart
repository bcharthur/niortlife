import '../../models/event.dart';
import 'event_repository.dart';

class EventRepositoryMock implements EventRepository {
  @override
  Future<Event?> byId(String id) async {
    final all = await list();
    try { return all.firstWhere((e) => e.id == id); } catch (_) { return null; }
  }

  @override
  Future<List<Event>> list({DateTime? from, DateTime? to}) async {
    final now = DateTime.now();
    final items = [
      Event(id: 'e1', title: 'Concert Jazz', dateTime: now.add(const Duration(days: 1)), venue: 'Moulin du Roc'),
      Event(id: 'e2', title: 'Match Chamois', dateTime: now.add(const Duration(days: 2)), venue: 'Stade René Gaillard'),
    ];
    return items.where((e) {
      final okFrom = from == null || e.dateTime.isAfter(from);
      final okTo = to == null || e.dateTime.isBefore(to);
      return okFrom && okTo;
    }).toList();
  }
}
