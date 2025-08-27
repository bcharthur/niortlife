import '../../models/discount.dart';
import 'discount_repository.dart';
import '../../../../core/network/http_client.dart';

class DiscountRepositoryRemote implements DiscountRepository {
  final ApiClient client;
  DiscountRepositoryRemote({required this.client});

  @override
  Future<List<Discount>> list({String? category}) async {
    final res = await client.getJson('/discounts', query: { if (category != null) 'category': category });
    if (res.isErr || res.data is! List) return <Discount>[];
    return (res.data as List).whereType<Map>().map((m) => Discount(
      id: (m['id'] ?? '').toString(),
      title: (m['title'] ?? '') as String,
      partner: (m['partner'] ?? '') as String,
      category: m['category'] as String?,
      url: m['url'] as String?,
      validUntil: DateTime.tryParse(m['validUntil'] as String? ?? ''),
    )).toList();
  }
}
