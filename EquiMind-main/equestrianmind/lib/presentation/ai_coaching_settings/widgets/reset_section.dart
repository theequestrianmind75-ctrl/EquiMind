import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ResetSection extends StatefulWidget {
  final VoidCallback onResetCoachingHistory;
  final VoidCallback onRestorePreferences;
  final VoidCallback onResetAiLearning;

  const ResetSection({
    Key? key,
    required this.onResetCoachingHistory,
    required this.onRestorePreferences,
    required this.onResetAiLearning,
  }) : super(key: key);

  @override
  State<ResetSection> createState() => _ResetSectionState();
}

class _ResetSectionState extends State<ResetSection> {
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
                iconName: 'restore',
                color: Color(0xFFD32F2F),
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Reset Options',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Reset various aspects of your coaching experience',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          _buildResetOption(
            'Clear Coaching History',
            'Remove all session records and performance data',
            'history',
            Color(0xFFF57C00),
            widget.onResetCoachingHistory,
            'This will delete all your riding sessions, progress tracking, and performance analytics.',
          ),
          SizedBox(height: 2.h),
          _buildResetOption(
            'Restore Default Preferences',
            'Reset all settings to factory defaults',
            'settings_backup_restore',
            AppTheme.lightTheme.primaryColor,
            widget.onRestorePreferences,
            'All your customized settings will be reset to the original app defaults.',
          ),
          SizedBox(height: 2.h),
          _buildResetOption(
            'Reset AI Learning',
            'Clear AI\'s learned patterns about your riding',
            'psychology',
            Color(0xFFD32F2F),
            widget.onResetAiLearning,
            'The AI will forget your riding patterns and start learning from scratch.',
          ),
        ],
      ),
    );
  }

  Widget _buildResetOption(
    String title,
    String description,
    String iconName,
    Color color,
    VoidCallback onTap,
    String warningText,
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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
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
              OutlinedButton(
                onPressed: () =>
                    _showResetConfirmation(title, warningText, onTap),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.5.w),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                ),
                child: Text(
                  'Reset',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(1.5.w),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: color,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    warningText,
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
      ),
    );
  }

  void _showResetConfirmation(
      String title, String warningText, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: Color(0xFFD32F2F),
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Confirm $title',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              warningText,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Color(0xFFD32F2F).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Text(
                'This action cannot be undone.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD32F2F),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title completed successfully'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Color(0xFFD32F2F),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD32F2F),
            ),
            child: Text(
              'Reset',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
