
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';
import '../../models/poi.dart';
import '../../widgets/custom_bottom_bar.dart';

class MapExplorerPage extends StatefulWidget {
  const MapExplorerPage({super.key});

  @override
  State<MapExplorerPage> createState() => _MapExplorerPageState();
}

class _MapExplorerPageState extends State<MapExplorerPage> {
  final MapController _mapController = MapController();

  static const LatLng _niortCenter = LatLng(46.323, -0.46);
  static const double _defaultZoom = 14.0;

  final Set<POICategory> _active = {
    POICategory.bar,
    POICategory.restaurant,
    POICategory.busStop,
    POICategory.event,
    POICategory.discount,
  };

  late final List<POI> _allPOIs = [
    POI(
      id: '1',
      name: 'Le Camion Bar',
      subtitle: 'Nightlife · Étudiant',
      address: 'Rue de la Gare, Niort',
      position: const LatLng(46.3252, -0.4625),
      category: POICategory.bar,
      openNow: true,
      tags: const ['Gratuit', 'Soirée étudiante', 'Concert'],
      price: '€€',
    ),
    POI(
      id: '2',
      name: 'Moulin du Roc',
      subtitle: 'Salle de spectacle · Culturel',
      address: 'Avenue de Limoges, Niort',
      position: const LatLng(46.3264, -0.4665),
      category: POICategory.event,
      openNow: false,
      tags: const ['Jazz', '20h30'],
      price: '25€',
    ),
    POI(
      id: '3',
      name: 'Gare SNCF',
      subtitle: 'Arrêt · Temps réel',
      address: 'Place de la Gare, Niort',
      position: const LatLng(46.3199, -0.4638),
      category: POICategory.busStop,
      openNow: true,
      tags: const ['Quai A', '3 min'],
    ),
    POI(
      id: '4',
      name: 'Parc de la Brèche',
      subtitle: 'Événement plein air',
      address: 'Centre-ville, Niort',
      position: const LatLng(46.3239, -0.4632),
      category: POICategory.event,
      openNow: true,
      tags: const ['Festival', '26 août'],
      price: '15€–25€',
    ),
    POI(
      id: '5',
      name: 'Le Bistrot Étudiant',
      subtitle: 'Restaurant · 20% OFF',
      address: 'Rue Victor Hugo, Niort',
      position: const LatLng(46.3218, -0.4565),
      category: POICategory.restaurant,
      openNow: true,
      tags: const ['Étudiant', 'Terrasse'],
      price: '20% OFF',
    ),
    POI(
      id: '6',
      name: 'Campus Universitaire',
      subtitle: 'Arrêt · Retardé +2 min',
      address: 'Campus, Niort',
      position: const LatLng(46.3142, -0.4620),
      category: POICategory.busStop,
      openNow: true,
      tags: const ['Quai B', '7 min'],
    ),
    POI(
      id: '7',
      name: 'Le Zinc',
      subtitle: 'Bar à cocktails',
      address: 'Rue Saint-Jean, Niort',
      position: const LatLng(46.3228, -0.4589),
      category: POICategory.bar,
      openNow: true,
      tags: const ['Jazz', 'Terrasse'],
      price: '€€',
    ),
    POI(
      id: '8',
      name: 'Mode & Style',
      subtitle: 'Boutique · 15% OFF',
      address: 'Centre-ville, Niort',
      position: const LatLng(46.3248, -0.4570),
      category: POICategory.discount,
      openNow: true,
      tags: const ['Étudiant'],
      price: '15% OFF',
    ),
  ];

  POI? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorPrimary = AppTheme.lightTheme.primaryColor;

