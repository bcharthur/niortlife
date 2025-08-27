import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransportWidget extends StatefulWidget {
  const TransportWidget({super.key});

  @override
  State<TransportWidget> createState() => _TransportWidgetState();
}

class _TransportWidgetState extends State<TransportWidget> {
  final List<Map<String, dynamic>> nextDepartures = [
    {
      "id": 1,
      "line": "Ligne 1",
      "destination": "Gare SNCF",
      "nextDeparture": "3 min",
      "followingDeparture": "18 min",
      "stop": "République",
      "type": "bus",
      "color": "#1E9BD6",
      "delay": null,
    },
    {
      "id": 2,
      "line": "Ligne 5",
      "destination": "Souché",
      "nextDeparture": "7 min",
      "followingDeparture": "22 min",
      "stop": "Hôtel de Ville",
      "type": "bus",
      "color": "#2ECC71",
      "delay": "2 min de retard",
    },
    {
      "id": 3,
      "line": "Tram A",
      "destination": "Université",
      "nextDeparture": "12 min",
      "followingDeparture": "27 min",
      "stop": "Centre-Ville",
      "type": "tram",
      "color": "#F39C12",
      "delay": null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Prochains transports",
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/transport-hub');
                },
                child: Text(
                  "Voir tout",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with location
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        "Arrêts à proximité",
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _refreshTransportData();
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'refresh',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Departures List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: nextDepartures.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
                itemBuilder: (context, index) {
                  final departure = nextDepartures[index];
                  return _buildDepartureItem(context, departure);
                },
              ),

              // View All Button
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/transport-hub');
                  },
                  icon: CustomIconWidget(
                    iconName: 'directions_transit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  label: Text(
                    "Planifier un trajet",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDepartureItem(
      BuildContext context, Map<String, dynamic> departure) {
    final Color lineColor = _parseColor(departure["color"] as String);
    final bool hasDelay = departure["delay"] != null;

    return GestureDetector(
      onTap: () {
        _showDepartureDetails(context, departure);
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            // Line Badge
            Container(
              width: 12.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName:
                        departure["type"] == "tram" ? 'tram' : 'directions_bus',
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    departure["line"] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(width: 3.w),

            // Destination and Stop
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    departure["destination"] as String,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          "Arrêt ${departure["stop"]}",
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (hasDelay) ...[
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'warning',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          departure["delay"] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Departure Times
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: hasDelay
                        ? AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    departure["nextDeparture"] as String,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: hasDelay
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "puis ${departure["followingDeparture"]}",
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDepartureDetails(
      BuildContext context, Map<String, dynamic> departure) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),

            // Line Info
            Row(
              children: [
                Container(
                  width: 15.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _parseColor(departure["color"] as String),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: departure["type"] == "tram"
                            ? 'tram'
                            : 'directions_bus',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        departure["line"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        departure["destination"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Arrêt ${departure["stop"]}",
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Departure Times
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Prochain départ",
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      Text(
                        departure["nextDeparture"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Suivant",
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      Text(
                        departure["followingDeparture"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (departure["delay"] != null) ...[
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'warning',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            departure["delay"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/transport-hub');
                    },
                    icon: CustomIconWidget(
                      iconName: 'directions',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    label: const Text('Itinéraire'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: CustomIconWidget(
                      iconName: 'notifications',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: const Text('Alertes'),
                  ),
                ),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 2.h),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  void _refreshTransportData() {
    // Simulate refresh with haptic feedback
    setState(() {
      // Update departure times (simulate real-time data)
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Horaires mis à jour'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
