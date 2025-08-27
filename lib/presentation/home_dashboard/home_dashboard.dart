import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/happening_tonight_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/student_discounts_widget.dart';
import './widgets/transport_widget.dart';
import './widgets/home_map_card_widget.dart';


class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          child: CustomScrollView(
            slivers: [
              // Location Header
              const SliverToBoxAdapter(
                child: LocationHeaderWidget(),
              ),

              // Main Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Welcome Section
                    _buildWelcomeSection(),

                    SizedBox(height: 3.h),

                    // Espace
                    SizedBox(height: 1.5.h),

// Mini carte (aperçu) avec bouton plein écran
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: const HomeMapCardWidget(
                        fullBleed: true,
                        height: 280, // ajuste à 300 si tu veux
                      ),
                    ),

// Espace
                    SizedBox(height: 2.h),

                    // Happening Tonight
                    const HappeningTonightWidget(),

                    SizedBox(height: 4.h),

                    // Student Discounts
                    const StudentDiscountsWidget(),

                    SizedBox(height: 4.h),

                    // Transport Widget
                    const TransportWidget(),

                    SizedBox(height: 4.h),

                    // Quick Actions
                    _buildQuickActionsSection(),

                    SizedBox(height: 10.h), // Bottom padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: _onBottomNavTap,
        variant: CustomBottomBarVariant.standard,
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: _openSearch,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          elevation: 4.0,
          child: CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildWelcomeSection() {
    final DateTime now = DateTime.now();
    final String greeting = _getGreeting(now.hour);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Découvrez ce qui se passe à Niort aujourd'hui",
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),

          // Stats Row
          Row(
            children: [
              _buildStatCard("12", "Événements", 'event'),
              SizedBox(width: 3.w),
              _buildStatCard("25", "Réductions", 'local_offer'),
              SizedBox(width: 3.w),
              _buildStatCard("8", "Lignes", 'directions_bus'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label, String iconName) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              number,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    final List<Map<String, dynamic>> quickActions = [
      {
        "title": "Sorties nocturnes",
        "subtitle": "Bars, clubs et événements",
        "icon": "nightlife",
        "route": "/nightlife-guide",
        "color": AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        "title": "Événements culturels",
        "subtitle": "Concerts, théâtre, expositions",
        "icon": "theater_comedy",
        "route": "/event-discovery",
        "color": AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        "title": "Transport en temps réel",
        "subtitle": "Horaires et itinéraires",
        "icon": "directions_transit",
        "route": "/transport-hub",
        "color": AppTheme.lightTheme.colorScheme.primary,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            "Accès rapide",
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: quickActions
                .map((action) => _buildQuickActionCard(action))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(Map<String, dynamic> action) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, action["route"] as String);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: (action["color"] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: action["icon"] as String,
                    color: action["color"] as Color,
                    size: 24,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action["title"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        action["subtitle"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return "Bonjour !";
    } else if (hour < 18) {
      return "Bon après-midi !";
    } else {
      return "Bonsoir !";
    }
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Contenu mis à jour'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _onBottomNavTap(int index) {
    final routes = [
      '/home-dashboard',
      '/event-discovery',
      '/student-discounts',
      '/transport-hub',
      '/nightlife-guide',
    ];

    if (index < routes.length && routes[index] != '/home-dashboard') {
      Navigator.pushNamed(context, routes[index]);
    }
  }

  void _openSearch() {
    showSearch(
      context: context,
      delegate: _NiortLifeSearchDelegate(),
    );
  }
}

class _NiortLifeSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Rechercher événements, lieux, réductions...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: CustomIconWidget(
          iconName: 'clear',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 24,
        ),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
      IconButton(
        icon: CustomIconWidget(
          iconName: 'mic',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        onPressed: () {
          // Voice search functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recherche vocale - Fonctionnalité à venir'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: CustomIconWidget(
        iconName: 'arrow_back',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 24,
      ),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Recherche pour: "$query"',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 1.h),
          Text(
            'Fonctionnalité de recherche à venir',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
      'Événements ce soir',
      'Restaurants étudiants',
      'Transport nocturne',
      'Réductions cinéma',
      'Bars centre-ville',
      'Concerts Moulin du Roc',
      'Soirées étudiantes',
      'Horaires bus ligne 1',
    ];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          title: Text(
            suggestion,
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}
