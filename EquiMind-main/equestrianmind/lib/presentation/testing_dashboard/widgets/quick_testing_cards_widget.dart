import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickTestingCardsWidget extends StatelessWidget {
  const QuickTestingCardsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Testing Scenarios',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildTestCard(
                  'Authentication Flow',
                  'Test login, biometric & social auth',
                  'security',
                  Colors.blue,
                  () => _startAuthTest(context),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildTestCard(
                  'Coaching Session',
                  'Simulate complete coaching flow',
                  'psychology',
                  Colors.green,
                  () => _startCoachingTest(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildTestCard(
                  'Biometric Integration',
                  'Test heart rate & stress sensors',
                  'favorite',
                  Colors.red,
                  () => _startBiometricTest(context),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildTestCard(
                  'Emergency Features',
                  'Validate panic button & contacts',
                  'emergency',
                  Colors.orange,
                  () => _startEmergencyTest(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard(
    String title,
    String description,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: color,
                      size: 20,
                    ),
                  ),
                ),
                Spacer(),
                CustomIconWidget(
                  iconName: 'play_arrow',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _startAuthTest(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'security',
              color: Colors.blue,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Authentication Flow Test'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This test will validate:'),
            SizedBox(height: 1.h),
            _buildTestStep('Email/Password Login'),
            _buildTestStep('Biometric Authentication'),
            _buildTestStep('Social Login (Google/Apple)'),
            _buildTestStep('Password Recovery Flow'),
            SizedBox(height: 2.h),
            Text(
              'Estimated time: 5-8 minutes',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showTestProgress(context, 'Authentication Flow');
            },
            child: Text('Start Test'),
          ),
        ],
      ),
    );
  }

  void _startCoachingTest(BuildContext context) {
    _showTestProgress(context, 'Coaching Session Simulation');
  }

  void _startBiometricTest(BuildContext context) {
    _showTestProgress(context, 'Biometric Integration Test');
  }

  void _startEmergencyTest(BuildContext context) {
    _showTestProgress(context, 'Emergency Feature Validation');
  }

  Widget _buildTestStep(String step) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check_circle_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            step,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showTestProgress(BuildContext context, String testName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting $testName...'),
        action: SnackBarAction(
          label: 'View Details',
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.featureTestingSuite);
          },
        ),
      ),
    );
  }
}
