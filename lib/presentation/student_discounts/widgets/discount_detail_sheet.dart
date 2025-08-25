import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Bottom sheet widget displaying detailed discount information with QR code
class DiscountDetailSheet extends StatefulWidget {
  final Map<String, dynamic> discount;

  const DiscountDetailSheet({
    super.key,
    required this.discount,
  });

  @override
  State<DiscountDetailSheet> createState() => _DiscountDetailSheetState();
}

class _DiscountDetailSheetState extends State<DiscountDetailSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header with business image
          _buildHeader(theme, colorScheme),
          // Tab Bar
          _buildTabBar(theme),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildQRCodeTab(theme, colorScheme),
                _buildDetailsTab(theme, colorScheme),
                _buildTermsTab(theme, colorScheme),
              ],
            ),
          ),
          // Action Buttons
          _buildActionButtons(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Business Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageWidget(
              imageUrl: widget.discount["image"] as String,
              width: double.infinity,
              height: 25.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 2.h),
          // Business Name and Discount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.discount["businessName"] as String,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.discount["offerDescription"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${widget.discount["percentage"]}% OFF",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'QR Code'),
        Tab(text: 'Détails'),
        Tab(text: 'Conditions'),
      ],
      labelColor: AppTheme.lightTheme.primaryColor,
      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
      indicatorColor: AppTheme.lightTheme.primaryColor,
      indicatorWeight: 3,
    );
  }

  Widget _buildQRCodeTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // QR Code
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                QrImageView(
                  data: _generateQRData(),
                  version: QrVersions.auto,
                  size: 60.w,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Présentez ce code QR en magasin',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Code: ${_generateDiscountCode()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          // Usage Instructions
          _buildInstructionCard(
            theme,
            colorScheme,
            'Comment utiliser',
            [
              '1. Présentez ce QR code au personnel',
              '2. Attendez la validation de votre statut étudiant',
              '3. Profitez de votre réduction !',
            ],
            'info',
          ),
          SizedBox(height: 2.h),
          // Validity Information
          _buildValidityCard(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Business Information
          _buildInfoSection(
            theme,
            'Informations sur l\'entreprise',
            [
              _buildInfoRow('Nom', widget.discount["businessName"] as String),
              _buildInfoRow('Adresse', widget.discount["address"] as String),
              _buildInfoRow('Téléphone', widget.discount["phone"] as String),
              _buildInfoRow('Distance', '${widget.discount["distance"]}m'),
            ],
          ),
          SizedBox(height: 3.h),
          // Discount Information
          _buildInfoSection(
            theme,
            'Détails de la réduction',
            [
              _buildInfoRow('Réduction', '${widget.discount["percentage"]}%'),
              _buildInfoRow('Type', widget.discount["category"] as String),
              _buildInfoRow(
                  'Valide jusqu\'au', widget.discount["validUntil"] as String),
              _buildInfoRow(
                  'Utilisations restantes', '${widget.discount["usagesLeft"]}'),
            ],
          ),
          SizedBox(height: 3.h),
          // Requirements
          _buildRequirementsSection(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildTermsTab(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conditions d\'utilisation',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildTermsContent(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      ThemeData theme, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exigences',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        if (widget.discount["studentVerificationRequired"] as bool)
          _buildRequirementChip(
            theme,
            colorScheme,
            'Carte étudiant requise',
            'school',
            AppTheme.secondaryLight,
          ),
        if (widget.discount["ageRestriction"] as bool)
          _buildRequirementChip(
            theme,
            colorScheme,
            'Restriction d\'âge 18+',
            'warning',
            AppTheme.warningLight,
          ),
      ],
    );
  }

  Widget _buildRequirementChip(
    ThemeData theme,
    ColorScheme colorScheme,
    String text,
    String iconName,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionCard(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    List<String> instructions,
    String iconName,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ...instructions.map((instruction) => Padding(
                padding: EdgeInsets.symmetric(vertical: 0.3.h),
                child: Text(
                  instruction,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildValidityCard(ThemeData theme, ColorScheme colorScheme) {
    final validUntil = DateTime.parse(widget.discount["validUntil"] as String);
    final daysLeft = validUntil.difference(DateTime.now()).inDays;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: daysLeft <= 3
            ? AppTheme.warningLight.withValues(alpha: 0.05)
            : AppTheme.secondaryLight.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: daysLeft <= 3
              ? AppTheme.warningLight.withValues(alpha: 0.2)
              : AppTheme.secondaryLight.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'schedule',
            color:
                daysLeft <= 3 ? AppTheme.warningLight : AppTheme.secondaryLight,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Validité',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  daysLeft > 0
                      ? 'Expire dans $daysLeft jour${daysLeft > 1 ? 's' : ''}'
                      : 'Expiré',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: daysLeft <= 3
                        ? AppTheme.warningLight
                        : AppTheme.secondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsContent(ThemeData theme, ColorScheme colorScheme) {
    final terms = [
      'Cette offre est valable uniquement pour les étudiants avec une carte étudiant valide.',
      'La réduction ne peut pas être combinée avec d\'autres offres ou promotions.',
      'L\'offre est limitée à une utilisation par personne et par jour.',
      'Le commerçant se réserve le droit de refuser l\'offre en cas de suspicion de fraude.',
      'Cette offre peut être retirée à tout moment sans préavis.',
      'Les conditions générales de vente du commerçant s\'appliquent.',
    ];

    return Column(
      children: terms
          .map((term) => Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 0.8.h, right: 2.w),
                      width: 1.w,
                      height: 1.w,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        term,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _saveToWallet(context),
              icon: CustomIconWidget(
                iconName: 'wallet',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              label: const Text('Enregistrer'),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _getDirections(context),
              icon: CustomIconWidget(
                iconName: 'directions',
                color: Colors.white,
                size: 20,
              ),
              label: const Text('Itinéraire'),
            ),
          ),
        ],
      ),
    );
  }

  String _generateQRData() {
    return 'DISCOUNT:${widget.discount["id"]}:${widget.discount["businessName"]}:${widget.discount["percentage"]}';
  }

  String _generateDiscountCode() {
    return 'NL${widget.discount["id"].toString().padLeft(4, '0')}';
  }

  void _saveToWallet(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Réduction enregistrée dans le portefeuille'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _getDirections(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Ouverture de l\'itinéraire vers ${widget.discount["businessName"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
