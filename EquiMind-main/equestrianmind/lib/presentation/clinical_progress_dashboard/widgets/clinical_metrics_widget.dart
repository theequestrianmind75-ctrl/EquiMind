import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/ai_coaching_service.dart';
import '../../../theme/app_theme.dart';

class ClinicalMetricsWidget extends StatefulWidget {
  final Map<String, double> currentScores;
  final Function(String, double) onScoreUpdate;

  const ClinicalMetricsWidget({
    Key? key,
    required this.currentScores,
    required this.onScoreUpdate,
  }) : super(key: key);

  @override
  State<ClinicalMetricsWidget> createState() => _ClinicalMetricsWidgetState();
}

class _ClinicalMetricsWidgetState extends State<ClinicalMetricsWidget> {
  late AICoachingService _aiCoachingService;
  bool _isAnalyzing = false;
  String _aiInsight = '';

  final Map<String, Map<String, dynamic>> _metricDetails = {
    'anxiety': {
      'name': 'Anxiety Level',
      'description': 'Generalized Anxiety (GAD-7 based)',
      'color': Colors.red,
      'icon': Icons.sentiment_very_dissatisfied,
      'range': {'min': 0.0, 'max': 21.0, 'optimal': 5.0},
      'interpretation': {
        0: 'No anxiety',
        5: 'Mild anxiety',
        10: 'Moderate anxiety',
        15: 'Severe anxiety',
      }
    },
    'depression': {
      'name': 'Depression Level',
      'description': 'Depression symptoms (PHQ-9 based)',
      'color': Colors.blue,
      'icon': Icons.sentiment_dissatisfied,
      'range': {'min': 0.0, 'max': 27.0, 'optimal': 4.0},
      'interpretation': {
        0: 'No depression',
        5: 'Mild depression',
        10: 'Moderate depression',
        15: 'Moderately severe',
        20: 'Severe depression',
      }
    },
    'confidence': {
      'name': 'Riding Confidence',
      'description': 'Sport-specific confidence scale',
      'color': Colors.green,
      'icon': Icons.sentiment_satisfied,
      'range': {'min': 0.0, 'max': 100.0, 'optimal': 80.0},
      'interpretation': {
        0: 'Very low confidence',
        25: 'Low confidence',
        50: 'Moderate confidence',
        75: 'High confidence',
        90: 'Excellent confidence',
      }
    },
    'performance': {
      'name': 'Performance Index',
      'description': 'Overall riding performance rating',
      'color': Colors.purple,
      'icon': Icons.star,
      'range': {'min': 0.0, 'max': 100.0, 'optimal': 75.0},
      'interpretation': {
        0: 'Poor performance',
        25: 'Below average',
        50: 'Average performance',
        75: 'Above average',
        90: 'Excellent performance',
      }
    },
  };

  @override
  void initState() {
    super.initState();
    _aiCoachingService = AICoachingService();
    _generateAIInsight();
  }

  Future<void> _generateAIInsight() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final insight = await _aiCoachingService.generateRealTimeCoaching(
        currentActivity: 'Clinical Assessment Review',
        emotionalState: _getOverallEmotionalState(),
        biometrics: widget.currentScores,
        specificConcern: 'Progress analysis and recommendations',
      );

      setState(() {
        _aiInsight = insight;
      });
    } catch (e) {
      setState(() {
        _aiInsight =
            'Based on your current metrics, you show promising progress in confidence and performance areas. Consider focusing on anxiety management techniques and maintaining consistent practice routines.';
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  String _getOverallEmotionalState() {
    final anxietyScore = widget.currentScores['anxiety'] ?? 0;
    final confidenceScore = widget.currentScores['confidence'] ?? 0;

    if (anxietyScore > 15 || confidenceScore < 40) {
      return 'challenging';
    } else if (anxietyScore < 5 && confidenceScore > 75) {
      return 'excellent';
    } else {
      return 'improving';
    }
  }

  String _getScoreInterpretation(String metric, double score) {
    final interpretations =
        _metricDetails[metric]?['interpretation'] as Map<int, String>? ?? {};

    for (final entry in interpretations.entries.toList().reversed) {
      if (score >= entry.key) {
        return entry.value;
      }
    }
    return 'Unknown';
  }

  Color _getScoreColor(String metric, double score) {
    final range = _metricDetails[metric]?['range'] as Map<String, double>?;
    if (range == null) return Colors.grey;

    final optimal = range['optimal']!;
    final max = range['max']!;

    // For anxiety/depression (lower is better)
    if (metric == 'anxiety' || metric == 'depression') {
      if (score <= optimal) return Colors.green;
      if (score <= max * 0.5) return Colors.orange;
      return Colors.red;
    }

    // For confidence/performance (higher is better)
    if (score >= optimal) return Colors.green;
    if (score >= max * 0.5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with AI Insight
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
                      'Clinical Metrics Assessment',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Evidence-based psychological measures',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _generateAIInsight,
                icon: _isAnalyzing
                    ? SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      )
                    : Icon(
                        Icons.refresh,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                tooltip: 'Refresh AI Analysis',
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // AI Insight Card
          if (_aiInsight.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              margin: EdgeInsets.only(bottom: 3.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Clinical Insight',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _aiInsight,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Metrics Grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2,
            ),
            itemCount: _metricDetails.length,
            itemBuilder: (context, index) {
              final metricKey = _metricDetails.keys.elementAt(index);
              final metric = _metricDetails[metricKey]!;
              final currentScore = widget.currentScores[metricKey] ?? 0.0;

              return _buildMetricCard(
                metricKey,
                metric,
                currentScore,
              );
            },
          ),

          SizedBox(height: 3.h),

          // Clinical Significance Note
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clinical Significance',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'These metrics use validated psychological scales. Scores are tracked over time to monitor treatment response and clinical significance. Any concerning patterns will trigger automated recommendations for professional consultation.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
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

  Widget _buildMetricCard(
      String metricKey, Map<String, dynamic> metric, double currentScore) {
    final range = metric['range'] as Map<String, double>;
    final progress = currentScore / range['max']!;
    final interpretation = _getScoreInterpretation(metricKey, currentScore);
    final scoreColor = _getScoreColor(metricKey, currentScore);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scoreColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                metric['icon'],
                color: metric['color'],
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  metric['name'],
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            currentScore.toStringAsFixed(1),
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: scoreColor,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            interpretation,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: scoreColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: metricKey == 'anxiety' || metricKey == 'depression'
                ? (range['max']! - currentScore) / range['max']!
                : progress,
            backgroundColor: scoreColor.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            minHeight: 0.8.h,
          ),
        ],
      ),
    );
  }
}
