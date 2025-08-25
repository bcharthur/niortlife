import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QRScannerWidget extends StatefulWidget {
  final Function(String) onQRScanned;
  const QRScannerWidget({super.key, required this.onQRScanned});

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  final MobileScannerController _controller =
  MobileScannerController(torchEnabled: false, facing: CameraFacing.back);

  bool isFlashOn = false;
  bool hasScanned = false;

  @override
  void reassemble() {
    super.reassemble();
    // Hot reload handling
    if (defaultTargetPlatform == TargetPlatform.android) {
      _controller.stop();
      _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Scanner QR Code',
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: CustomIconWidget(iconName: 'close', color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: isFlashOn ? 'flash_on' : 'flash_off',
              color: Colors.white,
              size: 24,
            ),
            onPressed: _toggleFlash,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                // Camera view with detection
                MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    if (hasScanned) return;
                    for (final barcode in capture.barcodes) {
                      final value = barcode.rawValue;
                      if (value != null) {
                        setState(() => hasScanned = true);
                        _handleQRScanned(value);
                        break;
                      }
                    }
                  },
                ),
                if (!hasScanned) _buildScanningOverlay(),
                // Overlay frame (visual guide)
                IgnorePointer(
                  child: Center(
                    child: Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Instructions
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              color: colorScheme.surface,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'qr_code_scanner',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 32,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Positionnez le QR code dans le cadre',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Le code sera scanné automatiquement',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return Positioned.fill(
      child: Center(
        child: SizedBox(
          width: 70.w,
          height: 70.w,
          child: Stack(
            children: [
              // Simple scanning line animation (static visual here)
              Positioned(
                top: 35.w,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppTheme.lightTheme.colorScheme.primary,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleQRScanned(String qrData) async {
    await _controller.stop(); // avoid multiple scans

    if (_isValidDiscountQR(qrData)) {
      widget.onQRScanned(qrData);
      _showScanSuccess();
    } else {
      _showScanError('QR code invalide');
    }
  }

  bool _isValidDiscountQR(String qrData) {
    // Expected format: DISCOUNT:ID:BUSINESS:PERCENTAGE
    return qrData.startsWith('DISCOUNT:') && qrData.split(':').length >= 4;
  }

  void _showScanSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.secondaryLight,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'QR Code scanné avec succès !',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'La réduction a été validée.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close scanner
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showScanError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(iconName: 'error', color: AppTheme.errorLight, size: 48),
            SizedBox(height: 2.h),
            Text(
              'Erreur de scan',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => hasScanned = false);
              await _controller.start();
            },
            child: const Text('Réessayer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close scanner
            },
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFlash() async {
    try {
      await _controller.toggleTorch(); // Future<void>; no return state in v6.0.x
      if (!mounted) return;
      setState(() {
        // We optimistically flip our local state.
        // If the device doesn't support torch, toggleTorch will throw and we won't flip.
        isFlashOn = !isFlashOn;
      });
    } catch (_) {
      // Torch not supported or not available; you could show a SnackBar here if desired.
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
