import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AudioWaveformWidget extends StatefulWidget {
  final bool isActive;
  final bool isMuted;
  final VoidCallback onMuteToggle;

  const AudioWaveformWidget({
    Key? key,
    required this.isActive,
    required this.isMuted,
    required this.onMuteToggle,
  }) : super(key: key);

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformWidgetState();
}

class _AudioWaveformWidgetState extends State<AudioWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isActive && !widget.isMuted) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AudioWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive &&
        !widget.isMuted &&
        !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isActive || widget.isMuted) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 12.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isActive
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Coach',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: widget.isActive
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: widget.onMuteToggle,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: widget.isMuted
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: widget.isMuted ? 'volume_off' : 'volume_up',
                    color: Colors.white,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(12, (index) {
                    final height = widget.isActive && !widget.isMuted
                        ? (0.3 + (_animation.value * 0.7)) *
                            (0.5 + (index % 3) * 0.25)
                        : 0.3;
                    return Container(
                      width: 3.w,
                      height: height * 6.h,
                      decoration: BoxDecoration(
                        color: widget.isActive && !widget.isMuted
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
