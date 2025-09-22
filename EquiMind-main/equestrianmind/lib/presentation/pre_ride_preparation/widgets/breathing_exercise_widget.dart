import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BreathingExerciseWidget extends StatefulWidget {
  final Function(bool) onExerciseStateChanged;

  const BreathingExerciseWidget({
    Key? key,
    required this.onExerciseStateChanged,
  }) : super(key: key);

  @override
  State<BreathingExerciseWidget> createState() =>
      _BreathingExerciseWidgetState();
}

class _BreathingExerciseWidgetState extends State<BreathingExerciseWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _pulseController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _pulseAnimation;

  bool _isExerciseActive = false;
  String _currentPhase = 'Tap to start';
  int _cycleCount = 0;
  final int _totalCycles = 5;

  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _breathingController.addStatusListener(_onBreathingStatusChanged);
    _pulseController.repeat(reverse: true);
  }

  void _onBreathingStatusChanged(AnimationStatus status) {
    if (!_isExerciseActive) return;

    if (status == AnimationStatus.completed) {
      setState(() {
        _currentPhase = 'Hold... 2 seconds';
      });
      HapticFeedback.lightImpact();

      Future.delayed(Duration(seconds: 2), () {
        if (_isExerciseActive) {
          _breathingController.reverse();
          setState(() {
            _currentPhase = 'Exhale slowly... 4 seconds';
          });
          HapticFeedback.lightImpact();
        }
      });
    } else if (status == AnimationStatus.dismissed) {
      setState(() {
        _cycleCount++;
        if (_cycleCount >= _totalCycles) {
          _stopExercise();
        } else {
          _currentPhase = 'Inhale deeply... 4 seconds';
          _breathingController.forward();
        }
      });
      HapticFeedback.lightImpact();
    }
  }

  void _startExercise() {
    setState(() {
      _isExerciseActive = true;
      _currentPhase = 'Inhale deeply... 4 seconds';
      _cycleCount = 0;
    });

    widget.onExerciseStateChanged(true);
    _breathingController.forward();
    HapticFeedback.mediumImpact();
  }

  void _stopExercise() {
    setState(() {
      _isExerciseActive = false;
      _currentPhase =
          _cycleCount >= _totalCycles ? 'Exercise Complete!' : 'Tap to start';
      if (_cycleCount >= _totalCycles) {
        _currentPhase = 'Great job! You\'re ready to ride.';
      }
    });

    widget.onExerciseStateChanged(false);
    _breathingController.reset();
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 50.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Breathing Exercise',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          if (_isExerciseActive)
            Text(
              'Cycle ${_cycleCount + 1} of $_totalCycles',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: _isExerciseActive ? _stopExercise : _startExercise,
                child: AnimatedBuilder(
                  animation:
                      Listenable.merge([_breathingAnimation, _pulseAnimation]),
                  builder: (context, child) {
                    double scale = _isExerciseActive
                        ? _breathingAnimation.value
                        : _pulseAnimation.value;

                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.8),
                              AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName:
                                _isExerciseActive ? 'pause' : 'play_arrow',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 8.w,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _currentPhase,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          if (_isExerciseActive)
            LinearProgressIndicator(
              value: (_cycleCount + _breathingController.value) / _totalCycles,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}
