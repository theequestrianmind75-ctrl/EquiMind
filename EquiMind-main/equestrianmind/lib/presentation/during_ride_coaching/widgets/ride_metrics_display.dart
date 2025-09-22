import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RideMetricsDisplay extends StatefulWidget {
  final Duration duration;
  final double distance;
  final double currentPace;
  final bool isVisible;

  const RideMetricsDisplay({
    Key? key,
    required this.duration,
    required this.distance,
    required this.currentPace,
    this.isVisible = true,
  }) : super(key: key);

  @override
  State<RideMetricsDisplay> createState() => _RideMetricsDisplayState();
}

class _RideMetricsDisplayState extends State<RideMetricsDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    if (widget.isVisible) {
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(RideMetricsDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _fadeController.forward();
      } else {
        _fadeController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0
        ? '$hours:$minutes:$seconds'
        : '$minutes:$seconds';
  }

  String _formatDistance(double distance) {
    if (distance < 1.0) {
      return '${(distance * 1000).toInt()}m';
    }
    return '${distance.toStringAsFixed(1)}km';
  }

  String _formatPace(double pace) {
    if (pace == 0) return '0.0 km/h';
    return '${pace.toStringAsFixed(1)} km/h';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricItem(
                  icon: 'schedule',
                  label: 'Duration',
                  value: _formatDuration(widget.duration),
                ),
                Container(
                  width: 1,
                  height: 6.h,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
                _buildMetricItem(
                  icon: 'straighten',
                  label: 'Distance',
                  value: _formatDistance(widget.distance),
                ),
                Container(
                  width: 1,
                  height: 6.h,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
                _buildMetricItem(
                  icon: 'speed',
                  label: 'Pace',
                  value: _formatPace(widget.currentPace),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
