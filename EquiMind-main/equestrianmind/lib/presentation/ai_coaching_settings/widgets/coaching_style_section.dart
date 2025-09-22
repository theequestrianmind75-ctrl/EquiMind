import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CoachingStyleSection extends StatefulWidget {
  final String selectedStyle;
  final Function(String) onStyleChanged;

  const CoachingStyleSection({
    Key? key,
    required this.selectedStyle,
    required this.onStyleChanged,
  }) : super(key: key);

  @override
  State<CoachingStyleSection> createState() => _CoachingStyleSectionState();
}

class _CoachingStyleSectionState extends State<CoachingStyleSection> {
  final List<Map<String, dynamic>> coachingStyles = [
    {
      'name': 'Encouraging',
      'description': 'Positive reinforcement and supportive guidance',
      'preview': 'Great job! You\'re building confidence with each stride.',
    },
    {
      'name': 'Direct',
      'description': 'Clear, concise instructions and feedback',
      'preview': 'Adjust your posture. Keep your heels down.',
    },
    {
      'name': 'Gentle',
      'description': 'Soft, patient approach for sensitive riders',
      'preview': 'Take your time. Feel the rhythm of your horse.',
    },
    {
      'name': 'Motivational',
      'description': 'High-energy coaching to push performance',
      'preview': 'Push through! You\'ve got this! Show your strength!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Coaching Style',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ...coachingStyles.map((style) => _buildStyleOption(style)).toList(),
        ],
      ),
    );
  }

  Widget _buildStyleOption(Map<String, dynamic> style) {
    final isSelected = widget.selectedStyle == style['name'];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () => widget.onStyleChanged(style['name'] as String),
        borderRadius: BorderRadius.circular(2.w),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: isSelected
                        ? 'radio_button_checked'
                        : 'radio_button_unchecked',
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          style['name'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          style['description'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _playPreview(style['preview'] as String),
                    borderRadius: BorderRadius.circular(1.5.w),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(1.5.w),
                      ),
                      child: CustomIconWidget(
                        iconName: 'play_arrow',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 4.w,
                      ),
                    ),
                  ),
                ],
              ),
              if (isSelected) ...[
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor
                        .withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    '"${style['preview']}"',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _playPreview(String preview) {
    // In a real implementation, this would use text-to-speech
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing preview: "$preview"'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }
}
