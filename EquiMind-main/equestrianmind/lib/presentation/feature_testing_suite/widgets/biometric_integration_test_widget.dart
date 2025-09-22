import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricIntegrationTestWidget extends StatefulWidget {
  final bool isActive;
  final bool testingInProgress;
  final int currentStep;
  final int totalSteps;

  const BiometricIntegrationTestWidget({
    Key? key,
    required this.isActive,
    required this.testingInProgress,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  State<BiometricIntegrationTestWidget> createState() =>
      _BiometricIntegrationTestWidgetState();
}

class _BiometricIntegrationTestWidgetState
    extends State<BiometricIntegrationTestWidget> {
  bool _heartRateConnected = false;
  bool _stressDetectionEnabled = true;
  bool _emergencyTriggersActive = false;
  double _mockHeartRate = 72.0;
  double _mockStressLevel = 0.3;
  String _connectionStatus = 'Disconnected';

  final List<Map<String, dynamic>> testSteps = [
    {
      'id': 1,
      'title': 'Device Discovery',
      'description': 'Scan and discover available biometric sensors',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 2,
      'title': 'Heart Rate Connection',
      'description': 'Establish connection with heart rate monitor',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 3,
      'title': 'Data Stream Validation',
      'description': 'Verify continuous heart rate data reception',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 4,
      'title': 'Stress Detection Accuracy',
      'description': 'Test stress level calculation algorithms',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 5,
      'title': 'Emergency Threshold Testing',
      'description': 'Validate emergency trigger thresholds',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 6,
      'title': 'Mock Data Injection',
      'description': 'Test system behavior with simulated extreme values',
      'completed': false,
      'inProgress': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateTestSteps();
    _simulateBiometricData();
  }

  @override
  void didUpdateWidget(BiometricIntegrationTestWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep) {
      _updateTestSteps();
    }
  }

  void _updateTestSteps() {
    setState(() {
      for (int i = 0; i < testSteps.length; i++) {
        if (i < widget.currentStep) {
          testSteps[i]['completed'] = true;
          testSteps[i]['inProgress'] = false;
        } else if (i == widget.currentStep && widget.testingInProgress) {
          testSteps[i]['completed'] = false;
          testSteps[i]['inProgress'] = true;
        } else {
          testSteps[i]['completed'] = false;
          testSteps[i]['inProgress'] = false;
        }
      }

      // Update connection status based on progress
      if (widget.currentStep >= 2) {
        _heartRateConnected = true;
        _connectionStatus = 'Connected';
      }
      if (widget.currentStep >= 5) {
        _emergencyTriggersActive = true;
      }
    });
  }

  void _simulateBiometricData() {
    if (!mounted) return;

    Future.delayed(Duration(seconds: 2), () {
      if (mounted && _heartRateConnected) {
        setState(() {
          // Simulate realistic heart rate variation
          _mockHeartRate = 65 + (DateTime.now().millisecondsSinceEpoch % 30);
          _mockStressLevel =
              0.2 + (0.4 * (DateTime.now().millisecondsSinceEpoch % 100) / 100);
        });
        _simulateBiometricData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTestDescription(),
          SizedBox(height: 3.h),
          _buildConnectionStatus(),
          SizedBox(height: 3.h),
          _buildBiometricDataDisplay(),
          SizedBox(height: 3.h),
          _buildTestStepsList(),
          SizedBox(height: 3.h),
          _buildMockDataInjection(),
        ],
      ),
    );
  }

  Widget _buildTestDescription() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                color: Colors.red,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Biometric Integration Test Suite',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'This test validates heart rate connectivity, stress detection accuracy, and emergency threshold triggers with mock data injection capabilities.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
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
              Text(
                'Device Connection Status',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getConnectionStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getConnectionStatusColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _connectionStatus,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getConnectionStatusColor(),
                        fontWeight: FontWeight.w600,
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
                child: _buildConnectionItem(
                  'Heart Rate Monitor',
                  _heartRateConnected ? 'Connected' : 'Searching...',
                  'favorite',
                  _heartRateConnected,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildConnectionItem(
                  'Stress Detection',
                  _stressDetectionEnabled ? 'Enabled' : 'Disabled',
                  'psychology',
                  _stressDetectionEnabled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionItem(
      String label, String status, String iconName, bool isActive) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.successLight.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? AppTheme.successLight.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: isActive ? AppTheme.successLight : Colors.grey,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            status,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: isActive ? AppTheme.successLight : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricDataDisplay() {
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
          Text(
            'Live Biometric Data',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildDataMetric(
                  'Heart Rate',
                  '${_mockHeartRate.toInt()} BPM',
                  'favorite',
                  Colors.red,
                  _getHeartRateStatus(_mockHeartRate),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildDataMetric(
                  'Stress Level',
                  '${(_mockStressLevel * 100).toInt()}%',
                  'psychology',
                  Colors.orange,
                  _getStressLevelStatus(_mockStressLevel),
                ),
              ),
            ],
          ),
          if (_emergencyTriggersActive) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: _mockStressLevel > 0.7
                    ? AppTheme.errorLight.withValues(alpha: 0.1)
                    : AppTheme.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _mockStressLevel > 0.7
                      ? AppTheme.errorLight
                      : AppTheme.successLight,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName:
                        _mockStressLevel > 0.7 ? 'warning' : 'check_circle',
                    color: _mockStressLevel > 0.7
                        ? AppTheme.errorLight
                        : AppTheme.successLight,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _mockStressLevel > 0.7
                        ? 'Emergency threshold triggered'
                        : 'Emergency thresholds within normal range',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _mockStressLevel > 0.7
                          ? AppTheme.errorLight
                          : AppTheme.successLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataMetric(
      String label, String value, String iconName, Color color, String status) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            status,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestStepsList() {
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
          Text(
            'Test Steps Progress',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: testSteps.length,
            itemBuilder: (context, index) {
              final step = testSteps[index];
              return Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: _buildTestStepItem(step),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTestStepItem(Map<String, dynamic> step) {
    final completed = step['completed'] as bool;
    final inProgress = step['inProgress'] as bool;

    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: completed
                ? AppTheme.successLight
                : inProgress
                    ? Colors.red
                    : Colors.grey.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: inProgress
                ? SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    completed ? Icons.check : Icons.radio_button_unchecked,
                    color: Colors.white,
                    size: 16,
                  ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step['title'],
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: completed || inProgress
                      ? AppTheme.lightTheme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                step['description'],
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMockDataInjection() {
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
          Text(
            'Mock Data Injection',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _injectMockData('high_stress'),
                  icon: CustomIconWidget(
                    iconName: 'warning',
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text('High Stress'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorLight,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _injectMockData('normal'),
                  icon: CustomIconWidget(iconName: 'check_circle', size: 16),
                  label: Text('Normal Range'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _injectMockData('high_hr'),
                  icon: CustomIconWidget(iconName: 'favorite', size: 16),
                  label: Text('High HR'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _injectMockData('disconnected'),
                  icon: CustomIconWidget(
                      iconName: 'bluetooth_disabled', size: 16),
                  label: Text('Disconnect'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getConnectionStatusColor() {
    switch (_connectionStatus) {
      case 'Connected':
        return AppTheme.successLight;
      case 'Connecting':
        return AppTheme.warningLight;
      case 'Disconnected':
      default:
        return AppTheme.errorLight;
    }
  }

  String _getHeartRateStatus(double heartRate) {
    if (heartRate < 60) return 'Low';
    if (heartRate > 100) return 'High';
    return 'Normal';
  }

  String _getStressLevelStatus(double stressLevel) {
    if (stressLevel < 0.3) return 'Low';
    if (stressLevel > 0.7) return 'High';
    return 'Moderate';
  }

  void _injectMockData(String type) {
    setState(() {
      switch (type) {
        case 'high_stress':
          _mockStressLevel = 0.85;
          _mockHeartRate = 120;
          break;
        case 'normal':
          _mockStressLevel = 0.3;
          _mockHeartRate = 75;
          break;
        case 'high_hr':
          _mockHeartRate = 140;
          _mockStressLevel = 0.6;
          break;
        case 'disconnected':
          _heartRateConnected = false;
          _connectionStatus = 'Disconnected';
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Injected $type mock data')),
    );
  }
}
