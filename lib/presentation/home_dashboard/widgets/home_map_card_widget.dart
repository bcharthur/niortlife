
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../../routes/app_routes.dart';

/// Mini carte pour la page d'accueil
/// - fullBleed: supprime marges arrondis pour occuper toute la largeur
/// - height: hauteur de la carte (par défaut 260)
/// - Affiche la position de l'utilisateur avec une flèche bleue (heading)
/// - Tap & bouton "Plein écran" => ouvre MapExplorer
class HomeMapCardWidget extends StatefulWidget {
  final bool fullBleed;
  final double height;

  const HomeMapCardWidget({
    super.key,
    this.fullBleed = false,
    this.height = 260,
  });

  @override
  State<HomeMapCardWidget> createState() => _HomeMapCardWidgetState();
}

class _HomeMapCardWidgetState extends State<HomeMapCardWidget> {
  static const LatLng _niortCenter = LatLng(46.323, -0.46);
  static const double _zoom = 13.5;

  final MapController _map = MapController();
  StreamSubscription<Position>? _sub;

  Position? _pos; // dernière position
  bool _serviceEnabled = true;
  LocationPermission _perm = LocationPermission.denied;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    // 1) Services activés ?
    final enabled = await Geolocator.isLocationServiceEnabled();
    // 2) Permissions
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    Position? first;
    if (enabled && (perm == LocationPermission.whileInUse || perm == LocationPermission.always)) {
      try {
        first = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } catch (_) {}
      _sub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 5,
        ),
      ).listen((p) {
        setState(() => _pos = p);
      });
    }

    if (mounted) {
      setState(() {
        _serviceEnabled = enabled;
        _perm = perm;
        _pos = first ?? _pos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = widget.fullBleed ? BorderRadius.zero : BorderRadius.circular(16);

    final markers = <Marker>[];
    final circles = <CircleMarker>[];

    if (_pos != null) {
      final user = LatLng(_pos!.latitude, _pos!.longitude);
      // Cercle de précision (si dispo)
      if (_pos!.accuracy.isFinite && _pos!.accuracy > 0) {
        circles.add(CircleMarker(
          point: user,
          radius: _pos!.accuracy, // en mètres
          useRadiusInMeter: true,
          color: Colors.blue.withOpacity(0.1),
          borderColor: Colors.blue.withOpacity(0.25),
          borderStrokeWidth: 1.5,
        ));
      }
      // Flèche bleue (type Google/Waze)
      final headingDeg = (_pos!.heading.isFinite && _pos!.heading >= 0) ? _pos!.heading : 0.0;
      final headingRad = headingDeg * math.pi / 180.0;
      markers.add(
        Marker(
          point: user,
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: headingRad,
            child: Icon(
              Icons.navigation, // triangle/flèche
              size: 36,
              color: Colors.blueAccent,
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: widget.fullBleed ? 0 : 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: radius),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: Stack(
          children: [
            // Carte en aperçu (non interactive pour préserver le scroll)
            IgnorePointer(
              ignoring: true,
              child: FlutterMap(
                mapController: _map,
                options: MapOptions(
                  initialCenter: _pos != null
                      ? LatLng(_pos!.latitude, _pos!.longitude)
                      : _niortCenter,
                  initialZoom: _zoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'niortlife',
                  ),
                  if (circles.isNotEmpty) CircleLayer(circles: circles),
                  if (markers.isNotEmpty) MarkerLayer(markers: markers),
                ],
              ),
            ),

            // Bandeau titre + statut localisation
            Positioned(
              left: 0, right: 0, top: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.surface.withOpacity(0.75),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.map, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Autour de moi',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    _buildLocationChip(theme),
                  ],
                ),
              ),
            ),

            // CTA Plein écran
            Positioned(
              right: 12,
              bottom: 12,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.mapExplorer),
                icon: const Icon(Icons.open_in_full),
                label: const Text('Plein écran'),
              ),
            ),

            // Tap n'importe où pour ouvrir la carte
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.mapExplorer),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationChip(ThemeData theme) {
    String label;
    Color? bg;
    if (!_serviceEnabled) {
      label = 'GPS désactivé';
      bg = Colors.orange.withOpacity(.15);
    } else if (!(_perm == LocationPermission.whileInUse || _perm == LocationPermission.always)) {
      label = 'Autoriser la localisation';
      bg = Colors.orange.withOpacity(.15);
    } else if (_pos == null) {
      label = 'Recherche...';
      bg = theme.colorScheme.surface.withOpacity(.85);
    } else {
      label = 'Ma position';
      bg = theme.colorScheme.surface.withOpacity(.85);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: theme.textTheme.labelSmall),
    );
  }
}
