import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_display_widget.dart';
import './widgets/breathing_exercise_widget.dart';
import './widgets/emergency_support_widget.dart';
import './widgets/emotion_assessment_widget.dart';
import './widgets/exercise_carousel_widget.dart';
import './widgets/horse_connection_widget.dart';
import './widgets/voice_memo_widget.dart';

class PreRidePreparation extends StatefulWidget {
  const PreRidePreparation({Key? key}) : super(key: key);

  @override
  State<PreRidePreparation> createState() => _PreRidePreparationState();
}

class _PreRidePreparationState extends State<PreRidePreparation>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  double _emotionLevel = 5.0;
  bool _breathingExerciseCompleted = false;
  String _selectedExercise = '';
  Map<String, dynamic> _horseObservation = {};
  String? _voiceMemoPath;
  bool _showEmergencySupport = false;

  double _overallProgress = 0.0;
  final int _totalSteps = 5;
  int _completedSteps = 0;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _updateProgress();
  }

  void _updateProgress() {
    _completedSteps = 0;

    if (_emotionLevel != 5.0) _completedSteps++;
    if (_breathingExerciseCompleted) _completedSteps++;
    if (_selectedExercise.isNotEmpty) _completedSteps++;
    if (_horseObservation.isNotEmpty) _completedSteps++;
    if (_voiceMemoPath != null) _completedSteps++;

    final newProgress = _completedSteps / _totalSteps;

    setState(() {
      _overallProgress = newProgress;
    });

    _progressController.animateTo(newProgress);
  }

  void _onEmotionChanged(double value) {
    setState(() {
      _emotionLevel = value;
    });
    _updateProgress();
  }

  void _onExerciseStateChanged(bool isActive) {
    if (!isActive && !_breathingExerciseCompleted) {
      setState(() {
        _breathingExerciseCompleted = true;
      });
      _updateProgress();
    }
  }

  void _onExerciseSelected(Map<String, dynamic> exercise) {
    setState(() {
      _selectedExercise = exercise['name'] ?? '';
    });
    _updateProgress();
  }

  void _onStartExercise(Map<String, dynamic> exercise) {
    // Handle exercise start logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${exercise['name']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onObservationChanged(Map<String, dynamic> observation) {
    setState(() {
      _horseObservation = observation;
    });
    _updateProgress();
  }

  void _onRecordingComplete(String? path) {
    setState(() {
      _voiceMemoPath = path;
    });
    _updateProgress();
  }

  void _onMemoSaved(String memo) {
    setState(() {
      _voiceMemoPath = memo;
    });
    _updateProgress();
  }

  void _showEmergencyModal() {
    setState(() {
      _showEmergencySupport = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EmergencySupportWidget(
        onClose: () {
          Navigator.pop(context);
          setState(() {
            _showEmergencySupport = false;
          });
        },
      ),
    );
  }

  void _navigateToRideCoaching() {
    if (_overallProgress >= 0.6) {
      Navigator.pushNamed(context, '/during-ride-coaching');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Complete more preparation steps before starting your ride'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        ),
      );
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Pre-Ride Preparation'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showEmergencyModal,
            icon: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'emergency',
                color: Colors.red,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Preparation Progress',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${(_overallProgress * 100).toInt()}%',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                      minHeight: 1.h,
                    );
                  },
                ),
                SizedBox(height: 1.h),
                Text(
                  '$_completedSteps of $_totalSteps steps completed',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  // Pre-Ride Preparation Instructions
                  Container(
                    width: double.infinity,
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
                            Icon(
                              Icons.checklist,
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 6.w,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                'Pre-Ride Preparation Steps',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        _buildPreparationStep(
                          stepNumber: '1',
                          title: 'Complete Psychological Assessment',
                          description:
                              'Pick one evidence-based psychological evaluation to do before each ride',
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                        SizedBox(height: 2.h),
                        _buildPreparationStep(
                          stepNumber: '2',
                          title: 'Practice Mindfulness & Exercises',
                          description:
                              'Complete breathing exercises and personalized activities to prepare mentally',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                        ),
                        SizedBox(height: 2.h),
                        _buildPreparationStep(
                          stepNumber: '3',
                          title: 'Connect & Document',
                          description:
                              'Bond with your horse and record voice memos for session tracking',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Emotion Assessment
                  EmotionAssessmentWidget(
                    onEmotionChanged: _onEmotionChanged,
                    currentValue: _emotionLevel,
                  ),

                  SizedBox(height: 3.h),

                  // Breathing Exercise
                  BreathingExerciseWidget(
                    onExerciseStateChanged: _onExerciseStateChanged,
                  ),

                  SizedBox(height: 3.h),

                  // Exercise Carousel
                  ExerciseCarouselWidget(
                    emotionalState: _getEmotionalStateString(_emotionLevel),
                    rideType: 'general', // Default ride type
                    onExerciseSelected: _onExerciseSelected,
                    onStartExercise: _onStartExercise,
                  ),

                  SizedBox(height: 3.h),

                  // Horse Connection
                  HorseConnectionWidget(
                    onObservationChanged: _onObservationChanged,
                  ),

                  SizedBox(height: 3.h),

                  // Voice Memo
                  VoiceMemoWidget(
                    onMemoSaved: _onMemoSaved,
                  ),

                  SizedBox(height: 3.h),

                  // Biometric Display
                  BiometricDisplayWidget(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Bottom action area
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                if (_overallProgress >= 0.6)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    margin: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 5.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Great job! You\'re ready to start your ride with confidence.',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/dashboard-home'),
                        child: Text('Save & Exit'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _navigateToRideCoaching,
                        icon: CustomIconWidget(
                          iconName: 'play_arrow',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 5.w,
                        ),
                        label: Text('Start Ride'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _overallProgress >= 0.6
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparationStep({
    required String stepNumber,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getEmotionalStateString(double value) {
    if (value <= 2.0) return 'anxious';
    if (value <= 4.0) return 'nervous';
    if (value <= 6.0) return 'neutral';
    if (value <= 8.0) return 'confident';
    return 'excited';
  }
}
