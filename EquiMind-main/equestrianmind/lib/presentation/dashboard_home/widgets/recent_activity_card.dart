import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityCard extends StatelessWidget {
  final Map<String, dynamic>? lastRideData;
  final VoidCallback? onViewDetailsPressed;
  final VoidCallback? onSharePressed;
  final VoidCallback? onAddNotesPressed;
  final VoidCallback? onRepeatPressed;

  const RecentActivityCard({
    Key? key,
    this.lastRideData,
    this.onViewDetailsPressed,
    this.onSharePressed,
    this.onAddNotesPressed,
    this.onRepeatPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lastRideData == null) {
      return _buildEmptyState();
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'history',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Recent Activity',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'share':
                        onSharePressed?.call();
                        break;
                      case 'notes':
                        onAddNotesPressed?.call();
                        break;
                      case 'repeat':
                        onRepeatPressed?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'share',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text('Share Progress'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'notes',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'note_add',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text('Add Notes'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'repeat',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'repeat',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text('Repeat Session'),
                        ],
                      ),
                    ),
                  ],
                  child: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (lastRideData!['sessionType'] as String?) ??
                            'Training Session',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        (lastRideData!['date'] as String?) ?? 'Today',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricItem(
                          'Duration',
                          (lastRideData!['duration'] as String?) ?? '45 min',
                          'timer',
                        ),
                      ),
                      Expanded(
                        child: _buildMetricItem(
                          'Performance',
                          (lastRideData!['performance'] as String?) ?? '8.5/10',
                          'trending_up',
                        ),
                      ),
                      Expanded(
                        child: _buildMetricItem(
                          'Confidence',
                          (lastRideData!['confidence'] as String?) ?? '92%',
                          'psychology',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'lightbulb',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            (lastRideData!['aiInsight'] as String?) ??
                                'Great improvement in seat stability during transitions. Focus on maintaining consistent breathing patterns.',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onViewDetailsPressed,
                child: Text('View Full Analysis'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.secondary,
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'directions_horse',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Start Your First Session',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Begin your equestrian journey with personalized coaching',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
