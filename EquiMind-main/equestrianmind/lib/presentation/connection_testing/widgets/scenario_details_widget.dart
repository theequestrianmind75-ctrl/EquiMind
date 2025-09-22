import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScenarioDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> scenario;

  const ScenarioDetailsWidget({
    Key? key,
    required this.scenario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'assessment',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Scenario',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      scenario['name'] as String,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          Text(
            scenario['description'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 3.h),

          // Scenario parameters grid
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.surfaceContainerHighest.withAlpha(77),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scenario Parameters',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildParameter(
                        'Rider Emotion',
                        '${(scenario['riderEmotion'] as double).toStringAsFixed(1)}/10',
                        _getEmotionDescription(
                            scenario['riderEmotion'] as double),
                        Icons.psychology,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildParameter(
                        'Connection',
                        '${((scenario['connectionStrength'] as double) * 100).toStringAsFixed(0)}%',
                        scenario['bonding'] as String,
                        Icons.favorite,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildParameter(
                        'Horse Mood',
                        scenario['horseMood'] as String,
                        'Current emotional state',
                        Icons.pets,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildParameter(
                        'Energy Level',
                        scenario['horseEnergy'] as String,
                        'Activity level today',
                        Icons.bolt,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (scenario['notes'] != null &&
              (scenario['notes'] as String).isNotEmpty) ...[
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiaryContainer
                    .withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary.withAlpha(51),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'note',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Observations',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    scenario['notes'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
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

  Widget _buildParameter(
      String title, String value, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 1.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color:
                AppTheme.lightTheme.colorScheme.onSurfaceVariant.withAlpha(179),
          ),
        ),
      ],
    );
  }

  String _getEmotionDescription(double emotion) {
    if (emotion >= 8) return 'Confident & Focused';
    if (emotion >= 6) return 'Calm & Centered';
    if (emotion >= 4) return 'Slightly Nervous';
    return 'Anxious';
  }
}
