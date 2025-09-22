import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceCommandWidget extends StatefulWidget {
  final bool isListening;
  final VoidCallback onActivate;
  final Function(String) onCommand;

  const VoiceCommandWidget({
    Key? key,
    required this.isListening,
    required this.onActivate,
    required this.onCommand,
  }) : super(key: key);

  @override
  State<VoiceCommandWidget> createState() => _VoiceCommandWidgetState();
}

class _VoiceCommandWidgetState extends State<VoiceCommandWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    if (widget.isListening) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _rippleController.repeat();
  }

  void _stopAnimations() {
    _pulseController.stop();
    _rippleController.stop();
  }

  @override
  void didUpdateWidget(VoiceCommandWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _startAnimations();
    } else if (!widget.isListening && oldWidget.isListening) {
      _stopAnimations();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onActivate,
      child: Container(
        width: 20.w,
        height: 20.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ripple effect when listening
            if (widget.isListening)
              AnimatedBuilder(
                animation: _rippleAnimation,
                builder: (context, child) {
                  return Container(
                    width: 20.w * (1 + _rippleAnimation.value * 0.5),
                    height: 20.w * (1 + _rippleAnimation.value * 0.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 1 - _rippleAnimation.value),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
            // Main button
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isListening ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isListening
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.surface,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                      boxShadow: widget.isListening
                          ? [
                              BoxShadow(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: widget.isListening ? 'mic' : 'mic_none',
                        color: widget.isListening
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
