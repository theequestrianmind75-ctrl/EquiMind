import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class DataPrivacySection extends StatefulWidget {
  final bool aiLearningEnabled;
  final String dataRetentionPeriod;
  final bool anonymizedSharingEnabled;
  final Function(bool) onAiLearningToggle;
  final Function(String) onDataRetentionChanged;
  final Function(bool) onAnonymizedSharingToggle;

  const DataPrivacySection({
    Key? key,
    required this.aiLearningEnabled,
    required this.dataRetentionPeriod,
    required this.anonymizedSharingEnabled,
    required this.onAiLearningToggle,
    required this.onDataRetentionChanged,
    required this.onAnonymizedSharingToggle,
  }) : super(key: key);

  @override
  State<DataPrivacySection> createState() => _DataPrivacySectionState();
}

class _DataPrivacySectionState extends State<DataPrivacySection> {
  final List<String> retentionOptions = [
    '1 Month',
    '3 Months',
    '6 Months',
    '1 Year',
    '2 Years',
    'Forever',
  ];

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
                iconName: 'privacy_tip',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Data Privacy',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildAiLearningToggle(),
          SizedBox(height: 3.h),
          _buildDataRetentionSelector(),
          SizedBox(height: 3.h),
          _buildAnonymizedSharingToggle(),
          SizedBox(height: 3.h),
          _buildPrivacyActions(),
        ],
      ),
    );
  }

  Widget _buildAiLearningToggle() {
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
                  color: widget.aiLearningEnabled
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: widget.aiLearningEnabled
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
                      'AI Learning from Your Data',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Allow AI to learn from your riding patterns to improve coaching',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.aiLearningEnabled,
                onChanged: widget.onAiLearningToggle,
                activeColor: AppTheme.lightTheme.primaryColor,
                activeTrackColor:
                    AppTheme.lightTheme.primaryColor.withValues(alpha: 0.5),
              ),
            ],
          ),
          if (widget.aiLearningEnabled) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(1.5.w),
              ),
              child: Text(
                'Your data helps improve AI coaching for better personalized guidance. All learning is done locally on your device.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataRetentionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Retention Period',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'How long to keep your coaching data and session history',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: AppTheme.lightTheme.dividerColor,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.dataRetentionPeriod,
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              items: retentionOptions.map((period) {
                return DropdownMenuItem<String>(
                  value: period,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName:
                            period == 'Forever' ? 'all_inclusive' : 'schedule',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        period,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  widget.onDataRetentionChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnonymizedSharingToggle() {
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
                  color: widget.anonymizedSharingEnabled
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: 'share',
                  color: widget.anonymizedSharingEnabled
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
                      'Anonymized Data Sharing',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Help improve the app by sharing anonymized usage data',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.anonymizedSharingEnabled,
                onChanged: widget.onAnonymizedSharingToggle,
                activeColor: AppTheme.lightTheme.primaryColor,
                activeTrackColor:
                    AppTheme.lightTheme.primaryColor.withValues(alpha: 0.5),
              ),
            ],
          ),
          if (widget.anonymizedSharingEnabled) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(1.5.w),
              ),
              child: Text(
                'Only aggregated, non-identifiable data is shared to help improve coaching algorithms for all users.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrivacyActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Actions',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _viewPrivacyPolicy,
                icon: CustomIconWidget(
                  iconName: 'description',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 4.w,
                ),
                label: Text(
                  'Privacy Policy',
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
                onPressed: _exportData,
                icon: CustomIconWidget(
                  iconName: 'download',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 4.w,
                ),
                label: Text(
                  'Export Data',
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
        SizedBox(height: 1.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _deleteAllData,
            icon: CustomIconWidget(
              iconName: 'delete_forever',
              color: Color(0xFFD32F2F),
              size: 4.w,
            ),
            label: Text(
              'Delete All My Data',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Color(0xFFD32F2F),
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Color(0xFFD32F2F),
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
    );
  }

  void _viewPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening privacy policy...'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Preparing data export...'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _deleteAllData() {
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
            Text(
              'Delete All Data',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'This will permanently delete all your coaching data, session history, and preferences. This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All data has been deleted'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Color(0xFFD32F2F),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD32F2F),
            ),
            child: Text(
              'Delete',
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
