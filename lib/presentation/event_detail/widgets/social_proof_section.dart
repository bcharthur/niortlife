import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SocialProofSection extends StatelessWidget {
  final Map<String, dynamic> socialData;

  const SocialProofSection({
    super.key,
    required this.socialData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attendeeCount = socialData['attendeeCount'] as int;
    final friendsAttending =
        (socialData['friendsAttending'] as List).cast<Map<String, dynamic>>();

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Participants',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Attendee count
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'people',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$attendeeCount participants',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'ont confirmé leur présence',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Friends attending
          if (friendsAttending.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Row(
              children: [
                // Friend avatars
                SizedBox(
                  height: 8.w,
                  child: Stack(
                    children: friendsAttending.take(3).map((friend) {
                      final index = friendsAttending.indexOf(friend);
                      return Positioned(
                        left: index * 5.w,
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: CustomImageWidget(
                              imageUrl: friend['avatar'] as String,
                              width: 8.w,
                              height: 8.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(width: friendsAttending.length > 3 ? 8.w : 6.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friendsAttending.length == 1
                            ? '${friendsAttending.first['name']} participe'
                            : friendsAttending.length == 2
                                ? '${friendsAttending.first['name']} et ${friendsAttending[1]['name']} participent'
                                : '${friendsAttending.first['name']} et ${friendsAttending.length - 1} autres participent',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (friendsAttending.length > 3)
                        Text(
                          'Voir tous les participants',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          // Interest indicator
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Événement populaire',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
