import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';

class AssessmentQuestionnaireScreen extends StatefulWidget {
  const AssessmentQuestionnaireScreen({super.key});

  @override
  State<AssessmentQuestionnaireScreen> createState() =>
      _AssessmentQuestionnaireScreenState();
}

class _AssessmentQuestionnaireScreenState
    extends State<AssessmentQuestionnaireScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Map<String, dynamic>? _assessmentData;
  String? _assessmentType;
  Map<int, int> _answers = {};
  int _currentQuestionIndex = 0;
  bool _isCompleted = false;

  final Map<String, Map<String, dynamic>> _assessmentQuestions = {
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
      ], // Questions with reverse scoring (0-indexed)
    },
    'EQCS': {
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
    },
    'HHRQ': {
      'name': 'Horse-Human Relationship Quality',
      'questions': [
        'I feel emotionally connected to my horse',
        'My horse seems to understand my moods and emotions',
        'I can easily communicate with my horse through non-verbal cues',
        'My horse appears calm and relaxed when I am around',
        'I trust my horse completely during our interactions',
        'My horse responds positively to my presence',
        'I feel that my horse and I work well together as a team',
        'My horse shows affection towards me',
        'I understand my horse\'s body language and signals',
        'My horse seems to enjoy our time together',
      ],
      'responses': ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
      'scores': [1, 2, 3, 4, 5],
      'maxScore': 50,
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _assessmentType = args['assessmentType'] as String?;
          _assessmentData = args['assessmentData'] as Map<String, dynamic>?;
        });
      }
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _calculateScore() {
    if (_assessmentType == null) return 0;

    final questionnaire = _assessmentQuestions[_assessmentType!];
    if (questionnaire == null) return 0;

    final scores = questionnaire['scores'] as List<int>;
    final reverseScored = questionnaire['reverseScored'] as List<int>? ?? [];

    int totalScore = 0;

    _answers.forEach((questionIndex, answerIndex) {
      int score = scores[answerIndex];

      // Handle reverse scoring for PSS-10
      if (_assessmentType == 'PSS-10' &&
          reverseScored.contains(questionIndex)) {
        final maxItemScore = scores.reduce((a, b) => a > b ? a : b);
        score = maxItemScore - score;
      }

      totalScore += score;
    });

    return totalScore;
  }

  String _getScoreInterpretation(int score) {
    switch (_assessmentType) {
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
      case 'EQCS':
        final percentage = (score / 50 * 100);
        if (percentage >= 80) return 'High confidence';
        if (percentage >= 60) return 'Moderate confidence';
        if (percentage >= 40) return 'Low-moderate confidence';
        return 'Low confidence';
      case 'HHRQ':
        final percentage = (score / 50 * 100);
        if (percentage >= 80) return 'Excellent relationship';
        if (percentage >= 60) return 'Good relationship';
        if (percentage >= 40) return 'Fair relationship';
        return 'Needs improvement';
      default:
        return 'Score: $score';
    }
  }

  Color _getScoreColor(int score) {
    switch (_assessmentType) {
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
      case 'EQCS':
      case 'HHRQ':
        final maxScore =
            _assessmentQuestions[_assessmentType!]!['maxScore'] as int;
        final percentage = (score / maxScore * 100);
        if (percentage >= 80) return Colors.green;
        if (percentage >= 60) return Colors.lightGreen;
        if (percentage >= 40) return Colors.orange;
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _nextQuestion() {
    final questionnaire = _assessmentQuestions[_assessmentType!];
    if (questionnaire == null) return;

    final questions = questionnaire['questions'] as List<String>;

    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      _completeAssessment();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _completeAssessment() {
    setState(() {
      _isCompleted = true;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_assessmentType == null ||
        _assessmentQuestions[_assessmentType!] == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          title: const Text('Assessment Error'),
          backgroundColor: AppTheme.primaryLight,
          foregroundColor: AppTheme.onPrimaryLight,
        ),
        body: const Center(
          child: Text('Assessment data not found'),
        ),
      );
    }

    final questionnaire = _assessmentQuestions[_assessmentType!]!;
    final questions = questionnaire['questions'] as List<String>;
    final responses = questionnaire['responses'] as List<String>;
    final scores = questionnaire['scores'] as List<int>;
    final maxScore = questionnaire['maxScore'] as int;
    final reverseScored = questionnaire['reverseScored'] as List<int>? ?? [];

    if (_isCompleted) {
      final finalScore = _calculateScore();
      final interpretation = _getScoreInterpretation(finalScore);
      final scoreColor = _getScoreColor(finalScore);

      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          title: Text('${questionnaire['name']} - Results'),
          backgroundColor: AppTheme.primaryLight,
          foregroundColor: AppTheme.onPrimaryLight,
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: scoreColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3.w),
                            border: Border.all(
                                color: scoreColor.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: scoreColor,
                                size: 12.w,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Assessment Complete',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimaryLight,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Your Score: $finalScore / $maxScore',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: scoreColor,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                interpretation,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: scoreColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Your Responses:',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryLight,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        ...questions.asMap().entries.map((entry) {
                          final questionIndex = entry.key;
                          final question = entry.value;
                          final answerIndex = _answers[questionIndex];
                          final isReversed =
                              reverseScored.contains(questionIndex);

                          return Container(
                            margin: EdgeInsets.only(bottom: 2.h),
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceLight,
                              borderRadius: BorderRadius.circular(2.w),
                              border: Border.all(
                                color: AppTheme.primaryLight
                                    .withValues(alpha: 0.2),
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
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textPrimaryLight,
                                        ),
                                      ),
                                    ),
                                    if (isReversed)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.w,
                                          vertical: 0.5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange
                                              .withValues(alpha: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(1.w),
                                        ),
                                        child: Text(
                                          'R',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                if (answerIndex != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                      vertical: 1.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryLight
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(1.w),
                                    ),
                                    child: Text(
                                      'Answer: ${responses[answerIndex]}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppTheme.primaryLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back to Hub'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/clinical-progress-dashboard',
                            (route) =>
                                route.settings.name ==
                                '/clinical-assessment-hub',
                          );
                        },
                        child: const Text('View Progress'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(questionnaire['name']),
        backgroundColor: AppTheme.primaryLight,
        foregroundColor: AppTheme.onPrimaryLight,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Center(
              child: Text(
                '${_currentQuestionIndex + 1}/${questions.length}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / questions.length,
            backgroundColor: AppTheme.primaryLight.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
            minHeight: 1.h,
          ),

          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(3.w),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.shadowLight,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  questions[_currentQuestionIndex],
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimaryLight,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              if (reverseScored.contains(_currentQuestionIndex))
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(1.w),
                                  ),
                                  child: Text(
                                    'Reverse Scored',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          ...responses.asMap().entries.map((entry) {
                            final responseIndex = entry.key;
                            final response = entry.value;
                            final isSelected =
                                _answers[_currentQuestionIndex] ==
                                    responseIndex;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _answers[_currentQuestionIndex] =
                                      responseIndex;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 2.h),
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primaryLight
                                          .withValues(alpha: 0.1)
                                      : AppTheme.backgroundLight,
                                  borderRadius: BorderRadius.circular(2.w),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primaryLight
                                        : AppTheme.outlineLight
                                            .withValues(alpha: 0.3),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? AppTheme.primaryLight
                                          : AppTheme.textSecondaryLight,
                                      size: 5.w,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        response,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: isSelected
                                              ? AppTheme.textPrimaryLight
                                              : AppTheme.textSecondaryLight,
                                          fontWeight: isSelected
                                              ? FontWeight.w500
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousQuestion,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _answers[_currentQuestionIndex] != null
                        ? _nextQuestion
                        : null,
                    icon: Icon(
                      _currentQuestionIndex == questions.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      _currentQuestionIndex == questions.length - 1
                          ? 'Complete'
                          : 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}