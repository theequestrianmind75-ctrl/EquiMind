import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AdvancedOptionsSection extends StatefulWidget {
  final bool offlineCoachingEnabled;
  final bool backgroundProcessingEnabled;
  final bool batteryOptimizationEnabled;
  final Function(bool) onOfflineCoachingToggle;
  final Function(bool) onBackgroundProcessingToggle;
  final Function(bool) onBatteryOptimizationToggle;

  const AdvancedOptionsSection({
    Key? key,
    required this.offlineCoachingEnabled,
    required this.backgroundProcessingEnabled,
    required this.batteryOptimizationEnabled,
    required this.onOfflineCoachingToggle,
    required this.onBackgroundProcessingToggle,
    required this.onBatteryOptimizationToggle,
  }) : super(key: key);

  @override
  State<AdvancedOptionsSection> createState() => _AdvancedOptionsSectionState();
}

class _AdvancedOptionsSectionState extends State<AdvancedOptionsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Advanced Options',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildAdvancedToggle(
            'Offline Coaching',
            'Enable AI coaching without internet connection',
            'offline_bolt',
            widget.offlineCoachingEnabled,
            widget.onOfflineCoachingToggle,
            'Uses local AI models for basic coaching when offline',
          ),
          SizedBox(height: 2.h),
          _buildAdvancedToggle(
            'Background Processing',
            'Allow app to run coaching in background',
            'play_circle',
            widget.backgroundProcessingEnabled,
            widget.onBackgroundProcessingToggle,
            'Enables continuous monitoring during rides',
          ),
          SizedBox(height: 2.h),
          _buildAdvancedToggle(
            'Battery Optimization',
            'Optimize battery usage during long sessions',
            'battery_saver',
            widget.batteryOptimizationEnabled,
            widget.onBatteryOptimizationToggle,
            'Reduces CPU usage and extends battery life',
          ),
          SizedBox(height: 3.h),
          _buildStorageInfo(),
        ],
      ),
    );
  }

  Widget _buildAdvancedToggle(
    String title,
    String description,
    String iconName,
    bool isEnabled,
    Function(bool) onToggle,
    String details,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: isEnabled
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      description,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: onToggle,
                activeColor: AppTheme.lightTheme.primaryColor,
                activeTrackColor:
                    AppTheme.lightTheme.primaryColor.withValues(alpha: 0.5),
              ),
            ],
          ),
          if (isEnabled) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(1.5.w),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      details,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStorageInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'storage',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Storage Usage',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildStorageItem('AI Models', '245 MB', 0.6),
          SizedBox(height: 1.h),
          _buildStorageItem('Session Data', '89 MB', 0.3),
          SizedBox(height: 1.h),
          _buildStorageItem('Cache', '34 MB', 0.1),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearCache,
                  icon: CustomIconWidget(
                    iconName: 'cleaning_services',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 4.w,
                  ),
                  label: Text(
                    'Clear Cache',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppTheme.lightTheme.primaryColor,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.5.w),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _updateModels,
                  icon: CustomIconWidget(
                    iconName: 'update',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 4.w,
                  ),
                  label: Text(
                    'Update Models',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppTheme.lightTheme.primaryColor,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.5.w),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageItem(String label, String size, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            Text(
              size,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor:
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          valueColor:
              AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.primaryColor),
          minHeight: 0.5.h,
        ),
      ],
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cache cleared successfully'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _updateModels() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checking for AI model updates...'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }
}
