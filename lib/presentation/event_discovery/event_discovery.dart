import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/event_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/search_bar_widget.dart';
import '../../widgets/actions/map_action_button.dart';

class EventDiscovery extends StatefulWidget {
  const EventDiscovery({super.key});

  @override
  State<EventDiscovery> createState() => _EventDiscoveryState();
}

class _EventDiscoveryState extends State<EventDiscovery>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<String> _selectedCategories = [];
  Map<String, dynamic> _activeFilters = {};
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock data for events
  final List<Map<String, dynamic>> _allEvents = [
    {
      "id": 1,
      "title": "Concert Jazz au Moulin du Roc",
      "category": "Culturel",
      "date": "25 Août 2025",
      "time": "20h30",
      "venue": "Moulin du Roc, Niort",
      "price": "25€",
      "image":
          "https://images.pexels.com/photos/1190298/pexels-photo-1190298.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": false,
      "ageRestriction": false,
      "description":
          "Soirée jazz exceptionnelle avec des artistes locaux et internationaux dans le cadre magique du Moulin du Roc.",
    },
    {
      "id": 2,
      "title": "Match de Football - Chamois Niortais",
      "category": "Sports",
      "date": "26 Août 2025",
      "time": "19h00",
      "venue": "Stade René Gaillard",
      "price": "15€",
      "image":
          "https://images.pexels.com/photos/274506/pexels-photo-274506.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": true,
      "ageRestriction": false,
      "description":
          "Venez supporter les Chamois Niortais dans ce match crucial de Ligue 2.",
    },
    {
      "id": 3,
      "title": "Soirée Étudiante - Le Camion",
      "category": "Soirées",
      "date": "27 Août 2025",
      "time": "22h00",
      "venue": "Le Camion, Centre-ville",
      "price": "8€",
      "image":
          "https://images.pexels.com/photos/1763075/pexels-photo-1763075.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": false,
      "ageRestriction": true,
      "description":
          "Soirée spéciale étudiants avec DJ set et ambiance festive. Entrée gratuite pour les étudiants avant 23h.",
    },
    {
      "id": 4,
      "title": "Festival des Arts de Rue",
      "category": "Gratuit",
      "date": "28 Août 2025",
      "time": "14h00",
      "venue": "Place de la Brèche",
      "price": "Gratuit",
      "image":
          "https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": false,
      "ageRestriction": false,
      "description":
          "Spectacles de rue gratuits avec jongleurs, musiciens et artistes de toute la région.",
    },
    {
      "id": 5,
      "title": "Tournoi de Tennis de Table",
      "category": "Sports",
      "date": "29 Août 2025",
      "time": "10h00",
      "venue": "Complexe Sportif Pré-Leroy",
      "price": "5€",
      "image":
          "https://images.pexels.com/photos/976873/pexels-photo-976873.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": false,
      "ageRestriction": false,
      "description":
          "Tournoi ouvert à tous les niveaux avec prix pour les gagnants et rafraîchissements.",
    },
    {
      "id": 6,
      "title": "Exposition Photo - Niort d'Hier et d'Aujourd'hui",
      "category": "Culturel",
      "date": "30 Août 2025",
      "time": "10h00",
      "venue": "Musée Bernard d'Agesci",
      "price": "7€",
      "image":
          "https://images.pexels.com/photos/1183992/pexels-photo-1183992.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isFavorite": true,
      "ageRestriction": false,
      "description":
          "Découvrez l'évolution de Niort à travers des photographies d'époque et contemporaines.",
    },
  ];

  List<Map<String, dynamic>> _filteredEvents = [];
  final List<String> _categories = ['Sports', 'Culturel', 'Soirées', 'Gratuit'];

  @override
  void initState() {
    super.initState();
    _filteredEvents = List.from(_allEvents);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _filterEvents();
  }

  void _filterEvents() {
    setState(() {
      _filteredEvents = _allEvents.where((event) {
        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final title = (event["title"] as String).toLowerCase();
          final venue = (event["venue"] as String).toLowerCase();
          final category = (event["category"] as String).toLowerCase();

          if (!title.contains(query) &&
              !venue.contains(query) &&
              !category.contains(query)) {
            return false;
          }
        }

        // Category filter
        if (_selectedCategories.isNotEmpty) {
          if (!_selectedCategories.contains(event["category"])) {
            return false;
          }
        }

        // Age restriction filter
        if (_activeFilters['ageRestriction'] == true) {
          if (event["ageRestriction"] != true) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
    _filterEvents();
  }

  void _toggleFavorite(int eventId) {
    setState(() {
      final eventIndex =
          _allEvents.indexWhere((event) => event["id"] == eventId);
      if (eventIndex != -1) {
        _allEvents[eventIndex]["isFavorite"] =
            !(_allEvents[eventIndex]["isFavorite"] as bool);
      }
    });
    _filterEvents();
  }

  void _shareEvent(Map<String, dynamic> event) {
    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Partage de "${event["title"]}" - Fonctionnalité à venir'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          _filterEvents();
        },
      ),
    );
  }

  void _onVoiceSearch() {
    // Mock voice search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recherche vocale - Fonctionnalité à venir'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Événements mis à jour'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _activeFilters.clear();
      _searchController.clear();
      _searchQuery = '';
    });
    _filterEvents();
  }

  void _browseAllEvents() {
    setState(() {
      _selectedCategories.clear();
      _activeFilters.clear();
      _searchController.clear();
      _searchQuery = '';
    });
    _filterEvents();
  }

  int _getActiveFilterCount() {
    int count = _selectedCategories.length;
    if (_activeFilters['dateRange'] != null) count++;
    if (_activeFilters['priceRange'] != null) count++;
    if (_activeFilters['locationRadius'] != null &&
        _activeFilters['locationRadius'] != 10.0) count++;
    if (_activeFilters['ageRestriction'] == true) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Événements',
        variant: CustomAppBarVariant.search,
        actions: const [
          MapActionButton(), // 👉 ouvre la carte
        ],
      ),

      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            onFilterTap: _showFilterBottomSheet,
            onVoiceSearch: _onVoiceSearch,
            onChanged: (value) {
              // Already handled by listener
            },
            filterCount: _getActiveFilterCount(),
          ),

          // Filter Chips
          Container(
            height: 8.h,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final count = _allEvents
                    .where((event) => event["category"] == category)
                    .length;

                return FilterChipWidget(
                  label: category,
                  isSelected: _selectedCategories.contains(category),
                  onTap: () => _toggleCategory(category),
                  count: count,
                );
              },
            ),
          ),

          // Events List
          Expanded(
            child: _filteredEvents.isEmpty
                ? EmptyStateWidget(
                    title: _searchQuery.isNotEmpty ||
                            _selectedCategories.isNotEmpty ||
                            _getActiveFilterCount() > 0
                        ? 'Aucun événement trouvé'
                        : 'Aucun événement disponible',
                    subtitle: _searchQuery.isNotEmpty ||
                            _selectedCategories.isNotEmpty ||
                            _getActiveFilterCount() > 0
                        ? 'Essayez de modifier vos critères de recherche ou vos filtres pour voir plus d\'événements.'
                        : 'Il n\'y a actuellement aucun événement disponible. Revenez plus tard pour découvrir de nouveaux événements.',
                    actionText: _searchQuery.isNotEmpty ||
                            _selectedCategories.isNotEmpty ||
                            _getActiveFilterCount() > 0
                        ? 'Effacer les filtres'
                        : null,
                    onActionPressed: _searchQuery.isNotEmpty ||
                            _selectedCategories.isNotEmpty ||
                            _getActiveFilterCount() > 0
                        ? _clearFilters
                        : null,
                    secondaryActionText: 'Parcourir tous les événements',
                    onSecondaryActionPressed: _browseAllEvents,
                  )
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: colorScheme.primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = _filteredEvents[index];

                        return EventCardWidget(
                          event: event,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/event-detail',
                              arguments: event,
                            );
                          },
                          onFavorite: () => _toggleFavorite(event["id"] as int),
                          onShare: () => _shareEvent(event),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 1, // Events tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home-dashboard', (route) => false);
              break;
            case 1:
              // Already on events page
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/student-discounts', (route) => false);
              break;
            case 3:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/transport-hub', (route) => false);
              break;
            case 4:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/nightlife-guide', (route) => false);
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Créer une alerte - Fonctionnalité à venir'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        icon: CustomIconWidget(
          iconName: 'notifications_active',
          color: colorScheme.onPrimary,
          size: 20,
        ),
        label: Text(
          'Alerte',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
