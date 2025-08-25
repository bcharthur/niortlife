import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EventCardWidget extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const EventCardWidget({
    super.key,
    required this.event,
    this.onTap,
    this.onFavorite,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    CustomImageWidget(
                      imageUrl: event["image"] as String,
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Category badge
                    Positioned(
                      top: 2.h,
                      left: 4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(event["category"] as String),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event["category"] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Favorite button
                    Positioned(
                      top: 2.h,
                      right: 4.w,
                      child: GestureDetector(
                        onTap: onFavorite,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: event["isFavorite"] == true
                                ? 'favorite'
                                : 'favorite_border',
                            color: event["isFavorite"] == true
                                ? Colors.red
                                : colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Event Details
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event["title"] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),

                    // Date and Time
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            "${event["date"]} • ${event["time"]}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),

                    // Venue
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            event["venue"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),

                    // Price and Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: event["price"] == "Gratuit"
                                ? AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.1)
                                : colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            event["price"] as String,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: event["price"] == "Gratuit"
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Share button
                        GestureDetector(
                          onTap: onShare,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'share',
                              color: colorScheme.onSurfaceVariant,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Colors.orange;
      case 'culturel':
        return Colors.purple;
      case 'soirées':
        return Colors.pink;
      case 'gratuit':
        return Colors.green;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
