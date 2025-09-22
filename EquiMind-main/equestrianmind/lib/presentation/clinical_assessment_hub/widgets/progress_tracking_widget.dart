import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';

class ProgressTrackingWidget extends StatefulWidget {
  final VoidCallback onRefresh;

  const ProgressTrackingWidget({
    super.key,
    required this.onRefresh,
  });

  @override
  State<ProgressTrackingWidget> createState() => _ProgressTrackingWidgetState();
}

class _ProgressTrackingWidgetState extends State<ProgressTrackingWidget> {
  String _selectedTimeframe = '3_months';
  List<Map<String, dynamic>> _trendData = [];

  @override
  void initState() {
    super.initState();
    _loadTrendData();
  }

  void _loadTrendData() {
    // Sample trend data - would be replaced with actual assessment history
    setState(() {
      _trendData = [
        {
          'date': '2024-08-01',
          'GAD-7': 12,
          'PHQ-9': 8,
          'DASS-21': 15,
          'EQCS': 6,
          'HHRQ': 7,
        },
        {
          'date': '2024-08-15',
          'GAD-7': 10,
          'PHQ-9': 7,
          'DASS-21': 13,
          'EQCS': 7,
          'HHRQ': 8,
        },
        {
          'date': '2024-09-01',
          'GAD-7': 8,
          'PHQ-9': 5,
          'DASS-21': 11,
          'EQCS': 8,
          'HHRQ': 9,
        },
        {
          'date': '2024-09-15',
          'GAD-7': 6,
          'PHQ-9': 4,
          'DASS-21': 9,
          'EQCS': 9,
          'HHRQ': 10,
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
          _buildTimeframeSelector(),
          SizedBox(height: 4.w),
          _buildTrendChart(),
          SizedBox(height: 4.w),
          _buildClinicalSignificanceIndicators(),
          SizedBox(height: 4.w),
          _buildProgressSummary(),
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
              _loadTrendData();
            },
            items: const [
              DropdownMenuItem(value: '1_month', child: Text('1 Month')),
              DropdownMenuItem(value: '3_months', child: Text('3 Months')),
              DropdownMenuItem(value: '6_months', child: Text('6 Months')),
              DropdownMenuItem(value: '1_year', child: Text('1 Year')),
            ],
          ),
        ),
        IconButton(
          onPressed: widget.onRefresh,
          icon: Icon(
            Icons.refresh,
            color: AppTheme.primaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendChart() {
    return Container(
      height: 40.h,
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
            'Assessment Score Trends',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 2.w),
          Text(
            'Clinical significance indicators show positive trend',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.successLight,
            ),
          ),
          SizedBox(height: 4.w),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawHorizontalLine: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < _trendData.length) {
                          final date =
                              DateTime.parse(_trendData[value.toInt()]['date']);
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
                  LineChartBarData(
                    spots: _trendData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          entry.value['GAD-7'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                  LineChartBarData(
                    spots: _trendData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          entry.value['PHQ-9'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                  LineChartBarData(
                    spots: _trendData.asMap().entries.map((entry) {
                      return FlSpot(
                          entry.key.toDouble(), entry.value['EQCS'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalSignificanceIndicators() {
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
            'Clinical Significance Indicators',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 3.w),
          _buildSignificanceItem('Anxiety Levels (GAD-7)', 'Improving',
              Colors.green, 'From Moderate to Mild'),
          _buildSignificanceItem('Depression (PHQ-9)', 'Stable Improvement',
              Colors.green, 'Consistent downward trend'),
          _buildSignificanceItem('Riding Confidence (EQCS)',
              'Significant Growth', Colors.blue, 'Above clinical threshold'),
          _buildSignificanceItem('Horse Bond (HHRQ)', 'Strong Progress',
              Colors.purple, 'Optimal range achieved'),
        ],
      ),
    );
  }

  Widget _buildSignificanceItem(
      String title, String status, Color color, String detail) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            color: color,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 11.sp,
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

  Widget _buildProgressSummary() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.successLight.withValues(alpha: 0.1),
            AppTheme.primaryLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: AppTheme.successLight.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: AppTheme.successLight,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Overall Progress Summary',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Text(
            'Your consistent engagement with evidence-based assessments shows meaningful clinical improvement across multiple domains. Anxiety and depression scores demonstrate sustained reduction, while riding confidence and horse relationship quality show significant positive growth.',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.textPrimaryLight,
              height: 1.4,
            ),
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Icon(
                Icons.book,
                color: AppTheme.primaryLight,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Recommended: Continue Chapter 9 exercises',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
