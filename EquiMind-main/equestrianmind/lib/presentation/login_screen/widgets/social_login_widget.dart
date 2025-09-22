import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onAppleLogin;

  const SocialLoginWidget({
    Key? key,
    this.onGoogleLogin,
    this.onAppleLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            'Or sign in with',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                onTap: onGoogleLogin,
                icon: 'g_translate',
                label: 'Google',
              ),
              _buildSocialButton(
                onTap: onAppleLogin,
                icon: 'apple',
                label: 'Apple',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback? onTap,
    required String icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
