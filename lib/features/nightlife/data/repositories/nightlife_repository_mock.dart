import '../../models/place.dart';
import 'nightlife_repository.dart';

class NightlifeRepositoryMock implements NightlifeRepository {
  @override
  Future<List<Place>> list({String? category}) async {
    final all = const [
      Place(id: 'p1', name: 'Le Camion', category: 'bar', lat: 46.321, lng: -0.462),
      Place(id: 'p2', name: 'Le Garage', category: 'club', lat: 46.325, lng: -0.466),
    ];
    if (category == null) return all;
    return all.where((p) => p.category == category).toList();
  }
}
