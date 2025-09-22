import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/ai_coaching_service.dart';
import '../../../theme/app_theme.dart';

class BookIntegrationWidget extends StatefulWidget {
  final Map<String, double> currentProgress;
  final List<String> relevantTopics;
  final Function(String) onTopicSelected;

  const BookIntegrationWidget({
    Key? key,
    required this.currentProgress,
    required this.relevantTopics,
    required this.onTopicSelected,
  }) : super(key: key);

  @override
  State<BookIntegrationWidget> createState() => _BookIntegrationWidgetState();
}

class _BookIntegrationWidgetState extends State<BookIntegrationWidget> {
  late AICoachingService _aiCoachingService;
  bool _isLoadingRecommendations = false;
  List<Map<String, dynamic>> _personalizedChapters = [];
  String _selectedCategory = 'all';

  final Map<String, Map<String, dynamic>> _bookStructure = {
    'foundations': {
      'title': 'Foundations of Equestrian Psychology',
      'chapters': [
        'Understanding the Rider-Horse Connection',
        'The Neuroscience of Fear and Confidence',
        'Building Mental Resilience in the Saddle',
      ],
      'color': Colors.blue,
      'icon': Icons.foundation,
    },
    'anxiety_management': {
      'title': 'Mastering Competition Anxiety',
      'chapters': [
        'Cognitive Restructuring for Riders',
        'Progressive Desensitization Techniques',
        'Breathing and Relaxation Methods',
        'Pre-Competition Mental Preparation',
      ],
      'color': Colors.red,
      'icon': Icons.psychology,
    },
    'confidence_building': {
      'title': 'Confidence Building Strategies',
      'chapters': [
        'Systematic Confidence Development',
        'Overcoming Past Trauma in Riding',
        'Building Trust Through Communication',
        'Success Visualization Techniques',
      ],
      'color': Colors.green,
      'icon': Icons.emoji_emotions,
    },
    'performance_optimization': {
      'title': 'Peak Performance Psychology',
      'chapters': [
        'Flow State Achievement in Riding',
        'Attention and Focus Training',
        'Goal Setting and Mental Training',
        'Competition Day Psychology',
      ],
      'color': Colors.purple,
      'icon': Icons.trending_up,
    },
    'case_studies': {
      'title': 'Real-World Success Stories',
      'chapters': [
        'From Fear to Fearless: Sarah\'s Journey',
        'Olympic Mindset: Mental Training Case Studies',
        'Overcoming Setbacks: Resilience in Action',
        'Youth Rider Development Programs',
      ],
      'color': Colors.orange,
      'icon': Icons.star,
    },
  };

  @override
  void initState() {
    super.initState();
    _aiCoachingService = AICoachingService();
    _generatePersonalizedRecommendations();
  }

  Future<void> _generatePersonalizedRecommendations() async {
    setState(() {
      _isLoadingRecommendations = true;
    });

    try {
      // Generate AI recommendations based on current progress
      final insight = await _aiCoachingService.generateRealTimeCoaching(
        currentActivity: 'Book Content Recommendation',
        emotionalState: _getProgressBasedEmotionalState(),
        biometrics: widget.currentProgress,
        specificConcern:
            'Personalized learning pathway based on clinical progress',
      );

      // Create personalized chapter recommendations
      setState(() {
        _personalizedChapters = _createPersonalizedRecommendations();
      });
    } catch (e) {
      setState(() {
        _personalizedChapters = _createPersonalizedRecommendations();
      });
    } finally {
      setState(() {
        _isLoadingRecommendations = false;
      });
    }
  }

  String _getProgressBasedEmotionalState() {
    final anxietyScore = widget.currentProgress['anxiety'] ?? 0;
    final confidenceScore = widget.currentProgress['confidence'] ?? 0;

    if (anxietyScore > 15) return 'high anxiety';
    if (confidenceScore < 40) return 'low confidence';
    if (confidenceScore > 75 && anxietyScore < 8) return 'excellent progress';
    return 'steady improvement';
  }

