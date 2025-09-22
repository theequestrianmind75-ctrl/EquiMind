import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum StressLevel { optimal, elevated, high }

class HeartRateMonitor extends StatefulWidget {
  final int? heartRate;
  final StressLevel stressLevel;
  final bool isConnected;

  const HeartRateMonitor({
    Key? key,
    this.heartRate,
    required this.stressLevel,
    required this.isConnected,
  }) : super(key: key);

  @override
  State<HeartRateMonitor> createState() => _HeartRateMonitorState();
}

class _HeartRateMonitorState extends State<HeartRateMonitor>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartbeatController;
  late Animation<double> _heartbeatAnimation;

  @override
  void initState() {
    super.initState();
    _heartbeatController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _heartbeatAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _heartbeatController, curve: Curves.easeInOut),
    );

    if (widget.isConnected && widget.heartRate != null) {
      _heartbeatController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(HeartRateMonitor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnected &&
        widget.heartRate != null &&
        !_heartbeatController.isAnimating) {
      _heartbeatController.repeat(reverse: true);
    } else if (!widget.isConnected || widget.heartRate == null) {
      _heartbeatController.stop();
    }
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    super.dispose();
  }

  Color _getStressColor() {
    switch (widget.stressLevel) {
      case StressLevel.optimal:
        return AppTheme.lightTheme.colorScheme.primary;
      case StressLevel.elevated:
        return Color(0xFFB8860B); // Warning color
      case StressLevel.high:
        return AppTheme.lightTheme.colorScheme.error;
    }
  }

  String _getStressLabel() {
    switch (widget.stressLevel) {
      case StressLevel.optimal:
        return 'Optimal';
      case StressLevel.elevated:
        return 'Elevated';
      case StressLevel.high:
        return 'High Stress';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isConnected
              ? _getStressColor()
              : AppTheme.lightTheme.colorScheme.outline,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Heart Rate',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: widget.isConnected
                      ? AppTheme.lightTheme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: widget.isConnected
                      ? _getStressColor().withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.isConnected ? _getStressLabel() : 'Disconnected',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: widget.isConnected
                        ? _getStressColor()
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _heartbeatAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: widget.isConnected && widget.heartRate != null
                        ? _heartbeatAnimation.value
                        : 1.0,
                    child: CustomIconWidget(
                      iconName: 'favorite',
                      color: widget.isConnected
                          ? _getStressColor()
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 8.w,
                    ),
                  );
                },
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.heartRate?.toString() ?? '--',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: widget.isConnected
                          ? _getStressColor()
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'BPM',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
