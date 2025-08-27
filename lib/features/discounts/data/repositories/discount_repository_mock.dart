import '../../models/discount.dart';
import 'discount_repository.dart';

class DiscountRepositoryMock implements DiscountRepository {
  @override
  Future<List<Discount>> list({String? category}) async {
    final all = [
      Discount(id: 'd1', title: '-20% étudiants', partner: 'Cinéma CGR', category: 'cinéma', url: 'https://example.com'),
      Discount(id: 'd2', title: 'Happy Hour', partner: 'Le Camion', category: 'bar'),
    ];
    if (category == null) return all;
    return all.where((d) => d.category == category).toList();
  }
}
