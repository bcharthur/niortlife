import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class EventInfoSection extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const EventInfoSection({
    super.key,
    required this.eventData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event title
          Text(
            eventData['title'] as String,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Date and time
          _buildInfoRow(
            context,
            'schedule',
            '${eventData['date']} • ${eventData['time']}',
          ),

          SizedBox(height: 1.h),

          // Venue
          _buildInfoRow(
            context,
            'location_on',
            eventData['venue'] as String,
          ),

          SizedBox(height: 1.h),

          // Price
          _buildInfoRow(
            context,
            'euro',
            eventData['price'] as String,
          ),

          if (eventData['ageRestriction'] != null) ...[
            SizedBox(height: 1.h),
            _buildInfoRow(
              context,
              'verified_user',
              eventData['ageRestriction'] as String,
            ),
          ],

          // Student discount indicator
          if (eventData['hasStudentDiscount'] == true) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'school',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Réduction étudiante disponible',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String iconName, String text) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
