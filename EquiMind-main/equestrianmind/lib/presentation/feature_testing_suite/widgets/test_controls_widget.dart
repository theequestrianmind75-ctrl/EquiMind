import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TestControlsWidget extends StatelessWidget {
  final bool testingInProgress;
  final bool canStartTest;
  final VoidCallback onStartTest;
  final VoidCallback onSkipStep;
  final VoidCallback onMarkFailed;
  final int currentStep;
  final int totalSteps;

  const TestControlsWidget({
    Key? key,
    required this.testingInProgress,
    required this.canStartTest,
    required this.onStartTest,
    required this.onSkipStep,
    required this.onMarkFailed,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (testingInProgress) ...[
              // Current step indicator
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'play_circle',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Step $currentStep of $totalSteps in progress...',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              // Interactive controls during testing
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSkipStep,
                      icon: CustomIconWidget(
                        iconName: 'skip_next',
                        size: 16,
                      ),
                      label: Text('Skip Step'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(0, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onMarkFailed,
                      icon: CustomIconWidget(
                        iconName: 'error',
                        color: AppTheme.errorLight,
                        size: 16,
                      ),
                      label: Text(
                        'Mark as Failed',
                        style: TextStyle(color: AppTheme.errorLight),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.errorLight),
                        minimumSize: Size(0, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Start test controls
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: canStartTest ? onStartTest : null,
                      icon: CustomIconWidget(
                        iconName: 'play_arrow',
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        canStartTest ? 'Start Test Sequence' : 'Test Completed',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canStartTest
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.successLight,
                        minimumSize: Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (!canStartTest) ...[
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.successLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.successLight.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successLight,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'All test steps completed successfully. Review results or switch to another test category.',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.successLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
