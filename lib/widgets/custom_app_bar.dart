import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Contemporary French Civic Mobile design
/// with Niort Blue Clarity theme for local discovery and student lifestyle apps.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (automatically determined if not specified)
  final bool? showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom bottom widget (typically used for tabs)
  final PreferredSizeWidget? bottom;

  /// Background color override
  final Color? backgroundColor;

  /// Foreground color override
  final Color? foregroundColor;

  /// Elevation override
  final double? elevation;

  /// App bar variant for different contexts
  final CustomAppBarVariant variant;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.variant = CustomAppBarVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on variant
    Color effectiveBackgroundColor;
    Color effectiveForegroundColor;
    double effectiveElevation;

    switch (variant) {
      case CustomAppBarVariant.standard:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        effectiveElevation = elevation ?? 2.0;
        break;
      case CustomAppBarVariant.primary:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimary;
        effectiveElevation = elevation ?? 4.0;
        break;
      case CustomAppBarVariant.transparent:
        effectiveBackgroundColor = backgroundColor ?? Colors.transparent;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        effectiveElevation = elevation ?? 0.0;
        break;
      case CustomAppBarVariant.search:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        effectiveElevation = elevation ?? 1.0;
        break;
    }

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: variant == CustomAppBarVariant.search ? 18 : 20,
          fontWeight: FontWeight.w600,
          color: effectiveForegroundColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: effectiveElevation,
      shadowColor: theme.shadowColor,
      leading: _buildLeading(context, effectiveForegroundColor),
      actions: _buildActions(context, effectiveForegroundColor),
      bottom: bottom,
      shape: variant == CustomAppBarVariant.transparent
          ? null
          : const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
            ),
      iconTheme: IconThemeData(
        color: effectiveForegroundColor,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: effectiveForegroundColor,
        size: 24,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    final shouldShowBack = showBackButton ?? Navigator.of(context).canPop();
    if (!shouldShowBack) return null;

    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: foregroundColor,
        size: 20,
      ),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: 'Retour',
    );
  }

  List<Widget>? _buildActions(BuildContext context, Color foregroundColor) {
    if (actions != null) return actions;

    // Default actions based on variant
    switch (variant) {
      case CustomAppBarVariant.search:
        return [
          IconButton(
            icon: Icon(
              Icons.search,
              color: foregroundColor,
            ),
            onPressed: () {
              // Implement search functionality
              showSearch(
                context: context,
                delegate: _CustomSearchDelegate(),
              );
            },
            tooltip: 'Rechercher',
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: foregroundColor,
            ),
            onPressed: () {
              // Show filter bottom sheet
              _showFilterBottomSheet(context);
            },
            tooltip: 'Filtrer',
          ),
        ];
      case CustomAppBarVariant.standard:
        return [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: foregroundColor,
            ),
            onPressed: () {
              // Navigate to notifications or show notification panel
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Notifications - Fonctionnalité à venir',
                    style: GoogleFonts.inter(),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Notifications',
          ),
        ];
      default:
        return null;
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Filtres',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Fonctionnalité de filtrage à venir',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// Search delegate for the custom app bar search functionality
class _CustomSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Rechercher...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Recherche pour: "$query"',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fonctionnalité de recherche à venir',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
      'Événements ce soir',
      'Restaurants étudiants',
      'Transport nocturne',
      'Réductions étudiantes',
      'Bars et clubs',
    ];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(
            suggestion,
            style: GoogleFonts.inter(),
          ),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}

/// Enum defining different app bar variants for various contexts
enum CustomAppBarVariant {
  /// Standard app bar with default styling
  standard,

  /// Primary colored app bar for main sections
  primary,

  /// Transparent app bar for overlay contexts
  transparent,

  /// Search-focused app bar with search and filter actions
  search,
}
