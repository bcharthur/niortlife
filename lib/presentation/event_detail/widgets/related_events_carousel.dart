import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class RelatedEventsCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> relatedEvents;
  final Function(Map<String, dynamic>) onEventTap;

  const RelatedEventsCarousel({
    super.key,
    required this.relatedEvents,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (relatedEvents.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Événements similaires',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 32.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: relatedEvents.length,
              itemBuilder: (context, index) {
                final event = relatedEvents[index];
                return _buildEventCard(context, event);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
    final theme = Theme.of(context);

    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 3.w),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => onEventTap(event),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event image
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 18.h,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      CustomImageWidget(
                        imageUrl: event['image'] as String,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),

                      // Price badge
                      if (event['price'] != null && event['price'] != 'Gratuit')
                        Positioned(
                          top: 2.w,
                          right: 2.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              event['price'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                      // Free badge
                      if (event['price'] == 'Gratuit')
                        Positioned(
                          top: 2.w,
                          right: 2.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Gratuit',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Event info
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event title
                      Text(
                        event['title'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.h),

                      // Date and venue
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              event['date'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 0.5.h),

                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              event['venue'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Category tag
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event['category'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
