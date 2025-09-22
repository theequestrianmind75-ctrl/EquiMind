import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GreetingHeader extends StatelessWidget {
  final String riderName;
  final String emotionalState;
  final VoidCallback? onEmergencyPressed;
  final VoidCallback? onProfilePressed;

  const GreetingHeader({
    Key? key,
    required this.riderName,
    required this.emotionalState,
    this.onEmergencyPressed,
    this.onProfilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  riderName,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildEmotionalStateIndicator(),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: onEmergencyPressed,
                icon: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomIconWidget(
                    iconName: 'emergency',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: onProfilePressed,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionalStateIndicator() {
    final stateData = _getEmotionalStateData(emotionalState);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: stateData['color'].withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: stateData['color'].withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: stateData['icon'],
            color: stateData['color'],
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            stateData['label'],
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: stateData['color'],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Map<String, dynamic> _getEmotionalStateData(String state) {
    switch (state.toLowerCase()) {
      case 'confident':
        return {
          'label': 'Feeling Confident',
          'icon': 'sentiment_very_satisfied',
          'color': AppTheme.lightTheme.colorScheme.secondary,
        };
      case 'calm':
        return {
          'label': 'Feeling Calm',
          'icon': 'sentiment_satisfied',
          'color': AppTheme.lightTheme.primaryColor,
        };
      case 'excited':
        return {
          'label': 'Feeling Excited',
          'icon': 'sentiment_very_satisfied',
          'color': AppTheme.lightTheme.colorScheme.tertiary,
        };
      case 'nervous':
        return {
          'label': 'Feeling Nervous',
          'icon': 'sentiment_neutral',
          'color': AppTheme.lightTheme.colorScheme.tertiary,
        };
      case 'anxious':
        return {
          'label': 'Feeling Anxious',
          'icon': 'sentiment_dissatisfied',
          'color': AppTheme.lightTheme.colorScheme.error,
        };
      case 'focused':
        return {
          'label': 'Feeling Focused',
          'icon': 'psychology',
          'color': AppTheme.lightTheme.primaryColor,
        };
      default:
        return {
          'label': 'Ready to Ride',
          'icon': 'sentiment_satisfied',
          'color': AppTheme.lightTheme.primaryColor,
        };
    }
  }
}
