import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NearbyStopsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> nearbyStops;
  final Function(Map<String, dynamic>) onStopTap;
  final Function(Map<String, dynamic>) onStopLongPress;

  const NearbyStopsWidget({
    super.key,
    required this.nearbyStops,
    required this.onStopTap,
    required this.onStopLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Arrêts à proximité',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 25.h,
          child: nearbyStops.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: nearbyStops.length,
                  itemBuilder: (context, index) {
                    final stop = nearbyStops[index];
                    return _buildStopCard(context, stop);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'location_searching',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Recherche d\'arrêts...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopCard(BuildContext context, Map<String, dynamic> stop) {
    final walkingTime = stop['walkingTime'] as int? ?? 0;
    final lines = (stop['lines'] as List?)?.cast<String>() ?? [];
    final accessibility = stop['accessibility'] as bool? ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onStopTap(stop),
          onLongPress: () => onStopLongPress(stop),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                // Stop icon and accessibility indicator
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'directions_bus',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 24,
                      ),
                      if (accessibility)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: 'accessible',
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 3.w),

                // Stop details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop['name'] as String? ?? 'Arrêt inconnu',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),

                      // Lines
                      if (lines.isNotEmpty)
                        Wrap(
                          spacing: 1.w,
                          runSpacing: 0.5.h,
                          children: lines.take(3).map((line) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getLineColor(line),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                line,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                      if (lines.length > 3) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          '+${lines.length - 3} autres lignes',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Walking time and distance
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'directions_walk',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${walkingTime}min',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${stop['distance'] ?? 0}m',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getLineColor(String line) {
    // Simple color mapping for different line types
    final lineNumber =
        int.tryParse(line.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final colors = [
      AppTheme.lightTheme.primaryColor,
      AppTheme.lightTheme.colorScheme.secondary,
      const Color(0xFF9C27B0),
      const Color(0xFFFF5722),
      const Color(0xFF607D8B),
      const Color(0xFF795548),
    ];
    return colors[lineNumber % colors.length];
  }
}
