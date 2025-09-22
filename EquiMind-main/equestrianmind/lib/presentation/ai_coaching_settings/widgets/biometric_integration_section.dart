import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class BiometricIntegrationSection extends StatefulWidget {
  final bool heartRateEnabled;
  final bool stressDetectionEnabled;
  final double emergencyThreshold;
  final Function(bool) onHeartRateToggle;
  final Function(bool) onStressDetectionToggle;
  final Function(double) onEmergencyThresholdChanged;

  const BiometricIntegrationSection({
    Key? key,
    required this.heartRateEnabled,
    required this.stressDetectionEnabled,
    required this.emergencyThreshold,
    required this.onHeartRateToggle,
    required this.onStressDetectionToggle,
    required this.onEmergencyThresholdChanged,
  }) : super(key: key);

  @override
  State<BiometricIntegrationSection> createState() =>
      _BiometricIntegrationSectionState();
}

class _BiometricIntegrationSectionState
    extends State<BiometricIntegrationSection> {
  final List<Map<String, dynamic>> connectedDevices = [
    {
      'name': 'Apple Watch Series 9',
      'type': 'Heart Rate Monitor',
      'status': 'Connected',
      'battery': 85,
      'icon': 'watch',
    },
    {
      'name': 'Polar H10',
      'type': 'Chest Strap',
      'status': 'Disconnected',
      'battery': 0,
      'icon': 'monitor_heart',
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
                iconName: 'favorite',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Biometric Integration',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildToggleOption(
            'Heart Rate Monitoring',
            'Track heart rate during rides for performance insights',
            'monitor_heart',
            widget.heartRateEnabled,
            widget.onHeartRateToggle,
          ),
          SizedBox(height: 2.h),
          _buildToggleOption(
            'Stress Detection',
            'Monitor stress levels and provide calming guidance',
            'psychology',
            widget.stressDetectionEnabled,
            widget.onStressDetectionToggle,
          ),
          SizedBox(height: 3.h),
          _buildEmergencyThresholdSlider(),
          SizedBox(height: 3.h),
          _buildConnectedDevices(),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    String description,
    String iconName,
    bool isEnabled,
    Function(bool) onToggle,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: isEnabled
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            activeColor: AppTheme.lightTheme.primaryColor,
            activeTrackColor:
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyThresholdSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Alert Sensitivity',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Heart rate threshold for emergency alerts: ${(widget.emergencyThreshold * 100 + 120).round()} BPM',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
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
            value: widget.emergencyThreshold,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            onChanged: widget.onEmergencyThresholdChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Low (120 BPM)',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'High (220 BPM)',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConnectedDevices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Connected Devices',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: _scanForDevices,
              icon: CustomIconWidget(
                iconName: 'bluetooth_searching',
                color: AppTheme.lightTheme.primaryColor,
                size: 4.w,
              ),
              label: Text(
                'Scan',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ...connectedDevices.map((device) => _buildDeviceCard(device)).toList(),
      ],
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device) {
    final isConnected = device['status'] == 'Connected';

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: isConnected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3)
              : AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: device['icon'] as String,
            color: isConnected
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
                  device['name'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  device['type'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isConnected && device['battery'] > 0) ...[
            CustomIconWidget(
              iconName: 'battery_full',
              color: AppTheme.lightTheme.primaryColor,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              '${device['battery']}%',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: isConnected
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: Text(
              device['status'] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isConnected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scanForDevices() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scanning for biometric devices...'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }
}
