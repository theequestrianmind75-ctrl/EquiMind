import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../services/emotion_detection_service.dart';

class EmotionInsightsWidget extends StatelessWidget {
  final EmotionReading? currentEmotion;
  final List<EmotionReading> emotionHistory;

  const EmotionInsightsWidget({
    super.key,
    this.currentEmotion,
    required this.emotionHistory,
  });

  Map<EmotionState, int> _getEmotionCounts() {
    final counts = <EmotionState, int>{};
    for (final emotion in emotionHistory) {
      counts[emotion.emotion] = (counts[emotion.emotion] ?? 0) + 1;
    }
    return counts;
  }

  EmotionState _getDominantEmotion() {
    final counts = _getEmotionCounts();
    if (counts.isEmpty) return EmotionState.calm;

    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  double _getAverageStress() {
    if (emotionHistory.isEmpty) return 0.0;

    final total =
        emotionHistory.map((e) => e.stressPercentage).reduce((a, b) => a + b);

    return total / emotionHistory.length;
  }

  Color _getEmotionColor(EmotionState emotion) {
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

  String _getInsightText() {
    if (emotionHistory.isEmpty) {
      return 'Start riding to see emotion insights and patterns.';
    }

    final dominant = _getDominantEmotion();
    final avgStress = _getAverageStress();
    final recentTrend = _getRecentTrend();

    String insight = 'Your dominant emotion today is ${dominant.name}. ';

    if (avgStress < 30) {
      insight +=
          'You\'re maintaining excellent emotional balance with low stress levels. ';
    } else if (avgStress < 60) {
      insight +=
          'Your stress levels are moderate - consider some breathing exercises. ';
    } else {
      insight +=
          'Elevated stress detected - try relaxation techniques before continuing. ';
    }

    insight += recentTrend;

    return insight;
  }

  String _getRecentTrend() {
    if (emotionHistory.length < 3) return '';

    final recent = emotionHistory.takeLast(3).toList();
    final stressLevels = recent.map((e) => e.stressPercentage).toList();

    if (stressLevels[2] > stressLevels[0] + 15) {
      return 'Your stress is trending upward - consider taking a break.';
    } else if (stressLevels[0] > stressLevels[2] + 15) {
      return 'Great improvement! Your stress levels are decreasing.';
    } else {
      return 'Your emotional state is remaining stable.';
    }
  }

  List<String> _getRecommendations() {
    final current = currentEmotion;
    if (current == null)
      return ['Continue monitoring your emotions during the ride.'];

    switch (current.emotion) {
      case EmotionState.anxious:
        return [
          'Practice deep breathing exercises',
          'Focus on your posture and seat',
          'Take a short break if needed',
          'Use positive self-talk'
        ];
      case EmotionState.frustrated:
        return [
          'Pause and reset your mindset',
          'Break down the task into smaller steps',
          'Remember your riding goals',
          'Consider ending on a positive note'
        ];
      case EmotionState.excited:
        return [
          'Channel excitement into focus',
          'Maintain steady breathing',
          'Stay present in the moment',
          'Use energy constructively'
        ];
      case EmotionState.confident:
        return [
          'Great mental state for learning!',
          'Try slightly more challenging exercises',
          'Maintain this positive momentum',
          'Share this confidence with your horse'
        ];
      case EmotionState.calm:
        return [
          'Perfect state for focused practice',
          'Ideal time for new techniques',
          'Maintain this balanced energy',
          'Excellent foundation for progress'
        ];
      default:
        return ['Continue monitoring your emotional state'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(230),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(51)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Emotion Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Current emotion and stats
          if (currentEmotion != null) ...[
            _buildCurrentEmotionCard(),
            SizedBox(height: 3.h),
          ],

          // Emotion distribution chart
          if (emotionHistory.isNotEmpty) ...[
            _buildEmotionDistribution(),
            SizedBox(height: 3.h),
          ],

          // AI insights
          _buildInsightsSection(),
          SizedBox(height: 3.h),

          // Recommendations
          _buildRecommendationsSection(),
        ],
      ),
    );
  }

  Widget _buildCurrentEmotionCard() {
    final emotion = currentEmotion!;
    final color = _getEmotionColor(emotion.emotion);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withAlpha(51),
            ),
            child: Icon(
              Icons.psychology,
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current: ${emotion.emotion.name.toUpperCase()}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(emotion.confidence * 100).round()}% confidence',
                  style: TextStyle(
                    color: Colors.white.withAlpha(179),
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  'Stress: ${emotion.stressPercentage.round()}%',
                  style: TextStyle(
                    color: Colors.white.withAlpha(179),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionDistribution() {
    final counts = _getEmotionCounts();
    final total = counts.values.fold(0, (a, b) => a + b);

    if (total == 0) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emotion Distribution',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 20.h,
          child: PieChart(
            PieChartData(
              sections: counts.entries.map((entry) {
                final emotion = entry.key;
                final count = entry.value;
                final percentage = (count / total * 100).round();

                return PieChartSectionData(
                  color: _getEmotionColor(emotion),
                  value: count.toDouble(),
                  title: '$percentage%',
                  radius: 60,
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 4.w,
          runSpacing: 1.h,
          children: counts.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getEmotionColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 1.w),
                Text(
                  entry.key.name,
                  style: TextStyle(
                    color: Colors.white.withAlpha(179),
                    fontSize: 9.sp,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Insights',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getInsightText(),
            style: TextStyle(
              color: Colors.white.withAlpha(230),
              fontSize: 10.sp,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection() {
    final recommendations = _getRecommendations();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        ...recommendations.map((rec) => Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: EdgeInsets.only(top: 0.5.h, right: 2.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      rec,
                      style: TextStyle(
                        color: Colors.white.withAlpha(204),
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

extension<T> on List<T> {
  List<T> takeLast(int count) {
    return skip(length > count ? length - count : 0).toList();
  }
}