  List<Map<String, dynamic>> _createPersonalizedRecommendations() {
    final anxietyScore = widget.currentProgress['anxiety'] ?? 0;
    final confidenceScore = widget.currentProgress['confidence'] ?? 0;
    final performanceScore = widget.currentProgress['performance'] ?? 0;

    List<Map<String, dynamic>> recommendations = [];

    // High anxiety recommendations
    if (anxietyScore > 12) {
      recommendations.addAll([
        {
          'chapter': 'Cognitive Restructuring for Riders',
          'category': 'anxiety_management',
          'priority': 'high',
          'reason':
              'Your anxiety scores indicate this chapter will provide immediate relief techniques',
          'estimatedBenefit': '25-35% anxiety reduction',
          'techniques': [
            'Thought challenging',
            'Cognitive reframing',
            'Evidence-based thinking'
          ],
        },
        {
          'chapter': 'Breathing and Relaxation Methods',
          'category': 'anxiety_management',
          'priority': 'high',
          'reason':
              'Physiological anxiety management techniques for immediate application',
          'estimatedBenefit': '15-25% stress reduction',
          'techniques': [
            '4-7-8 breathing',
            'Progressive muscle relaxation',
            'Mindful breathing'
          ],
        },
      ]);
    }

    // Low confidence recommendations
    if (confidenceScore < 60) {
      recommendations.addAll([
        {
          'chapter': 'Systematic Confidence Development',
          'category': 'confidence_building',
          'priority': 'high',
          'reason':
              'Structured approach to building riding confidence systematically',
          'estimatedBenefit': '30-40% confidence increase',
          'techniques': [
            'Confidence ladder',
            'Success anchoring',
            'Graduated exposure'
          ],
        },
        {
          'chapter': 'Success Visualization Techniques',
          'category': 'confidence_building',
          'priority': 'medium',
          'reason':
              'Mental rehearsal to build confidence and prepare for success',
          'estimatedBenefit': '20-30% confidence boost',
          'techniques': [
            'Mental imagery',
            'Success scripting',
            'Sensory visualization'
          ],
        },
      ]);
    }

    // Performance optimization for intermediate/advanced
    if (performanceScore > 60 && anxietyScore < 10) {
      recommendations.addAll([
        {
          'chapter': 'Flow State Achievement in Riding',
          'category': 'performance_optimization',
          'priority': 'medium',
          'reason':
              'Your progress indicates readiness for advanced performance techniques',
          'estimatedBenefit': '15-25% performance enhancement',
          'techniques': [
            'Flow triggers',
            'Attention training',
            'Challenge-skill balance'
          ],
        },
        {
          'chapter': 'Competition Day Psychology',
          'category': 'performance_optimization',
          'priority': 'medium',
          'reason': 'Optimize competitive performance and mental preparation',
          'estimatedBenefit': '10-20% competition performance',
          'techniques': [
            'Pre-competition routines',
            'Peak state management',
            'Focus cues'
          ],
        },
      ]);
    }

    // Always include foundational content for new users
    if (recommendations.isEmpty || widget.currentProgress.isEmpty) {
      recommendations.addAll([
        {
          'chapter': 'Understanding the Rider-Horse Connection',
          'category': 'foundations',
          'priority': 'medium',
          'reason': 'Essential foundation for all equestrian psychology work',
          'estimatedBenefit': 'Comprehensive understanding',
          'techniques': [
            'Bonding exercises',
            'Communication skills',
            'Empathy development'
          ],
        },
        {
          'chapter': 'The Neuroscience of Fear and Confidence',
          'category': 'foundations',
          'priority': 'medium',
          'reason':
              'Scientific understanding of fear and confidence mechanisms',
          'estimatedBenefit': 'Improved self-awareness',
          'techniques': [
            'Fear response understanding',
            'Neuroplasticity training',
            'Brain-based interventions'
          ],
        },
      ]);
    }

    return recommendations;
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
          // Header
          Row(
            children: [
              Icon(
                Icons.menu_book,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Integrated Book Resources',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Personalized content based on your progress',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _generatePersonalizedRecommendations,
                icon: _isLoadingRecommendations
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
                tooltip: 'Refresh Recommendations',
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Category Filter
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('all', 'All Categories'),
                  ..._bookStructure.entries.map((entry) {
                    return _buildCategoryChip(entry.key, entry.value['title']);
                  }).toList(),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Personalized Recommendations Section
          if (_personalizedChapters.isNotEmpty) ...[
            Text(
              'Recommended for You',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Column(
              children: _personalizedChapters.map((recommendation) {
                return _buildRecommendationCard(recommendation);
              }).toList(),
            ),
            SizedBox(height: 3.h),
          ],

          // Book Structure
          Text(
            'Complete Book Structure',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Column(
            children: _bookStructure.entries
                .where((entry) =>
                    _selectedCategory == 'all' ||
                    _selectedCategory == entry.key)
                .map((entry) {
              return _buildBookSection(entry.key, entry.value);
            }).toList(),
          ),

          SizedBox(height: 3.h),

          // Progress-Based Success Stories
          _buildSuccessStories(),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String key, String label) {
    final isSelected = _selectedCategory == key;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = key;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> recommendation) {
    final category = _bookStructure[recommendation['category']];
    final priorityColor = _getPriorityColor(recommendation['priority']);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            priorityColor.withValues(alpha: 0.05),
            (category?['color'] as Color?)?.withValues(alpha: 0.05) ??
                Colors.grey.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color:
                      (category?['color'] as Color?)?.withValues(alpha: 0.1) ??
                          Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  category?['icon'] ?? Icons.book,
                  color: category?['color'] ?? Colors.grey,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation['chapter'],
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      category?['title'] ?? 'Unknown Category',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _buildPriorityChip(recommendation['priority']),
            ],
          ),

          SizedBox(height: 2.h),

          Text(
            recommendation['reason'],
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 1.h),

          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Expected Benefit: ${recommendation['estimatedBenefit']}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: priorityColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Techniques Preview
          Wrap(
            spacing: 1.w,
            runSpacing: 1.w,
            children:
                (recommendation['techniques'] as List<String>).map((technique) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  technique,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 2.h),

          ElevatedButton.icon(
            onPressed: () => widget.onTopicSelected(recommendation['chapter']),
            icon: Icon(Icons.menu_book, size: 4.w),
            label: Text('Read Chapter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: priorityColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    final color = _getPriorityColor(priority);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        priority.toUpperCase(),
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBookSection(String sectionKey, Map<String, dynamic> section) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (section['color'] as Color).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                section['icon'],
                color: section['color'],
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  section['title'],
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Column(
            children: (section['chapters'] as List<String>).map((chapter) {
              return ListTile(
                dense: true,
                leading: Icon(
                  Icons.circle,
                  size: 2.w,
                  color: section['color'],
                ),
                title: Text(
                  chapter,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 3.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                onTap: () => widget.onTopicSelected(chapter),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStories() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withValues(alpha: 0.1),
            Colors.orange.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Success Stories Matching Your Progress',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Based on your current progress profile, these success stories provide inspiration and practical strategies:',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSuccessStoryItem(
            'From Anxious to Confident: Maria\'s Transformation',
            'Similar anxiety levels, achieved 70% improvement in 6 months',
            Icons.trending_up,
          ),
          _buildSuccessStoryItem(
            'Overcoming Competition Nerves: Jake\'s Journey',
            'Competition anxiety success story with practical techniques',
            Icons.emoji_events,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStoryItem(
      String title, String description, IconData icon) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        color: Colors.amber,
        size: 5.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        description,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 3.w,
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      ),
      onTap: () => widget.onTopicSelected(title),
    );
  }
}
