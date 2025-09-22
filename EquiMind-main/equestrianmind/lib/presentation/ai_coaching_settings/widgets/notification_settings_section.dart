import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class NotificationSettingsSection extends StatefulWidget {
  final bool coachingReminders;
  final bool progressCelebrations;
  final bool sessionScheduling;
  final Function(bool) onCoachingRemindersToggle;
  final Function(bool) onProgressCelebrationsToggle;
  final Function(bool) onSessionSchedulingToggle;

  const NotificationSettingsSection({
    Key? key,
    required this.coachingReminders,
    required this.progressCelebrations,
    required this.sessionScheduling,
    required this.onCoachingRemindersToggle,
    required this.onProgressCelebrationsToggle,
    required this.onSessionSchedulingToggle,
  }) : super(key: key);

  @override
  State<NotificationSettingsSection> createState() =>
      _NotificationSettingsSectionState();
}

class _NotificationSettingsSectionState
    extends State<NotificationSettingsSection> {
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
                iconName: 'notifications',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Notification Settings',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildNotificationToggle(
            'Coaching Reminders',
            'Daily reminders to practice and improve',
            'schedule',
            widget.coachingReminders,
            widget.onCoachingRemindersToggle,
          ),
          SizedBox(height: 2.h),
          _buildNotificationToggle(
            'Progress Celebrations',
            'Notifications when you achieve milestones',
            'celebration',
            widget.progressCelebrations,
            widget.onProgressCelebrationsToggle,
          ),
          SizedBox(height: 2.h),
          _buildNotificationToggle(
            'Session Scheduling',
            'Reminders for upcoming coaching sessions',
            'event',
            widget.sessionScheduling,
            widget.onSessionSchedulingToggle,
          ),
          SizedBox(height: 3.h),
          _buildPermissionStatus(),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String description,
    String iconName,
    bool isEnabled,
    Function(bool) onToggle,
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
      child: Row(
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
    );
  }

  Widget _buildPermissionStatus() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Notification Permissions',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Notifications are currently enabled. You can manage detailed notification settings in your device\'s system settings.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openSystemSettings,
                  icon: CustomIconWidget(
                    iconName: 'settings',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 4.w,
                  ),
                  label: Text(
                    'System Settings',
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
                child: ElevatedButton.icon(
                  onPressed: _testNotifications,
                  icon: CustomIconWidget(
                    iconName: 'send',
                    color: Colors.white,
                    size: 4.w,
                  ),
                  label: Text(
                    'Test Notification',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
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

  void _openSystemSettings() {
    // In a real implementation, this would open system notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening system notification settings...'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _testNotifications() {
    // In a real implementation, this would send a test notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text('Test notification sent successfully!'),
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }
}
