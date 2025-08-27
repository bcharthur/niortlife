import 'package:flutter/material.dart';
import '../presentation/nightlife_guide/nightlife_guide.dart';
import '../presentation/event_discovery/event_discovery.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/event_detail/event_detail.dart';
import '../presentation/transport_hub/transport_hub.dart';
import '../presentation/student_discounts/student_discounts.dart';
import '../presentation/map_explorer/map_explorer.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String nightlifeGuide = '/nightlife-guide';
  static const String eventDiscovery = '/event-discovery';
  static const String homeDashboard = '/home-dashboard';
  static const String eventDetail = '/event-detail';
  static const String transportHub = '/transport-hub';
  static const String studentDiscounts = '/student-discounts';
  static const String mapExplorer = '/map-explorer';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const NightlifeGuide(),
    nightlifeGuide: (context) => const NightlifeGuide(),
    eventDiscovery: (context) => const EventDiscovery(),
    homeDashboard: (context) => const HomeDashboard(),
    eventDetail: (context) => const EventDetail(),
    transportHub: (context) => const TransportHub(),
    studentDiscounts: (context) => const StudentDiscounts(),
    mapExplorer: (context) => const MapExplorerPage(),
    // TODO: Add your other routes here
  };
}
