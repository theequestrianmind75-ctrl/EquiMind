import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementBadgesWidget({
    Key? key,
    required this.achievements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Achievements Unlocked',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          achievements.isEmpty
              ? _buildNoAchievements()
              : _buildAchievementsList(),
        ],
      ),
    );
  }

  Widget _buildNoAchievements() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'star_border',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Keep riding to unlock achievements!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Complete more rides and improve your skills to earn badges',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.2,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isNew = achievement['isNew'] as bool? ?? false;

    return Container(
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
        border: isNew
            ? Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                width: 2,
              )
            : null,
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: _getAchievementColor(
                            achievement['category'] as String? ?? '')
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: _getAchievementIcon(
                        achievement['category'] as String? ?? ''),
                    color: _getAchievementColor(
                        achievement['category'] as String? ?? ''),
                    size: 32,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  achievement['title'] as String? ?? 'Achievement',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Text(
                  achievement['description'] as String? ?? 'Great job!',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getAchievementColor(
                            achievement['category'] as String? ?? '')
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${achievement['points'] as int? ?? 0} pts',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getAchievementColor(
                          achievement['category'] as String? ?? ''),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isNew)
            Positioned(
              top: 2.w,
              right: 2.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'NEW',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 8.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getAchievementIcon(String category) {
    switch (category.toLowerCase()) {
      case 'confidence':
        return 'psychology';
      case 'consistency':
        return 'trending_up';
      case 'calm':
        return 'self_improvement';
      case 'technique':
        return 'sports';
      case 'endurance':
        return 'timer';
      case 'milestone':
        return 'flag';
      default:
        return 'emoji_events';
    }
  }

  Color _getAchievementColor(String category) {
    switch (category.toLowerCase()) {
      case 'confidence':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'consistency':
        return Colors.green.shade600;
      case 'calm':
        return Colors.blue.shade600;
      case 'technique':
        return Colors.purple.shade600;
      case 'endurance':
        return Colors.orange.shade600;
      case 'milestone':
        return Colors.red.shade600;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