    final filtered = _allPOIs.where((p) => _active.contains(p.category)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorer la carte'),
        actions: [
          IconButton(
            tooltip: 'Recentrer Niort',
            icon: const Icon(Icons.center_focus_strong),
            onPressed: () {
              _mapController.move(_niortCenter, _defaultZoom);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _niortCenter,
              initialZoom: _defaultZoom,
              onTap: (_, __) => setState(() => _selected = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'niortlife',
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 60,
                  size: const Size(40, 40),
                  // Older plugin versions pass the list of markers to the builder
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                        color: colorPrimary.withOpacity(.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.2),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                  markers: filtered.map((p) {
                    final icon = _iconFor(p.category);
                    final color = _colorFor(p.category, Theme.of(context).colorScheme);
                    return Marker(
                      point: p.position,
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () => setState(() => _selected = p),
                        child: _MapPin(icon: icon, color: color, open: p.openNow),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          // Filters
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: _FilterChips(
              active: _active,
              onChanged: (cat, on) => setState(() {
                if (on) {
                  _active.add(cat);
                } else {
                  _active.remove(cat);
                }
              }),
            ),
          ),

          // FABs
          Positioned(
            right: 12,
            bottom: 24 + (_selected != null ? 220 : 0),
            child: Column(
              children: [
                _RoundFab(
                  icon: Icons.my_location,
                  tooltip: 'Ma position (ajoutez geolocator)',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Brancher Geolocator pour centrer sur votre position.')),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _RoundFab(
                  icon: Icons.layers,
                  tooltip: 'Style de carte',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vous pouvez ajouter d’autres tuiles si besoin.')),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom sheet
          if (_selected != null)
            _BottomCard(
              poi: _selected!,
              onClose: () => setState(() => _selected = null),
            ),
        ],
      ),

      // 👇 Barre du bas avec la Carte active (index 5)
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 5,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(context, '/home-dashboard', (route) => false);
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(context, '/event-discovery', (route) => false);
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(context, '/student-discounts', (route) => false);
              break;
            case 3:
              Navigator.pushNamedAndRemoveUntil(context, '/transport-hub', (route) => false);
              break;
            case 4:
              Navigator.pushNamedAndRemoveUntil(context, '/nightlife-guide', (route) => false);
              break;
            case 5:
            // déjà sur la Carte
              break;
          }
        },
      ),


    );
  }

  IconData _iconFor(POICategory c) {
    switch (c) {
      case POICategory.bar:
        return Icons.local_bar;
      case POICategory.restaurant:
        return Icons.restaurant;
      case POICategory.event:
        return Icons.event;
      case POICategory.deal:
      case POICategory.discount: // alias
        return Icons.local_offer;
      case POICategory.bus:
        return Icons.directions_bus;
      case POICategory.busStop:
        return Icons.departure_board; // ou Icons.directions_bus_filled
      case POICategory.other:
        return Icons.place;
    }
  }


  Color _colorFor(POICategory c, ColorScheme cs) {
    switch (c) {
      case POICategory.bar:
        return cs.secondary;
      case POICategory.restaurant:
        return cs.tertiary;
      case POICategory.event:
        return cs.primary;
      case POICategory.deal:
      case POICategory.discount:
        return Colors.teal; // ou cs.secondaryContainer si tu préfères
      case POICategory.bus:
      case POICategory.busStop:
        return Colors.indigo; // ou cs.primaryContainer
      case POICategory.other:
        return cs.outline;
    }
  }
}

class _RoundFab extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  const _RoundFab({required this.icon, required this.tooltip, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      elevation: 3,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool open;
  const _MapPin({required this.icon, required this.color, required this.open});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Transform.translate(
          offset: const Offset(0, -6),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              Transform.rotate(
                angle: pi / 4,
                child: Container(width: 12, height: 12, color: color),
              ),
            ],
          ),
        ),
        if (open)
          Positioned(
            top: -8,
            right: -12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
              ),
              child: const Text('Ouvert', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            ),
          ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  final Set<POICategory> active;
  final void Function(POICategory, bool) onChanged;
  const _FilterChips({required this.active, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final data = <(POICategory, String, IconData)>[
      (POICategory.bar, 'Bars', Icons.local_bar),
      (POICategory.restaurant, 'Resto', Icons.restaurant),
      (POICategory.busStop, 'Bus', Icons.directions_bus),
      (POICategory.event, 'Événements', Icons.event),
      (POICategory.discount, 'Réductions', Icons.local_offer),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 4),
          for (final (cat, label, icon) in data) ...[
            FilterChip(
              selected: active.contains(cat),
              onSelected: (v) => onChanged(cat, v),
              avatar: Icon(icon, size: 18),
              label: Text(label),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _BottomCard extends StatelessWidget {
  final POI poi;
  final VoidCallback onClose;
  const _BottomCard({required this.poi, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = AppTheme.lightTheme.primaryColor;

    Future<void> _openMaps() async {
      final query = Uri.encodeComponent('${poi.name}, ${poi.address}');
      final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Material(
        elevation: 12,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      poi.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
                ],
              ),
              Text(poi.subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.place, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(poi.address, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: -8,
                children: [
                  for (final tag in poi.tags)
                    Chip(
                      label: Text(tag),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  if (poi.price != null)
                    Chip(
                      label: Text(poi.price!),
                      backgroundColor: primary.withOpacity(.1),
                      side: BorderSide(color: primary.withOpacity(.2)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_outline),
                      label: const Text('Enregistrer'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: primary),
                      onPressed: _openMaps,
                      icon: const Icon(Icons.directions),
                      label: const Text('Itinéraire'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
