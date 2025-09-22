import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/audio_waveform_widget.dart';
import './widgets/emergency_stop_button.dart';
import './widgets/gps_tracking_indicator.dart';
import './widgets/heart_rate_monitor.dart';
import './widgets/ride_metrics_display.dart';
import './widgets/voice_command_widget.dart';

class DuringRideCoaching extends StatefulWidget {
  const DuringRideCoaching({Key? key}) : super(key: key);

  @override
  State<DuringRideCoaching> createState() => _DuringRideCoachingState();
}

class _DuringRideCoachingState extends State<DuringRideCoaching>
    with TickerProviderStateMixin {
  // Session state
  bool _isSessionActive = true;
  bool _isAudioMuted = false;
  bool _isListeningForCommands = false;
  bool _isGpsTracking = true;
  bool _isHeartRateConnected = true;
  bool _showMetrics = true;

  // Ride data
  Duration _rideDuration = Duration.zero;
  double _rideDistance = 0.0;
  double _currentPace = 0.0;
  int? _currentHeartRate = 72;
  StressLevel _currentStressLevel = StressLevel.optimal;
  String? _currentLocation = "Training Arena";

  // Timers and controllers
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  // Mock coaching messages
  final List<String> _coachingMessages = [
    "Great posture! Keep your shoulders relaxed and centered.",
    "Remember to breathe deeply and maintain your rhythm.",
    "Your horse is responding well to your calm energy.",
    "Focus on your seat and maintain gentle contact with the reins.",
    "Excellent transition! Keep that smooth communication going.",
  ];

  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeSession();
    _setupAnimations();
    _startRideTimer();
    _simulateRideData();
  }

  void _initializeSession() {
    // Lock screen orientation to portrait for safety
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Keep screen on during session
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _setupAnimations() {
    _backgroundController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: AppTheme.lightTheme.colorScheme.surface,
      end: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _backgroundController.repeat(reverse: true);
  }

  void _startRideTimer() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (_isSessionActive && mounted) {
        setState(() {
          _rideDuration = _rideDuration + Duration(seconds: 1);
        });
        return true;
      }
      return false;
    });
  }

  void _simulateRideData() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 5));
      if (_isSessionActive && mounted) {
        setState(() {
          // Simulate distance increase
          _rideDistance += 0.02; // 20 meters every 5 seconds

          // Simulate pace variation
          _currentPace = 8.0 + (DateTime.now().millisecond % 100) / 50.0;

          // Simulate heart rate variation
          if (_isHeartRateConnected) {
            _currentHeartRate = 70 + (DateTime.now().millisecond % 40);

            // Update stress level based on heart rate
            if (_currentHeartRate! < 80) {
              _currentStressLevel = StressLevel.optimal;
            } else if (_currentHeartRate! < 100) {
              _currentStressLevel = StressLevel.elevated;
            } else {
              _currentStressLevel = StressLevel.high;
            }
          }
        });

        // Auto-hide metrics after 5 seconds
        if (_showMetrics) {
          Future.delayed(Duration(seconds: 5), () {
            if (mounted) {
              setState(() {
                _showMetrics = false;
              });
            }
          });
        }

        return true;
      }
      return false;
    });
  }

  void _handleEmergencyStop() {
    setState(() {
      _isSessionActive = false;
    });

    // Show confirmation dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Session Stopped',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Your coaching session has been stopped. Would you like to save your progress?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/dashboard-home');
            },
            child: Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/post-ride-analysis');
            },
            child: Text('Save & Analyze'),
          ),
        ],
      ),
    );
  }

  void _toggleAudioMute() {
    setState(() {
      _isAudioMuted = !_isAudioMuted;
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            _isAudioMuted ? 'Audio coaching muted' : 'Audio coaching enabled'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _activateVoiceCommand() {
    setState(() {
      _isListeningForCommands = !_isListeningForCommands;
    });

    if (_isListeningForCommands) {
      // Simulate voice command recognition
      Future.delayed(Duration(seconds: 3), () {
        if (mounted && _isListeningForCommands) {
          _handleVoiceCommand("confidence boost");
          setState(() {
            _isListeningForCommands = false;
          });
        }
      });
    }
  }

  void _handleVoiceCommand(String command) {
    String response = "";

    switch (command.toLowerCase()) {
      case "confidence boost":
        response =
            "You're doing amazing! Trust yourself and your horse. You've got this!";
        break;
      case "breathing reminder":
        response =
            "Take a deep breath in... and slowly out. Let your body relax with each exhale.";
        break;
      case "focus technique":
        response =
            "Focus on the present moment. Feel your connection with your horse and the rhythm of movement.";
        break;
      default:
        response = _coachingMessages[_currentMessageIndex];
        _currentMessageIndex =
            (_currentMessageIndex + 1) % _coachingMessages.length;
    }

    // Show coaching message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response),
        duration: Duration(seconds: 4),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showMetricsTemporarily() {
    setState(() {
      _showMetrics = true;
    });

    // Auto-hide after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showMetrics = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundAnimation.value ??
                      AppTheme.lightTheme.colorScheme.surface,
                  AppTheme.lightTheme.colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Main content
                  Positioned.fill(
                    child: Column(
                      children: [
                        // Top section - GPS and Heart Rate
                        Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GpsTrackingIndicator(
                                isTracking: _isGpsTracking,
                                currentLocation: _currentLocation,
                              ),
                              HeartRateMonitor(
                                heartRate: _currentHeartRate,
                                stressLevel: _currentStressLevel,
                                isConnected: _isHeartRateConnected,
                              ),
                            ],
                          ),
                        ),

                        Spacer(),

                        // Center section - Emergency Stop Button
                        EmergencyStopButton(
                          onPressed: _handleEmergencyStop,
                          isActive: _isSessionActive,
                        ),

                        SizedBox(height: 4.h),

                        // Audio Waveform
                        AudioWaveformWidget(
                          isActive: _isSessionActive && !_isAudioMuted,
                          isMuted: _isAudioMuted,
                          onMuteToggle: _toggleAudioMute,
                        ),

                        Spacer(),

                        // Bottom section - Voice Command and Metrics
                        Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            children: [
                              // Voice Command Widget
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  VoiceCommandWidget(
                                    isListening: _isListeningForCommands,
                                    onActivate: _activateVoiceCommand,
                                    onCommand: _handleVoiceCommand,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Say "Hey Coach"',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelMedium
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 3.h),

                              // Metrics Display (with tap to show)
                              GestureDetector(
                                onTap: _showMetricsTemporarily,
                                child: _showMetrics
                                    ? RideMetricsDisplay(
                                        duration: _rideDuration,
                                        distance: _rideDistance,
                                        currentPace: _currentPace,
                                        isVisible: _showMetrics,
                                      )
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: AppTheme
                                              .lightTheme.colorScheme.surface
                                              .withValues(alpha: 0.7),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline
                                                .withValues(alpha: 0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomIconWidget(
                                              iconName: 'visibility',
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurfaceVariant,
                                              size: 5.w,
                                            ),
                                            SizedBox(width: 2.w),
                                            Text(
                                              'Tap to show metrics',
                                              style: AppTheme.lightTheme
                                                  .textTheme.labelMedium
                                                  ?.copyWith(
                                                color: AppTheme
                                                    .lightTheme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Session status indicator
                  if (!_isSessionActive)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.5),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'pause_circle_filled',
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 15.w,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Session Paused',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleLarge
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Emergency stop activated',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
