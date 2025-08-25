import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationHeaderWidget extends StatelessWidget {
  final String currentLocation;
  final bool isLocationAccurate;
  final VoidCallback onLocationTap;
  final VoidCallback onRefresh;
  final bool isRefreshing;

  const LocationHeaderWidget({
    super.key,
    required this.currentLocation,
    required this.isLocationAccurate,
    required this.onLocationTap,
    required this.onRefresh,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Location icon with accuracy indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: isLocationAccurate
                          ? AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: isLocationAccurate
                          ? 'my_location'
                          : 'location_searching',
                      color: isLocationAccurate
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.error,
                      size: 24,
                    ),
                  ),
                  if (isLocationAccurate)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 3.w),

              // Location text
              Expanded(
                child: GestureDetector(
                  onTap: onLocationTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Position actuelle',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              currentLocation,
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'edit_location',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Refresh button
              Container(
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: isRefreshing ? null : onRefresh,
                  icon: isRefreshing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.primaryColor,
                            ),
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'refresh',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                  tooltip: 'Actualiser',
                ),
              ),
            ],
          ),

          // Accuracy indicator
          if (!isLocationAccurate) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Position approximative. Activez la géolocalisation pour plus de précision.',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Last update time
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 12,
              ),
              SizedBox(width: 1.w),
              Text(
                'Dernière mise à jour: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
