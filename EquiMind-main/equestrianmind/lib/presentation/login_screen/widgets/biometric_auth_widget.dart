import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback? onBiometricSuccess;
  final bool isEnabled;

  const BiometricAuthWidget({
    Key? key,
    this.onBiometricSuccess,
    this.isEnabled = false,
  }) : super(key: key);

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget> {
  bool _isAuthenticating = false;

  Future<void> _authenticateWithBiometrics() async {
    if (!widget.isEnabled || _isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Simulate biometric authentication check
      await Future.delayed(Duration(milliseconds: 500));

      // Trigger haptic feedback
      HapticFeedback.lightImpact();

      if (widget.onBiometricSuccess != null) {
        widget.onBiometricSuccess!();
      }
    } catch (e) {
      // Handle biometric authentication error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Biometric authentication failed. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: AppTheme.lightTheme.dividerColor,
            margin: EdgeInsets.symmetric(vertical: 2.h),
          ),
          Text(
            'Or continue with',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: _authenticateWithBiometrics,
            child: Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1.0,
                ),
              ),
              child: _isAuthenticating
                  ? Center(
                      child: SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'fingerprint',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 8.w,
                    ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Use biometric authentication',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
