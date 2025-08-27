import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Tab Bar implementing Contemporary French Civic Mobile design
/// with smooth animations and accessibility features for content categorization.
class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  /// List of tab labels
  final List<String> tabs;

  /// Current selected tab index
  final int currentIndex;

  /// Callback when a tab is tapped
  final ValueChanged<int> onTap;

  /// Tab bar variant for different contexts
  final CustomTabBarVariant variant;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected tab color
  final Color? selectedColor;

  /// Custom unselected tab color
  final Color? unselectedColor;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Tab alignment when not scrollable
  final TabAlignment tabAlignment;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.variant = CustomTabBarVariant.standard,
    this.isScrollable = false,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.tabAlignment = TabAlignment.center,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(
        variant == CustomTabBarVariant.compact ? 40 : 48,
      );
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.currentIndex,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _tabController.addListener(_handleTabChange);
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _tabController.animateTo(widget.currentIndex);
    }
    if (oldWidget.tabs.length != widget.tabs.length) {
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.currentIndex.clamp(0, widget.tabs.length - 1),
      );
      _tabController.addListener(_handleTabChange);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      widget.onTap(_tabController.index);
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = widget.backgroundColor ??
        (widget.variant == CustomTabBarVariant.surface
            ? colorScheme.surface
            : Colors.transparent);

    final effectiveSelectedColor = widget.selectedColor ?? colorScheme.primary;
    final effectiveUnselectedColor =
        widget.unselectedColor ?? colorScheme.onSurfaceVariant;
    final effectiveIndicatorColor =
        widget.indicatorColor ?? colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: widget.variant == CustomTabBarVariant.bordered
            ? Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              )
            : null,
        boxShadow: widget.variant == CustomTabBarVariant.elevated
            ? [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: _buildTabBar(
        theme,
        effectiveSelectedColor,
        effectiveUnselectedColor,
        effectiveIndicatorColor,
      ),
    );
  }

  Widget _buildTabBar(
    ThemeData theme,
    Color selectedColor,
    Color unselectedColor,
    Color indicatorColor,
  ) {
    switch (widget.variant) {
      case CustomTabBarVariant.pills:
        return _buildPillTabBar(theme, selectedColor, unselectedColor);
      case CustomTabBarVariant.segmented:
        return _buildSegmentedTabBar(theme, selectedColor, unselectedColor);
      default:
        return _buildStandardTabBar(
            theme, selectedColor, unselectedColor, indicatorColor);
    }
  }

  Widget _buildStandardTabBar(
    ThemeData theme,
    Color selectedColor,
    Color unselectedColor,
    Color indicatorColor,
  ) {
    return TabBar(
      controller: _tabController,
      tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
      isScrollable: widget.isScrollable,
      tabAlignment: widget.tabAlignment,
      labelColor: selectedColor,
      unselectedLabelColor: unselectedColor,
      indicatorColor: indicatorColor,
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: widget.variant == CustomTabBarVariant.compact ? 13 : 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: widget.variant == CustomTabBarVariant.compact ? 13 : 14,
        fontWeight: FontWeight.w400,
      ),
      overlayColor: WidgetStateProperty.all(
        selectedColor.withValues(alpha: 0.1),
      ),
      splashFactory: InkRipple.splashFactory,
      dividerColor: Colors.transparent,
    );
  }

  Widget _buildPillTabBar(
    ThemeData theme,
    Color selectedColor,
    Color unselectedColor,
  ) {
    return Container(
      height: widget.variant == CustomTabBarVariant.compact ? 40 : 48,
      padding: const EdgeInsets.all(4),
      child: widget.isScrollable
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildPillTabs(theme, selectedColor, unselectedColor),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildPillTabs(theme, selectedColor, unselectedColor),
            ),
    );
  }

  List<Widget> _buildPillTabs(
    ThemeData theme,
    Color selectedColor,
    Color unselectedColor,
  ) {
    return widget.tabs.asMap().entries.map((entry) {
      final index = entry.key;
      final tab = entry.value;
      final isSelected = index == widget.currentIndex;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor
                : selectedColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => widget.onTap(index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  tab,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : selectedColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSegmentedTabBar(
    ThemeData theme,
    Color selectedColor,
    Color unselectedColor,
  ) {
    return Container(
      height: widget.variant == CustomTabBarVariant.compact ? 40 : 48,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: widget.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == widget.currentIndex;
          final isFirst = index == 0;
          final isLast = index == widget.tabs.length - 1;

          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : Colors.transparent,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(isFirst ? 6 : 0),
                  right: Radius.circular(isLast ? 6 : 0),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(isFirst ? 6 : 0),
                    right: Radius.circular(isLast ? 6 : 0),
                  ),
                  onTap: () => widget.onTap(index),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      tab,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : unselectedColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Enum defining different tab bar variants
enum CustomTabBarVariant {
  /// Standard tab bar with underline indicator
  standard,

  /// Compact tab bar with smaller height
  compact,

  /// Tab bar with surface background
  surface,

  /// Tab bar with bottom border
  bordered,

  /// Elevated tab bar with shadow
  elevated,

  /// Pill-style tabs with rounded backgrounds
  pills,

  /// Segmented control style tabs
  segmented,
}

/// Custom Tab Bar Controller for managing tab state across widgets
class CustomTabBarController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void nextTab(int maxIndex) {
    if (_currentIndex < maxIndex) {
      setIndex(_currentIndex + 1);
    }
  }

  void previousTab() {
    if (_currentIndex > 0) {
      setIndex(_currentIndex - 1);
    }
  }
}
