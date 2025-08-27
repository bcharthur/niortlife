import '../../models/place.dart';

abstract class NightlifeRepository {
  Future<List<Place>> list({String? category});
}
