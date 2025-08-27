import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar implementing Contemporary French Civic Mobile design
/// with persistent state management for local discovery and student lifestyle apps.
class CustomBottomBar extends StatefulWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when a tab is tapped
  final ValueChanged<int> onTap;

  /// Bottom bar variant for different contexts
  final CustomBottomBarVariant variant;

  /// Whether to show labels
  final bool showLabels;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.showLabels = true,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = _getNavigationItems();

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: widget.variant == CustomBottomBarVariant.compact ? 60 : 80,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return _buildNavigationItem(
                context,
                item,
                index,
                isSelected,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    _NavigationItem item,
    int index,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedColor = widget.selectedItemColor ?? colorScheme.primary;
    final unselectedColor =
        widget.unselectedItemColor ?? colorScheme.onSurfaceVariant;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onTap(index);
          _navigateToRoute(context, item.route);
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastOutSlowIn,
                    padding: EdgeInsets.all(isSelected ? 8 : 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      color: isSelected ? selectedColor : unselectedColor,
                      size: widget.variant == CustomBottomBarVariant.compact
                          ? 20
                          : 24,
                    ),
                  ),

                  // Label with animation
                  if (widget.showLabels &&
                      widget.variant != CustomBottomBarVariant.compact) ...[
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? selectedColor : unselectedColor,
                      ),
                      child: Text(
                        item.label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],

                  // Active indicator
                  if (isSelected &&
                      widget.variant == CustomBottomBarVariant.indicator) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<_NavigationItem> _getNavigationItems() {
    return [
      _NavigationItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Accueil',
        route: '/home-dashboard',
      ),
      _NavigationItem(
        icon: Icons.event_outlined,
        selectedIcon: Icons.event,
        label: 'Événements',
        route: '/event-discovery',
      ),
      _NavigationItem(
        icon: Icons.local_offer_outlined,
        selectedIcon: Icons.local_offer,
        label: 'Réductions',
        route: '/student-discounts',
      ),
      _NavigationItem(
        icon: Icons.directions_bus_outlined,
        selectedIcon: Icons.directions_bus,
        label: 'Transport',
        route: '/transport-hub',
      ),
      _NavigationItem(
        icon: Icons.nightlife_outlined,
        selectedIcon: Icons.nightlife,
        label: 'Sorties',
        route: '/nightlife-guide',
      ),
    ];
  }


  void _navigateToRoute(BuildContext context, String route) {
    // Only navigate if not already on the current route
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }
}

/// Navigation item data class
class _NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}

/// Enum defining different bottom bar variants
enum CustomBottomBarVariant {
  /// Standard bottom bar with full labels and icons
  standard,

  /// Compact bottom bar with smaller icons and no labels
  compact,

  /// Bottom bar with active indicator dots
  indicator,

  /// Floating bottom bar with elevated appearance
  floating,
}

/// Custom Bottom Bar with floating variant implementation
class CustomFloatingBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when a tab is tapped
  final ValueChanged<int> onTap;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  const CustomFloatingBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CustomBottomBar(
            currentIndex: currentIndex,
            onTap: onTap,
            variant: CustomBottomBarVariant.standard,
            backgroundColor: Colors.transparent,
            selectedItemColor: selectedItemColor,
            unselectedItemColor: unselectedItemColor,
          ),
        ),
      ),
    );
  }
}
