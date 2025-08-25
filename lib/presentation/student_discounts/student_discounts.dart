import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/discount_card_widget.dart';
import './widgets/discount_detail_sheet.dart';
import './widgets/discount_filter_sheet.dart';
import './widgets/empty_state_widget.dart';
import './widgets/qr_scanner_widget.dart';

/// Student Discounts screen providing categorized access to local business offers
/// with QR code generation for participating venues
class StudentDiscounts extends StatefulWidget {
  const StudentDiscounts({super.key});

  @override
  State<StudentDiscounts> createState() => _StudentDiscountsState();
}

class _StudentDiscountsState extends State<StudentDiscounts>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomIndex = 2; // Student Discounts tab
  int _currentTabIndex = 0;
  String _selectedRadius = '1km';
  String _searchQuery = '';
  Map<String, dynamic> _currentFilters = {};
  bool _isOfflineMode = false;

  final List<String> _categories = ['Tous', 'Bars', 'Restaurants', 'Boutiques'];
  final List<String> _radiusOptions = ['500m', '1km', '2km'];

  // Mock data for student discounts
  final List<Map<String, dynamic>> _allDiscounts = [
    {
      "id": 1,
      "businessName": "Le Bistrot Étudiant",
      "offerDescription": "Réduction sur tous les plats du jour",
      "percentage": 20,
      "category": "Restaurants",
      "image":
          "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&h=300&fit=crop",
      "distance": 250,
      "validUntil": "2025-09-15",
      "studentVerificationRequired": true,
      "ageRestriction": false,
      "address": "15 Rue de la République, Niort",
      "phone": "05 49 24 12 34",
      "usagesLeft": 5,
    },
    {
      "id": 2,
      "businessName": "Bar Le Campus",
      "offerDescription": "Happy hour étudiants tous les soirs",
      "percentage": 30,
      "category": "Bars",
      "image":
          "https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=500&h=300&fit=crop",
      "distance": 180,
      "validUntil": "2025-08-30",
      "studentVerificationRequired": true,
      "ageRestriction": true,
      "address": "8 Place de la Brèche, Niort",
      "phone": "05 49 28 45 67",
      "usagesLeft": 3,
    },
    {
      "id": 3,
      "businessName": "Mode & Style",
      "offerDescription": "Réduction sur toute la collection automne",
      "percentage": 15,
      "category": "Boutiques",
      "image":
          "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=500&h=300&fit=crop",
      "distance": 320,
      "validUntil": "2025-09-30",
      "studentVerificationRequired": true,
      "ageRestriction": false,
      "address": "22 Rue Victor Hugo, Niort",
      "phone": "05 49 32 18 90",
      "usagesLeft": 8,
    },
    {
      "id": 4,
      "businessName": "Pizza Corner",
      "offerDescription": "Pizza étudiante + boisson offerte",
      "percentage": 25,
      "category": "Restaurants",
      "image":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&h=300&fit=crop",
      "distance": 450,
      "validUntil": "2025-08-28",
      "studentVerificationRequired": false,
      "ageRestriction": false,
      "address": "5 Avenue de Paris, Niort",
      "phone": "05 49 35 67 89",
      "usagesLeft": 2,
    },
    {
      "id": 5,
      "businessName": "Café des Arts",
      "offerDescription": "Café + pâtisserie à prix réduit",
      "percentage": 18,
      "category": "Restaurants",
      "image":
          "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=500&h=300&fit=crop",
      "distance": 150,
      "validUntil": "2025-09-10",
      "studentVerificationRequired": true,
      "ageRestriction": false,
      "address": "12 Rue des Halles, Niort",
      "phone": "05 49 26 43 21",
      "usagesLeft": 6,
    },
    {
      "id": 6,
      "businessName": "Night Club Sensation",
      "offerDescription": "Entrée gratuite avant 23h",
      "percentage": 100,
      "category": "Bars",
      "image":
          "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=500&h=300&fit=crop",
      "distance": 600,
      "validUntil": "2025-08-26",
      "studentVerificationRequired": true,
      "ageRestriction": true,
      "address": "30 Boulevard Main, Niort",
      "phone": "05 49 40 55 77",
      "usagesLeft": 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredDiscounts {
    List<Map<String, dynamic>> filtered = List.from(_allDiscounts);

    // Filter by category
    if (_currentTabIndex > 0) {
      final category = _categories[_currentTabIndex];
      filtered = filtered
          .where((discount) => discount["category"] == category)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((discount) =>
              (discount["businessName"] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (discount["offerDescription"] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply additional filters
    if (_currentFilters.isNotEmpty) {
      filtered = _applyFilters(filtered);
    }

    return filtered;
  }

  List<Map<String, dynamic>> _applyFilters(
      List<Map<String, dynamic>> discounts) {
    List<Map<String, dynamic>> filtered = List.from(discounts);

    // Filter by discount percentage range
    if (_currentFilters.containsKey('minDiscount') &&
        _currentFilters.containsKey('maxDiscount')) {
      final minDiscount = _currentFilters['minDiscount'] as int;
      final maxDiscount = _currentFilters['maxDiscount'] as int;
      filtered = filtered.where((discount) {
        final percentage = discount["percentage"] as int;
        return percentage >= minDiscount && percentage <= maxDiscount;
      }).toList();
    }

    // Filter by business type
    if (_currentFilters.containsKey('businessType') &&
        _currentFilters['businessType'] != 'Tous') {
      final businessType = _currentFilters['businessType'] as String;
      filtered = filtered
          .where((discount) => discount["category"] == businessType)
          .toList();
    }

    // Filter by student verification requirement
    if (_currentFilters.containsKey('studentVerificationOnly') &&
        _currentFilters['studentVerificationOnly'] == true) {
      filtered = filtered
          .where((discount) => discount["studentVerificationRequired"] == true)
          .toList();
    }

    // Filter by age restriction
    if (_currentFilters.containsKey('ageRestrictedOnly') &&
        _currentFilters['ageRestrictedOnly'] == true) {
      filtered = filtered
          .where((discount) => discount["ageRestriction"] == true)
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search and Location Header
          _buildSearchHeader(theme, colorScheme),
          // Category Tabs
          _buildCategoryTabs(),
          // Discounts Grid
          Expanded(
            child: _buildDiscountsContent(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: _handleBottomNavigation,
      ),
      floatingActionButton: _buildQRScannerFAB(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: 'Réductions Étudiantes',
      variant: CustomAppBarVariant.search,
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'filter_list',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
          onPressed: _showFilterSheet,
          tooltip: 'Filtres',
        ),
        if (_isOfflineMode)
          Container(
            margin: EdgeInsets.only(right: 2.w),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.warningLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'wifi_off',
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Hors ligne',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSearchHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher des réductions...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Location Radius Selector
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Rayon de recherche:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  value: _selectedRadius,
                  underline: const SizedBox(),
                  items: _radiusOptions.map((radius) {
                    return DropdownMenuItem(
                      value: radius,
                      child: Text(
                        radius,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedRadius = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return CustomTabBar(
      tabs: _categories,
      currentIndex: _currentTabIndex,
      onTap: (index) {
        setState(() {
          _currentTabIndex = index;
        });
        _tabController.animateTo(index);
      },
      variant: CustomTabBarVariant.pills,
      isScrollable: true,
    );
  }

  Widget _buildDiscountsContent() {
    final filteredDiscounts = _filteredDiscounts;

    if (filteredDiscounts.isEmpty) {
      return EmptyStateWidget(
        category: _currentTabIndex > 0 ? _categories[_currentTabIndex] : 'Tous',
        onSuggestBusiness: _showSuggestBusinessDialog,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshDiscounts,
      child: GridView.builder(
        padding: EdgeInsets.all(2.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 2.w,
          mainAxisSpacing: 2.w,
        ),
        itemCount: filteredDiscounts.length,
        itemBuilder: (context, index) {
          final discount = filteredDiscounts[index];
          return DiscountCardWidget(
            discount: discount,
            onTap: () => _showDiscountDetail(discount),
            onSave: () => _saveDiscountToWallet(discount),
          );
        },
      ),
    );
  }

  Widget _buildQRScannerFAB() {
    return FloatingActionButton.extended(
      onPressed: _openQRScanner,
      icon: CustomIconWidget(
        iconName: 'qr_code_scanner',
        color: Colors.white,
        size: 24,
      ),
      label: const Text('Scanner QR'),
      backgroundColor: AppTheme.lightTheme.primaryColor,
    );
  }

  void _handleBottomNavigation(int index) {
    if (index != _currentBottomIndex) {
      switch (index) {
        case 0:
          Navigator.pushNamedAndRemoveUntil(
              context, '/home-dashboard', (route) => false);
          break;
        case 1:
          Navigator.pushNamedAndRemoveUntil(
              context, '/event-discovery', (route) => false);
          break;
        case 2:
          // Already on student discounts
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
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: 80.h,
        child: DiscountFilterSheet(
          currentFilters: _currentFilters,
          onFiltersApplied: (filters) {
            setState(() {
              _currentFilters = filters;
            });
          },
        ),
      ),
    );
  }

  void _showDiscountDetail(Map<String, dynamic> discount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DiscountDetailSheet(discount: discount),
    );
  }

  void _saveDiscountToWallet(Map<String, dynamic> discount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('${discount["businessName"]} enregistré dans le portefeuille'),
        action: SnackBarAction(
          label: 'Voir',
          onPressed: () => _showDiscountDetail(discount),
        ),
      ),
    );
  }

  void _openQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerWidget(
          onQRScanned: (qrData) {
            _handleQRScanned(qrData);
          },
        ),
      ),
    );
  }

  void _handleQRScanned(String qrData) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR Code scanné: Réduction validée'),
        backgroundColor: AppTheme.secondaryLight,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuggestBusinessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suggérer une entreprise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vous connaissez une entreprise qui devrait proposer des réductions étudiantes ?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nom de l\'entreprise',
                hintText: 'Ex: Restaurant Le Bon Goût',
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Adresse (optionnel)',
                hintText: 'Ex: 15 Rue de la Paix, Niort',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Suggestion envoyée ! Merci pour votre contribution.'),
                ),
              );
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshDiscounts() async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // In a real app, this would fetch new data from the API
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Réductions mises à jour'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
