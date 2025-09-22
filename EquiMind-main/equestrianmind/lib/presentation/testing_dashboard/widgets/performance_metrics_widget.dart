import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PerformanceMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> metricsData;

  const PerformanceMetricsWidget({
    Key? key,
    required this.metricsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
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
                iconName: 'speed',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Performance Metrics',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  metricsData['overallHealth'] ?? 'Unknown',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Memory Usage',
                  '${metricsData['memoryUsage'] ?? 0}%',
                  'memory',
                  _getMemoryColor(metricsData['memoryUsage'] ?? 0),
                  metricsData['memoryUsage'] / 100.0 ?? 0.0,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  'Battery Usage',
                  '${metricsData['batteryConsumption'] ?? 0}%',
                  'battery_full',
                  _getBatteryColor(metricsData['batteryConsumption'] ?? 0),
                  metricsData['batteryConsumption'] / 50.0 ?? 0.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Network Activity',
                  '${metricsData['networkActivity'] ?? 0} MB/s',
                  'wifi',
                  _getNetworkColor(metricsData['networkActivity'] ?? 0),
                  metricsData['networkActivity'] / 20.0 ?? 0.0,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildMetricCard(
                  'Overall Health',
                  _getHealthPercentage(),
                  'health_and_safety',
                  _getStatusColor(),
                  _getHealthValue(),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Metrics are updated every 30 seconds during testing sessions',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _refreshMetrics(context),
                child: Text('Refresh'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String iconName,
    Color color,
    double progress,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    final health = metricsData['overallHealth'] ?? 'Unknown';
    switch (health.toLowerCase()) {
      case 'optimal':
        return AppTheme.successLight;
      case 'good':
        return Colors.green;
      case 'warning':
        return AppTheme.warningLight;
      case 'critical':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getMemoryColor(double usage) {
    if (usage < 50) return AppTheme.successLight;
    if (usage < 80) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  Color _getBatteryColor(double usage) {
    if (usage < 10) return AppTheme.successLight;
    if (usage < 25) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  Color _getNetworkColor(double activity) {
    if (activity < 5) return AppTheme.successLight;
    if (activity < 15) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  String _getHealthPercentage() {
    final health = metricsData['overallHealth'] ?? 'Unknown';
    switch (health.toLowerCase()) {
      case 'optimal':
        return '95%';
      case 'good':
        return '80%';
      case 'warning':
        return '65%';
      case 'critical':
        return '30%';
      default:
        return 'N/A';
    }
  }

  double _getHealthValue() {
    final health = metricsData['overallHealth'] ?? 'Unknown';
    switch (health.toLowerCase()) {
      case 'optimal':
        return 0.95;
      case 'good':
        return 0.80;
      case 'warning':
        return 0.65;
      case 'critical':
        return 0.30;
      default:
        return 0.0;
    }
  }

  void _refreshMetrics(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Refreshing performance metrics...')),
    );
  }
}
