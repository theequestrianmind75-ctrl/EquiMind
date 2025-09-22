import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class EquestrianLogoWidget extends StatelessWidget {
  const EquestrianLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          // Logo Container with Horse Head Image
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  blurRadius: 12.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'assets/images/horse_head_-1755481004920.png',
                width: 25.w,
                height: 25.w,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // App Name
          Text(
            'EquiMind',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),

          SizedBox(height: 0.5.h),

          // Tagline
          Text(
            'Elevate Your Riding Performance',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
