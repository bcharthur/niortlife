
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import 'widgets/filter_bottom_sheet_widget.dart';
import 'widgets/safety_mode_widget.dart';
import 'widgets/venue_card_widget.dart';
import 'widgets/venue_context_menu_widget.dart';

class NightlifeGuide extends StatefulWidget {
  const NightlifeGuide({super.key});

  @override
  State<NightlifeGuide> createState() => _NightlifeGuideState();
}

class _NightlifeGuideState extends State<NightlifeGuide>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  bool _isLoading = false;
  bool _showOpenOnly = false;
  bool _safetyModeActive = false;

  /// Désactive la vérif d'âge par défaut. Passe à `false` pour réactiver.
  bool _ageVerified = false;

  /// Empêche l'ouverture multiple de la modale.
  bool _ageDialogShown = false;

  double _locationRadius = 5.0;
  String _currentTime = '';
  OverlayEntry? _contextMenuOverlay;

  Map<String, dynamic> _filters = {
    'musicGenres': <String>[],
    'crowdSizes': <String>[],
    'minPrice': 0.0,
    'maxPrice': 50.0,
    'minSafetyRating': 1,
    'venueTypes': <String>[],
  };

  final List<Map<String, dynamic>> _venues = [
    {
      "id": 1,
      "name": "Le Zinc",
      "image":
      "https://images.unsplash.com/photo-1514933651103-005eec06c04b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "address": "12 Rue Saint-Jean, Niort",
      "hours": "18h00 - 02h00",
      "isOpen": true,
      "crowdLevel": "Modéré",
      "hasStudentDiscount": true,
      "badges": ["Jazz", "Cocktails", "Terrasse"],
      "safetyRating": 4,
      "venueType": "Bar",
      "priceRange": 15.0,
    },
    {
      "id": 2,
      "name": "Club Atmosphere",
      "image":
      "https://images.unsplash.com/photo-1571266028243-d220c9c3b2d2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "address": "25 Avenue de Paris, Niort",
      "hours": "22h00 - 05h00",
      "isOpen": true,
      "crowdLevel": "Élevé",
      "hasStudentDiscount": false,
      "badges": ["Électro", "Danse", "18+"],
      "safetyRating": 3,
      "venueType": "Club",
      "priceRange": 25.0,
    },
    {
      "id": 3,
      "name": "Pub O'Malley's",
      "image":
      "https://images.unsplash.com/photo-1572116469696-31de0f17cc34?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "address": "8 Place de la Brèche, Niort",
      "hours": "17h00 - 01h00",
      "isOpen": false,
      "crowdLevel": "Faible",
      "hasStudentDiscount": true,
      "badges": ["Bière", "Sport", "Décontracté"],
      "safetyRating": 5,
      "venueType": "Pub",
      "priceRange": 12.0,
    },
    {
      "id": 4,
      "name": "Lounge 79",
      "image":
      "https://images.unsplash.com/photo-1566417713940-fe7c737a9ef2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "address": "79 Rue Ricard, Niort",
      "hours": "19h00 - 02h30",
      "isOpen": true,
      "crowdLevel": "Modéré",
      "hasStudentDiscount": true,
      "badges": ["Lounge", "Cocktails", "Chic"],
      "safetyRating": 4,
      "venueType": "Lounge",
      "priceRange": 20.0,
    },
    {
      "id": 5,
      "name": "La Discothèque",
      "image":
      "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "address": "15 Boulevard Main, Niort",
      "hours": "23h00 - 06h00",
      "isOpen": true,
      "crowdLevel": "Élevé",
      "hasStudentDiscount": false,
      "badges": ["House", "Techno", "VIP"],
      "safetyRating": 3,
      "venueType": "Discothèque",
      "priceRange": 30.0,
    },
  ];

  List<Map<String, dynamic>> _filteredVenues = [];
  List<Map<String, dynamic>> _tonightsPlan = [];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));

    _updateCurrentTime();

    // Affiche une seule modale si _ageVerified == false
    _checkAgeVerification();

    _filteredVenues = List.from(_venues);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _contextMenuOverlay?.remove();
    super.dispose();
  }

  void _updateCurrentTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });
  }

  void _checkAgeVerification() {
    if (!_ageVerified && !_ageDialogShown) {
      _ageDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showAgeVerificationDialog();
      });
    }
  }

  void _showAgeVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'Vérification d\'âge',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vous devez avoir 18 ans ou plus pour accéder au guide nocturne.',
              style: GoogleFonts.inter(fontSize: 14.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              'Confirmez-vous avoir 18 ans ou plus ?',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _ageDialogShown = false;
              Navigator.pushReplacementNamed(context, '/home-dashboard');
            },
            child: Text(
              'Non',
              style: GoogleFonts.inter(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _ageVerified = true;
              });
              _ageDialogShown = false;
              Navigator.pop(context);
            },
            child: Text(
              'Oui, j\'ai 18 ans+',
              style: GoogleFonts.inter(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme),
      body: _buildBody(colorScheme),
      floatingActionButton: SafetyModeWidget(
        isActive: _safetyModeActive,
        onToggle: _toggleSafetyMode,
        onEmergencyContact: _showEmergencyContacts,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 2,
      title: Row(
        children: [
          CustomIconWidget(
            iconName: 'nightlife',
            color: colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Text(
            'Sorties Nocturnes',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 2.w),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                _currentTime,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _showFilterBottomSheet,
          icon: CustomIconWidget(
            iconName: 'tune',
            color: colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(ColorScheme colorScheme) {
    return Column(
      children: [
        _buildFilterHeader(colorScheme),
        Expanded(
          child: _filteredVenues.isEmpty
              ? _buildEmptyState(colorScheme)
              : _buildVenuesList(),
        ),
      ],
    );
  }

  Widget _buildFilterHeader(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Switch(
                  value: _showOpenOnly,
                  onChanged: (value) {
                    setState(() {
                      _showOpenOnly = value;
                      _applyFilters();
                    });
                  },
                ),
                SizedBox(width: 2.w),
                Text(
                  'Ouvert maintenant',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${_locationRadius.round()} km',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenuesList() {
    return RefreshIndicator(
      onRefresh: _refreshVenues,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 10.h),
        itemCount: _filteredVenues.length,
        itemBuilder: (context, index) {
          final venue = _filteredVenues[index];
          return VenueCardWidget(
            venue: venue,
            onTap: () => _navigateToVenueDetail(venue),
            onAddToPlan: () => _addToTonightsPlan(venue),
            onShare: () => _shareVenue(venue),
            onLongPress: () => _showVenueContextMenu(venue, context),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 4.h),
          Text(
            'Aucun lieu trouvé',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Essayez d\'explorer une zone différente\nou revenez plus tard',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: _expandSearchArea,
                child: Text(
                  'Explorer plus loin',
                  style: GoogleFonts.inter(),
                ),
              ),
              SizedBox(width: 4.w),
              ElevatedButton(
                onPressed: _resetFilters,
                child: Text(
                  'Réinitialiser filtres',
                  style: GoogleFonts.inter(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem('home', 'Accueil', '/home-dashboard', false),
              _buildNavItem('event', 'Événements', '/event-discovery', false),
              _buildNavItem(
                  'local_offer', 'Réductions', '/student-discounts', false),
              _buildNavItem(
                  'directions_bus', 'Transport', '/transport-hub', false),
              _buildNavItem('nightlife', 'Sorties', '/nightlife-guide', true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      String icon, String label, String route, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    final color =
    isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshVenues() async {
    setState(() {
      _isLoading = true;
    });

    _refreshController.forward();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _updateCurrentTime();
      _applyFilters();
    });

    _refreshController.reset();
  }

  void _applyFilters() {
    setState(() {
      _filteredVenues = _venues.where((venue) {
        // Open only filter
        if (_showOpenOnly && venue["isOpen"] != true) {
          return false;
        }

        // Music genre filter
        final musicGenres = _filters['musicGenres'] as List<String>;
        if (musicGenres.isNotEmpty) {
          final venueBadges = venue["badges"] as List<String>;
          if (!musicGenres.any((genre) => venueBadges.contains(genre))) {
            return false;
          }
        }

        // Crowd size filter
        final crowdSizes = _filters['crowdSizes'] as List<String>;
        if (crowdSizes.isNotEmpty && !crowdSizes.contains(venue["crowdLevel"])) {
          return false;
        }

        // Price range filter
        final venuePrice = venue["priceRange"] as double;
        final minPrice = _filters['minPrice'] as double;
        final maxPrice = _filters['maxPrice'] as double;
        if (venuePrice < minPrice || venuePrice > maxPrice) {
          return false;
        }

        // Safety rating filter
        final minSafetyRating = _filters['minSafetyRating'] as int;
        if ((venue["safetyRating"] as int) < minSafetyRating) {
          return false;
        }

        // Venue type filter
        final venueTypes = _filters['venueTypes'] as List<String>;
        if (venueTypes.isNotEmpty && !venueTypes.contains(venue["venueType"])) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _filters,
        onFiltersChanged: (newFilters) {
          setState(() {
            _filters = newFilters;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _toggleSafetyMode() {
    setState(() {
      _safetyModeActive = !_safetyModeActive;
    });

    if (_safetyModeActive) {
      _showSafetyModeBottomSheet();
    }
  }

  void _showSafetyModeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafetyModeBottomSheet(
        isActive: _safetyModeActive,
        onToggle: _toggleSafetyMode,
        onEmergencyContact: _showEmergencyContacts,
      ),
    );
  }

  void _showEmergencyContacts() {
    // Emergency contacts functionality handled in SafetyModeBottomSheet
  }

  void _showVenueContextMenu(Map<String, dynamic> venue, BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _contextMenuOverlay?.remove();
    _contextMenuOverlay = OverlayEntry(
      builder: (context) => VenueContextMenuOverlay(
        venue: venue,
        position: position,
        onCall: () => _callVenue(venue),
        onDirections: () => _getDirections(venue),
        onAddReview: () => _addReview(venue),
        onReportSafety: () => _reportSafety(venue),
        onClose: () {
          _contextMenuOverlay?.remove();
          _contextMenuOverlay = null;
        },
      ),
    );

    Overlay.of(context).insert(_contextMenuOverlay!);
  }

  void _navigateToVenueDetail(Map<String, dynamic> venue) {
    Navigator.pushNamed(
      context,
      '/event-detail',
      arguments: {
        'type': 'venue',
        'data': venue,
      },
    );
  }

  void _addToTonightsPlan(Map<String, dynamic> venue) {
    setState(() {
      if (!_tonightsPlan.any((v) => v["id"] == venue["id"])) {
        _tonightsPlan.add(venue);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${venue["name"]} ajouté au plan de ce soir',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareVenue(Map<String, dynamic> venue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Partage de ${venue["name"]} avec vos amis',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _callVenue(Map<String, dynamic> venue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Appel vers ${venue["name"]}',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _getDirections(Map<String, dynamic> venue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Itinéraire vers ${venue["name"]}',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addReview(Map<String, dynamic> venue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ajouter un avis pour ${venue["name"]}',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reportSafety(Map<String, dynamic> venue) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Signalement pour ${venue["name"]}',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _expandSearchArea() {
    setState(() {
      _locationRadius = (_locationRadius + 5).clamp(5, 25);
      _applyFilters();
    });
  }

  void _resetFilters() {
    setState(() {
      _filters = {
        'musicGenres': <String>[],
        'crowdSizes': <String>[],
        'minPrice': 0.0,
        'maxPrice': 50.0,
        'minSafetyRating': 1,
        'venueTypes': <String>[],
      };
      _showOpenOnly = false;
      _applyFilters();
    });
  }
}
