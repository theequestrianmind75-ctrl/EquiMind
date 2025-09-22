import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class ProgressTrackerWidget extends StatefulWidget {
  final List<Map<String, dynamic>> interventions;

  const ProgressTrackerWidget({
    super.key,
    required this.interventions,
  });

  @override
  State<ProgressTrackerWidget> createState() => _ProgressTrackerWidgetState();
}

class _ProgressTrackerWidgetState extends State<ProgressTrackerWidget> {
  String _selectedTimeframe = 'last_30_days';
  List<Map<String, dynamic>> _progressData = [];

  @override
  void initState() {
    super.initState();
    _generateProgressData();
  }

  void _generateProgressData() {
    // Sample progress data - would be loaded from actual intervention history
    setState(() {
      _progressData = [
        {
          'date': '2024-08-01',
          'interventionsCompleted': 3,
          'effectivenessRating': 4.2,
          'categories': {
            'CBT': 2,
            'MINDFULNESS': 1,
            'EXPOSURE': 0,
            'EQUINE_ASSISTED': 0,
          },
        },
        {
          'date': '2024-08-05',
          'interventionsCompleted': 2,
          'effectivenessRating': 4.5,
          'categories': {
            'CBT': 1,
            'MINDFULNESS': 1,
            'EXPOSURE': 0,
            'EQUINE_ASSISTED': 0,
          },
        },
        {
          'date': '2024-08-10',
          'interventionsCompleted': 4,
          'effectivenessRating': 4.1,
          'categories': {
            'CBT': 2,
            'MINDFULNESS': 1,
            'EXPOSURE': 1,
            'EQUINE_ASSISTED': 0,
          },
        },
        {
          'date': '2024-08-15',
          'interventionsCompleted': 3,
          'effectivenessRating': 4.7,
          'categories': {
            'CBT': 1,
            'MINDFULNESS': 2,
            'EXPOSURE': 0,
            'EQUINE_ASSISTED': 0,
          },
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 4.w),
          _buildTimeframeSelector(),
          SizedBox(height: 4.w),
          _buildProgressChart(),
          SizedBox(height: 4.w),
          _buildCategoryBreakdown(),
          SizedBox(height: 4.w),
          _buildInterventionHistory(),
          SizedBox(height: 4.w),
          _buildEffectivenessMetrics(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryLight.withValues(alpha: 0.1),
            AppTheme.successLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            color: AppTheme.primaryLight,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Intervention Progress Tracking',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  'Monitor therapeutic progress and intervention effectiveness',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    return Row(
      children: [
        Text(
          'Timeframe: ',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: DropdownButton<String>(
            value: _selectedTimeframe,
            isExpanded: true,
            onChanged: (value) {
              setState(() => _selectedTimeframe = value!);
              _generateProgressData();
            },
            items: const [
              DropdownMenuItem(
                value: 'last_7_days',
                child: Text('Last 7 Days'),
              ),
              DropdownMenuItem(
                value: 'last_30_days',
                child: Text('Last 30 Days'),
              ),
              DropdownMenuItem(
                value: 'last_3_months',
                child: Text('Last 3 Months'),
              ),
              DropdownMenuItem(
                value: 'all_time',
                child: Text('All Time'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressChart() {
    return Container(
      height: 35.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intervention Completion Trends',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 2.w),
          Text(
            'Shows number of interventions completed over time',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 4.w),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < _progressData.length) {
                          final date = DateTime.parse(
                              _progressData[value.toInt()]['date']);
                          return Text(
                            '${date.month}/${date.day}',
                            style: TextStyle(fontSize: 10.sp),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  // Interventions completed line
                  LineChartBarData(
                    spots: _progressData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          entry.value['interventionsCompleted'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.primaryLight,
                    barWidth: 4,
                    dotData: FlDotData(show: true),
                  ),
                  // Effectiveness rating line (scaled by 2 for visibility)
                  LineChartBarData(
                    spots: _progressData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          (entry.value['effectivenessRating'] * 2).toDouble());
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.successLight,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Completed', AppTheme.primaryLight, false),
              _buildLegendItem(
                  'Effectiveness (x2)', AppTheme.successLight, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDashed) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4.w,
          height: 0.5.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(0.5.w),
          ),
          child: isDashed
              ? CustomPaint(
                  painter: DashedLinePainter(color: color),
                )
              : null,
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown() {
    final categoryColors = {
      'CBT': Colors.blue,
      'MINDFULNESS': Colors.green,
      'EXPOSURE': Colors.orange,
      'EQUINE_ASSISTED': Colors.purple,
    };

    // Calculate totals for each category
    final categoryTotals = <String, int>{};
    for (var data in _progressData) {
      final categories = data['categories'] as Map<String, dynamic>;
      for (var entry in categories.entries) {
        categoryTotals[entry.key] =
            (categoryTotals[entry.key] ?? 0) + (entry.value as int);
      }
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Intervention Category Breakdown',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 3.w),
          ...categoryTotals.entries.map(
            (entry) => _buildCategoryItem(
              entry.key,
              entry.value,
              categoryColors[entry.key]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category, int count, Color color) {
    final total = _progressData
        .map((d) => (d['categories'] as Map<String, dynamic>)
            .values
            .fold<int>(0, (sum, value) => sum + (value as int)))
        .fold<int>(0, (sum, value) => sum + value);

    final percentage =
        total > 0 ? (count / total * 100).toStringAsFixed(1) : '0.0';

    return Container(
      margin: EdgeInsets.only(bottom: 2.w),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getCategoryDisplayName(category),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  '$count interventions ($percentage%)',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'CBT':
        return 'CBT Techniques';
      case 'MINDFULNESS':
        return 'Mindfulness Practices';
      case 'EXPOSURE':
        return 'Exposure Therapy';
      case 'EQUINE_ASSISTED':
        return 'Equine-Assisted';
      default:
        return category;
    }
  }

  Widget _buildInterventionHistory() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Intervention Sessions',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 3.w),
          ..._generateRecentSessions()
              .map((session) => _buildSessionItem(session)),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _generateRecentSessions() {
    return [
      {
        'title': 'Pre-Ride Anxiety Management',
        'category': 'CBT',
        'date': '2024-08-15',
        'duration': 15,
        'effectiveness': 4.5,
        'status': 'completed',
      },
      {
        'title': 'Horse-Human Connection Meditation',
        'category': 'MINDFULNESS',
        'date': '2024-08-14',
        'duration': 20,
        'effectiveness': 4.8,
        'status': 'completed',
      },
      {
        'title': 'Mounting Confidence Building',
        'category': 'EXPOSURE',
        'date': '2024-08-12',
        'duration': 25,
        'effectiveness': 4.2,
        'status': 'completed',
      },
    ];
  }

  Widget _buildSessionItem(Map<String, dynamic> session) {
    final categoryColors = {
      'CBT': Colors.blue,
      'MINDFULNESS': Colors.green,
      'EXPOSURE': Colors.orange,
      'EQUINE_ASSISTED': Colors.purple,
    };

    final color = categoryColors[session['category']] ?? AppTheme.primaryLight;

    return Container(
      margin: EdgeInsets.only(bottom: 2.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 1.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(0.5.w),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['title'],
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  _getCategoryDisplayName(session['category']),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${session['date']} • ${session['duration']} min',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: AppTheme.accentLight,
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    session['effectiveness'].toString(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentLight,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.w),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEffectivenessMetrics() {
    final avgEffectiveness = _progressData.isEmpty
        ? 0.0
        : _progressData
                .map((d) => d['effectivenessRating'] as double)
                .reduce((a, b) => a + b) /
            _progressData.length;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.successLight.withValues(alpha: 0.1),
            AppTheme.accentLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.successLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: AppTheme.successLight,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Effectiveness Metrics',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Average Rating',
                  avgEffectiveness.toStringAsFixed(1),
                  '/5.0',
                  AppTheme.successLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  'Sessions Completed',
                  _progressData
                      .map((d) => d['interventionsCompleted'] as int)
                      .fold<int>(0, (sum, count) => sum + count)
                      .toString(),
                  'total',
                  AppTheme.primaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Text(
            'Your intervention effectiveness rating shows consistent positive outcomes, indicating strong therapeutic progress and engagement.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textPrimaryLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, String suffix, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 1.w),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                suffix,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: color.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
