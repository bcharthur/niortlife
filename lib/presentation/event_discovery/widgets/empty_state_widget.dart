import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryActionPressed;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.secondaryActionText,
    this.onSecondaryActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'event_busy',
                color: colorScheme.primary,
                size: 60,
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Subtitle
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action Buttons
            if (actionText != null && onActionPressed != null) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onActionPressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(actionText!),
                ),
              ),
              if (secondaryActionText != null &&
                  onSecondaryActionPressed != null) ...[
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onSecondaryActionPressed,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: Text(secondaryActionText!),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
