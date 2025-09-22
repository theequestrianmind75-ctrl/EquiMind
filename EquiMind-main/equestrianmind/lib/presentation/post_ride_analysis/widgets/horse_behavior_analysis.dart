import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HorseBehaviorAnalysis extends StatelessWidget {
  final Map<String, dynamic> behaviorData;

  const HorseBehaviorAnalysis({
    Key? key,
    required this.behaviorData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
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
              CustomIconWidget(
                iconName: 'pets',
                color: Colors.brown.shade600,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Horse Behavior Analysis',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.brown.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildBehaviorOverview(),
          SizedBox(height: 3.h),
          _buildCorrelationInsights(),
          SizedBox(height: 3.h),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildBehaviorOverview() {
    final behaviors = behaviorData['observedBehaviors'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Observed Behaviors',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: behaviors.map((behavior) {
            final behaviorMap = behavior as Map<String, dynamic>;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getBehaviorColor(behaviorMap['type'] as String? ?? '')
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      _getBehaviorColor(behaviorMap['type'] as String? ?? ''),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName:
                        _getBehaviorIcon(behaviorMap['type'] as String? ?? ''),
                    color:
                        _getBehaviorColor(behaviorMap['type'] as String? ?? ''),
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    behaviorMap['name'] as String? ?? 'Unknown',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getBehaviorColor(
                          behaviorMap['type'] as String? ?? ''),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCorrelationInsights() {
    final correlations =
        behaviorData['riderCorrelations'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rider-Horse Correlations',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: correlations.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
          itemBuilder: (context, index) {
            final correlation = correlations[index] as Map<String, dynamic>;
            return Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _getCorrelationColor(
                              correlation['strength'] as double? ?? 0.0)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'trending_up',
                      color: _getCorrelationColor(
                          correlation['strength'] as double? ?? 0.0),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          correlation['description'] as String? ??
                              'No description',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Correlation: ${((correlation['strength'] as double? ?? 0.0) * 100).toStringAsFixed(0)}%',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _getCorrelationColor(
                                correlation['strength'] as double? ?? 0.0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    final recommendations =
        behaviorData['recommendations'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relationship Recommendations',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recommendations.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
          itemBuilder: (context, index) {
            final recommendation =
                recommendations[index] as Map<String, dynamic>;
            return Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0.5.h),
                    padding: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomIconWidget(
                      iconName: 'lightbulb',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation['title'] as String? ??
                              'Recommendation',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          recommendation['description'] as String? ??
                              'No description available',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (recommendation['priority'] != null) ...[
                          SizedBox(height: 1.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(
                                      recommendation['priority'] as String? ??
                                          '')
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${recommendation['priority']} Priority',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getPriorityColor(
                                    recommendation['priority'] as String? ??
                                        ''),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String _getBehaviorIcon(String type) {
    switch (type.toLowerCase()) {
      case 'calm':
        return 'sentiment_satisfied';
      case 'nervous':
        return 'sentiment_dissatisfied';
      case 'responsive':
        return 'flash_on';
      case 'resistant':
        return 'block';
      case 'alert':
        return 'visibility';
      default:
        return 'pets';
    }
  }

  Color _getBehaviorColor(String type) {
    switch (type.toLowerCase()) {
      case 'calm':
        return Colors.green.shade600;
      case 'nervous':
        return Colors.orange.shade600;
      case 'responsive':
        return Colors.blue.shade600;
      case 'resistant':
        return Colors.red.shade600;
      case 'alert':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return Colors.grey.shade600;
    }
  }

  Color _getCorrelationColor(double strength) {
    if (strength >= 0.7) return Colors.green.shade600;
    if (strength >= 0.4) return AppTheme.lightTheme.colorScheme.tertiary;
    if (strength >= 0.2) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade600;
      case 'medium':
        return Colors.orange.shade600;
      case 'low':
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
