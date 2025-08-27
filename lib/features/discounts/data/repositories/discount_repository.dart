import '../../models/discount.dart';

abstract class DiscountRepository {
  Future<List<Discount>> list({String? category});
}
