import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class OutcomeMeasuresWidget extends StatefulWidget {
  final Map<String, double> currentScores;
  final List<Map<String, dynamic>> historicalData;

  const OutcomeMeasuresWidget({
    Key? key,
    required this.currentScores,
    required this.historicalData,
  }) : super(key: key);

  @override
  State<OutcomeMeasuresWidget> createState() => _OutcomeMeasuresWidgetState();
}

class _OutcomeMeasuresWidgetState extends State<OutcomeMeasuresWidget> {
  String _selectedTimeframe = '3_months';
  String _selectedScale = 'all';

  final Map<String, String> _timeframeOptions = {
    '1_month': '1 Month',
    '3_months': '3 Months',
    '6_months': '6 Months',
    '1_year': '1 Year',
  };

  final Map<String, Map<String, dynamic>> _validatedScales = {
    'GAD-7': {
      'name': 'Generalized Anxiety Disorder 7-item',
      'description': 'Measures severity of generalized anxiety symptoms',
      'range': {'min': 0, 'max': 21},
      'thresholds': {'minimal': 4, 'mild': 9, 'moderate': 14, 'severe': 21},
      'color': Colors.red,
      'icon': Icons.sentiment_very_dissatisfied,
    },
    'PHQ-9': {
      'name': 'Patient Health Questionnaire-9',
      'description': 'Assesses severity of depression symptoms',
      'range': {'min': 0, 'max': 27},
      'thresholds': {
        'minimal': 4,
        'mild': 9,
        'moderate': 14,
        'moderately_severe': 19,
        'severe': 27
      },
      'color': Colors.blue,
      'icon': Icons.sentiment_dissatisfied,
    },
    'DASS-21': {
      'name': 'Depression Anxiety Stress Scales-21',
      'description': 'Comprehensive measure of emotional states',
      'range': {'min': 0, 'max': 42},
      'thresholds': {
        'normal': 9,
        'mild': 13,
        'moderate': 20,
        'severe': 27,
        'extremely_severe': 42
      },
      'color': Colors.purple,
      'icon': Icons.psychology,
    },
    'SCAS': {
      'name': 'Sport Competition Anxiety Scale',
      'description': 'Sport-specific anxiety measurement',
      'range': {'min': 10, 'max': 40},
      'thresholds': {'low': 15, 'moderate': 25, 'high': 35, 'very_high': 40},
      'color': Colors.orange,
      'icon': Icons.sports,
    },
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
          // Header with Controls
          Row(children: [
            Icon(Icons.assessment,
                color: AppTheme.lightTheme.colorScheme.primary, size: 6.w),
            SizedBox(width: 3.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Validated Outcome Measures',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.onSurface)),
                  Text('Evidence-based psychological assessments',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme
                              .lightTheme.colorScheme.onSurfaceVariant)),
                ])),
          ]),

          SizedBox(height: 3.h),

          // Time Frame and Scale Filters
          Row(children: [
            Expanded(
                child: DropdownButtonFormField<String>(
                    value: _selectedTimeframe,
                    decoration: InputDecoration(
                        labelText: 'Timeframe',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h)),
                    items: _timeframeOptions.entries.map((entry) {
                      return DropdownMenuItem(
                          value: entry.key, child: Text(entry.value));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTimeframe = value!;
                      });
                    })),
            SizedBox(width: 3.w),
            Expanded(
                child: DropdownButtonFormField<String>(
                    value: _selectedScale,
                    decoration: InputDecoration(
                        labelText: 'Scale',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h)),
                    items: [
                      DropdownMenuItem(value: 'all', child: Text('All Scales')),
                      ..._validatedScales.entries.map((entry) {
                        return DropdownMenuItem(
                            value: entry.key, child: Text(entry.key));
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedScale = value!;
                      });
                    })),
          ]),

          SizedBox(height: 3.h),

          // Progress Chart
          Container(
              height: 40.h,
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3))),
              child: _buildProgressChart()),

          SizedBox(height: 3.h),

          // Current Assessments Summary
          _buildCurrentAssessmentsSummary(),

          SizedBox(height: 3.h),

          // Clinical Significance Analysis
          _buildClinicalSignificanceAnalysis(),

          SizedBox(height: 3.h),

          // Reliability and Validity Information
          _buildReliabilityInfo(),
        ]));
  }

  Widget _buildProgressChart() {
    return Column(children: [
      Text('Progress Trends Over Time',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface)),
      SizedBox(height: 2.h),
      Expanded(
          child: LineChart(LineChartData(
              gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 5,
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
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            const dates = [
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun'
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < dates.length) {
                              return Text(dates[value.toInt()],
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant));
                            }
                            return Text('');
                          })),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          reservedSize: 42,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString(),
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant));
                          }))),
              borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3))),
              minX: 0,
              maxX: 5,
              minY: 0,
              maxY: 25,
              lineBarsData: _buildChartLines(),
              lineTouchData: LineTouchData(touchTooltipData:
                  LineTouchTooltipData(getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                      '${_getScaleNameFromIndex(spot.barIndex)}\n${spot.y.toStringAsFixed(1)}',
                      TextStyle(
                          color:
                              AppTheme.lightTheme.colorScheme.onInverseSurface,
                          fontWeight: FontWeight.w600));
                }).toList();
              }))))),
    ]);
  }

  List<LineChartBarData> _buildChartLines() {
    List<LineChartBarData> lines = [];

    if (_selectedScale == 'all') {
      int index = 0;
      for (var scale in _validatedScales.entries) {
        lines.add(LineChartBarData(
            spots: _generateSampleData(scale.key),
            isCurved: true,
            color: scale.value['color'],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                        radius: 4,
                        color: scale.value['color'],
                        strokeWidth: 2,
                        strokeColor: Colors.white)),
            belowBarData: BarAreaData(
                show: true,
                color:
                    (scale.value['color'] as Color).withValues(alpha: 0.1))));
        index++;
      }
    } else {
      final scale = _validatedScales[_selectedScale];
      if (scale != null) {
        lines.add(LineChartBarData(
            spots: _generateSampleData(_selectedScale),
            isCurved: true,
            color: scale['color'],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                        radius: 5,
                        color: scale['color'],
                        strokeWidth: 2,
                        strokeColor: Colors.white)),
            belowBarData: BarAreaData(
                show: true,
                color: (scale['color'] as Color).withValues(alpha: 0.2))));
      }
    }

    return lines;
  }

  List<FlSpot> _generateSampleData(String scale) {
    // Generate sample progression data based on scale type
    switch (scale) {
      case 'GAD-7':
        return [
          FlSpot(0, 15),
          FlSpot(1, 12),
          FlSpot(2, 10),
          FlSpot(3, 8),
          FlSpot(4, 6),
          FlSpot(5, 5)
        ];
      case 'PHQ-9':
        return [
          FlSpot(0, 14),
          FlSpot(1, 11),
          FlSpot(2, 9),
          FlSpot(3, 7),
          FlSpot(4, 6),
          FlSpot(5, 4)
        ];
      case 'DASS-21':
        return [
          FlSpot(0, 18),
          FlSpot(1, 15),
          FlSpot(2, 12),
          FlSpot(3, 10),
          FlSpot(4, 8),
          FlSpot(5, 6)
        ];
      case 'SCAS':
        return [
          FlSpot(0, 28),
          FlSpot(1, 25),
          FlSpot(2, 22),
          FlSpot(3, 20),
          FlSpot(4, 18),
          FlSpot(5, 16)
        ];
      default:
        return [
          FlSpot(0, 10),
          FlSpot(1, 8),
          FlSpot(2, 6),
          FlSpot(3, 5),
          FlSpot(4, 4),
          FlSpot(5, 3)
        ];
    }
  }

  String _getScaleNameFromIndex(int index) {
    final keys = _validatedScales.keys.toList();
    return index < keys.length ? keys[index] : 'Unknown';
  }

  Widget _buildCurrentAssessmentsSummary() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Recent Assessment Scores',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface)),
      SizedBox(height: 2.h),
      if (widget.historicalData.isEmpty)
        _buildEmptyAssessmentsState()
      else
        Column(
            children: widget.historicalData.take(3).map((assessment) {
          return _buildAssessmentCard(assessment);
        }).toList()),
    ]);
  }

  Widget _buildEmptyAssessmentsState() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3))),
        child: Column(children: [
          Icon(Icons.assessment_outlined,
              size: 8.w,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
          SizedBox(height: 2.h),
          Text('No Recent Assessments',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface)),
          SizedBox(height: 1.h),
          Text(
              'Complete validated assessments to track your progress over time.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center),
        ]));
  }

  Widget _buildAssessmentCard(Map<String, dynamic> assessment) {
    final scale = _validatedScales[assessment['type']];
    final changeDirection =
        (assessment['change'] ?? 0) < 0 ? 'improvement' : 'increase';
    final changeIcon = (assessment['change'] ?? 0) < 0
        ? Icons.trending_down
        : Icons.trending_up;
    final changeColor =
        (assessment['change'] ?? 0) < 0 ? Colors.green : Colors.red;

    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: (scale?['color'] as Color?)?.withValues(alpha: 0.3) ??
                    Colors.grey.withValues(alpha: 0.3))),
        child: Row(children: [
          Icon(scale?['icon'] ?? Icons.assessment,
              color: scale?['color'] ?? Colors.grey, size: 5.w),
          SizedBox(width: 3.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(assessment['type'] ?? 'Unknown',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface)),
                Text(
                    'Severity: ${assessment['severity']} (${assessment['score']})',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
              ])),
          Column(children: [
            Icon(changeIcon, color: changeColor, size: 4.w),
            Text('${(assessment['change'] ?? 0).abs()}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: changeColor, fontWeight: FontWeight.w600)),
          ]),
        ]));
  }

  Widget _buildClinicalSignificanceAnalysis() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.green.withValues(alpha: 0.1),
              Colors.blue.withValues(alpha: 0.1),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.trending_down, color: Colors.green, size: 5.w),
            SizedBox(width: 3.w),
            Text('Clinical Significance Analysis',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface)),
          ]),
          SizedBox(height: 2.h),
          Text(
              'Your scores show clinically significant improvement over the past 3 months:',
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.lightTheme.colorScheme.onSurface)),
          SizedBox(height: 1.h),
          _buildSignificanceItem(
              'GAD-7: Decreased by 7 points (clinically significant)',
              Colors.green),
          _buildSignificanceItem(
              'PHQ-9: Decreased by 6 points (clinically significant)',
              Colors.green),
          _buildSignificanceItem(
              'Confidence: Increased by 25 points (substantial improvement)',
              Colors.green),
        ]));
  }

  Widget _buildSignificanceItem(String text, Color color) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5.h),
        child: Row(children: [
          Icon(Icons.check_circle, color: color, size: 4.w),
          SizedBox(width: 2.w),
          Expanded(
              child: Text(text,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface))),
        ]));
  }

  Widget _buildReliabilityInfo() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Scale Reliability & Validity',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface)),
          SizedBox(height: 1.h),
          Text(
              'All scales used are internationally validated with high reliability coefficients (α > 0.85). Clinical cut-off scores are based on normative data and diagnostic guidelines. Changes of ≥5 points on anxiety/depression scales indicate clinically meaningful improvement.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
        ]));
  }
}
