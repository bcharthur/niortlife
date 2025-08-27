class Discount {
  final String id;
  final String title;
  final String partner;
  final String? category;
  final String? url;
  final DateTime? validUntil;

  const Discount({
    required this.id,
    required this.title,
    required this.partner,
    this.category,
    this.url,
    this.validUntil,
  });
}
