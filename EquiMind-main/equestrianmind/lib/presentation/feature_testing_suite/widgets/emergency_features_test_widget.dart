import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyFeaturesTestWidget extends StatefulWidget {
  final bool isActive;
  final bool testingInProgress;
  final int currentStep;
  final int totalSteps;

  const EmergencyFeaturesTestWidget({
    Key? key,
    required this.isActive,
    required this.testingInProgress,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  State<EmergencyFeaturesTestWidget> createState() =>
      _EmergencyFeaturesTestWidgetState();
}

class _EmergencyFeaturesTestWidgetState
    extends State<EmergencyFeaturesTestWidget> {
  bool _emergencyModeActive = false;
  bool _contactNotificationEnabled = true;
  bool _locationSharingEnabled = true;
  String _emergencyStatus = 'Ready';
  double _locationAccuracy = 0.0;
  List<String> _emergencyContacts = [
    'Emergency Contact 1',
    'Emergency Contact 2'
  ];

  final List<Map<String, dynamic>> testSteps = [
    {
      'id': 1,
      'title': 'Panic Button Functionality',
      'description': 'Test emergency activation with safe simulation',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 2,
      'title': 'Contact Notification System',
      'description': 'Verify emergency contact notification delivery',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 3,
      'title': 'Location Sharing Accuracy',
      'description': 'Test GPS accuracy and location transmission',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 4,
      'title': 'Emergency Response Flow',
      'description': 'Validate complete emergency response workflow',
      'completed': false,
      'inProgress': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateTestSteps();
  }

  @override
  void didUpdateWidget(EmergencyFeaturesTestWidget oldWidget) {
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

      // Simulate location accuracy improvement during testing
      if (widget.currentStep >= 3) {
        _locationAccuracy = 95.0 + (widget.currentStep * 1.0);
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
          _buildEmergencyStatus(),
          SizedBox(height: 3.h),
          _buildPanicButtonSimulation(),
          SizedBox(height: 3.h),
          _buildTestStepsList(),
          SizedBox(height: 3.h),
          _buildLocationAccuracyTest(),
        ],
      ),
    );
  }

  Widget _buildTestDescription() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'emergency',
                color: Colors.purple,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Emergency Features Test Suite',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'This test provides safe simulation of panic scenarios, contact notification verification, and location sharing accuracy checks.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.warningLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.warningLight.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.warningLight,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Testing mode only - No real emergency calls will be made',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.warningLight,
                      fontWeight: FontWeight.w500,
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

  Widget _buildEmergencyStatus() {
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
                'Emergency System Status',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getEmergencyStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getEmergencyStatusColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _emergencyStatus,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getEmergencyStatusColor(),
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
                child: _buildStatusItem(
                  'Contact Notifications',
                  _contactNotificationEnabled ? 'Enabled' : 'Disabled',
                  'contact_phone',
                  _contactNotificationEnabled,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatusItem(
                  'Location Sharing',
                  _locationSharingEnabled ? 'Active' : 'Inactive',
                  'location_on',
                  _locationSharingEnabled,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Emergency Contacts:',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          Column(
            children: _emergencyContacts
                .map((contact) => Container(
                      margin: EdgeInsets.only(bottom: 0.5.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'person',
                            color: Colors.purple,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            contact,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          Spacer(),
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.successLight,
                            size: 16,
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
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

  Widget _buildPanicButtonSimulation() {
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
            'Panic Button Simulation',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Center(
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: _emergencyModeActive
                    ? AppTheme.errorLight
                    : Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.errorLight,
                  width: _emergencyModeActive ? 4 : 2,
                ),
                boxShadow: _emergencyModeActive
                    ? [
                        BoxShadow(
                          color: AppTheme.errorLight.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: InkWell(
                onTap: _toggleEmergencyMode,
                borderRadius: BorderRadius.circular(100),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'emergency',
                        color: _emergencyModeActive
                            ? Colors.white
                            : AppTheme.errorLight,
                        size: 48,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _emergencyModeActive ? 'ACTIVE' : 'EMERGENCY',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: _emergencyModeActive
                              ? Colors.white
                              : AppTheme.errorLight,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _emergencyModeActive
                ? 'Emergency mode is active - Testing panic scenario simulation'
                : 'Tap the emergency button to test panic scenario simulation',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: _emergencyModeActive
                  ? AppTheme.errorLight
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (_emergencyModeActive) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.errorLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.errorLight.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Simulated Emergency Actions:',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.errorLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildEmergencyAction('GPS location captured', true),
                  _buildEmergencyAction('Emergency contacts notified', true),
                  _buildEmergencyAction('Emergency services contacted', false),
                  _buildEmergencyAction('Coaching session paused', true),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmergencyAction(String action, bool completed) {
    return Container(
      margin: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: completed ? 'check_circle' : 'radio_button_unchecked',
            color: completed ? AppTheme.successLight : Colors.grey,
            size: 14,
          ),
          SizedBox(width: 2.w),
          Text(
            action,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: completed
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                    ? Colors.purple
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

  Widget _buildLocationAccuracyTest() {
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
            'Location Sharing Accuracy',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildLocationMetric(
                  'GPS Accuracy',
                  '${_locationAccuracy.toInt()}%',
                  'gps_fixed',
                  _getLocationAccuracyColor(_locationAccuracy),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildLocationMetric(
                  'Share Status',
                  _locationSharingEnabled ? 'Active' : 'Inactive',
                  'share_location',
                  _locationSharingEnabled ? AppTheme.successLight : Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _testLocationSharing(),
                  icon: CustomIconWidget(
                    iconName: 'location_on',
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text('Test Location Sharing'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _toggleLocationSharing(),
                  icon: CustomIconWidget(
                    iconName: _locationSharingEnabled
                        ? 'location_off'
                        : 'location_on',
                    size: 16,
                  ),
                  label: Text(_locationSharingEnabled ? 'Disable' : 'Enable'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMetric(
      String label, String value, String iconName, Color color) {
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
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getEmergencyStatusColor() {
    switch (_emergencyStatus.toLowerCase()) {
      case 'ready':
        return AppTheme.successLight;
      case 'testing':
        return AppTheme.warningLight;
      case 'active':
        return AppTheme.errorLight;
      default:
        return Colors.grey;
    }
  }

  Color _getLocationAccuracyColor(double accuracy) {
    if (accuracy >= 95) return AppTheme.successLight;
    if (accuracy >= 85) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  void _toggleEmergencyMode() {
    setState(() {
      _emergencyModeActive = !_emergencyModeActive;
      _emergencyStatus = _emergencyModeActive ? 'Testing' : 'Ready';
    });

    if (_emergencyModeActive) {
      // Simulate emergency timeout
      Future.delayed(Duration(seconds: 10), () {
        if (mounted && _emergencyModeActive) {
          setState(() {
            _emergencyModeActive = false;
            _emergencyStatus = 'Ready';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Emergency simulation completed')),
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Emergency simulation started - Testing panic scenario'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Emergency simulation cancelled')),
      );
    }
  }

  void _testLocationSharing() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Testing location sharing accuracy and transmission')),
    );
  }

  void _toggleLocationSharing() {
    setState(() {
      _locationSharingEnabled = !_locationSharingEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_locationSharingEnabled
            ? 'Location sharing enabled'
            : 'Location sharing disabled'),
      ),
    );
  }
}
