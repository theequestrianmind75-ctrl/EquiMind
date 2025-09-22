import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../services/emotion_detection_service.dart';

class EmotionIndicatorWidget extends StatefulWidget {
  final EmotionReading? emotion;
  final bool isCompact;

  const EmotionIndicatorWidget({
    super.key,
    this.emotion,
    this.isCompact = true,
  });

  @override
  State<EmotionIndicatorWidget> createState() => _EmotionIndicatorWidgetState();
}

class _EmotionIndicatorWidgetState extends State<EmotionIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(EmotionIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.emotion?.emotion != widget.emotion?.emotion) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  Color _getEmotionColor(EmotionState? emotion) {
    switch (emotion) {
      case EmotionState.calm:
        return Colors.green;
      case EmotionState.anxious:
        return Colors.red;
      case EmotionState.excited:
        return Colors.orange;
      case EmotionState.frustrated:
        return Colors.purple;
      case EmotionState.confident:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getEmotionIcon(EmotionState? emotion) {
    switch (emotion) {
      case EmotionState.calm:
        return Icons.self_improvement;
      case EmotionState.anxious:
        return Icons.warning;
      case EmotionState.excited:
        return Icons.flash_on;
      case EmotionState.frustrated:
        return Icons.mood_bad;
      case EmotionState.confident:
        return Icons.trending_up;
      default:
        return Icons.psychology;
    }
  }

  @override
  Widget build(BuildContext context) {
    final emotion = widget.emotion;
    final color = _getEmotionColor(emotion?.emotion);
    final confidence = emotion?.confidence ?? 0.0;

    return Container(
      padding: EdgeInsets.all(widget.isCompact ? 2.w : 4.w),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          // Main emotion indicator
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Progress ring
                  SizedBox(
                    width: widget.isCompact ? 15.w : 25.w,
                    height: widget.isCompact ? 15.w : 25.w,
                    child: CircularProgressIndicator(
                      value: confidence * _progressAnimation.value,
                      strokeWidth: widget.isCompact ? 3 : 6,
                      backgroundColor: Colors.grey.withAlpha(77),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  // Emotion icon
                  Container(
                    width: widget.isCompact ? 10.w : 15.w,
                    height: widget.isCompact ? 10.w : 15.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withAlpha(51),
                    ),
                    child: Icon(
                      _getEmotionIcon(emotion?.emotion),
                      color: color,
                      size: widget.isCompact ? 16.sp : 24.sp,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: widget.isCompact ? 1.h : 2.h),
          // Emotion name
          Text(
            emotion?.emotion.name.toUpperCase() ?? 'DETECTING',
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.isCompact ? 10.sp : 16.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          if (!widget.isCompact) ...[
            SizedBox(height: 1.h),
            // Confidence level
            Text(
              'Confidence: ${((confidence * 100).round())}%',
              style: TextStyle(
                color: Colors.white.withAlpha(204),
                fontSize: 10.sp,
              ),
            ),
            SizedBox(height: 1.h),
            // Stress and confidence indices
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricIndicator(
                  'Stress',
                  emotion?.stressPercentage ?? 0.0,
                  Colors.red,
                ),
                _buildMetricIndicator(
                  'Confidence',
                  (emotion?.confidenceIndex ?? 0.0) * 100,
                  Colors.green,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricIndicator(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(179),
            fontSize: 8.sp,
          ),
        ),
        SizedBox(height: 0.5.h),
        Stack(
          children: [
            Container(
              width: 15.w,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(77),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              width: (15.w * (value / 100)).clamp(0.0, 15.w),
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          '${value.round()}%',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
