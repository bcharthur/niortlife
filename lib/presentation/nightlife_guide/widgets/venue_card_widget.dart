import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class VenueCardWidget extends StatelessWidget {
  final Map<String, dynamic> venue;
  final VoidCallback? onTap;
  final VoidCallback? onAddToPlan;
  final VoidCallback? onShare;
  final VoidCallback? onLongPress;

  const VenueCardWidget({
    super.key,
    required this.venue,
    this.onTap,
    this.onAddToPlan,
    this.onShare,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Dismissible(
          key: Key('venue_${venue["id"]}'),
          background: _buildSwipeBackground(
            context,
            colorScheme.secondary,
            CustomIconWidget(
              iconName: 'playlist_add',
              color: AppTheme.lightTheme.colorScheme.onSecondary,
              size: 24,
            ),
            'Ajouter au plan',
            Alignment.centerLeft,
          ),
          secondaryBackground: _buildSwipeBackground(
            context,
            colorScheme.primary,
            CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
            'Partager',
            Alignment.centerRight,
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              onAddToPlan?.call();
            } else if (direction == DismissDirection.endToStart) {
              onShare?.call();
            }
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVenueImage(),
                _buildVenueContent(context, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(
    BuildContext context,
    Color color,
    Widget icon,
    String text,
    Alignment alignment,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 0.5.h),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: CustomImageWidget(
            imageUrl: venue["image"] as String,
            width: double.infinity,
            height: 20.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 2.h,
          left: 3.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: _getCrowdLevelColor(),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'people',
                  color: Colors.white,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Text(
                  venue["crowdLevel"] as String,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (venue["hasStudentDiscount"] == true)
          Positioned(
            top: 2.h,
            right: 3.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'school',
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Étudiant',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVenueContent(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  venue["name"] as String,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: venue["isOpen"] == true
                      ? AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  venue["isOpen"] == true ? 'Ouvert' : 'Fermé',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: venue["isOpen"] == true
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                venue["hours"] as String,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildVenueBadges(colorScheme),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  venue["address"] as String,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVenueBadges(ColorScheme colorScheme) {
    final badges = venue["badges"] as List<String>? ?? [];

    return Wrap(
      spacing: 2.w,
      runSpacing: 0.5.h,
      children: badges.map((badge) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getCrowdLevelColor() {
    final crowdLevel = venue["crowdLevel"] as String;
    switch (crowdLevel.toLowerCase()) {
      case 'faible':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'modéré':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'élevé':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}