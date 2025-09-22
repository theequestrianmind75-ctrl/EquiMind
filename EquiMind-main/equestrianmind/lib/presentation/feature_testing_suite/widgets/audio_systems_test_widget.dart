import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AudioSystemsTestWidget extends StatefulWidget {
  final bool isActive;
  final bool testingInProgress;
  final int currentStep;
  final int totalSteps;

  const AudioSystemsTestWidget({
    Key? key,
    required this.isActive,
    required this.testingInProgress,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  State<AudioSystemsTestWidget> createState() => _AudioSystemsTestWidgetState();
}

class _AudioSystemsTestWidgetState extends State<AudioSystemsTestWidget> {
  bool _voiceCommandEnabled = true;
  bool _coachingAudioEnabled = true;
  bool _backgroundAudioHandling = false;
  double _audioQualityScore = 0.0;
  String _recognitionStatus = 'Ready';
  String _lastCommand = 'None';

  final List<Map<String, dynamic>> testSteps = [
    {
      'id': 1,
      'title': 'Audio System Initialization',
      'description': 'Initialize audio recording and playback components',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 2,
      'title': 'Voice Command Recognition',
      'description': 'Test recognition accuracy for coaching commands',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 3,
      'title': 'Coaching Audio Quality',
      'description': 'Assess audio playback quality and clarity',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 4,
      'title': 'Background Audio Handling',
      'description': 'Test behavior during calls and notifications',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 5,
      'title': 'Audio Latency Testing',
      'description': 'Measure response time between command and feedback',
      'completed': false,
      'inProgress': false,
    },
  ];

  final List<String> voiceCommands = [
    'Start session',
    'Emergency help',
    'Pause coaching',
    'Resume coaching',
    'End session',
    'Breathing exercise',
  ];

  @override
  void initState() {
    super.initState();
    _updateTestSteps();
  }

  @override
  void didUpdateWidget(AudioSystemsTestWidget oldWidget) {
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

      // Simulate audio quality scoring
      if (widget.currentStep >= 3) {
        _audioQualityScore = 85 + (widget.currentStep * 2.0);
      }

      // Enable background handling test
      if (widget.currentStep >= 4) {
        _backgroundAudioHandling = true;
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
          _buildAudioSystemStatus(),
          SizedBox(height: 3.h),
          _buildVoiceCommandTester(),
          SizedBox(height: 3.h),
          _buildTestStepsList(),
          SizedBox(height: 3.h),
          _buildAudioQualityAssessment(),
        ],
      ),
    );
  }

  Widget _buildTestDescription() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'headset_mic',
                color: Colors.orange,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Audio Systems Test Suite',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'This test validates voice command recognition, coaching audio quality, and background audio handling during calls or notifications.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSystemStatus() {
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
            'Audio System Status',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatusItem(
                  'Voice Recognition',
                  _recognitionStatus,
                  'mic',
                  _voiceCommandEnabled,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatusItem(
                  'Audio Playback',
                  'Active',
                  'volume_up',
                  _coachingAudioEnabled,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                'Last Command:',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _lastCommand,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
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

  Widget _buildVoiceCommandTester() {
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
                'Voice Command Testing',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Switch(
                value: _voiceCommandEnabled,
                onChanged: (value) =>
                    setState(() => _voiceCommandEnabled = value),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: voiceCommands
                .map((command) => _buildCommandButton(command))
                .toList(),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _voiceCommandEnabled
                      ? () => _startVoiceRecognition()
                      : null,
                  icon: CustomIconWidget(
                    iconName:
                        _recognitionStatus == 'Listening' ? 'mic' : 'mic_none',
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text(_recognitionStatus == 'Listening'
                      ? 'Listening...'
                      : 'Start Voice Test'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _recognitionStatus == 'Listening'
                        ? AppTheme.errorLight
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommandButton(String command) {
    return InkWell(
      onTap: () => _testCommand(command),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: _lastCommand == command
              ? Colors.orange.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _lastCommand == command
                ? Colors.orange
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          '"$command"',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: _lastCommand == command
                ? Colors.orange
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight:
                _lastCommand == command ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
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
                    ? Colors.orange
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

  Widget _buildAudioQualityAssessment() {
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
            'Audio Quality Assessment',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildQualityMetric(
                  'Overall Score',
                  '${_audioQualityScore.toInt()}%',
                  'grade',
                  _getQualityColor(_audioQualityScore),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQualityMetric(
                  'Background Handling',
                  _backgroundAudioHandling ? 'Active' : 'Inactive',
                  'settings_voice',
                  _backgroundAudioHandling
                      ? AppTheme.successLight
                      : Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _testAudioPlayback(),
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text('Test Coaching Audio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _simulateBackgroundAudio(),
                  icon: CustomIconWidget(iconName: 'phone', size: 16),
                  label: Text('Simulate Call'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityMetric(
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

  Color _getQualityColor(double score) {
    if (score >= 90) return AppTheme.successLight;
    if (score >= 70) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  void _testCommand(String command) {
    setState(() {
      _lastCommand = command;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Testing voice command: "$command"')),
    );
  }

  void _startVoiceRecognition() {
    setState(() {
      _recognitionStatus =
          _recognitionStatus == 'Listening' ? 'Ready' : 'Listening';
    });

    if (_recognitionStatus == 'Listening') {
      // Simulate voice recognition timeout
      Future.delayed(Duration(seconds: 5), () {
        if (mounted && _recognitionStatus == 'Listening') {
          setState(() {
            _recognitionStatus = 'Ready';
          });
        }
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_recognitionStatus == 'Listening'
            ? 'Voice recognition started - speak a command'
            : 'Voice recognition stopped'),
      ),
    );
  }

  void _testAudioPlayback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Playing coaching audio sample for quality assessment')),
    );
  }

  void _simulateBackgroundAudio() {
    setState(() {
      _backgroundAudioHandling = !_backgroundAudioHandling;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_backgroundAudioHandling
            ? 'Simulating background call - testing audio behavior'
            : 'Call simulation ended'),
      ),
    );
  }
}
