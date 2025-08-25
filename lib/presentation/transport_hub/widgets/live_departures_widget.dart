import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LiveDeparturesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> departures;
  final Function(Map<String, dynamic>) onDepartureSwipeRight;
  final Function(Map<String, dynamic>) onDepartureSwipeLeft;

  const LiveDeparturesWidget({
    super.key,
    required this.departures,
    required this.onDepartureSwipeRight,
    required this.onDepartureSwipeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Prochains départs',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'Temps réel',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 1.w),
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
          child: departures.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: departures.length,
                  itemBuilder: (context, index) {
                    final departure = departures[index];
                    return _buildDepartureCard(context, departure);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'schedule',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Aucun départ prévu',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartureCard(
      BuildContext context, Map<String, dynamic> departure) {
    final line = departure['line'] as String? ?? '';
    final destination = departure['destination'] as String? ?? '';
    final departureTime = departure['departureTime'] as String? ?? '';
    final delay = departure['delay'] as int? ?? 0;
    final status = departure['status'] as String? ?? 'on_time';
    final platform = departure['platform'] as String? ?? '';
    final minutesUntil = departure['minutesUntil'] as int? ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Dismissible(
        key: Key('${departure['id'] ?? DateTime.now().millisecondsSinceEpoch}'),
        background: _buildSwipeBackground(
          context,
          'Ajouter aux favoris',
          CustomIconWidget(
            iconName: 'favorite',
            color: Colors.white,
            size: 24,
          ),
          AppTheme.lightTheme.colorScheme.secondary,
          Alignment.centerLeft,
        ),
        secondaryBackground: _buildSwipeBackground(
          context,
          'Alertes départ',
          CustomIconWidget(
            iconName: 'notifications',
            color: Colors.white,
            size: 24,
          ),
          AppTheme.lightTheme.primaryColor,
          Alignment.centerRight,
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            onDepartureSwipeRight(departure);
          } else {
            onDepartureSwipeLeft(departure);
          }
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                // Line badge
                Container(
                  width: 12.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _getLineColor(line),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        line,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (platform.isNotEmpty) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          'Quai $platform',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 3.w),

                // Destination and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Text(
                            departureTime,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (delay > 0) ...[
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '+${delay}min',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: _getStatusColor(status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Countdown and status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        minutesUntil <= 0 ? 'Maintenant' : '${minutesUntil}min',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: BoxDecoration(
                            color: _getStatusColor(status),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          _getStatusText(status),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(
    BuildContext context,
    String text,
    Widget icon,
    Color color,
    Alignment alignment,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: alignment,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 1.h),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getLineColor(String line) {
    final lineNumber =
        int.tryParse(line.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final colors = [
      AppTheme.lightTheme.primaryColor,
      AppTheme.lightTheme.colorScheme.secondary,
      const Color(0xFF9C27B0),
      const Color(0xFFFF5722),
      const Color(0xFF607D8B),
      const Color(0xFF795548),
    ];
    return colors[lineNumber % colors.length];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'on_time':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'delayed':
        return const Color(0xFFF39C12);
      case 'cancelled':
        return const Color(0xFFE74C3C);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'on_time':
        return 'À l\'heure';
      case 'delayed':
        return 'Retardé';
      case 'cancelled':
        return 'Annulé';
      default:
        return 'Inconnu';
    }
  }
}
