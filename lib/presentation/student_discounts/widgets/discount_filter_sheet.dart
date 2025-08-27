import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

/// Bottom sheet widget for filtering discount options
class DiscountFilterSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersApplied;
  final Map<String, dynamic> currentFilters;

  const DiscountFilterSheet({
    super.key,
    required this.onFiltersApplied,
    required this.currentFilters,
  });

  @override
  State<DiscountFilterSheet> createState() => _DiscountFilterSheetState();
}

class _DiscountFilterSheetState extends State<DiscountFilterSheet> {
  late Map<String, dynamic> _filters;
  RangeValues _discountRange = const RangeValues(10, 50);
  String _selectedBusinessType = 'Tous';
  String _selectedExpiration = 'Tous';
  bool _studentVerificationOnly = false;
  bool _ageRestrictedOnly = false;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _initializeFilters();
  }

  void _initializeFilters() {
    _discountRange = RangeValues(
      (_filters['minDiscount'] ?? 10).toDouble(),
      (_filters['maxDiscount'] ?? 50).toDouble(),
    );
    _selectedBusinessType = _filters['businessType'] ?? 'Tous';
    _selectedExpiration = _filters['expiration'] ?? 'Tous';
    _studentVerificationOnly = _filters['studentVerificationOnly'] ?? false;
    _ageRestrictedOnly = _filters['ageRestrictedOnly'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtres',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Réinitialiser',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Discount Percentage Range
                  _buildSectionTitle('Pourcentage de réduction'),
                  SizedBox(height: 2.h),
                  _buildDiscountRangeSlider(theme),
                  SizedBox(height: 3.h),

                  // Business Type Filter
                  _buildSectionTitle('Type d\'entreprise'),
                  SizedBox(height: 1.h),
                  _buildBusinessTypeFilter(theme),
                  SizedBox(height: 3.h),

                  // Expiration Filter
                  _buildSectionTitle('Expiration'),
                  SizedBox(height: 1.h),
                  _buildExpirationFilter(theme),
                  SizedBox(height: 3.h),

                  // Additional Filters
                  _buildSectionTitle('Filtres supplémentaires'),
                  SizedBox(height: 1.h),
                  _buildAdditionalFilters(theme),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          // Apply Button
          Padding(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: Text('Appliquer les filtres'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildDiscountRangeSlider(ThemeData theme) {
    return Column(
      children: [
        RangeSlider(
          values: _discountRange,
          min: 5,
          max: 70,
          divisions: 13,
          labels: RangeLabels(
            '${_discountRange.start.round()}%',
            '${_discountRange.end.round()}%',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _discountRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_discountRange.start.round()}% - ${_discountRange.end.round()}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Réduction',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBusinessTypeFilter(ThemeData theme) {
    final businessTypes = [
      'Tous',
      'Bars',
      'Restaurants',
      'Boutiques',
      'Services'
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: businessTypes.map((type) {
        final isSelected = _selectedBusinessType == type;
        return FilterChip(
          label: Text(type),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedBusinessType = type;
            });
          },
          backgroundColor: theme.colorScheme.surface,
          selectedColor:
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.primaryColor,
          labelStyle: theme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpirationFilter(ThemeData theme) {
    final expirationOptions = [
      'Tous',
      'Aujourd\'hui',
      'Cette semaine',
      'Ce mois'
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: expirationOptions.map((option) {
        final isSelected = _selectedExpiration == option;
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedExpiration = option;
            });
          },
          backgroundColor: theme.colorScheme.surface,
          selectedColor:
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.lightTheme.primaryColor,
          labelStyle: theme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdditionalFilters(ThemeData theme) {
    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            'Vérification étudiant requise uniquement',
            style: theme.textTheme.bodyMedium,
          ),
          subtitle: Text(
            'Afficher seulement les offres nécessitant une carte étudiant',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          value: _studentVerificationOnly,
          onChanged: (value) {
            setState(() {
              _studentVerificationOnly = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: Text(
            'Restrictions d\'âge (18+) uniquement',
            style: theme.textTheme.bodyMedium,
          ),
          subtitle: Text(
            'Afficher seulement les offres avec restrictions d\'âge',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          value: _ageRestrictedOnly,
          onChanged: (value) {
            setState(() {
              _ageRestrictedOnly = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _discountRange = const RangeValues(10, 50);
      _selectedBusinessType = 'Tous';
      _selectedExpiration = 'Tous';
      _studentVerificationOnly = false;
      _ageRestrictedOnly = false;
    });
  }

  void _applyFilters() {
    final filters = {
      'minDiscount': _discountRange.start.round(),
      'maxDiscount': _discountRange.end.round(),
      'businessType': _selectedBusinessType,
      'expiration': _selectedExpiration,
      'studentVerificationOnly': _studentVerificationOnly,
      'ageRestrictedOnly': _ageRestrictedOnly,
    };

    widget.onFiltersApplied(filters);
    Navigator.pop(context);
  }
}
