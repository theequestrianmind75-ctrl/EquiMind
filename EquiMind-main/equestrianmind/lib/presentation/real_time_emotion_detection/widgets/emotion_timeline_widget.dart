import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../services/emotion_detection_service.dart';

class EmotionTimelineWidget extends StatelessWidget {
  final List<EmotionReading> emotions;
  final bool isCompact;

  const EmotionTimelineWidget({
    super.key,
    required this.emotions,
    this.isCompact = true,
  });

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

  double _getEmotionValue(EmotionState emotion) {
    switch (emotion) {
      case EmotionState.calm:
        return 1.0;
      case EmotionState.confident:
        return 2.0;
      case EmotionState.excited:
        return 3.0;
      case EmotionState.frustrated:
        return 4.0;
      case EmotionState.anxious:
        return 5.0;
      default:
        return 0.0;
    }
  }

  List<FlSpot> _getEmotionSpots() {
    if (emotions.isEmpty) return [];

    return emotions.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final emotion = entry.value;
      return FlSpot(index, _getEmotionValue(emotion.emotion));
    }).toList();
  }

  List<FlSpot> _getStressSpots() {
    if (emotions.isEmpty) return [];

    return emotions.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final emotion = entry.value;
      return FlSpot(index, emotion.stressPercentage / 20); // Scale to 0-5 range
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (emotions.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(26),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              'Emotion Timeline',
              style: TextStyle(
                color: Colors.white,
                fontSize: isCompact ? 10.sp : 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'No emotion data yet...',
              style: TextStyle(
                color: Colors.white.withAlpha(179),
                fontSize: isCompact ? 8.sp : 12.sp,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(isCompact ? 2.w : 4.w),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Emotion Timeline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isCompact ? 10.sp : 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${emotions.length} readings',
                style: TextStyle(
                  color: Colors.white.withAlpha(179),
                  fontSize: isCompact ? 8.sp : 10.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 1.h : 2.h),
          SizedBox(
            height: isCompact ? 12.h : 20.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withAlpha(26),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: !isCompact,
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 10.w,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 1:
                            return Text('Calm',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8.sp));
                          case 2:
                            return Text('Confident',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8.sp));
                          case 3:
                            return Text('Excited',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8.sp));
                          case 4:
                            return Text('Frustrated',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8.sp));
                          case 5:
                            return Text('Anxious',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 8.sp));
                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() % 2 == 0 &&
                            value.toInt() < emotions.length) {
                          final emotion = emotions[value.toInt()];
                          final minutes = DateTime.now()
                              .difference(emotion.timestamp)
                              .inMinutes;
                          return Text(
                            '${minutes}m',
                            style: TextStyle(
                                color: Colors.white.withAlpha(179),
                                fontSize: 8.sp),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: emotions.length.toDouble() - 1,
                minY: 0,
                maxY: 5,
                lineBarsData: [
                  // Emotion line
                  LineChartBarData(
                    spots: _getEmotionSpots(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        if (index >= emotions.length)
                          return FlDotCirclePainter(color: Colors.blue);
                        final emotion = emotions[index];
                        return FlDotCirclePainter(
                          radius: 4,
                          color: _getEmotionColor(emotion.emotion),
                          strokeColor: Colors.white,
                          strokeWidth: 2,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withAlpha(26),
                    ),
                  ),
                  // Stress level line
                  LineChartBarData(
                    spots: _getStressSpots(),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
          if (!isCompact) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                _buildLegendItem('Emotion', Colors.blue),
                SizedBox(width: 4.w),
                _buildLegendItem('Stress', Colors.red),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 2,
          color: color,
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(179),
            fontSize: 8.sp,
          ),
        ),
      ],
    );
  }
}
