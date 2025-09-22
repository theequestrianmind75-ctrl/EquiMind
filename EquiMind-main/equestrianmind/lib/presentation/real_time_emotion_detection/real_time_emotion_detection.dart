import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../services/emotion_detection_service.dart';
import './widgets/biometric_display_widget.dart';
import './widgets/emotion_indicator_widget.dart';
import './widgets/emotion_insights_widget.dart';
import './widgets/emotion_timeline_widget.dart';
import './widgets/privacy_controls_widget.dart';
import './widgets/voice_feedback_widget.dart';

class RealTimeEmotionDetection extends StatefulWidget {
  const RealTimeEmotionDetection({super.key});

  @override
  State<RealTimeEmotionDetection> createState() =>
      _RealTimeEmotionDetectionState();
}

class _RealTimeEmotionDetectionState extends State<RealTimeEmotionDetection>
    with TickerProviderStateMixin {
  final EmotionDetectionService _emotionService = EmotionDetectionService();

  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  StreamSubscription<EmotionReading>? _emotionSubscription;
  StreamSubscription<BiometricData>? _biometricSubscription;

  bool _isExpanded = false;
  bool _isOverlayMode = true;
  bool _isInitialized = false;
  String _statusMessage = 'Initializing...';

  EmotionReading? _currentEmotion;
  BiometricData? _currentBiometrics;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));

    _pulseController.repeat(reverse: true);

    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      setState(() {
        _statusMessage = 'Requesting permissions...';
      });

      final success = await _emotionService.initialize();

      if (success) {
        setState(() {
          _isInitialized = true;
          _statusMessage = 'Ready to start detection';
        });

        _startEmotionDetection();
      } else {
        setState(() {
          _statusMessage = 'Permission denied - using limited features';
          _isInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Initialization failed - check permissions';
      });
    }
  }

  void _startEmotionDetection() {
    _emotionService.startDetection();

    _emotionSubscription = _emotionService.emotionStream.listen((emotion) {
      setState(() {
        _currentEmotion = emotion;
      });

      // Trigger animations based on emotion changes
      _triggerEmotionAnimation(emotion);
    });

    _biometricSubscription =
        _emotionService.biometricStream.listen((biometrics) {
      setState(() {
        _currentBiometrics = biometrics;
      });
    });

    setState(() {
      _statusMessage = 'Detecting emotions...';
    });
  }

  void _triggerEmotionAnimation(EmotionReading emotion) {
    if (emotion.emotion == EmotionState.anxious ||
        emotion.stressPercentage > 70) {
      _pulseController.duration = const Duration(milliseconds: 1000);
    } else if (emotion.emotion == EmotionState.excited) {
      _pulseController.duration = const Duration(milliseconds: 800);
    } else {
      _pulseController.duration = const Duration(milliseconds: 2000);
    }

    _fadeController.forward().then((_) {
      _fadeController.reverse();
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleOverlayMode() {
    setState(() {
      _isOverlayMode = !_isOverlayMode;
    });
  }

  Color _getEmotionColor(EmotionState? emotion) {
    switch (emotion) {
      case EmotionState.calm:
        return Colors.green.shade400;
      case EmotionState.anxious:
        return Colors.red.shade400;
      case EmotionState.excited:
        return Colors.orange.shade400;
      case EmotionState.frustrated:
        return Colors.purple.shade400;
      case EmotionState.confident:
        return Colors.blue.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  String _getEmotionText(EmotionState? emotion) {
    return emotion?.name.toUpperCase() ?? 'DETECTING';
  }

  Widget _buildOverlayInterface() {
    if (!_isInitialized) {
      return _buildInitializationScreen();
    }

    return Positioned(
      top: 8.h,
      right: 4.w,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isExpanded ? 80.w : 20.w,
              height: _isExpanded ? 60.h : 20.w,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(204),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getEmotionColor(_currentEmotion?.emotion),
                  width: 2,
                ),
              ),
              child: _isExpanded ? _buildExpandedView() : _buildCompactView(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactView() {
    return InkWell(
      onTap: _toggleExpanded,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getEmotionColor(_currentEmotion?.emotion),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 1.h),
            Text(
              _getEmotionText(_currentEmotion?.emotion),
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedView() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Emotion Detection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _toggleExpanded,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          EmotionIndicatorWidget(
            emotion: _currentEmotion,
            isCompact: false,
          ),
          SizedBox(height: 2.h),
          BiometricDisplayWidget(
            biometrics: _currentBiometrics,
            emotion: _currentEmotion,
          ),
          SizedBox(height: 2.h),
          EmotionTimelineWidget(
            emotions: _emotionService.getEmotionHistory(5),
            isCompact: true,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _toggleOverlayMode,
                icon: Icon(
                  _isOverlayMode ? Icons.fullscreen : Icons.fullscreen_exit,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => _showEmotionInsights(),
                icon: const Icon(Icons.insights, color: Colors.white),
              ),
              IconButton(
                onPressed: () => _showPrivacyControls(),
                icon: const Icon(Icons.privacy_tip, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenInterface() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Real-Time Emotion Detection',
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
        actions: [
          IconButton(
            onPressed: _toggleOverlayMode,
            icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
          ),
        ],
      ),
      body: _isInitialized ? _buildFullContent() : _buildInitializationScreen(),
    );
  }

  Widget _buildFullContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmotionIndicatorWidget(
            emotion: _currentEmotion,
            isCompact: false,
          ),
          SizedBox(height: 3.h),
          BiometricDisplayWidget(
            biometrics: _currentBiometrics,
            emotion: _currentEmotion,
          ),
          SizedBox(height: 3.h),
          EmotionTimelineWidget(
            emotions: _emotionService.getEmotionHistory(5),
            isCompact: false,
          ),
          SizedBox(height: 3.h),
          EmotionInsightsWidget(
            currentEmotion: _currentEmotion,
            emotionHistory: _emotionService.getEmotionHistory(10),
          ),
          SizedBox(height: 3.h),
          VoiceFeedbackWidget(
            emotion: _currentEmotion,
          ),
          SizedBox(height: 3.h),
          PrivacyControlsWidget(),
        ],
      ),
    );
  }

  Widget _buildInitializationScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withAlpha(230),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 2.h),
            Text(
              _statusMessage,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showEmotionInsights() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: EmotionInsightsWidget(
          currentEmotion: _currentEmotion,
          emotionHistory: _emotionService.getEmotionHistory(15),
        ),
      ),
    );
  }

  void _showPrivacyControls() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: PrivacyControlsWidget(),
      ),
    );
  }

  @override
  void dispose() {
    _emotionService.stopDetection();
    _emotionSubscription?.cancel();
    _biometricSubscription?.cancel();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isOverlayMode
        ? Stack(
            children: [
              Container(
                  color:
                      Colors.transparent), // Transparent background for overlay
              _buildOverlayInterface(),
            ],
          )
        : _buildFullScreenInterface();
  }
}
