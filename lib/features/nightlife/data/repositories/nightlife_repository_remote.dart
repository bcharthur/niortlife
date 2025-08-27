import '../../models/place.dart';
import 'nightlife_repository.dart';
import '../../../../core/network/http_client.dart';

class NightlifeRepositoryRemote implements NightlifeRepository {
  final ApiClient client;
  NightlifeRepositoryRemote({required this.client});

  @override
  Future<List<Place>> list({String? category}) async {
    final res = await client.getJson('/places', query: { if (category != null) 'category': category });
    if (res.isErr || res.data is! List) return const <Place>[];
    return (res.data as List).whereType<Map>().map((m) => Place(
      id: (m['id'] ?? '').toString(),
      name: (m['name'] ?? '') as String,
      category: m['category'] as String?,
      lat: (m['lat'] ?? 0).toDouble(),
      lng: (m['lng'] ?? 0).toDouble(),
    )).toList();
  }
}
