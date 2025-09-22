import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TestProgressWidget extends StatelessWidget {
  final double overallProgress;
  final bool testingInProgress;
  final String currentTestName;
  final String estimatedTimeRemaining;
  final int completedCategories;
  final int totalCategories;

  const TestProgressWidget({
    Key? key,
    required this.overallProgress,
    required this.testingInProgress,
    required this.currentTestName,
    required this.estimatedTimeRemaining,
    required this.completedCategories,
    required this.totalCategories,
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
                iconName: 'analytics',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Testing Progress',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: testingInProgress
                      ? AppTheme.warningLight.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (testingInProgress) ...[
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.warningLight),
                        ),
                      ),
                      SizedBox(width: 1.w),
                    ],
                    Text(
                      testingInProgress ? 'TESTING' : 'IDLE',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: testingInProgress
                            ? AppTheme.warningLight
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Text(
                'Overall Progress:',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                '${(overallProgress * 100).toInt()}%',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: overallProgress,
            backgroundColor:
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
            valueColor:
                AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.primaryColor),
            minHeight: 6,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildProgressItem(
                  'Categories Completed',
                  '$completedCategories/$totalCategories',
                  'checklist_rtl',
                  AppTheme.successLight,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildProgressItem(
                  'Time Remaining',
                  estimatedTimeRemaining,
                  'schedule',
                  AppTheme.warningLight,
                ),
              ),
            ],
          ),
          if (testingInProgress && currentTestName.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'play_arrow',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Currently Testing: $currentTestName',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
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

  Widget _buildProgressItem(
      String label, String value, String iconName, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
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
            color: color,
          ),
        ),
      ],
    );
  }
}
