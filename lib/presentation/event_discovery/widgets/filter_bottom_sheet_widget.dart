import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _selectedDateRange;
  RangeValues _priceRange = const RangeValues(0, 100);
  double _locationRadius = 10.0;
  bool _ageRestriction = false;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _selectedDateRange = _filters['dateRange'] as DateTimeRange?;
    _priceRange =
        _filters['priceRange'] as RangeValues? ?? const RangeValues(0, 100);
    _locationRadius = _filters['locationRadius'] as double? ?? 10.0;
    _ageRestriction = _filters['ageRestriction'] as bool? ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 10.w,
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
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Tout effacer',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filters Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Range Filter
                  _buildFilterSection(
                    title: 'Période',
                    child: _buildDateRangeFilter(theme, colorScheme),
                  ),

                  SizedBox(height: 3.h),

                  // Price Range Filter
                  _buildFilterSection(
                    title: 'Prix (€)',
                    child: _buildPriceRangeFilter(theme, colorScheme),
                  ),

                  SizedBox(height: 3.h),

                  // Location Radius Filter
                  _buildFilterSection(
                    title: 'Rayon de recherche',
                    child: _buildLocationRadiusFilter(theme, colorScheme),
                  ),

                  SizedBox(height: 3.h),

                  // Age Restriction Filter
                  _buildFilterSection(
                    title: 'Restrictions d\'âge',
                    child: _buildAgeRestrictionFilter(theme, colorScheme),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  'Appliquer les filtres',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        child,
      ],
    );
  }

  Widget _buildDateRangeFilter(ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: _selectDateRange,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'date_range',
              color: colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                _selectedDateRange != null
                    ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                    : 'Sélectionner une période',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _selectedDateRange != null
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRangeFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 100,
          divisions: 20,
          labels: RangeLabels(
            '${_priceRange.start.round()}€',
            '${_priceRange.end.round()}€',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_priceRange.start.round()}€',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '${_priceRange.end.round()}€',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationRadiusFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Slider(
          value: _locationRadius,
          min: 1,
          max: 50,
          divisions: 49,
          label: '${_locationRadius.round()} km',
          onChanged: (value) {
            setState(() {
              _locationRadius = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 km',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '${_locationRadius.round()} km',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '50 km',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgeRestrictionFilter(ThemeData theme, ColorScheme colorScheme) {
    return SwitchListTile(
      title: Text(
        'Événements 18+ uniquement',
        style: theme.textTheme.bodyMedium,
      ),
      subtitle: Text(
        'Afficher seulement les événements pour adultes',
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      value: _ageRestriction,
      onChanged: (value) {
        setState(() {
          _ageRestriction = value;
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _clearAllFilters() {
    setState(() {
      _selectedDateRange = null;
      _priceRange = const RangeValues(0, 100);
      _locationRadius = 10.0;
      _ageRestriction = false;
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{
      'dateRange': _selectedDateRange,
      'priceRange': _priceRange,
      'locationRadius': _locationRadius,
      'ageRestriction': _ageRestriction,
    };

    widget.onFiltersChanged(filters);
    Navigator.pop(context);
  }
}
