import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class VenueContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> venue;
  final VoidCallback? onCall;
  final VoidCallback? onDirections;
  final VoidCallback? onAddReview;
  final VoidCallback? onReportSafety;
  final VoidCallback? onClose;

  const VenueContextMenuWidget({
    super.key,
    required this.venue,
    this.onCall,
    this.onDirections,
    this.onAddReview,
    this.onReportSafety,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(colorScheme),
          _buildMenuItems(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: venue["image"] as String,
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue["name"] as String,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: colorScheme.onSurfaceVariant,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
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
          ),
          IconButton(
            onPressed: onClose,
            icon: CustomIconWidget(
              iconName: 'close',
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, ColorScheme colorScheme) {
    final menuItems = [
      {
        "icon": "phone",
        "title": "Appeler le lieu",
        "subtitle": "Contacter directement",
        "color": colorScheme.primary,
        "onTap": onCall,
      },
      {
        "icon": "directions",
        "title": "Itinéraire",
        "subtitle": "Ouvrir dans Maps",
        "color": colorScheme.secondary,
        "onTap": onDirections,
      },
      {
        "icon": "rate_review",
        "title": "Ajouter un avis",
        "subtitle": "Partager votre expérience",
        "color": colorScheme.tertiary,
        "onTap": onAddReview,
      },
      {
        "icon": "report",
        "title": "Signaler un problème",
        "subtitle": "Sécurité ou autre préoccupation",
        "color": AppTheme.lightTheme.colorScheme.error,
        "onTap": onReportSafety,
      },
    ];

    return Padding(
      padding: EdgeInsets.all(2.w),
      child: Column(
        children: menuItems.map((item) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  onClose?.call();
                  item["onTap"] as VoidCallback?;
                  _handleMenuAction(context, item["title"] as String);
                },
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color:
                              (item["color"] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: item["icon"] as String,
                          color: item["color"] as Color,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"] as String,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              item["subtitle"] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'chevron_right',
                        color: colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    String message;
    Color backgroundColor;

    switch (action) {
      case "Appeler le lieu":
        message = "Appel vers ${venue["name"]}";
        backgroundColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case "Itinéraire":
        message = "Ouverture de l'itinéraire vers ${venue["name"]}";
        backgroundColor = AppTheme.lightTheme.colorScheme.secondary;
        break;
      case "Ajouter un avis":
        message = "Formulaire d'avis pour ${venue["name"]}";
        backgroundColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case "Signaler un problème":
        message = "Formulaire de signalement pour ${venue["name"]}";
        backgroundColor = AppTheme.lightTheme.colorScheme.error;
        break;
      default:
        message = "Action: $action";
        backgroundColor = AppTheme.lightTheme.colorScheme.primary;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class VenueContextMenuOverlay extends StatelessWidget {
  final Map<String, dynamic> venue;
  final Offset position;
  final VoidCallback? onCall;
  final VoidCallback? onDirections;
  final VoidCallback? onAddReview;
  final VoidCallback? onReportSafety;
  final VoidCallback onClose;

  const VenueContextMenuOverlay({
    super.key,
    required this.venue,
    required this.position,
    this.onCall,
    this.onDirections,
    this.onAddReview,
    this.onReportSafety,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay
        GestureDetector(
          onTap: onClose,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.3),
          ),
        ),
        // Context menu
        Positioned(
          left: (position.dx - 40.w).clamp(4.w, 96.w - 80.w),
          top: (position.dy - 20.h).clamp(10.h, 90.h - 40.h),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 80.w,
              constraints: BoxConstraints(maxHeight: 60.h),
              child: VenueContextMenuWidget(
                venue: venue,
                onCall: onCall,
                onDirections: onDirections,
                onAddReview: onAddReview,
                onReportSafety: onReportSafety,
                onClose: onClose,
              ),
            ),
          ),
        ),
      ],
    );
  }
}