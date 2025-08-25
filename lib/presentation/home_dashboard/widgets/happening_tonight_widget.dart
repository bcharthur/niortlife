import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HappeningTonightWidget extends StatelessWidget {
  const HappeningTonightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tonightEvents = [
      {
        "id": 1,
        "title": "Soirée Étudiante - Le Camion",
        "venue": "Le Camion Bar",
        "time": "22h00",
        "distance": "0.8 km",
        "image":
            "https://images.pexels.com/photos/1763075/pexels-photo-1763075.jpeg?auto=compress&cs=tinysrgb&w=800",
        "category": "Nightlife",
        "price": "Gratuit",
        "isLiked": false,
      },
      {
        "id": 2,
        "title": "Concert Jazz au Moulin du Roc",
        "venue": "Moulin du Roc",
        "time": "20h30",
        "distance": "1.2 km",
        "image":
            "https://images.pexels.com/photos/1105666/pexels-photo-1105666.jpeg?auto=compress&cs=tinysrgb&w=800",
        "category": "Culture",
        "price": "15€",
        "isLiked": true,
      },
      {
        "id": 3,
        "title": "Karaoké Night - Pub O'Malley's",
        "venue": "O'Malley's Irish Pub",
        "time": "21h00",
        "distance": "0.5 km",
        "image":
            "https://images.pexels.com/photos/2747449/pexels-photo-2747449.jpeg?auto=compress&cs=tinysrgb&w=800",
        "category": "Entertainment",
        "price": "5€",
        "isLiked": false,
      },
      {
        "id": 4,
        "title": "Tournoi de Billard",
        "venue": "Bar des Sports",
        "time": "19h30",
        "distance": "1.5 km",
        "image":
            "https://images.pexels.com/photos/1040473/pexels-photo-1040473.jpeg?auto=compress&cs=tinysrgb&w=800",
        "category": "Sports",
        "price": "10€",
        "isLiked": false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ce soir à Niort",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/event-discovery');
                },
                child: Text(
                  "Voir tout",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 28.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: tonightEvents.length,
            itemBuilder: (context, index) {
              final event = tonightEvents[index];
              return Container(
                width: 70.w,
                margin: EdgeInsets.only(right: 3.w),
                child: _buildEventCard(context, event),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/event-detail');
      },
      onLongPress: () {
        _showQuickActions(context, event);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              CustomImageWidget(
                imageUrl: event["image"] as String,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              event["category"] as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            event["price"] as String,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),

                      // Title
                      Text(
                        event["title"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),

                      // Venue and Time
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              event["venue"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),

                      // Time and Distance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'access_time',
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                event["time"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            event["distance"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Like Button
              Positioned(
                top: 2.h,
                right: 3.w,
                child: GestureDetector(
                  onTap: () {
                    // Handle like toggle
                  },
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: (event["isLiked"] as bool)
                          ? 'favorite'
                          : 'favorite_border',
                      color: (event["isLiked"] as bool)
                          ? AppTheme.lightTheme.colorScheme.error
                          : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context, Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              event["title"] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  context,
                  'share',
                  'Partager',
                  () => Navigator.pop(context),
                ),
                _buildQuickActionButton(
                  context,
                  'favorite_border',
                  'Favoris',
                  () => Navigator.pop(context),
                ),
                _buildQuickActionButton(
                  context,
                  'directions',
                  'Itinéraire',
                  () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String iconName,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
