import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmotionTimelineWidget extends StatefulWidget {
  final List<Map<String, dynamic>> emotionData;

  const EmotionTimelineWidget({
    Key? key,
    required this.emotionData,
  }) : super(key: key);

  @override
  State<EmotionTimelineWidget> createState() => _EmotionTimelineWidgetState();
}

class _EmotionTimelineWidgetState extends State<EmotionTimelineWidget> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CustomIconWidget(
                iconName: 'mood',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24),
            SizedBox(width: 2.w),
            Text('Emotion Timeline',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary)),
          ]),
          SizedBox(height: 3.h),
          Container(
              height: 25.h,
              child: LineChart(LineChartData(
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            strokeWidth: 1);
                      }),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const phases = [
                                  'Pre',
                                  'Start',
                                  'Mid',
                                  'End',
                                  'Post'
                                ];
                                if (value.toInt() < phases.length) {
                                  return Text(phases[value.toInt()],
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall);
                                }
                                return Text('');
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const emotions = [
                                  'Anxious',
                                  'Nervous',
                                  'Calm',
                                  'Confident',
                                  'Excited'
                                ];
                                if (value.toInt() >= 0 &&
                                    value.toInt() < emotions.length) {
                                  return Text(emotions[value.toInt()],
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(fontSize: 10.sp));
                                }
                                return Text('');
                              }))),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3))),
                  minX: 0,
                  maxX: 4,
                  minY: 0,
                  maxY: 4,
                  lineBarsData: [
                    LineChartBarData(
                        spots: _generateEmotionSpots(),
                        isCurved: true,
                        gradient: LinearGradient(colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.tertiary,
                        ]),
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                  radius: 6,
                                  color: _getEmotionColor(spot.y),
                                  strokeWidth: 2,
                                  strokeColor:
                                      AppTheme.lightTheme.colorScheme.surface);
                            }),
                        belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(colors: [
                              AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.1),
                            ]))),
                  ],
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event,
                          LineTouchResponse? touchResponse) {
                        if (touchResponse != null &&
                            touchResponse.lineBarSpots != null) {
                          setState(() {
                            selectedIndex =
                                touchResponse.lineBarSpots!.first.spotIndex;
                          });
                        }
                      },
                      touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final emotions = [
                            'Anxious',
                            'Nervous',
                            'Calm',
                            'Confident',
                            'Excited'
                          ];
                          final phases = [
                            'Pre-ride',
                            'Start',
                            'Mid-ride',
                            'End',
                            'Post-ride'
                          ];
                          return LineTooltipItem(
                              '${phases[barSpot.x.toInt()]}\n${emotions[barSpot.y.toInt()]}',
                              AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w500));
                        }).toList();
                      }))))),
          SizedBox(height: 2.h),
          if (selectedIndex != null) _buildEmotionDetail(),
        ]));
  }

  List<FlSpot> _generateEmotionSpots() {
    return widget.emotionData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return FlSpot(index.toDouble(), (data['emotionLevel'] as double? ?? 2.0));
    }).toList();
  }

  Color _getEmotionColor(double emotionLevel) {
    if (emotionLevel >= 3.5) return Colors.green.shade600;
    if (emotionLevel >= 2.5) return AppTheme.lightTheme.colorScheme.tertiary;
    if (emotionLevel >= 1.5) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  Widget _buildEmotionDetail() {
    if (selectedIndex == null || selectedIndex! >= widget.emotionData.length) {
      return SizedBox.shrink();
    }

    final data = widget.emotionData[selectedIndex!];
    final phases = ['Pre-ride', 'Start', 'Mid-ride', 'End', 'Post-ride'];

    return Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(phases[selectedIndex!],
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary)),
          SizedBox(height: 1.h),
          Text(
              data['notes'] as String? ?? 'No additional notes for this phase.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
        ]));
  }
}
