import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class TriggerSensitivitySection extends StatefulWidget {
  final String selectedSensitivity;
  final Function(String) onSensitivityChanged;

  const TriggerSensitivitySection({
    Key? key,
    required this.selectedSensitivity,
    required this.onSensitivityChanged,
  }) : super(key: key);

  @override
  State<TriggerSensitivitySection> createState() =>
      _TriggerSensitivitySectionState();
}

class _TriggerSensitivitySectionState extends State<TriggerSensitivitySection> {
  final List<Map<String, dynamic>> sensitivityLevels = [
    {
      'level': 'High',
      'description': 'Frequent guidance and immediate feedback',
      'details': 'AI intervenes every 30-60 seconds with tips and corrections',
      'icon': 'notifications_active',
      'color': Color(0xFFD32F2F),
    },
    {
      'level': 'Medium',
      'description': 'Balanced coaching with moderate intervention',
      'details': 'AI provides feedback every 2-3 minutes or when needed',
      'icon': 'notifications',
      'color': Color(0xFFF57C00),
    },
    {
      'level': 'Low',
      'description': 'Minimal interruption, key moments only',
      'details': 'AI speaks only for safety concerns or major corrections',
      'icon': 'notifications_none',
      'color': Color(0xFF388E3C),
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
                iconName: 'tune',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Trigger Sensitivity',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Control when AI provides coaching feedback',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ...sensitivityLevels
              .map((level) => _buildSensitivityOption(level))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSensitivityOption(Map<String, dynamic> level) {
    final isSelected = widget.selectedSensitivity == level['level'];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: () => widget.onSensitivityChanged(level['level'] as String),
        borderRadius: BorderRadius.circular(2.w),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isSelected
                ? (level['color'] as Color).withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: isSelected
                  ? level['color'] as Color
                  : AppTheme.lightTheme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: (level['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: level['icon'] as String,
                  color: level['color'] as Color,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
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
                              ? level['color'] as Color
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          level['level'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? level['color'] as Color
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      level['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(height: 1.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color:
                              (level['color'] as Color).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(1.5.w),
                        ),
                        child: Text(
                          level['details'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
