import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeviceTestingToolsWidget extends StatefulWidget {
  const DeviceTestingToolsWidget({Key? key}) : super(key: key);

  @override
  State<DeviceTestingToolsWidget> createState() =>
      _DeviceTestingToolsWidgetState();
}

class _DeviceTestingToolsWidgetState extends State<DeviceTestingToolsWidget> {
  bool _hapticTestRunning = false;
  bool _audioTestRunning = false;
  bool _biometricCalibrating = false;
  double _hapticIntensity = 0.5;
  double _audioVolume = 0.7;
  String _biometricStatus = 'Ready';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'build',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Device Testing Tools',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildHapticFeedbackTester(),
          SizedBox(height: 3.h),
          _buildAudioQualityValidator(),
          SizedBox(height: 3.h),
          _buildBiometricSensorCalibration(),
          SizedBox(height: 3.h),
          _buildTestFlightIntegration(),
        ],
      ),
    );
  }

  Widget _buildHapticFeedbackTester() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'vibration',
                    color: Colors.purple,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Haptic Feedback Tester',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Test vibration patterns for coaching feedback',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _hapticTestRunning,
                onChanged: (value) {
                  setState(() => _hapticTestRunning = value);
                  _toggleHapticTest(value);
                },
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Intensity: ${(_hapticIntensity * 100).toInt()}%',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Slider(
            value: _hapticIntensity,
            onChanged: (value) => setState(() => _hapticIntensity = value),
            divisions: 10,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _testHapticPattern('light'),
                  child: Text('Light'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _testHapticPattern('medium'),
                  child: Text('Medium'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _testHapticPattern('heavy'),
                  child: Text('Heavy'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioQualityValidator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'headset_mic',
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Quality Validator',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Test audio playback and recording quality',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: CustomIconWidget(
                  iconName: _audioTestRunning ? 'stop' : 'play_arrow',
                  color: _audioTestRunning
                      ? AppTheme.errorLight
                      : AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                onPressed: () {
                  setState(() => _audioTestRunning = !_audioTestRunning);
                  _toggleAudioTest(_audioTestRunning);
                },
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Volume: ${(_audioVolume * 100).toInt()}%',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Slider(
            value: _audioVolume,
            onChanged: (value) => setState(() => _audioVolume = value),
            divisions: 10,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _testAudio('coaching'),
                  icon: CustomIconWidget(iconName: 'psychology', size: 16),
                  label: Text('Coaching Audio'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _testAudio('recording'),
                  icon: CustomIconWidget(iconName: 'mic', size: 16),
                  label: Text('Recording'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricSensorCalibration() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'favorite',
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biometric Sensor Calibration',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Calibrate heart rate and stress detection sensors',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getBiometricStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _biometricStatus,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getBiometricStatusColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _biometricCalibrating
                      ? null
                      : () => _calibrateSensor('heart_rate'),
                  icon: CustomIconWidget(iconName: 'favorite', size: 16),
                  label: Text('Heart Rate'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _biometricCalibrating
                      ? null
                      : () => _calibrateSensor('stress'),
                  icon: CustomIconWidget(iconName: 'psychology', size: 16),
                  label: Text('Stress Level'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ElevatedButton.icon(
            onPressed:
                _biometricCalibrating ? null : () => _startFullCalibration(),
            icon: _biometricCalibrating
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : CustomIconWidget(
                    iconName: 'tune', size: 16, color: Colors.white),
            label: Text(
                _biometricCalibrating ? 'Calibrating...' : 'Full Calibration'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestFlightIntegration() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'flight',
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'TestFlight Integration',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.apple,
                          size: 16,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                    Text(
                      'Beta feedback collection and Xcode console streaming',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openBetaFeedback(),
                  icon: CustomIconWidget(iconName: 'feedback', size: 16),
                  label: Text('Beta Feedback'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _streamXcodeLogs(),
                  icon: CustomIconWidget(iconName: 'terminal', size: 16),
                  label: Text('Xcode Logs'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Offline testing capability maintains state across app launches',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBiometricStatusColor() {
    switch (_biometricStatus.toLowerCase()) {
      case 'ready':
        return AppTheme.successLight;
      case 'calibrating':
        return AppTheme.warningLight;
      case 'error':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  void _toggleHapticTest(bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(enabled
            ? 'Haptic feedback testing enabled'
            : 'Haptic feedback testing disabled'),
      ),
    );
  }

  void _testHapticPattern(String pattern) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Testing $pattern haptic pattern')),
    );
  }

  void _toggleAudioTest(bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(enabled
            ? 'Audio quality test started'
            : 'Audio quality test stopped'),
      ),
    );
  }

  void _testAudio(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Testing $type audio quality')),
    );
  }

  void _calibrateSensor(String sensorType) {
    setState(() {
      _biometricCalibrating = true;
      _biometricStatus = 'Calibrating';
    });

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _biometricCalibrating = false;
          _biometricStatus = 'Ready';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$sensorType sensor calibrated successfully')),
        );
      }
    });
  }

  void _startFullCalibration() {
    setState(() {
      _biometricCalibrating = true;
      _biometricStatus = 'Calibrating';
    });

    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _biometricCalibrating = false;
          _biometricStatus = 'Ready';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Full biometric calibration completed')),
        );
      }
    });
  }

  void _openBetaFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening TestFlight beta feedback')),
    );
  }

  void _streamXcodeLogs() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting Xcode console log stream')),
    );
  }
}
