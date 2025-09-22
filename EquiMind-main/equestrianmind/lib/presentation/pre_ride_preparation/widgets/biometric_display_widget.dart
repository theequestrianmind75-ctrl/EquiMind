import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricDisplayWidget extends StatefulWidget {
  const BiometricDisplayWidget({Key? key}) : super(key: key);

  @override
  State<BiometricDisplayWidget> createState() => _BiometricDisplayWidgetState();
}

class _BiometricDisplayWidgetState extends State<BiometricDisplayWidget> {
  bool _isConnected = false;
  int _currentHeartRate = 72;
  double _stressLevel = 3.2;

  // Mock heart rate data for the last 5 minutes
  final List<FlSpot> _heartRateData = [
    FlSpot(0, 78),
    FlSpot(1, 76),
    FlSpot(2, 74),
    FlSpot(3, 72),
    FlSpot(4, 70),
    FlSpot(5, 72),
  ];

  @override
  void initState() {
    super.initState();
    _simulateConnection();
  }

  void _simulateConnection() {
    // Simulate biometric device connection
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isConnected = true;
        });
      }
    });
  }

  Color _getStressColor(double stressLevel) {
    if (stressLevel <= 2.0) return AppTheme.lightTheme.colorScheme.primary;
    if (stressLevel <= 4.0) return Color(0xFFB8860B);
    return Color(0xFFA0522D);
  }

  String _getStressLabel(double stressLevel) {
    if (stressLevel <= 2.0) return 'Relaxed';
    if (stressLevel <= 4.0) return 'Moderate';
    return 'Elevated';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'monitor_heart',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Biometric Monitoring',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _isConnected
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: _isConnected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _isConnected ? 'Connected' : 'Connecting...',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _isConnected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          if (_isConnected) ...[
            // Current metrics
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'favorite',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 5.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '$_currentHeartRate',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'BPM',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color:
                          _getStressColor(_stressLevel).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'psychology',
                          color: _getStressColor(_stressLevel),
                          size: 5.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _stressLevel.toStringAsFixed(1),
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _getStressColor(_stressLevel),
                          ),
                        ),
                        Text(
                          _getStressLabel(_stressLevel),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Heart rate trend chart
            Text(
              'Heart Rate Trend (Last 5 minutes)',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 2.h),

            Container(
              height: 15.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 8.w,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}m',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 5,
                  minY: 65,
                  maxY: 85,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _heartRateData,
                      isCurved: true,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.lightTheme.colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor:
                                AppTheme.lightTheme.colorScheme.surface,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'trending_down',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Great progress! Your heart rate is decreasing, showing relaxation.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Center(
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  CircularProgressIndicator(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Connecting to your biometric device...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Make sure your device is nearby and paired',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
