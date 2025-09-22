import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../post_ride_analysis/widgets/horse_behavior_analysis.dart';

class TestResultsWidget extends StatelessWidget {
  final Map<String, dynamic> testResults;
  final VoidCallback onRunAnotherTest;

  const TestResultsWidget({
    Key? key,
    required this.testResults,
    required this.onRunAnotherTest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final performanceMetrics =
        testResults['performanceMetrics'] as Map<String, dynamic>;
    final horseBehaviorData =
        testResults['horseBehaviorData'] as Map<String, dynamic>;
    final aiInsights = testResults['aiInsights'] as List<dynamic>;
    final results = testResults['testResults'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow.withAlpha(26),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.green.shade600,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Complete',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade600,
                          ),
                        ),
                        Text(
                          'Connection analysis generated successfully',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // Performance metrics overview
        _buildPerformanceMetrics(performanceMetrics, results),

        SizedBox(height: 3.h),

        // Horse behavior analysis
        HorseBehaviorAnalysis(behaviorData: horseBehaviorData),

        SizedBox(height: 3.h),

        // AI insights
        _buildAIInsights(aiInsights),

        SizedBox(height: 3.h),

        // Improvement areas and strengths
        _buildAnalysisSummary(results),

        SizedBox(height: 4.h),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onRunAnotherTest,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Test Another Scenario',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'home',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  'Back to App',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics(
      Map<String, dynamic> metrics, Map<String, dynamic> results) {
    final connectionScore = results['connectionScore'] as double;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withAlpha(26),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 3.h),

          // Overall connection score - large display
          Center(
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getConnectionColor(connectionScore).withAlpha(26),
                border: Border.all(
                  color: _getConnectionColor(connectionScore),
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(connectionScore * 100).toStringAsFixed(0)}%',
                    style:
                        AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: _getConnectionColor(connectionScore),
                    ),
                  ),
                  Text(
                    'Connection Score',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Individual metrics grid
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 2.h,
            crossAxisSpacing: 3.w,
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard(
                'Balance',
                '${(metrics['balance_score'] as double).toStringAsFixed(0)}%',
                Icons.balance,
                _getScoreColor(metrics['balance_score'] as double),
              ),
              _buildMetricCard(
                'Communication',
                '${(metrics['communication_clarity'] as double).toStringAsFixed(0)}%',
                Icons.chat,
                _getScoreColor(metrics['communication_clarity'] as double),
              ),
              _buildMetricCard(
                'Responsiveness',
                '${(metrics['horse_responsiveness'] as double).toStringAsFixed(0)}%',
                Icons.flash_on,
                _getScoreColor(metrics['horse_responsiveness'] as double),
              ),
              _buildMetricCard(
                'Harmony',
                '${(metrics['overall_harmony'] as double).toStringAsFixed(0)}%',
                Icons.favorite,
                _getScoreColor(metrics['overall_harmony'] as double),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha(51),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSummary(Map<String, dynamic> results) {
    final improvementAreas = results['improvementAreas'] as List<dynamic>;
    final strengths = results['strengths'] as List<dynamic>;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withAlpha(26),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Summary',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 3.h),

          // Strengths
          if (strengths.isNotEmpty) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'star',
                  color: Colors.green.shade600,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Strengths',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: strengths
                  .map((strength) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          strength as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 2.h),
          ],

          // Improvement areas
          if (improvementAreas.isNotEmpty) ...[
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'trending_up',
                  color: Colors.orange.shade600,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Areas for Improvement',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: improvementAreas
                  .map((area) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Text(
                          area as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAIInsights(List<dynamic> insights) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withAlpha(26),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Insights',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          ...insights.cast<Map<String, dynamic>>().map((insight) =>
            Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Text(
                insight['text'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getConnectionColor(double score) {
    if (score >= 0.8) return Colors.green.shade600;
    if (score >= 0.6) return Colors.blue.shade600;
    if (score >= 0.4) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green.shade600;
    if (score >= 60) return Colors.blue.shade600;
    if (score >= 40) return Colors.orange.shade600;
    return Colors.red.shade600;
  }
}