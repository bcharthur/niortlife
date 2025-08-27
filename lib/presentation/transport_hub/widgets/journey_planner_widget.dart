import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class JourneyPlannerWidget extends StatelessWidget {
  final VoidCallback onPlanJourneyTap;
  final VoidCallback onScanQRTap;

  const JourneyPlannerWidget({
    super.key,
    required this.onPlanJourneyTap,
    required this.onScanQRTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Plan Journey Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: onPlanJourneyTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'route',
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Planifier un trajet',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Quick Actions Row
          Row(
            children: [
              // Scan QR Code
              Expanded(
                child: Container(
                  height: 12.h,
                  child: OutlinedButton(
                    onPressed: onScanQRTap,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppTheme.lightTheme.primaryColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'qr_code_scanner',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 32,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Scanner QR',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // My Routes
              Expanded(
                child: Container(
                  height: 12.h,
                  child: OutlinedButton(
                    onPressed: () => _showMyRoutes(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'bookmark_outline',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 32,
                            ),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 4.w,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '3',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Mes trajets',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Quick destination chips
          _buildQuickDestinations(context),
        ],
      ),
    );
  }

  Widget _buildQuickDestinations(BuildContext context) {
    final quickDestinations = [
      {'name': 'Gare SNCF', 'icon': 'train'},
      {'name': 'Centre-ville', 'icon': 'location_city'},
      {'name': 'Campus', 'icon': 'school'},
      {'name': 'Hôpital', 'icon': 'local_hospital'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Destinations rapides',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: quickDestinations.map((destination) {
            return ActionChip(
              onPressed: () =>
                  _planToDestination(context, destination['name'] as String),
              avatar: CustomIconWidget(
                iconName: destination['icon'] as String,
                color: AppTheme.lightTheme.primaryColor,
                size: 16,
              ),
              label: Text(
                destination['name'] as String,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              backgroundColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              side: BorderSide(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showMyRoutes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
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
                    'Mes trajets favoris',
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

            // Routes list
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  _buildSavedRoute(
                    context,
                    'Domicile → Campus',
                    'Ligne 3, 15 min',
                    '08:30',
                  ),
                  _buildSavedRoute(
                    context,
                    'Campus → Centre-ville',
                    'Ligne 1, 12 min',
                    '17:45',
                  ),
                  _buildSavedRoute(
                    context,
                    'Gare → Domicile',
                    'Ligne 2, 20 min',
                    '19:15',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedRoute(
    BuildContext context,
    String route,
    String details,
    String time,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        leading: Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: 'bookmark',
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 20,
          ),
        ),
        title: Text(
          route,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          details,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Prochain',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Planification du trajet: $route'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _planToDestination(BuildContext context, String destination) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Planification vers: $destination'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
