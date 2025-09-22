import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScenarioSelectorWidget extends StatelessWidget {
  final List<Map<String, dynamic>> scenarios;
  final Function(Map<String, dynamic>) onScenarioSelected;

  const ScenarioSelectorWidget({
    Key? key,
    required this.scenarios,
    required this.onScenarioSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: scenarios
          .map((scenario) => _buildScenarioCard(context, scenario))
          .toList(),
    );
  }

  Widget _buildScenarioCard(
      BuildContext context, Map<String, dynamic> scenario) {
    final connectionStrength = scenario['connectionStrength'] as double;
    final riderEmotion = scenario['riderEmotion'] as double;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onScenarioSelected(scenario),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color:
                            _getScenarioColor(connectionStrength).withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: _getScenarioIcon(scenario['id'] as String),
                        color: _getScenarioColor(connectionStrength),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scenario['name'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            scenario['description'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'play_arrow',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Scenario metrics
                Row(
                  children: [
                    Expanded(
                      child: _buildMetric(
                        'Rider Emotion',
                        '${riderEmotion.toStringAsFixed(1)}/10',
                        _getEmotionColor(riderEmotion),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildMetric(
                        'Connection',
                        '${(connectionStrength * 100).toStringAsFixed(0)}%',
                        _getScenarioColor(connectionStrength),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildMetric(
                        'Horse Mood',
                        scenario['horseMood'] as String,
                        _getHorseMoodColor(scenario['horseMood'] as String),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Expected insights preview
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                        .withAlpha(77),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expected Insights:',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 1.w,
                        runSpacing: 0.5.h,
                        children:
                            (scenario['expectedInsights'] as List<dynamic>)
                                .map((insight) => Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary
                                            .withAlpha(26),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        insight as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ))
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withAlpha(77)),
          ),
          child: Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _getScenarioIcon(String scenarioId) {
    switch (scenarioId) {
      case 'perfect_harmony':
        return 'favorite';
      case 'anxious_rider_nervous_horse':
        return 'warning';
      case 'confident_rider_resistant_horse':
        return 'fitness_center';
      case 'fluctuating_emotions':
        return 'trending_up';
      case 'new_partnership':
        return 'handshake';
      case 'post_incident_recovery':
        return 'healing';
      case 'competition_ready':
        return 'emoji_events';
      default:
        return 'pets';
    }
  }

  Color _getScenarioColor(double connectionStrength) {
    if (connectionStrength >= 0.8) return Colors.green.shade600;
    if (connectionStrength >= 0.6) return Colors.blue.shade600;
    if (connectionStrength >= 0.4) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Color _getEmotionColor(double emotion) {
    if (emotion >= 8) return Colors.green.shade600;
    if (emotion >= 6) return Colors.blue.shade600;
    if (emotion >= 4) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Color _getHorseMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
      case 'focused':
        return Colors.green.shade600;
      case 'alert':
      case 'playful':
        return Colors.blue.shade600;
      case 'anxious':
      case 'nervous':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
