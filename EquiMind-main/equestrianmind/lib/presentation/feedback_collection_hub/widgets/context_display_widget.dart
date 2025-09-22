import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class ContextDisplayWidget extends StatelessWidget {
  final String currentScreen;
  final String sessionInfo;

  const ContextDisplayWidget({
    Key? key,
    required this.currentScreen,
    required this.sessionInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Screen Context
          Text(
            'Current Screen Context',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),

          _buildContextCard(
            'Screen',
            currentScreen,
            Icons.phone_android,
            AppTheme.lightTheme.colorScheme.primary,
          ),

          SizedBox(height: 2.h),

          _buildContextCard(
            'Session',
            sessionInfo,
            Icons.access_time,
            AppTheme.lightTheme.colorScheme.secondary,
          ),

          SizedBox(height: 3.h),

          // Device Information
          Text(
            'Device Information',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),

          _buildDeviceInfoSection(),

          SizedBox(height: 3.h),

          // App Information
          Text(
            'App Information',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),

          _buildAppInfoSection(),

          SizedBox(height: 3.h),

          // User Information
          Text(
            'User Information',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),

          _buildUserInfoSection(),
        ],
      ),
    );
  }

  Widget _buildContextCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              // Could add a snackbar here for feedback
            },
            icon: Icon(
              Icons.copy,
              size: 18,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow('Platform', 'iOS 17.2.1'),
          _buildDivider(),
          _buildInfoRow('Device', 'iPhone 15 Pro'),
          _buildDivider(),
          _buildInfoRow('Screen Size', '2556 × 1179'),
          _buildDivider(),
          _buildInfoRow('Orientation', 'Portrait'),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow('App Version', '1.0.0+1'),
          _buildDivider(),
          _buildInfoRow('Build', 'Debug'),
          _buildDivider(),
          _buildInfoRow('Flutter Version', '3.16.0'),
          _buildDivider(),
          _buildInfoRow('Dart Version', '3.2.0'),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow('User ID', 'user_123456'),
          _buildDivider(),
          _buildInfoRow('Session Duration', '15 minutes'),
          _buildDivider(),
          _buildInfoRow('Feature Usage', 'Testing Dashboard'),
          _buildDivider(),
          _buildInfoRow('Network', 'WiFi Connected'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTheme.dataTextStyle(
              isLight: true,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppTheme.lightTheme.dividerColor,
      height: 1,
    );
  }
}
