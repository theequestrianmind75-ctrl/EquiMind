import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PerformanceMetricsWidget extends StatefulWidget {
  final Map<String, dynamic> performanceData;

  const PerformanceMetricsWidget({
    Key? key,
    required this.performanceData,
  }) : super(key: key);

  @override
  State<PerformanceMetricsWidget> createState() =>
      _PerformanceMetricsWidgetState();
}

class _PerformanceMetricsWidgetState extends State<PerformanceMetricsWidget> {
  String selectedMetric = 'heartRate';

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
                iconName: 'analytics',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24),
            SizedBox(width: 2.w),
            Text('Performance Metrics',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary)),
          ]),
          SizedBox(height: 3.h),
          _buildMetricSelector(),
          SizedBox(height: 3.h),
          Container(height: 25.h, child: _buildSelectedChart()),
          SizedBox(height: 3.h),
          _buildMetricSummary(),
        ]));
  }

  Widget _buildMetricSelector() {
    final metrics = [
      {'key': 'heartRate', 'label': 'Heart Rate', 'icon': 'favorite'},
      {'key': 'stress', 'label': 'Stress', 'icon': 'psychology'},
      {'key': 'confidence', 'label': 'Confidence', 'icon': 'trending_up'},
    ];

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: metrics.map((metric) {
          final isSelected = selectedMetric == metric['key'];
          return GestureDetector(
              onTap: () {
                setState(() {
                  selectedMetric = metric['key'] as String;
                });
              },
              child: Container(
                  margin: EdgeInsets.only(right: 3.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    CustomIconWidget(
                        iconName: metric['icon'] as String,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 18),
                    SizedBox(width: 2.w),
                    Text(metric['label'] as String,
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400)),
                  ])));
        }).toList()));
  }

  Widget _buildSelectedChart() {
    switch (selectedMetric) {
      case 'heartRate':
        return _buildHeartRateChart();
      case 'stress':
        return _buildStressChart();
      case 'confidence':
        return _buildConfidenceChart();
      default:
        return _buildHeartRateChart();
    }
  }

  Widget _buildHeartRateChart() {
    final heartRateData =
        widget.performanceData['heartRateZones'] as List<dynamic>? ?? [];

    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final zones = ['Rest', 'Fat Burn', 'Cardio', 'Peak'];
              return BarTooltipItem(
                  '${zones[group.x.toInt()]}\n${rod.toY.round()}%',
                  AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500));
            })),
        titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      const zones = ['Rest', 'Fat Burn', 'Cardio', 'Peak'];
                      if (value.toInt() < zones.length) {
                        return Text(zones[value.toInt()],
                            style: AppTheme.lightTheme.textTheme.bodySmall);
                      }
                      return Text('');
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text('${value.toInt()}%',
                          style: AppTheme.lightTheme.textTheme.bodySmall);
                    }))),
        borderData: FlBorderData(show: false),
        barGroups: heartRateData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value as Map<String, dynamic>;
          return BarChartGroupData(x: index, barRods: [
            BarChartRodData(
                toY: (data['percentage'] as double? ?? 0.0),
                color: _getHeartRateZoneColor(index),
                width: 8.w,
                borderRadius: BorderRadius.circular(4)),
          ]);
        }).toList()));
  }

  Widget _buildStressChart() {
    final stressData =
        widget.performanceData['stressLevels'] as List<dynamic>? ?? [];

    return LineChart(LineChartData(
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
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text('${(value * 10).toInt()}min',
                          style: AppTheme.lightTheme.textTheme.bodySmall);
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      const levels = ['Low', 'Med', 'High'];
                      if (value.toInt() < levels.length) {
                        return Text(levels[value.toInt()],
                            style: AppTheme.lightTheme.textTheme.bodySmall);
                      }
                      return Text('');
                    }))),
        borderData: FlBorderData(
            show: true,
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3))),
        minX: 0,
        maxX: (stressData.length - 1).toDouble(),
        minY: 0,
        maxY: 2,
        lineBarsData: [
          LineChartBarData(
              spots: stressData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value as Map<String, dynamic>;
                return FlSpot(
                    index.toDouble(), (data['level'] as double? ?? 0.0));
              }).toList(),
              isCurved: true,
              color: Colors.red.shade400,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                  show: true,
                  color: Colors.red.shade400.withValues(alpha: 0.1))),
        ]));
  }

  Widget _buildConfidenceChart() {
    final confidenceData =
        widget.performanceData['confidenceLevels'] as List<dynamic>? ?? [];

    return LineChart(LineChartData(
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  strokeWidth: 1);
            }),
        titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text('${(value * 10).toInt()}min',
                          style: AppTheme.lightTheme.textTheme.bodySmall);
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text('${value.toInt()}%',
                          style: AppTheme.lightTheme.textTheme.bodySmall);
                    }))),
        borderData: FlBorderData(
            show: true,
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3))),
        minX: 0,
        maxX: (confidenceData.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
              spots: confidenceData.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value as Map<String, dynamic>;
                return FlSpot(
                    index.toDouble(), (data['level'] as double? ?? 0.0));
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(colors: [
                AppTheme.lightTheme.colorScheme.tertiary,
                Colors.green.shade600,
              ]),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(colors: [
                    AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1),
                    Colors.green.shade600.withValues(alpha: 0.1),
                  ]))),
        ]));
  }

  Color _getHeartRateZoneColor(int index) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];
    return colors[index % colors.length];
  }

  Widget _buildMetricSummary() {
    final summaryData = _getSummaryForMetric(selectedMetric);

    return Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Average',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
                Text(summaryData['average'] ?? '0',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.primary)),
              ])),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Peak',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
                Text(summaryData['peak'] ?? '0',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.primary)),
              ])),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Improvement',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
                Text(summaryData['improvement'] ?? '0%',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade600)),
              ])),
        ]));
  }

  Map<String, String> _getSummaryForMetric(String metric) {
    switch (metric) {
      case 'heartRate':
        return {
          'average': '142 bpm',
          'peak': '168 bpm',
          'improvement': '+5%',
        };
      case 'stress':
        return {
          'average': 'Medium',
          'peak': 'High',
          'improvement': '-12%',
        };
      case 'confidence':
        return {
          'average': '78%',
          'peak': '92%',
          'improvement': '+15%',
        };
      default:
        return {
          'average': '0',
          'peak': '0',
          'improvement': '0%',
        };
    }
  }
}
