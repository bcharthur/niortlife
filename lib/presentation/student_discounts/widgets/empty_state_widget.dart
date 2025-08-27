import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget displaying empty state when no discounts are available
class EmptyStateWidget extends StatelessWidget {
  final String category;
  final VoidCallback onSuggestBusiness;

  const EmptyStateWidget({
    super.key,
    required this.category,
    required this.onSuggestBusiness,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty State Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: _getEmptyStateIcon(),
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.6),
                size: 20.w,
              ),
            ),
            SizedBox(height: 4.h),
            // Empty State Title
            Text(
              _getEmptyStateTitle(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            // Empty State Description
            Text(
              _getEmptyStateDescription(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Suggest Business Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSuggestBusiness,
                icon: CustomIconWidget(
                  iconName: 'add_business',
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text('Suggérer une entreprise'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Secondary Action
            TextButton.icon(
              onPressed: () => _refreshDiscounts(context),
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              label: Text(
                'Actualiser les offres',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmptyStateIcon() {
    switch (category.toLowerCase()) {
      case 'bars':
        return 'local_bar';
      case 'restaurants':
        return 'restaurant';
      case 'boutiques':
      case 'shops':
        return 'shopping_bag';
      default:
        return 'local_offer';
    }
  }

  String _getEmptyStateTitle() {
    switch (category.toLowerCase()) {
      case 'bars':
        return 'Aucune offre de bar';
      case 'restaurants':
        return 'Aucune offre de restaurant';
      case 'boutiques':
      case 'shops':
        return 'Aucune offre de boutique';
      default:
        return 'Aucune réduction disponible';
    }
  }

  String _getEmptyStateDescription() {
    switch (category.toLowerCase()) {
      case 'bars':
        return 'Il n\'y a actuellement aucune réduction disponible pour les bars dans votre zone. Essayez d\'élargir votre rayon de recherche ou suggérez un nouveau bar.';
      case 'restaurants':
        return 'Il n\'y a actuellement aucune réduction disponible pour les restaurants dans votre zone. Essayez d\'élargir votre rayon de recherche ou suggérez un nouveau restaurant.';
      case 'boutiques':
      case 'shops':
        return 'Il n\'y a actuellement aucune réduction disponible pour les boutiques dans votre zone. Essayez d\'élargir votre rayon de recherche ou suggérez une nouvelle boutique.';
      default:
        return 'Il n\'y a actuellement aucune réduction disponible dans votre zone. Essayez d\'ajuster vos filtres ou suggérez une nouvelle entreprise.';
    }
  }

  void _refreshDiscounts(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Actualisation des offres...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
