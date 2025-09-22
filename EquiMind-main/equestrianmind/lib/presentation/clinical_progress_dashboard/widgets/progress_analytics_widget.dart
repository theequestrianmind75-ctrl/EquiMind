import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressAnalyticsWidget extends StatefulWidget {
  final Map<String, double> scores;
  final List<Map<String, dynamic>> assessments;

  const ProgressAnalyticsWidget({
    Key? key,
    required this.scores,
    required this.assessments,
  }) : super(key: key);

  @override
  State<ProgressAnalyticsWidget> createState() =>
      _ProgressAnalyticsWidgetState();
}

class _ProgressAnalyticsWidgetState extends State<ProgressAnalyticsWidget> {
  String _selectedView = 'trends';
  bool _showPredictiveAnalysis = true;

  final Map<String, String> _viewOptions = {
    'trends': 'Trends',
    'correlations': 'Correlations',
    'patterns': 'Patterns',
    'predictions': 'Predictions',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header with View Selector
          Row(children: [
            Icon(Icons.analytics,
                color: AppTheme.lightTheme.colorScheme.primary, size: 6.w),
            SizedBox(width: 3.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Progress Analytics',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.onSurface)),
                  Text('Statistical analysis & predictive insights',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme
                              .lightTheme.colorScheme.onSurfaceVariant)),
                ])),
          ]),

          SizedBox(height: 3.h),

          // View Selector
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8)),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: _viewOptions.entries.map((entry) {
                    final isSelected = _selectedView == entry.key;
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedView = entry.key;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.5.h),
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(entry.value,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                        color: isSelected
                                            ? AppTheme.lightTheme.colorScheme
                                                .onPrimary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal))));
                  }).toList()))),

          SizedBox(height: 3.h),

          // Content based on selected view
          _buildSelectedView(),

          SizedBox(height: 3.h),

          // Statistical Summary
          _buildStatisticalSummary(),
        ]));
  }

  Widget _buildSelectedView() {
    switch (_selectedView) {
      case 'trends':
        return _buildTrendsView();
      case 'correlations':
        return _buildCorrelationsView();
      case 'patterns':
        return _buildPatternsView();
      case 'predictions':
        return _buildPredictionsView();
      default:
        return _buildTrendsView();
    }
  }

  Widget _buildTrendsView() {
    return Container(
        height: 35.h,
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3))),
        child: Column(children: [
          Text('Progress Trends Analysis',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface)),
          SizedBox(height: 2.h),
          Expanded(
              child: LineChart(LineChartData(
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 10,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
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
                              interval: 2,
                              getTitlesWidget: (value, meta) {
                                const months = [
                                  'Jan',
                                  'Mar',
                                  'May',
                                  'Jul',
                                  'Sep',
                                  'Nov'
                                ];
                                final index = (value / 2).floor();
                                if (index >= 0 && index < months.length) {
                                  return Text(months[index],
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: AppTheme
                                                  .lightTheme
                                                  .colorScheme
                                                  .onSurfaceVariant));
                                }
                                return Text('');
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 20,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString(),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant));
                              }))),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3))),
                  minX: 0,
                  maxX: 10,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    // Anxiety trend line
                    LineChartBarData(
                        spots: [
                          FlSpot(0, 85),
                          FlSpot(2, 75),
                          FlSpot(4, 65),
                          FlSpot(6, 50),
                          FlSpot(8, 40),
                          FlSpot(10, 32),
                        ],
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                            show: true,
                            color: Colors.red.withValues(alpha: 0.1))),
                    // Confidence trend line
                    LineChartBarData(
                        spots: [
                          FlSpot(0, 45),
                          FlSpot(2, 52),
                          FlSpot(4, 58),
                          FlSpot(6, 68),
                          FlSpot(8, 75),
                          FlSpot(10, 78),
                        ],
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                            show: true,
                            color: Colors.green.withValues(alpha: 0.1))),
                    // Performance trend line
                    LineChartBarData(
                        spots: [
                          FlSpot(0, 60),
                          FlSpot(2, 62),
                          FlSpot(4, 70),
                          FlSpot(6, 76),
                          FlSpot(8, 80),
                          FlSpot(10, 82),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withValues(alpha: 0.1))),
                  ],
                  lineTouchData: LineTouchData(touchTooltipData:
                      LineTouchTooltipData(getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      String label;
                      switch (spot.barIndex) {
                        case 0:
                          label = 'Anxiety';
                          break;
                        case 1:
                          label = 'Confidence';
                          break;
                        case 2:
                          label = 'Performance';
                          break;
                        default:
                          label = 'Unknown';
                      }
                      return LineTooltipItem(
                          '$label: ${spot.y.toStringAsFixed(1)}',
                          TextStyle(
                              color: AppTheme
                                  .lightTheme.colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w600));
                    }).toList();
                  }))))),
        ]));
  }

  Widget _buildCorrelationsView() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3))),
        child: Column(children: [
          Text('Performance Correlations',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface)),
          SizedBox(height: 3.h),
          _buildCorrelationMatrix(),
        ]));
  }

  Widget _buildCorrelationMatrix() {
    final correlations = [
      {
        'metric1': 'Anxiety',
        'metric2': 'Performance',
        'correlation': -0.75,
        'strength': 'Strong Negative'
      },
      {
        'metric1': 'Confidence',
        'metric2': 'Performance',
        'correlation': 0.82,
        'strength': 'Strong Positive'
      },
      {
        'metric1': 'Anxiety',
        'metric2': 'Confidence',
        'correlation': -0.68,
        'strength': 'Moderate Negative'
      },
      {
        'metric1': 'Training Hours',
        'metric2': 'Confidence',
        'correlation': 0.71,
        'strength': 'Strong Positive'
      },
    ];

    return Column(
        children: correlations.map((correlation) {
      return _buildCorrelationItem(correlation);
    }).toList());
  }

  Widget _buildCorrelationItem(Map<String, dynamic> correlation) {
    final correlationValue = correlation['correlation'] as double;
    final isPositive = correlationValue > 0;
    final strength = correlationValue.abs();

    Color strengthColor;
    if (strength > 0.7) {
      strengthColor = isPositive ? Colors.green : Colors.red;
    } else if (strength > 0.4) {
      strengthColor = Colors.orange;
    } else {
      strengthColor = Colors.grey;
    }

    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: strengthColor.withValues(alpha: 0.3))),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('${correlation['metric1']} ↔ ${correlation['metric2']}',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface)),
                SizedBox(height: 0.5.h),
                Text(correlation['strength'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: strengthColor, fontWeight: FontWeight.w500)),
              ])),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
              decoration: BoxDecoration(
                  color: strengthColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16)),
              child: Text(correlationValue.toStringAsFixed(2),
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: strengthColor, fontWeight: FontWeight.w700))),
        ]));
  }

  Widget _buildPatternsView() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Behavioral Pattern Analysis',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface)),
          SizedBox(height: 3.h),
          _buildPatternInsight(
              'Peak Performance Windows',
              'Your best performances occur between 10-11 AM and 3-4 PM, correlating with natural cortisol rhythms.',
              Icons.schedule,
              Colors.green),
          _buildPatternInsight(
              'Anxiety Triggers',
              'Competition anxiety spikes 48-72 hours before events, suggesting benefit from earlier intervention timing.',
              Icons.warning,
              Colors.orange),
          _buildPatternInsight(
              'Recovery Patterns',
              'Optimal recovery occurs with 2-day intervals between intensive training sessions.',
              Icons.refresh,
              Colors.blue),
          _buildPatternInsight(
              'Seasonal Trends',
              'Performance metrics show 15% improvement during spring months, potentially linked to increased daylight.',
              Icons.wb_sunny,
              Colors.purple),
        ]));
  }

  Widget _buildPatternInsight(
      String title, String description, IconData icon, Color color) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.2))),
        child: Row(children: [
          Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 5.w)),
          SizedBox(width: 3.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface)),
                SizedBox(height: 0.5.h),
                Text(description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
              ])),
        ]));
  }

  Widget _buildPredictionsView() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Predictive Analytics',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface)),
            Spacer(),
            Icon(Icons.auto_graph,
                color: AppTheme.lightTheme.colorScheme.primary, size: 5.w),
          ]),
          SizedBox(height: 3.h),
          _buildPredictionCard(
              '30-Day Forecast',
              'Based on current trends, anxiety levels are predicted to decrease by 20% with continued intervention.',
              0.85,
              Colors.green),
          _buildPredictionCard(
              'Performance Projection',
              'Riding confidence expected to reach 85% within 6 weeks at current improvement rate.',
              0.78,
              Colors.blue),
          _buildPredictionCard(
              'Risk Assessment',
              'Low probability (12%) of treatment plateau based on historical response patterns.',
              0.88,
              Colors.orange),
        ]));
  }

  Widget _buildPredictionCard(
      String title, String description, double confidence, Color color) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface)),
            Spacer(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.w),
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Text('${(confidence * 100).toInt()}% confidence',
                    style: AppTheme.lightTheme.textTheme.bodySmall
                        ?.copyWith(color: color, fontWeight: FontWeight.w600))),
          ]),
          SizedBox(height: 1.h),
          Text(description,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
              value: confidence,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 0.5.h),
        ]));
  }

  Widget _buildStatisticalSummary() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Statistical Summary',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary)),
          SizedBox(height: 2.h),
          Row(children: [
            Expanded(child: _buildStatItem('Mean Improvement', '+18.5%')),
            Expanded(child: _buildStatItem('Effect Size', '1.24 (Large)')),
          ]),
          SizedBox(height: 1.h),
          Row(children: [
            Expanded(child: _buildStatItem('Trend Significance', 'p < 0.001')),
            Expanded(child: _buildStatItem('R² Value', '0.78')),
          ]),
        ]));
  }

  Widget _buildStatItem(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.primary)),
      Text(label,
          style: AppTheme.lightTheme.textTheme.bodySmall
              ?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface)),
    ]);
  }
}
