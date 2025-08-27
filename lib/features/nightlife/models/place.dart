class Place {
  final String id;
  final String name;
  final String? category;
  final double lat, lng;

  const Place({required this.id, required this.name, this.category, required this.lat, required this.lng});
}
