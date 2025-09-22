import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HorseConnectionWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onObservationChanged;

  const HorseConnectionWidget({
    Key? key,
    required this.onObservationChanged,
  }) : super(key: key);

  @override
  State<HorseConnectionWidget> createState() => _HorseConnectionWidgetState();
}

class _HorseConnectionWidgetState extends State<HorseConnectionWidget> {
  final TextEditingController _observationController = TextEditingController();
  String _selectedMood = 'Calm';
  String _selectedEnergy = 'Moderate';

  final List<String> _horseMoods = [
    'Anxious',
    'Alert',
    'Calm',
    'Playful',
    'Focused'
  ];
  final List<String> _energyLevels = ['Low', 'Moderate', 'High', 'Very High'];

  @override
  void initState() {
    super.initState();
    _updateObservation();
  }

  void _updateObservation() {
    widget.onObservationChanged({
      'mood': _selectedMood,
      'energy': _selectedEnergy,
      'notes': _observationController.text,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
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
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Horse Connection',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          Text(
            'How is your horse today?',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Horse mood selection
          Text(
            'Mood',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 1.h),

          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _horseMoods.map((mood) {
              final isSelected = mood == _selectedMood;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMood = mood;
                  });
                  _updateObservation();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    mood,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 3.h),

          // Energy level selection
          Text(
            'Energy Level',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 1.h),

          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _energyLevels.map((energy) {
              final isSelected = energy == _selectedEnergy;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedEnergy = energy;
                  });
                  _updateObservation();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    energy,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onSecondary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 3.h),

          // Additional observations
          Text(
            'Additional Observations',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 1.h),

          TextField(
            controller: _observationController,
            maxLines: 3,
            onChanged: (value) => _updateObservation(),
            decoration: InputDecoration(
              hintText:
                  'Any specific behaviors, concerns, or positive signs you\'ve noticed?',
              hintStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(3.w),
            ),
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }
}
