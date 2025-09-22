import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class VoiceSettingsSection extends StatefulWidget {
  final double voiceSpeed;
  final String selectedAccent;
  final double volume;
  final Function(double) onSpeedChanged;
  final Function(String) onAccentChanged;
  final Function(double) onVolumeChanged;

  const VoiceSettingsSection({
    Key? key,
    required this.voiceSpeed,
    required this.selectedAccent,
    required this.volume,
    required this.onSpeedChanged,
    required this.onAccentChanged,
    required this.onVolumeChanged,
  }) : super(key: key);

  @override
  State<VoiceSettingsSection> createState() => _VoiceSettingsSectionState();
}

class _VoiceSettingsSectionState extends State<VoiceSettingsSection> {
  final List<String> availableAccents = [
    'American',
    'British',
    'Australian',
    'Canadian',
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
                iconName: 'record_voice_over',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Voice Settings',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSpeedSlider(),
          SizedBox(height: 3.h),
          _buildAccentSelector(),
          SizedBox(height: 3.h),
          _buildVolumeSlider(),
          SizedBox(height: 3.h),
          _buildTestPlaybackButton(),
        ],
      ),
    );
  }

  Widget _buildSpeedSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Speech Speed',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            Text(
              '${(widget.voiceSpeed * 100).round()}%',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.lightTheme.primaryColor,
            thumbColor: AppTheme.lightTheme.primaryColor,
            overlayColor:
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
            inactiveTrackColor:
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
            trackHeight: 1.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2.w),
          ),
          child: Slider(
            value: widget.voiceSpeed,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            onChanged: widget.onSpeedChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Slow',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Fast',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccentSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Voice Accent',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: AppTheme.lightTheme.dividerColor,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.selectedAccent,
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              items: availableAccents.map((accent) {
                return DropdownMenuItem<String>(
                  value: accent,
                  child: Text(
                    accent,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  widget.onAccentChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Volume',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            Text(
              '${(widget.volume * 100).round()}%',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'volume_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.lightTheme.primaryColor,
                  thumbColor: AppTheme.lightTheme.primaryColor,
                  overlayColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  inactiveTrackColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  trackHeight: 1.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2.w),
                ),
                child: Slider(
                  value: widget.volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: widget.onVolumeChanged,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'volume_up',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTestPlaybackButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _testPlayback,
        icon: CustomIconWidget(
          iconName: 'play_circle_outline',
          color: AppTheme.lightTheme.primaryColor,
          size: 5.w,
        ),
        label: Text(
          'Test Voice Settings',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          side: BorderSide(
            color: AppTheme.lightTheme.primaryColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
      ),
    );
  }

  void _testPlayback() {
    // In a real implementation, this would use text-to-speech with current settings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Testing voice with ${widget.selectedAccent} accent at ${(widget.voiceSpeed * 100).round()}% speed'),
        duration: Duration(seconds: 3),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }
}
