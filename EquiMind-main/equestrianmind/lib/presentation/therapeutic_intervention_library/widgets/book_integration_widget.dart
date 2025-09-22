import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';

class BookIntegrationWidget extends StatefulWidget {
  final String selectedCategory;

  const BookIntegrationWidget({
    super.key,
    required this.selectedCategory,
  });

  @override
  State<BookIntegrationWidget> createState() => _BookIntegrationWidgetState();
}

class _BookIntegrationWidgetState extends State<BookIntegrationWidget> {
  List<Map<String, dynamic>> _bookContent = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBookContent();
  }

  @override
  void didUpdateWidget(BookIntegrationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _loadBookContent();
    }
  }

  void _loadBookContent() {
    setState(() => _isLoading = true);

    // Simulate loading book content based on selected category
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _bookContent = _generateBookContent(widget.selectedCategory);
          _isLoading = false;
        });
      }
    });
  }

  List<Map<String, dynamic>> _generateBookContent(String category) {
    switch (category) {
      case 'CBT':
        return [
          {
            'type': 'chapter',
            'title': 'Chapter 6: Cognitive Restructuring for Riders',
            'pages': '145-168',
            'summary':
                'Learn evidence-based techniques for identifying and challenging negative thought patterns that impact riding performance and confidence.',
            'keyTopics': [
              'Thought Records',
              'Cognitive Distortions',
              'Behavioral Experiments'
            ],
            'exercises': [
              'Pre-Ride Thought Analysis Worksheet',
              'Fear-Based Thinking Challenge Exercise',
              'Performance Anxiety Restructuring Protocol',
            ],
            'caseStudies': [
              'Sarah\'s Journey: From Fear to Confidence',
              'Mark\'s Competition Anxiety Transformation',
            ],
          },
          {
            'type': 'chapter',
            'title': 'Chapter 7: Evidence-Based Interventions for Riders',
            'pages': '169-195',
            'summary':
                'Comprehensive guide to implementing CBT techniques specifically adapted for equestrian sports psychology.',
            'keyTopics': [
              'Intervention Planning',
              'Progress Measurement',
              'Relapse Prevention'
            ],
            'exercises': [
              'Personal CBT Protocol Development',
              'Weekly Progress Tracking System',
              'Emergency Coping Skills Toolkit',
            ],
            'caseStudies': [
              'Emma\'s Professional Riding Career Recovery',
              'David\'s Return to Competition After Injury',
            ],
          },
        ];

      case 'MINDFULNESS':
        return [
          {
            'type': 'chapter',
            'title': 'Chapter 8: Mindful Riding Techniques',
            'pages': '201-235',
            'summary':
                'Discover how mindfulness practices can enhance the horse-rider relationship and improve performance through present-moment awareness.',
            'keyTopics': [
              'Body Awareness',
              'Breath Synchronization',
              'Emotional Regulation'
            ],
            'exercises': [
              'Horse-Human Connection Meditation',
              'Mindful Mounting Sequence',
              'Present-Moment Awareness Training',
            ],
            'caseStudies': [
              'Lisa\'s Breakthrough in Hunter/Jumper Competition',
              'Michael\'s Dressage Performance Enhancement',
            ],
          },
          {
            'type': 'chapter',
            'title': 'Chapter 9: Advanced Mindfulness for Competition',
            'pages': '236-268',
            'summary':
                'Advanced mindfulness techniques specifically designed for high-pressure competitive environments.',
            'keyTopics': [
              'Competition Mindfulness',
              'Pressure Management',
              'Flow State Cultivation'
            ],
            'exercises': [
              'Competition Preparation Meditation',
              'Ring Entrance Mindfulness Protocol',
              'Post-Performance Integration Practice',
            ],
            'caseStudies': [
              'Olympic Rider\'s Mental Training Program',
              'Young Rider\'s Competition Confidence Building',
            ],
          },
        ];

      case 'EXPOSURE':
        return [
          {
            'type': 'chapter',
            'title': 'Chapter 10: Systematic Desensitization for Riders',
            'pages': '275-308',
            'summary':
                'Step-by-step guide to overcoming riding fears through gradual, systematic exposure therapy protocols.',
            'keyTopics': [
              'Fear Hierarchy',
              'Exposure Planning',
              'Safety Protocols'
            ],
            'exercises': [
              'Personal Fear Assessment Scale',
              'Graduated Exposure Schedule',
              'Safety Resource Development',
            ],
            'caseStudies': [
              'Jennifer\'s Recovery from Serious Fall',
              'Tom\'s Trailer Loading Anxiety Resolution',
            ],
          },
        ];

      case 'EQUINE_ASSISTED':
        return [
          {
            'type': 'chapter',
            'title': 'Chapter 12: The Therapeutic Horse-Human Bond',
            'pages': '345-380',
            'summary':
                'Explore the unique therapeutic benefits of the horse-human relationship and how to cultivate healing connections.',
            'keyTopics': [
              'Attachment Theory',
              'Emotional Mirroring',
              'Trust Building'
            ],
            'exercises': [
              'Ground Work Relationship Building',
              'Energy Awareness Training',
              'Communication Without Words',
            ],
            'caseStudies': [
              'Rachel\'s Trauma Recovery Through Horses',
              'Alex\'s Autism Spectrum Support Program',
            ],
          },
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
                ),
                SizedBox(height: 4.w),
                Text(
                  'Loading book content...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 4.w),
                if (_bookContent.isEmpty)
                  _buildEmptyState()
                else
                  ..._bookContent.map((content) => _buildContentCard(content)),
              ],
            ),
          );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryLight.withValues(alpha: 0.1),
            AppTheme.accentLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_stories,
            color: AppTheme.primaryLight,
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Content Integration',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                Text(
                  'Relevant chapters and exercises for ${_getCategoryDisplayName(widget.selectedCategory)} interventions',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.book_outlined,
              size: 20.w,
              color: AppTheme.textSecondaryLight,
            ),
            SizedBox(height: 4.w),
            Text(
              'No Book Content Available',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 2.w),
            Text(
              'Select an intervention category to view relevant book chapters and exercises',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(Map<String, dynamic> content) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.w),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.w),
                  topRight: Radius.circular(3.w),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    color: AppTheme.primaryLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content['title'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryLight,
                          ),
                        ),
                        Text(
                          'Pages ${content['pages']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.primaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary
                  Text(
                    content['summary'],
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppTheme.textPrimaryLight,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 3.w),

                  // Key Topics
                  if (content['keyTopics'] != null) ...[
                    Text(
                      'Key Topics:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 2.w),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.w,
                      children: (content['keyTopics'] as List<String>)
                          .map((topic) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 1.w,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryLight
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(1.w),
                                ),
                                child: Text(
                                  topic,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppTheme.primaryLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 3.w),
                  ],

                  // Exercises
                  if (content['exercises'] != null) ...[
                    Text(
                      'Practical Exercises:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 2.w),
                    ...(content['exercises'] as List<String>)
                        .map((exercise) => Container(
                              margin: EdgeInsets.only(bottom: 1.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 1.5.w,
                                    height: 1.5.w,
                                    margin: EdgeInsets.only(top: 1.5.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme.successLight,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      exercise,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppTheme.textPrimaryLight,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                    SizedBox(height: 3.w),
                  ],

                  // Case Studies
                  if (content['caseStudies'] != null) ...[
                    Text(
                      'Case Studies:',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 2.w),
                    ...(content['caseStudies'] as List<String>)
                        .map((caseStudy) => Container(
                              margin: EdgeInsets.only(bottom: 2.w),
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme.accentLight
                                    .withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(
                                  color: AppTheme.accentLight
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: AppTheme.accentLight,
                                    size: 4.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      caseStudy,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppTheme.textPrimaryLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ],
                ],
              ),
            ),

            // Action Buttons
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(3.w),
                  bottomRight: Radius.circular(3.w),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewChapter(content),
                      icon: Icon(Icons.visibility_outlined, size: 4.w),
                      label: Text('View Chapter'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 3.w),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _startExercises(content),
                      icon: Icon(Icons.play_arrow, size: 4.w),
                      label: Text('Start Exercises'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 3.w),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'CBT':
        return 'CBT Techniques';
      case 'MINDFULNESS':
        return 'Mindfulness Practices';
      case 'EXPOSURE':
        return 'Exposure Therapy';
      case 'EQUINE_ASSISTED':
        return 'Equine-Assisted';
      default:
        return category;
    }
  }

  void _viewChapter(Map<String, dynamic> content) {
    Navigator.pushNamed(
      context,
      '/book-chapter-viewer',
      arguments: content,
    );
  }

  void _startExercises(Map<String, dynamic> content) {
    Navigator.pushNamed(
      context,
      '/book-exercises',
      arguments: content,
    );
  }
}
