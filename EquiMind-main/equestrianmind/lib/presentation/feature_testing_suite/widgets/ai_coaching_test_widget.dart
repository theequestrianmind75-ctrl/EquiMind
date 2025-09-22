import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiCoachingTestWidget extends StatefulWidget {
  final bool isActive;
  final bool testingInProgress;
  final int currentStep;
  final int totalSteps;

  const AiCoachingTestWidget({
    Key? key,
    required this.isActive,
    required this.testingInProgress,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  State<AiCoachingTestWidget> createState() => _AiCoachingTestWidgetState();
}

class _AiCoachingTestWidgetState extends State<AiCoachingTestWidget> {
  String _currentEmotionalState = 'Confident';
  double _responseTime = 0.0;
  bool _audioPlaybackEnabled = true;

  final List<Map<String, dynamic>> testSteps = [
    {
      'id': 1,
      'title': 'Initialize AI Coaching System',
      'description': 'Verify AI coaching service connection and authentication',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 2,
      'title': 'Emotional State Detection',
      'description': 'Test recognition of different emotional states',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 3,
      'title': 'Confidence Level Assessment',
      'description': 'Validate confidence scoring algorithms',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 4,
      'title': 'Anxiety Response Generation',
      'description': 'Test appropriate coaching responses for anxiety',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 5,
      'title': 'Audio Coaching Playback',
      'description': 'Verify audio response generation and playback quality',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 6,
      'title': 'Response Time Measurement',
      'description': 'Measure AI response generation latency',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 7,
      'title': 'Context Awareness Test',
      'description': 'Verify coaching adapts to riding context',
      'completed': false,
      'inProgress': false,
    },
    {
      'id': 8,
      'title': 'Coaching History Integration',
      'description': 'Test personalization based on past sessions',
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
  void didUpdateWidget(AiCoachingTestWidget oldWidget) {
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

      // Simulate response time measurement
      if (widget.currentStep >= 6) {
        _responseTime = 1.2 + (0.3 * (widget.currentStep - 6));
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
          _buildEmotionalStateSimulator(),
          SizedBox(height: 3.h),
          _buildTestStepsList(),
          SizedBox(height: 3.h),
          _buildResponseMetrics(),
          SizedBox(height: 3.h),
          _buildAudioPlaybackControls(),
        ],
      ),
    );
  }

  Widget _buildTestDescription() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'AI Coaching Test Suite',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'This test simulates various emotional states and validates appropriate coaching responses with audio playback controls and response time measurements.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionalStateSimulator() {
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
            'Emotional State Simulator',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Text(
                'Current State:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getEmotionalStateColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _currentEmotionalState,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: _getEmotionalStateColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              'Confident',
              'Anxious',
              'Nervous',
              'Excited',
              'Frustrated',
              'Calm',
            ].map((state) => _buildStateButton(state)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStateButton(String state) {
    final isSelected = _currentEmotionalState == state;
    return InkWell(
      onTap: () => setState(() => _currentEmotionalState = state),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          state,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? Colors.blue
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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
                    ? Colors.blue
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

  Widget _buildResponseMetrics() {
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
            'Response Metrics',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Response Time',
                  '${_responseTime.toStringAsFixed(1)}s',
                  'schedule',
                  _getResponseTimeColor(_responseTime),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildMetricItem(
                  'Accuracy Rate',
                  '${widget.currentStep > 0 ? (87 + widget.currentStep * 2).clamp(87, 95) : 0}%',
                  'check_circle',
                  AppTheme.successLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlaybackControls() {
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
                'Audio Coaching Playback',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Switch(
                value: _audioPlaybackEnabled,
                onChanged: (value) =>
                    setState(() => _audioPlaybackEnabled = value),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _audioPlaybackEnabled
                      ? () => _playAudioSample('coaching')
                      : null,
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text('Play Coaching Sample'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _audioPlaybackEnabled
                      ? () => _playAudioSample('response')
                      : null,
                  icon: CustomIconWidget(iconName: 'headset_mic', size: 16),
                  label: Text('Test Response'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
      String label, String value, String iconName, Color color) {
    return Column(
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
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getEmotionalStateColor() {
    switch (_currentEmotionalState.toLowerCase()) {
      case 'confident':
        return AppTheme.successLight;
      case 'anxious':
      case 'nervous':
        return AppTheme.errorLight;
      case 'excited':
        return Colors.orange;
      case 'frustrated':
        return AppTheme.warningLight;
      case 'calm':
        return Colors.blue;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getResponseTimeColor(double time) {
    if (time < 1.5) return AppTheme.successLight;
    if (time < 3.0) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  void _playAudioSample(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Playing $type audio sample for $_currentEmotionalState state')),
    );
  }
}