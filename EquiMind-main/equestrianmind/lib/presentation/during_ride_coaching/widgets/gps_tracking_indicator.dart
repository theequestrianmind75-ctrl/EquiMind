import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GpsTrackingIndicator extends StatefulWidget {
  final bool isTracking;
  final String? currentLocation;

  const GpsTrackingIndicator({
    Key? key,
    required this.isTracking,
    this.currentLocation,
  }) : super(key: key);

  @override
  State<GpsTrackingIndicator> createState() => _GpsTrackingIndicatorState();
}

class _GpsTrackingIndicatorState extends State<GpsTrackingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isTracking) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(GpsTrackingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTracking && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isTracking) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isTracking
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isTracking ? _pulseAnimation.value : 1.0,
                child: CustomIconWidget(
                  iconName: widget.isTracking ? 'gps_fixed' : 'gps_off',
                  color: widget.isTracking
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              );
            },
          ),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isTracking ? 'GPS Active' : 'GPS Inactive',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: widget.isTracking
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.currentLocation != null) ...[
                SizedBox(height: 0.5.h),
                Text(
                  widget.currentLocation!,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
