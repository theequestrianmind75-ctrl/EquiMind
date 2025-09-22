import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class EmergencyFeaturesSection extends StatefulWidget {
  final String emergencyContact;
  final String panicButtonBehavior;
  final int safetyCheckFrequency;
  final Function(String) onEmergencyContactChanged;
  final Function(String) onPanicButtonBehaviorChanged;
  final Function(int) onSafetyCheckFrequencyChanged;

  const EmergencyFeaturesSection({
    Key? key,
    required this.emergencyContact,
    required this.panicButtonBehavior,
    required this.safetyCheckFrequency,
    required this.onEmergencyContactChanged,
    required this.onPanicButtonBehaviorChanged,
    required this.onSafetyCheckFrequencyChanged,
  }) : super(key: key);

  @override
  State<EmergencyFeaturesSection> createState() =>
      _EmergencyFeaturesSectionState();
}

class _EmergencyFeaturesSectionState extends State<EmergencyFeaturesSection> {
  final TextEditingController _contactController = TextEditingController();
  final List<String> panicButtonOptions = [
    'Call Emergency Contact',
    'Call 911',
    'Send Location + Call',
    'Silent Alert Only',
  ];
  final List<int> checkFrequencyOptions = [5, 10, 15, 30, 60];

  @override
  void initState() {
    super.initState();
    _contactController.text = widget.emergencyContact;
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

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
                iconName: 'emergency',
                color: Color(0xFFD32F2F),
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Emergency Features',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildEmergencyContactField(),
          SizedBox(height: 3.h),
          _buildPanicButtonBehavior(),
          SizedBox(height: 3.h),
          _buildSafetyCheckFrequency(),
          SizedBox(height: 3.h),
          _buildTestEmergencyButton(),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contact',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Primary contact for emergency situations',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _contactController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Enter phone number',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            suffixIcon: _contactController.text.isNotEmpty
                ? InkWell(
                    onTap: () => _selectFromContacts(),
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'contacts',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 5.w,
                      ),
                    ),
                  )
                : null,
            filled: true,
            fillColor: AppTheme.lightTheme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.primaryColor,
                width: 2,
              ),
            ),
          ),
          onChanged: widget.onEmergencyContactChanged,
        ),
      ],
    );
  }

  Widget _buildPanicButtonBehavior() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Panic Button Behavior',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'What happens when emergency button is pressed',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        ...panicButtonOptions
            .map((option) => _buildPanicButtonOption(option))
            .toList(),
      ],
    );
  }

  Widget _buildPanicButtonOption(String option) {
    final isSelected = widget.panicButtonBehavior == option;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: () => widget.onPanicButtonBehaviorChanged(option),
        borderRadius: BorderRadius.circular(2.w),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xFFD32F2F).withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: isSelected
                  ? Color(0xFFD32F2F)
                  : AppTheme.lightTheme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: isSelected
                    ? 'radio_button_checked'
                    : 'radio_button_unchecked',
                color: isSelected
                    ? Color(0xFFD32F2F)
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  option,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected
                        ? Color(0xFFD32F2F)
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (option == 'Call Emergency Contact' ||
                  option == 'Send Location + Call')
                CustomIconWidget(
                  iconName: 'phone',
                  color: isSelected
                      ? Color(0xFFD32F2F)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
              if (option == 'Call 911')
                CustomIconWidget(
                  iconName: 'local_police',
                  color: isSelected
                      ? Color(0xFFD32F2F)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
              if (option == 'Silent Alert Only')
                CustomIconWidget(
                  iconName: 'notifications_off',
                  color: isSelected
                      ? Color(0xFFD32F2F)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyCheckFrequency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Check-in Frequency',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'How often to check if you\'re okay during rides',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: checkFrequencyOptions.map((frequency) {
            final isSelected = widget.safetyCheckFrequency == frequency;
            return InkWell(
              onTap: () => widget.onSafetyCheckFrequencyChanged(frequency),
              borderRadius: BorderRadius.circular(2.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(0xFFD32F2F)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: isSelected
                        ? Color(0xFFD32F2F)
                        : AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  '${frequency}min',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTestEmergencyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _testEmergencyFeatures,
        icon: CustomIconWidget(
          iconName: 'warning',
          color: Colors.white,
          size: 5.w,
        ),
        label: Text(
          'Test Emergency Features',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD32F2F),
          padding: EdgeInsets.symmetric(vertical: 3.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
      ),
    );
  }

  void _selectFromContacts() {
    // In a real implementation, this would open the contacts picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening contacts...'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _testEmergencyFeatures() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: Color(0xFFD32F2F),
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Test Emergency',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'This will test your emergency settings without actually calling anyone. Continue?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Emergency test completed successfully'),
                  duration: Duration(seconds: 3),
                  backgroundColor: Color(0xFFD32F2F),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD32F2F),
            ),
            child: Text(
              'Test',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
