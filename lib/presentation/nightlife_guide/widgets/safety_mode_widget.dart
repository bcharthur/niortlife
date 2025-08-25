import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SafetyModeWidget extends StatefulWidget {
  final bool isActive;
  final VoidCallback onToggle;
  final VoidCallback onEmergencyContact;

  const SafetyModeWidget({
    super.key,
    required this.isActive,
    required this.onToggle,
    required this.onEmergencyContact,
  });

  @override
  State<SafetyModeWidget> createState() => _SafetyModeWidgetState();
}

class _SafetyModeWidgetState extends State<SafetyModeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    if (widget.isActive) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SafetyModeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
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

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? _scaleAnimation.value : 1.0,
          child: FloatingActionButton(
            onPressed: widget.onToggle,
            backgroundColor: widget.isActive
                ? AppTheme.lightTheme.colorScheme.error
                : colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: widget.isActive ? 8 : 4,
            child: widget.isActive
                ? CustomIconWidget(
                    iconName: 'shield',
                    color: Colors.white,
                    size: 24,
                  )
                : CustomIconWidget(
                    iconName: 'security',
                    color: Colors.white,
                    size: 24,
                  ),
          ),
        );
      },
    );
  }
}

class SafetyModeBottomSheet extends StatefulWidget {
  final bool isActive;
  final VoidCallback onToggle;
  final VoidCallback onEmergencyContact;

  const SafetyModeBottomSheet({
    super.key,
    required this.isActive,
    required this.onToggle,
    required this.onEmergencyContact,
  });

  @override
  State<SafetyModeBottomSheet> createState() => _SafetyModeBottomSheetState();
}

class _SafetyModeBottomSheetState extends State<SafetyModeBottomSheet> {
  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      "name": "Police",
      "number": "17",
      "icon": "local_police",
      "color": Colors.blue,
    },
    {
      "name": "SAMU",
      "number": "15",
      "icon": "local_hospital",
      "color": Colors.red,
    },
    {
      "name": "Pompiers",
      "number": "18",
      "icon": "local_fire_department",
      "color": Colors.orange,
    },
    {
      "name": "Urgences",
      "number": "112",
      "icon": "emergency",
      "color": Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(colorScheme),
          _buildHeader(colorScheme),
          _buildSafetyToggle(colorScheme),
          if (widget.isActive) ...[
            _buildActiveFeatures(colorScheme),
            _buildEmergencyContacts(colorScheme),
          ] else
            _buildInactiveInfo(colorScheme),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHandle(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      width: 10.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: colorScheme.outline,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'shield',
            color: widget.isActive
                ? AppTheme.lightTheme.colorScheme.error
                : colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Text(
            'Mode Sécurité',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyToggle(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: widget.isActive
            ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
            : colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isActive
                      ? 'Mode Sécurité Activé'
                      : 'Activer le Mode Sécurité',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  widget.isActive
                      ? 'Votre position est partagée avec vos contacts de confiance'
                      : 'Partagez votre position en temps réel avec vos proches',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.isActive,
            onChanged: (_) => widget.onToggle(),
            activeColor: AppTheme.lightTheme.colorScheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFeatures(ColorScheme colorScheme) {
    final features = [
      {
        "title": "Partage de position",
        "subtitle": "Position partagée toutes les 5 minutes",
        "icon": "location_on",
        "status": "Actif",
      },
      {
        "title": "Check-in automatique",
        "subtitle": "Notification envoyée à vos contacts",
        "icon": "check_circle",
        "status": "Actif",
      },
      {
        "title": "Alerte de sécurité",
        "subtitle": "Bouton d'urgence disponible",
        "icon": "warning",
        "status": "Prêt",
      },
    ];

    return Container(
      margin: EdgeInsets.all(6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fonctionnalités actives',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          ...features.map((feature) => Container(
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: feature["icon"] as String,
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature["title"] as String,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            feature["subtitle"] as String,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        feature["status"] as String,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contacts d\'urgence',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 2.5,
            ),
            itemCount: _emergencyContacts.length,
            itemBuilder: (context, index) {
              final contact = _emergencyContacts[index];
              return GestureDetector(
                onTap: () => _callEmergencyNumber(contact["number"] as String),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: (contact["color"] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: contact["color"] as Color,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: contact["icon"] as String,
                        color: contact["color"] as Color,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              contact["name"] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              contact["number"] as String,
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveInfo(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.all(6.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'info',
            color: colorScheme.primary,
            size: 32,
          ),
          SizedBox(height: 2.h),
          Text(
            'Le Mode Sécurité vous permet de :',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Column(
            children: [
              _buildInfoItem(
                colorScheme,
                'location_on',
                'Partager votre position en temps réel',
              ),
              _buildInfoItem(
                colorScheme,
                'notifications',
                'Envoyer des alertes automatiques',
              ),
              _buildInfoItem(
                colorScheme,
                'phone',
                'Accéder rapidement aux numéros d\'urgence',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(ColorScheme colorScheme, String icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callEmergencyNumber(String number) {
    // In a real app, this would use url_launcher to make a phone call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Appel vers le $number',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}