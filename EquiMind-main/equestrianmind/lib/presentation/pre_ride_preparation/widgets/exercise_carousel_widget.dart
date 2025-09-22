import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/ai_coaching_service.dart';

class ExerciseCarouselWidget extends StatefulWidget {
  final String emotionalState;
  final String rideType;
  final Function(Map<String, dynamic>) onExerciseSelected;
  final Function(Map<String, dynamic>) onStartExercise;

  const ExerciseCarouselWidget({
    Key? key,
    required this.emotionalState,
    required this.rideType,
    required this.onExerciseSelected,
    required this.onStartExercise,
  }) : super(key: key);

  @override
  State<ExerciseCarouselWidget> createState() => _ExerciseCarouselWidgetState();
}

class _ExerciseCarouselWidgetState extends State<ExerciseCarouselWidget> {
  final PageController _pageController = PageController();
  List<Map<String, dynamic>> exercises = [];
  bool isLoading = true;
  int currentIndex = 0;
  final AICoachingService _aiService = AICoachingService();

  @override
  void initState() {
    super.initState();
    _generateExercises();
  }

  Future<void> _generateExercises() async {
    try {
      setState(() {
        isLoading = true;
      });

      final generatedExercises = await _aiService.generatePreRideExercises(
        emotionalState: widget.emotionalState,
        rideType: widget.rideType,
        availableMinutes: 15, // Default 15 minutes
      );

      setState(() {
        exercises = generatedExercises;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        exercises = _getFallbackExercises();
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFallbackExercises() {
    return [
      {
        "name": "Centering Breath",
        "description":
            "A grounding breathing exercise to center your mind and body",
        "duration": 3,
        "category": "breathing",
        "instructions": [
          "Sit comfortably with feet flat on the ground",
          "Inhale slowly for 4 counts through your nose",
          "Hold your breath for 4 counts",
          "Exhale slowly for 6 counts through your mouth",
          "Repeat 5-8 times"
        ]
      },
      {
        "name": "Successful Ride Visualization",
        "description":
            "Mental rehearsal of a confident, successful riding experience",
        "duration": 5,
        "category": "visualization",
        "instructions": [
          "Close your eyes and relax your body",
          "Visualize yourself mounting confidently",
          "See yourself riding with perfect balance and control",
          "Imagine your horse responding beautifully to your aids",
          "Feel the satisfaction of a successful session"
        ]
      },
      {
        "name": "Body Activation",
        "description": "Light physical warm-up to prepare your body for riding",
        "duration": 4,
        "category": "physical_warmup",
        "instructions": [
          "Stand tall and roll your shoulders backward 5 times",
          "Gently turn your head left and right, holding for 5 seconds each",
          "March in place for 30 seconds",
          "Do 5 gentle arm circles forward, then backward",
          "Take 3 deep breaths to finish"
        ]
      }
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personalized Exercises',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              if (!isLoading)
                IconButton(
                  onPressed: _generateExercises,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  tooltip: 'Generate New Exercises',
                ),
            ],
          ),
          SizedBox(height: 2.h),
          if (isLoading)
            _buildLoadingState()
          else if (exercises.isEmpty)
            _buildEmptyState()
          else ...[
            SizedBox(
              height: 35.h,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                  widget.onExerciseSelected(exercises[index]);
                },
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return _buildExerciseCard(exercises[index]);
                },
              ),
            ),
            SizedBox(height: 2.h),
            _buildPageIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 35.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.primaryColor,
            ),
            SizedBox(height: 2.h),
            Text(
              'AI is creating personalized exercises...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 35.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Unable to load exercises',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Please check your connection and try again',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton.icon(
              onPressed: _generateExercises,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 18,
              ),
              label: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 12.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getCategoryColor(exercise['category'] as String? ?? ''),
                  _getCategoryColor(exercise['category'] as String? ?? '')
                      .withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName:
                        _getCategoryIcon(exercise['category'] as String? ?? ''),
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '${exercise['duration'] ?? 5} min',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise['name'] as String? ?? 'Exercise',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    exercise['description'] as String? ??
                        'No description available',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => widget.onStartExercise(exercise),
                      icon: CustomIconWidget(
                        iconName: 'play_arrow',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 18,
                      ),
                      label: Text('Start Exercise'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        exercises.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
          width: currentIndex == index ? 8.w : 2.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'breathing':
        return 'air';
      case 'visualization':
        return 'visibility';
      case 'physical_warmup':
        return 'fitness_center';
      case 'mental_preparation':
        return 'psychology';
      default:
        return 'self_improvement';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'breathing':
        return Colors.blue.shade600;
      case 'visualization':
        return Colors.purple.shade600;
      case 'physical_warmup':
        return Colors.orange.shade600;
      case 'mental_preparation':
        return Colors.teal.shade600;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }
}
