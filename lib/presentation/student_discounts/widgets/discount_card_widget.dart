import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

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
    final cs = theme.colorScheme;
    final primary = AppTheme.lightTheme.primaryColor;

    // ---- Mapping pour aligner les clés Home vs Page Réductions ----
    final String imageUrl =
    (discount['logo'] ?? discount['image'] ?? '') as String;
    final String businessName =
    (discount['businessName'] ?? '') as String;
    final String category =
    (discount['category'] ?? '') as String;

    final String offerText = (discount['offer'] as String?) ??
        (discount['percentage'] != null
            ? '${discount['percentage']}% de réduction'
            : '');

    final String description =
        (discount['description'] as String?) ??
            (discount['offerDescription'] as String?) ??
            '';

    final String distanceLabel = _formatDistance(discount['distance']);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onSave,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Bandeau image (identique Home) ----
            Container(
              height: 12.h,
              decoration: BoxDecoration(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
                color: cs.surfaceContainerHighest,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CustomImageWidget(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (category.isNotEmpty)
                    Positioned(
                      top: 1.h,
                      right: 2.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          category,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ---- Contenu (identique Home) ----
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom
                    Text(
                      businessName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),

                    // Offre (pill)
                    if (offerText.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: cs.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          offerText,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: cs.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (offerText.isNotEmpty) SizedBox(height: 1.h),

                    // Description
                    Expanded(
                      child: Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Distance + QR preview
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              color: cs.onSurfaceVariant,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              distanceLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: cs.outline.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomIconWidget(
                            iconName: 'qr_code',
                            color: primary,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Distance: int (m) -> "320 m" / "0,7 km"
  //            String  -> laissé tel quel
  String _formatDistance(dynamic raw) {
    if (raw is String) return raw;
    if (raw is num) {
      final m = raw.toDouble();
      if (m >= 1000) {
        final km = (m / 1000);
        // 1 décimale, virgule française
        final txt = (km.toStringAsFixed(1)).replaceAll('.', ',');
        return '$txt km';
      }
      return '${m.toInt()} m';
    }
    return '';
  }
}
