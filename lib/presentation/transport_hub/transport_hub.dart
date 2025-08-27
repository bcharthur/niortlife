import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/journey_planner_widget.dart';
import './widgets/live_departures_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/nearby_stops_widget.dart';
import '../../widgets/custom_bottom_bar.dart';


class TransportHub extends StatefulWidget {
  const TransportHub({super.key});

  @override
  State<TransportHub> createState() => _TransportHubState();
}

class _TransportHubState extends State<TransportHub>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  bool _isLocationAccurate = true;
  String _currentLocation = "Centre-ville, Niort";

  // Mock data for nearby stops
  final List<Map<String, dynamic>> _nearbyStops = [
    {
      "id": 1,
      "name": "Place de la Brèche",
      "distance": 120,
      "walkingTime": 2,
      "lines": ["1", "2", "3", "N1"],
      "accessibility": true,
    },
    {
      "id": 2,
      "name": "Hôtel de Ville",
      "distance": 250,
      "walkingTime": 3,
      "lines": ["1", "4", "5"],
      "accessibility": true,
    },
    {
      "id": 3,
      "name": "Gare SNCF",
      "distance": 450,
      "walkingTime": 6,
      "lines": ["2", "3", "6", "7", "N2"],
      "accessibility": true,
    },
    {
      "id": 4,
      "name": "Campus Universitaire",
      "distance": 680,
      "walkingTime": 8,
      "lines": ["8", "9"],
      "accessibility": false,
    },
    {
      "id": 5,
      "name": "Centre Commercial Mendès France",
      "distance": 890,
      "walkingTime": 11,
      "lines": ["4", "5", "10"],
      "accessibility": true,
    },
  ];

  // Mock data for live departures
  final List<Map<String, dynamic>> _liveDepartures = [
    {
      "id": 1,
      "line": "1",
      "destination": "Gare SNCF",
      "departureTime": "14:58",
      "minutesUntil": 3,
      "delay": 0,
      "status": "on_time",
      "platform": "A",
    },
    {
      "id": 2,
      "line": "3",
      "destination": "Campus Universitaire",
      "departureTime": "15:02",
      "minutesUntil": 7,
      "delay": 2,
      "status": "delayed",
      "platform": "B",
    },
    {
      "id": 3,
      "line": "2",
      "destination": "Souché",
      "departureTime": "15:05",
      "minutesUntil": 10,
      "delay": 0,
      "status": "on_time",
      "platform": "A",
    },
    {
      "id": 4,
      "line": "4",
      "destination": "Mendès France",
      "departureTime": "15:08",
      "minutesUntil": 13,
      "delay": 0,
      "status": "on_time",
      "platform": "C",
    },
    {
      "id": 5,
      "line": "N1",
      "destination": "Sainte-Pezenne",
      "departureTime": "15:15",
      "minutesUntil": 20,
      "delay": 5,
      "status": "delayed",
      "platform": "B",
    },
    {
      "id": 6,
      "line": "5",
      "destination": "Saint-Liguaire",
      "departureTime": "15:20",
      "minutesUntil": 25,
      "delay": 0,
      "status": "on_time",
      "platform": "A",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _simulateLocationUpdate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulateLocationUpdate() {
    // Simulate getting user location
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLocationAccurate = true;
          _currentLocation = "Place de la Brèche, Niort";
        });
      }
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        // Update departure times
        for (var departure in _liveDepartures) {
          departure['minutesUntil'] = (departure['minutesUntil'] as int) - 1;
          if (departure['minutesUntil'] < 0) {
            departure['minutesUntil'] = 30; // Reset for demo
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 2.w),
              const Text('Données mises à jour'),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleLocationTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLocationModal(),
    );
  }

  Widget _buildLocationModal() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Choisir une position',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher une adresse...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          // Location options
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              children: [
                _buildLocationOption(
                  'Ma position actuelle',
                  'Place de la Brèche, Niort',
                  'my_location',
                  true,
                ),
                _buildLocationOption(
                  'Domicile',
                  '12 Rue des Halles, Niort',
                  'home',
                  false,
                ),
                _buildLocationOption(
                  'Travail',
                  'Campus Universitaire, Niort',
                  'work',
                  false,
                ),
                _buildLocationOption(
                  'Gare SNCF',
                  'Place de la Gare, Niort',
                  'train',
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationOption(
      String title, String address, String iconName, bool isSelected) {
    return Card(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        leading: Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppTheme.lightTheme.primaryColor : null,
          ),
        ),
        subtitle: Text(
          address,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        trailing: isSelected
            ? CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              )
            : null,
        onTap: () {
          setState(() {
            _currentLocation = address;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _handleStopTap(Map<String, dynamic> stop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStopDetailModal(stop),
    );
  }

  Widget _buildStopDetailModal(Map<String, dynamic> stop) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'directions_walk',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${stop['walkingTime']}min à pied (${stop['distance']}m)',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Tab bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Horaires'),
              Tab(text: 'Plan'),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTimetableTab(stop),
                _buildMapTab(stop),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableTab(Map<String, dynamic> stop) {
    return ListView(
      padding: EdgeInsets.all(4.w),
      children: [
        Text(
          'Prochains départs',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ..._liveDepartures.take(4).map((departure) {
          return Card(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        departure['line'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          departure['destination'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Quai ${departure['platform']}',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${departure['minutesUntil']}min',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMapTab(Map<String, dynamic> stop) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            height: 30.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'map',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Plan de l\'arrêt',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Fonctionnalité à venir',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Itinéraire vers ${stop['name']}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: CustomIconWidget(
                iconName: 'directions',
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Itinéraire'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStopLongPress(Map<String, dynamic> stop) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                stop['name'] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'home',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text('Définir comme Domicile'),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Domicile défini: ${stop['name']}');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'work',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text('Définir comme Travail'),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Travail défini: ${stop['name']}');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: const Text('Partager la position'),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Position partagée');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report_problem',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Signaler un problème',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Problème signalé');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleDepartureSwipeRight(Map<String, dynamic> departure) {
    _showSnackBar(
        '${departure['line']} → ${departure['destination']} ajouté aux favoris');
  }

  void _handleDepartureSwipeLeft(Map<String, dynamic> departure) {
    _showSnackBar(
        'Alerte configurée pour ${departure['line']} → ${departure['destination']}');
  }

  void _handlePlanJourney() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildJourneyPlannerModal(),
    );
  }

  Widget _buildJourneyPlannerModal() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Planifier un trajet',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Départ',
                      hintText: _currentLocation,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'my_location',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Destination',
                      hintText: 'Où voulez-vous aller ?',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            hintText: 'Aujourd\'hui',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: 'calendar_today',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Heure',
                            hintText: 'Maintenant',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: 'access_time',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  CheckboxListTile(
                    title: const Text('Accessible PMR'),
                    subtitle: const Text(
                        'Trajets adaptés aux personnes à mobilité réduite'),
                    value: false,
                    onChanged: (value) {},
                    secondary: CustomIconWidget(
                      iconName: 'accessible',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSnackBar('Recherche d\'itinéraires en cours...');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'search',
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          const Text('Rechercher'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleScanQR() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'qr_code_scanner',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('Scanner QR Code'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'qr_code',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 64,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Fonctionnalité à venir',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            const Text(
                'Scannez le QR code sur votre ticket ou à l\'arrêt pour accéder aux informations en temps réel.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/home-dashboard', (r) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, '/event-discovery', (r) => false);
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(context, '/student-discounts', (r) => false);
        break;
      case 3:
      // déjà sur Transport
        break;
      case 4:
        Navigator.pushNamedAndRemoveUntil(context, '/nightlife-guide', (r) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                pinned: false,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                elevation: 0,

                // ⬇️ Ajout de la flèche retour
                leading: IconButton(
                  tooltip: 'Retour',
                  icon: const Icon(Icons.arrow_back),
                  color: AppTheme.lightTheme.primaryColor,
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).maybePop();
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home-dashboard',
                            (route) => false,
                      );
                    }
                  },
                ),


                title: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'directions_bus',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 28,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Transport',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () => _showSnackBar('Notifications transport'),
                    icon: Stack(
                      children: [
                        CustomIconWidget(
                          iconName: 'notifications_outlined',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 3.w,
                            height: 3.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                ],
              ),


              // Location Header
              SliverToBoxAdapter(
                child: LocationHeaderWidget(
                  currentLocation: _currentLocation,
                  isLocationAccurate: _isLocationAccurate,
                  onLocationTap: _handleLocationTap,
                  onRefresh: _handleRefresh,
                  isRefreshing: _isRefreshing,
                ),
              ),

              // Nearby Stops
              SliverToBoxAdapter(
                child: NearbyStopsWidget(
                  nearbyStops: _nearbyStops,
                  onStopTap: _handleStopTap,
                  onStopLongPress: _handleStopLongPress,
                ),
              ),

              // Live Departures
              SliverToBoxAdapter(
                child: LiveDeparturesWidget(
                  departures: _liveDepartures,
                  onDepartureSwipeRight: _handleDepartureSwipeRight,
                  onDepartureSwipeLeft: _handleDepartureSwipeLeft,
                ),
              ),

              // Journey Planner
              SliverToBoxAdapter(
                child: JourneyPlannerWidget(
                  onPlanJourneyTap: _handlePlanJourney,
                  onScanQRTap: _handleScanQR,
                ),
              ),

              // Bottom padding
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 3, // l’onglet Transport
        onTap: _onBottomNavTap,
      ),
    );
  }
}
