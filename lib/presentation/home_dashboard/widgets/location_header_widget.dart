import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationHeaderWidget extends StatefulWidget {
  const LocationHeaderWidget({super.key});

  @override
  State<LocationHeaderWidget> createState() => _LocationHeaderWidgetState();
}

class _LocationHeaderWidgetState extends State<LocationHeaderWidget> {
  final Map<String, dynamic> locationData = {
    "neighborhood": "Centre-Ville",
    "city": "Niort",
    "weather": {
      "temperature": "18°C",
      "condition": "Nuageux",
      "icon": "cloud",
    },
    "lastUpdated": "Il y a 5 min",
  };

  bool _isLocationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _isLocationEnabled
          ? _buildLocationContent()
          : _buildLocationDisabled(),
    );
  }

  Widget _buildLocationContent() {
    return Row(
      children: [
        // Location Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationData["neighborhood"] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          locationData["city"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                locationData["lastUpdated"] as String,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Weather Widget
        _buildWeatherWidget(),

        SizedBox(width: 3.w),

        // Settings Button
        GestureDetector(
          onTap: () {
            _showLocationSettings();
          },
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherWidget() {
    final weather = locationData["weather"] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: _getWeatherIcon(weather["icon"] as String),
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weather["temperature"] as String,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                weather["condition"] as String,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDisabled() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'location_off',
            color: AppTheme.lightTheme.colorScheme.onErrorContainer,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Localisation désactivée",
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Activez la localisation pour découvrir les événements près de vous",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          ElevatedButton(
            onPressed: () {
              _enableLocation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.onErrorContainer,
              foregroundColor: AppTheme.lightTheme.colorScheme.errorContainer,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            ),
            child: const Text("Activer"),
          ),
        ],
      ),
    );
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 'wb_sunny';
      case 'cloud':
      case 'cloudy':
        return 'cloud';
      case 'rain':
      case 'rainy':
        return 'umbrella';
      case 'snow':
        return 'ac_unit';
      case 'storm':
        return 'flash_on';
      default:
        return 'wb_cloudy';
    }
  }

  void _showLocationSettings() {
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

            Text(
              "Paramètres de localisation",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),

            // Location Toggle
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Localisation automatique",
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Permet de découvrir les événements près de vous",
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isLocationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isLocationEnabled = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Weather Toggle
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'wb_sunny',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Météo locale",
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Affiche la météo de votre quartier",
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (value) {
                      // Handle weather toggle
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Manual Location Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showManualLocationPicker();
                },
                icon: CustomIconWidget(
                  iconName: 'edit_location',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: const Text("Choisir manuellement"),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 2.h),
          ],
        ),
      ),
    );
  }

  void _showManualLocationPicker() {
    final List<String> neighborhoods = [
      "Centre-Ville",
      "Souché",
      "Clou-Bouchet",
      "Sainte-Pezenne",
      "Tour Chabot",
      "Goise",
      "Champclairot",
    ];

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
            Text(
              "Choisir votre quartier",
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                itemCount: neighborhoods.length,
                itemBuilder: (context, index) {
                  final neighborhood = neighborhoods[index];
                  final isSelected =
                      neighborhood == locationData["neighborhood"];

                  return ListTile(
                    leading: CustomIconWidget(
                      iconName: 'location_on',
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    title: Text(
                      neighborhood,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        locationData["neighborhood"] = neighborhood;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 2.h),
          ],
        ),
      ),
    );
  }

  void _enableLocation() {
    setState(() {
      _isLocationEnabled = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Localisation activée'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
