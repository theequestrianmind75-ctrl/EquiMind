import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RideSummaryCard extends StatelessWidget {
  final Map<String, dynamic> rideData;

  const RideSummaryCard({
    Key? key,
    required this.rideData,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ride Summary',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      _getScoreColor(rideData['overallScore'] as double? ?? 0.0)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(rideData['overallScore'] as double? ?? 0.0).toStringAsFixed(1)}/10',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: _getScoreColor(
                        rideData['overallScore'] as double? ?? 0.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  icon: 'schedule',
                  label: 'Duration',
                  value: rideData['duration'] as String? ?? '0 min',
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildMetricItem(
                  icon: 'straighten',
                  label: 'Distance',
                  value: rideData['distance'] as String? ?? '0 km',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  icon: 'favorite',
                  label: 'Avg Heart Rate',
                  value: '${rideData['avgHeartRate'] as int? ?? 0} bpm',
                  color: Colors.red.shade400,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildMetricItem(
                  icon: 'psychology',
                  label: 'Confidence',
                  value: '${rideData['confidenceLevel'] as int? ?? 0}%',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8.0) return Colors.green.shade600;
    if (score >= 6.0) return AppTheme.lightTheme.colorScheme.tertiary;
    if (score >= 4.0) return Colors.orange.shade600;
    return Colors.red.shade600;
  }
}
