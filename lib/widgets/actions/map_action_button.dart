
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class MapActionButton extends StatelessWidget {
  final Color? color;
  const MapActionButton({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Ouvrir la carte',
      icon: Icon(Icons.map, color: color),
      onPressed: () => Navigator.pushNamed(context, AppRoutes.mapExplorer),
    );
  }
}
