import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget representing a single discount card in the student discounts grid
class DiscountCardWidget extends StatelessWidget {
  final Map<String, dynamic> discount;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const DiscountCardWidget({
    super.key,
    required this.discount,
    required this.onTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showContextMenu(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Image with Discount Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CustomImageWidget(
                    imageUrl: discount["image"] as String,
                    width: double.infinity,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                ),
                // Discount Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${discount["percentage"]}% OFF",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Student Verification Required Badge
                if (discount["studentVerificationRequired"] as bool)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.3.h),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'school',
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            "Étudiant",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Age Restriction Badge
                if (discount["ageRestriction"] as bool)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.3.h),
                      decoration: BoxDecoration(
                        color: AppTheme.warningLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "18+",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Business Information
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Business Name
                  Text(
                    discount["businessName"] as String,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  // Offer Description
                  Text(
                    discount["offerDescription"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  // Distance and Validity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Distance
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            "${discount["distance"]}m",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                      // Validity Period
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _formatValidityPeriod(
                                discount["validUntil"] as String),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatValidityPeriod(String validUntil) {
    try {
      final date = DateTime.parse(validUntil);
      final now = DateTime.now();
      final difference = date.difference(now).inDays;

      if (difference <= 0) {
        return "Expiré";
      } else if (difference == 1) {
        return "1 jour";
      } else if (difference <= 7) {
        return "$difference jours";
      } else {
        return "${(difference / 7).floor()} sem.";
      }
    } catch (e) {
      return validUntil;
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            // Context Menu Options
            _buildContextMenuItem(
              context,
              'Enregistrer dans le portefeuille',
              'wallet',
              onSave,
            ),
            _buildContextMenuItem(
              context,
              'Partager la réduction',
              'share',
              () => _shareDiscount(context),
            ),
            _buildContextMenuItem(
              context,
              'Obtenir l\'itinéraire',
              'directions',
              () => _getDirections(context),
            ),
            _buildContextMenuItem(
              context,
              'Appeler l\'entreprise',
              'phone',
              () => _callBusiness(context),
            ),
            _buildContextMenuItem(
              context,
              'Signaler un problème',
              'report',
              () => _reportIssue(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: Theme.of(context).colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _shareDiscount(BuildContext context) {
    // Share discount functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partage de la réduction "${discount["businessName"]}"'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _getDirections(BuildContext context) {
    // Get directions functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Ouverture de l\'itinéraire vers ${discount["businessName"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _callBusiness(BuildContext context) {
    // Call business functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appel de ${discount["businessName"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reportIssue(BuildContext context) {
    // Report issue functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Signalement d\'un problème pour ${discount["businessName"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
