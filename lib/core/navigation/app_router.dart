import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../presentation/nightlife_guide/nightlife_guide.dart';
import '../../presentation/event_discovery/event_discovery.dart';
import '../../presentation/home_dashboard/home_dashboard.dart';
import '../../presentation/event_detail/event_detail.dart';
import '../../presentation/transport_hub/transport_hub.dart';
import '../../presentation/student_discounts/student_discounts.dart';
import '../../presentation/map_explorer/map_explorer.dart';
import 'platform_adaptive_page_route.dart';

typedef RouteWidgetBuilder = Widget Function(BuildContext);

class AppRouter {
  static final Map<String, RouteWidgetBuilder> _builders = <String, RouteWidgetBuilder>{
    AppRoutes.initial: (context) => const NightlifeGuide(),
    AppRoutes.nightlifeGuide: (context) => const NightlifeGuide(),
    AppRoutes.eventDiscovery: (context) => const EventDiscovery(),
    AppRoutes.homeDashboard: (context) => const HomeDashboard(),
    AppRoutes.eventDetail: (context) => const EventDetail(),
    AppRoutes.transportHub: (context) => const TransportHub(),
    AppRoutes.studentDiscounts: (context) => const StudentDiscounts(),
    AppRoutes.mapExplorer: (context) => const MapExplorerPage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = _builders[settings.name];
    if (builder == null) {
      // Fallback: simple unknown route page
      return PlatformAdaptivePageRoute(
        settings: RouteSettings(name: '/unknown', arguments: settings.arguments),
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Page introuvable')),
          body: Center(
            child: Text('Aucune route définie pour: \${settings.name}'),
          ),
        ),
      );
    }
    return PlatformAdaptivePageRoute(
      settings: settings,
      builder: builder,
    );
  }
}