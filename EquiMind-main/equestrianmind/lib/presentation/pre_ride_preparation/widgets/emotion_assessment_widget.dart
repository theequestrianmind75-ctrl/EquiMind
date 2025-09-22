import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../services/ai_coaching_service.dart';

class EmotionAssessmentWidget extends StatefulWidget {
  final Function(double) onEmotionChanged;
  final double currentValue;

  const EmotionAssessmentWidget({
    Key? key,
    required this.onEmotionChanged,
    required this.currentValue,
  }) : super(key: key);

  @override
  State<EmotionAssessmentWidget> createState() =>
      _EmotionAssessmentWidgetState();
}

class _EmotionAssessmentWidgetState extends State<EmotionAssessmentWidget>
    with SingleTickerProviderStateMixin {
  late TabController _assessmentTabController;
  late AICoachingService _aiCoachingService;

  bool _isAnalyzing = false;
  String _aiRecommendation = '';
  int _selectedAssessmentType = 0;

  // Clinical assessment scales - Updated to include PSS-10
  final Map<String, Map<String, dynamic>> _clinicalScales = {
    'GAD-7': {
      'name': 'Generalized Anxiety Disorder 7-item',
      'questions': [
        'Feeling nervous, anxious, or on edge',
        'Not being able to stop or control worrying',
        'Worrying too much about different things',
        'Trouble relaxing',
        'Being so restless that it\'s hard to sit still',
        'Becoming easily annoyed or irritable',
        'Feeling afraid as if something awful might happen',
      ],
      'responses': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day'
      ],
      'scores': [0, 1, 2, 3],
      'maxScore': 21,
      'color': Colors.red,
    },
    'PHQ-9': {
      'name': 'Patient Health Questionnaire-9',
      'questions': [
        'Little interest or pleasure in doing things',
        'Feeling down, depressed, or hopeless',
        'Trouble falling or staying asleep, or sleeping too much',
        'Feeling tired or having little energy',
        'Poor appetite or overeating',
        'Feeling bad about yourself',
        'Trouble concentrating on things',
        'Moving or speaking slowly or being fidgety',
        'Thoughts that you would be better off dead',
      ],
      'responses': [
        'Not at all',
        'Several days',
        'More than half the days',
        'Nearly every day'
      ],
      'scores': [0, 1, 2, 3],
      'maxScore': 27,
      'color': Colors.blue,
    },
    'PSS-10': {
      'name': 'Perceived Stress Scale-10',
      'questions': [
        'In the last month, how often have you been upset because of something that happened unexpectedly?',
        'In the last month, how often have you felt that you were unable to control the important things in your life?',
        'In the last month, how often have you felt nervous and "stressed"?',
        'In the last month, how often have you felt confident about your ability to handle your personal problems?',
        'In the last month, how often have you felt that things were going your way?',
        'In the last month, how often have you found that you could not cope with all the things that you had to do?',
        'In the last month, how often have you been able to control irritations in your life?',
        'In the last month, how often have you felt that you were on top of things?',
        'In the last month, how often have you been angered because of things that were outside of your control?',
        'In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?',
      ],
      'responses': [
        'Never',
        'Almost never',
        'Sometimes',
        'Fairly often',
        'Very often'
      ],
      'scores': [0, 1, 2, 3, 4],
      'maxScore': 40,
      'reverseScored': [
        3,
        4,
        6,
        7
      ], // Questions 4, 5, 7, 8 are reverse scored (index 3, 4, 6, 7)
      'color': Colors.orange,
    },
    'Confidence Scale': {
      'name': 'Equestrian Confidence Scale',
      'questions': [
        'I feel confident when approaching my horse',
        'I trust my ability to handle unexpected situations while riding',
        'I feel calm and in control during riding sessions',
        'I believe I can achieve my riding goals',
        'I enjoy the challenge of learning new riding skills',
        'I feel positive about my riding progress',
        'I look forward to my riding sessions',
        'I feel comfortable riding in different environments',
        'I trust my horse to respond appropriately to my cues',
        'I feel secure in my riding abilities',
      ],
      'responses': [
        'Strongly Disagree',
        'Disagree',
        'Neutral',
        'Agree',
        'Strongly Agree'
      ],
      'scores': [1, 2, 3, 4, 5],
      'maxScore': 50,
      'color': Colors.green,
    },
  };

  Map<String, List<int>> _assessmentScores = {};

  @override
  void initState() {
    super.initState();
    _assessmentTabController =
        TabController(length: 4, vsync: this); // Updated to 4 tabs
    _aiCoachingService = AICoachingService();

    // Initialize assessment scores
    _clinicalScales.forEach((key, value) {
      _assessmentScores[key] =
          List.filled((value['questions'] as List).length, 0);
    });

    _generateInitialRecommendation();
  }

  Future<void> _generateInitialRecommendation() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final recommendation = await _aiCoachingService.generateRealTimeCoaching(
        currentActivity: 'Pre-ride emotional assessment',
        emotionalState: _getEmotionalStateString(widget.currentValue),
        biometrics: {'currentEmotionLevel': widget.currentValue},
        specificConcern:
            'Evidence-based assessment and preparation recommendations',
      );

      setState(() {
        _aiRecommendation = recommendation;
      });
    } catch (e) {
      setState(() {
        _aiRecommendation =
            'Focus on deep breathing and positive self-talk. Take time to connect with your horse before mounting. Trust your training and stay present in the moment.';
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  int _calculateTotalScore(String scale) {
    final scores = _assessmentScores[scale] ?? [];
    final scaleData = _clinicalScales[scale];

    if (scaleData == null) return 0;

    // Handle reverse scoring for PSS-10
    if (scale == 'PSS-10' && scaleData['reverseScored'] != null) {
      final reverseIndexes = scaleData['reverseScored'] as List<int>;
      final maxItemScore =
          (scaleData['scores'] as List<int>).reduce((a, b) => a > b ? a : b);

      int total = 0;
      for (int i = 0; i < scores.length; i++) {
        if (reverseIndexes.contains(i)) {
          // Reverse scoring: 0->4, 1->3, 2->2, 3->1, 4->0
          total += maxItemScore - scores[i];
        } else {
          total += scores[i];
        }
      }
      return total;
    }

    return scores.fold(0, (sum, score) => sum + score);
  }

  String _getScoreInterpretation(String scale, int score) {
    switch (scale) {
      case 'GAD-7':
        if (score <= 4) return 'Minimal anxiety';
        if (score <= 9) return 'Mild anxiety';
        if (score <= 14) return 'Moderate anxiety';
        return 'Severe anxiety';
      case 'PHQ-9':
        if (score <= 4) return 'Minimal depression';
        if (score <= 9) return 'Mild depression';
        if (score <= 14) return 'Moderate depression';
        if (score <= 19) return 'Moderately severe depression';
        return 'Severe depression';
      case 'PSS-10':
        if (score <= 13) return 'Low stress';
        if (score <= 26) return 'Moderate stress';
        return 'High stress';
      case 'Confidence Scale':
        final percentage =
            (score / 50 * 100); // Fixed calculation with correct max score
        if (percentage >= 80) return 'High confidence';
        if (percentage >= 60) return 'Moderate confidence';
        if (percentage >= 40) return 'Low-moderate confidence';
        return 'Low confidence';
      default:
        return 'Score: $score';
    }
  }

  Color _getScoreColor(String scale, int score) {
    switch (scale) {
      case 'GAD-7':
      case 'PHQ-9':
        if (score <= 4) return Colors.green;
        if (score <= 9) return Colors.yellow;
        if (score <= 14) return Colors.orange;
        return Colors.red;
      case 'PSS-10':
        if (score <= 13) return Colors.green;
        if (score <= 26) return Colors.orange;
        return Colors.red;
      case 'Confidence Scale':
        final percentage =
            (score / 50 * 100); // Fixed calculation with correct max score
        if (percentage >= 80) return Colors.green;
        if (percentage >= 60) return Colors.lightGreen;
        if (percentage >= 40) return Colors.orange;
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _assessmentTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
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
          // Header with assessment selection guidance
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Psychological Assessment Selection',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Choose one evidence-based evaluation before your ride',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(
                    context, '/clinical-progress-dashboard'),
                icon: Icon(
                  Icons.analytics,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                tooltip: 'View Progress Dashboard',
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Assessment Selection Cards - Updated to include 4 assessments
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildAssessmentSelectionCard(
                      title: 'GAD-7',
                      subtitle: '(Anxiety)',
                      description: 'Generalized Anxiety Disorder Assessment',
                      color: Colors.red,
                      onTap: () {
                        setState(() {
                          _selectedAssessmentType = 0;
                          _assessmentTabController.animateTo(0);
                        });
                      },
                      isSelected: _selectedAssessmentType == 0,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildAssessmentSelectionCard(
                      title: 'PHQ-9',
                      subtitle: '(Depression)',
                      description: 'Patient Health Questionnaire',
                      color: Colors.blue,
                      onTap: () {
                        setState(() {
                          _selectedAssessmentType = 1;
                          _assessmentTabController.animateTo(1);
                        });
                      },
                      isSelected: _selectedAssessmentType == 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _buildAssessmentSelectionCard(
                      title: 'PSS-10',
                      subtitle: '(Stress)',
                      description: 'Perceived Stress Scale',
                      color: Colors.orange,
                      onTap: () {
                        setState(() {
                          _selectedAssessmentType = 2;
                          _assessmentTabController.animateTo(2);
                        });
                      },
                      isSelected: _selectedAssessmentType == 2,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildAssessmentSelectionCard(
                      title: 'ECS',
                      subtitle: '(Confidence)',
                      description: 'Equestrian Confidence Scale',
                      color: Colors.green,
                      onTap: () {
                        setState(() {
                          _selectedAssessmentType = 3;
                          _assessmentTabController.animateTo(3);
                        });
                      },
                      isSelected: _selectedAssessmentType == 3,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Selected Assessment Display - Updated to include PSS-10
          if (_selectedAssessmentType >= 0 && _selectedAssessmentType <= 3)
            Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: TabBarView(
                controller: _assessmentTabController,
                children: [
                  _buildSimplifiedAssessmentTab(
                      'GAD-7', _clinicalScales['GAD-7']!),
                  _buildSimplifiedAssessmentTab(
                      'PHQ-9', _clinicalScales['PHQ-9']!),
                  _buildSimplifiedAssessmentTab(
                      'PSS-10', _clinicalScales['PSS-10']!),
                  _buildSimplifiedAssessmentTab(
                      'Confidence Scale', _clinicalScales['Confidence Scale']!),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssessmentSelectionCard({
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : AppTheme.lightTheme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? color
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? color
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? color
                    : AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimplifiedAssessmentTab(
      String scaleKey, Map<String, dynamic> scale) {
    final questions = scale['questions'] as List<String>;
    final responses = scale['responses'] as List<String>;
    final scores = scale['scores'] as List<int>;
    final totalScore = _calculateTotalScore(scaleKey);
    final maxScore = scale['maxScore'] as int;
    final interpretation = _getScoreInterpretation(scaleKey, totalScore);
    final scoreColor = _getScoreColor(scaleKey, totalScore);
    final reverseScored = scale['reverseScored'] as List<int>? ?? [];

    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scale header with score
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: (scale['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (scale['color'] as Color).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scale['name'],
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        interpretation,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: scoreColor,
                        ),
                      ),
                      if (scaleKey == 'PSS-10')
                        Padding(
                          padding: EdgeInsets.only(top: 0.5.h),
                          child: Text(
                            'Note: Some questions are reverse scored',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: scoreColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$totalScore / $maxScore',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scoreColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Questions - Simplified scrollable list
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: questions.asMap().entries.map((questionEntry) {
                  final questionIndex = questionEntry.key;
                  final question = questionEntry.value;
                  final currentScore =
                      _assessmentScores[scaleKey]?[questionIndex] ?? 0;
                  final isReversed = reverseScored.contains(questionIndex);

                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${questionIndex + 1}. $question',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (isReversed)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'R',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Wrap(
                          spacing: 2.w,
                          children:
                              responses.asMap().entries.map((responseEntry) {
                            final responseIndex = responseEntry.key;
                            final response = responseEntry.value;
                            final scoreValue = scores[responseIndex];
                            final isSelected = currentScore == scoreValue;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _assessmentScores[scaleKey]![questionIndex] =
                                      scoreValue;
                                });

                                // Update emotion level
                                final newTotalScore =
                                    _calculateTotalScore(scaleKey);
                                final normalizedScore =
                                    (newTotalScore / maxScore * 10)
                                        .clamp(1.0, 10.0);
                                widget.onEmotionChanged(normalizedScore);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (scale['color'] as Color)
                                          .withValues(alpha: 0.2)
                                      : AppTheme.lightTheme.colorScheme
                                          .surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected
                                        ? scale['color'] as Color
                                        : AppTheme
                                            .lightTheme.colorScheme.outline
                                            .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  response,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.onSurface
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
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
