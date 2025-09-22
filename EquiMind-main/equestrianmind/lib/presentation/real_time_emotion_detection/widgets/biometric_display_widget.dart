import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../../../services/emotion_detection_service.dart';

class BiometricDisplayWidget extends StatefulWidget {
  final BiometricData? biometrics;
  final EmotionReading? emotion;

  const BiometricDisplayWidget({
    super.key,
    this.biometrics,
    this.emotion,
  });

  @override
  State<BiometricDisplayWidget> createState() => _BiometricDisplayWidgetState();
}

class _BiometricDisplayWidgetState extends State<BiometricDisplayWidget>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _pulseController;
  late Animation<double> _heartAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _heartAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _heartController, curve: Curves.easeInOut));

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _startAnimations();
  }

  void _startAnimations() {
    _heartController.repeat(reverse: true);
    _pulseController.repeat();
  }

  @override
  void didUpdateWidget(BiometricDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.biometrics?.heartRate != widget.biometrics?.heartRate) {
      _updateHeartRateAnimation();
    }
  }

  void _updateHeartRateAnimation() {
    final heartRate = widget.biometrics?.heartRate ?? 75.0;
    final bpm = heartRate.clamp(40.0, 180.0);
    final duration = Duration(milliseconds: (60000 / bpm).round());

    _heartController.duration = duration;
  }

  Color _getHeartRateColor(double? heartRate) {
    if (heartRate == null) return Colors.grey;

    if (heartRate < 60) return Colors.blue;
    if (heartRate < 100) return Colors.green;
    if (heartRate < 150) return Colors.orange;
    return Colors.red;
  }

  Color _getStressColor(double stressLevel) {
    if (stressLevel < 0.3) return Colors.green;
    if (stressLevel < 0.6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final biometrics = widget.biometrics;
    final emotion = widget.emotion;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biometric Data',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildHeartRateCard(biometrics?.heartRate),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStressLevelCard(biometrics?.stressLevel ?? 0.5),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildArousalCard(biometrics?.arousalLevel ?? 0.0),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildMovementCard(biometrics?.movementIntensity ?? 0.0),
              ),
            ],
          ),
          if (emotion != null) ...[
            SizedBox(height: 2.h),
            _buildEmotionExplanation(emotion),
          ],
        ],
      ),
    );
  }

  Widget _buildHeartRateCard(double? heartRate) {
    final hr = heartRate ?? 0.0;
    final color = _getHeartRateColor(heartRate);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _heartAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _heartAnimation.value,
                child: Icon(
                  Icons.favorite,
                  color: color,
                  size: 20.sp,
                ),
              );
            },
          ),
          SizedBox(height: 1.h),
          Text(
            '${hr.round()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'BPM',
            style: TextStyle(
              color: Colors.white.withAlpha(179),
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStressLevelCard(double stressLevel) {
    final color = _getStressColor(stressLevel);
    final percentage = (stressLevel * 100).round();

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 12.w,
                height: 12.w,
                child: CircularProgressIndicator(
                  value: stressLevel,
                  backgroundColor: Colors.grey.withAlpha(77),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 4,
                ),
              ),
              Icon(
                Icons.psychology,
                color: color,
                size: 16.sp,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '$percentage%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Stress',
            style: TextStyle(
              color: Colors.white.withAlpha(179),
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArousalCard(double arousalLevel) {
    final color = Colors.purple;
    final percentage = (arousalLevel * 100).round();

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (arousalLevel * 0.3 * _pulseAnimation.value),
                child: Icon(
                  Icons.flash_on,
                  color: color,
                  size: 16.sp,
                ),
              );
            },
          ),
          SizedBox(height: 1.h),
          Text(
            '$percentage%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Arousal',
            style: TextStyle(
              color: Colors.white.withAlpha(179),
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementCard(double movementIntensity) {
    final color = Colors.teal;
    final intensity = math.min(movementIntensity / 10.0, 1.0);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.directions_run,
            color: color,
            size: 16.sp,
          ),
          SizedBox(height: 1.h),
          Container(
            width: 15.w,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(77),
              borderRadius: BorderRadius.circular(2),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 15.w * intensity,
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Movement',
            style: TextStyle(
              color: Colors.white.withAlpha(179),
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionExplanation(EmotionReading emotion) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            emotion.explanation,
            style: TextStyle(
              color: Colors.white.withAlpha(204),
              fontSize: 9.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Updated: ${_formatTimestamp(emotion.timestamp)}',
            style: TextStyle(
              color: Colors.white.withAlpha(153),
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else {
      return '${diff.inHours}h ago';
    }
  }

  @override
  void dispose() {
    _heartController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}
