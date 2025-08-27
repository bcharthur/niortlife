class Event {
  final String id;
  final String title;
  final DateTime dateTime;
  final String venue;
  final String? imageUrl;
  final bool ageRestriction;

  const Event({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.venue,
    this.imageUrl,
    this.ageRestriction = false,
  });
}
