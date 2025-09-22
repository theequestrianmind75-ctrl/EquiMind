import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppInfoSectionWidget extends StatelessWidget {
  final Map<String, dynamic> appInfo;
  final String testingSessionId;
  final bool testingModeEnabled;

  const AppInfoSectionWidget({
    Key? key,
    required this.appInfo,
    required this.testingSessionId,
    required this.testingModeEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'App Information',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: testingModeEnabled
                      ? AppTheme.successLight.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  testingModeEnabled ? 'TESTING' : 'NORMAL',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: testingModeEnabled
                        ? AppTheme.successLight
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Version',
                  appInfo['version'] ?? 'Unknown',
                  'apps',
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  'Build',
                  appInfo['buildNumber'] ?? 'Unknown',
                  'build',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Environment',
                  appInfo['environment'] ?? 'Unknown',
                  'cloud',
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  'Modified',
                  appInfo['lastModified'] ?? 'Unknown',
                  'schedule',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2)),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'fingerprint',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Session ID: $testingSessionId',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  // Copy session ID to clipboard
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Session ID copied to clipboard')),
                  );
                },
                child: CustomIconWidget(
                  iconName: 'copy',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, String iconName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
