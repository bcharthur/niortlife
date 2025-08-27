import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
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
          _buildHandle(colorScheme),
          _buildHeader(colorScheme),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMusicPreferences(colorScheme),
                  SizedBox(height: 3.h),
                  _buildCrowdSize(colorScheme),
                  SizedBox(height: 3.h),
                  _buildPriceRange(colorScheme),
                  SizedBox(height: 3.h),
                  _buildSafetyRating(colorScheme),
                  SizedBox(height: 3.h),
                  _buildVenueType(colorScheme),
                  SizedBox(height: 3.h),
                  _buildActionButtons(context),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      width: 10.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: colorScheme.outline,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Row(
        children: [
          Text(
            'Filtres',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              'Réinitialiser',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicPreferences(ColorScheme colorScheme) {
    final musicGenres = [
      'Électro',
      'Hip-Hop',
      'Pop',
      'Rock',
      'Jazz',
      'Reggae',
      'Techno',
      'House'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Préférences musicales',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: musicGenres.map((genre) {
            final isSelected = (_filters['musicGenres'] as List<String>? ?? [])
                .contains(genre);
            return FilterChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final genres =
                      List<String>.from(_filters['musicGenres'] ?? []);
                  if (selected) {
                    genres.add(genre);
                  } else {
                    genres.remove(genre);
                  }
                  _filters['musicGenres'] = genres;
                });
              },
              labelStyle: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color:
                    isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.primary,
              checkmarkColor: colorScheme.onPrimary,
              side: BorderSide(color: colorScheme.outline),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCrowdSize(ColorScheme colorScheme) {
    final crowdSizes = ['Faible', 'Modéré', 'Élevé'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Niveau de foule',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: crowdSizes.map((size) {
            final isSelected =
                (_filters['crowdSizes'] as List<String>? ?? []).contains(size);
            return FilterChip(
              label: Text(size),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final sizes = List<String>.from(_filters['crowdSizes'] ?? []);
                  if (selected) {
                    sizes.add(size);
                  } else {
                    sizes.remove(size);
                  }
                  _filters['crowdSizes'] = sizes;
                });
              },
              labelStyle: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color:
                    isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.primary,
              checkmarkColor: colorScheme.onPrimary,
              side: BorderSide(color: colorScheme.outline),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRange(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gamme de prix',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        RangeSlider(
          values: RangeValues(
            (_filters['minPrice'] as double? ?? 0.0),
            (_filters['maxPrice'] as double? ?? 50.0),
          ),
          min: 0,
          max: 50,
          divisions: 10,
          labels: RangeLabels(
            '${(_filters['minPrice'] as double? ?? 0.0).round()}€',
            '${(_filters['maxPrice'] as double? ?? 50.0).round()}€',
          ),
          onChanged: (values) {
            setState(() {
              _filters['minPrice'] = values.start;
              _filters['maxPrice'] = values.end;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0€',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '50€+',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSafetyRating(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note de sécurité minimum',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: List.generate(5, (index) {
            final rating = index + 1;
            final isSelected =
                (_filters['minSafetyRating'] as int? ?? 1) >= rating;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _filters['minSafetyRating'] = rating;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 1.w),
                child: CustomIconWidget(
                  iconName: isSelected ? 'star' : 'star_border',
                  color: isSelected ? Colors.amber : colorScheme.outline,
                  size: 24,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildVenueType(ColorScheme colorScheme) {
    final venueTypes = ['Bar', 'Club', 'Pub', 'Lounge', 'Discothèque'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type de lieu',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: venueTypes.map((type) {
            final isSelected =
                (_filters['venueTypes'] as List<String>? ?? []).contains(type);
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final types = List<String>.from(_filters['venueTypes'] ?? []);
                  if (selected) {
                    types.add(type);
                  } else {
                    types.remove(type);
                  }
                  _filters['venueTypes'] = types;
                });
              },
              labelStyle: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color:
                    isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.primary,
              checkmarkColor: colorScheme.onPrimary,
              side: BorderSide(color: colorScheme.outline),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              widget.onFiltersChanged(_filters);
              Navigator.pop(context);
            },
            child: Text(
              'Appliquer',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
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
    });
  }
}