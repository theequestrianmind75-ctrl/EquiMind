import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/ai_coaching_service.dart';
import './widgets/book_integration_widget.dart';
import './widgets/clinical_metrics_widget.dart';
import './widgets/clinical_report_widget.dart';
import './widgets/goal_tracking_widget.dart';
import './widgets/intervention_tracking_widget.dart';
import './widgets/outcome_measures_widget.dart';
import './widgets/progress_analytics_widget.dart';
import './widgets/risk_monitoring_widget.dart';

class ClinicalProgressDashboard extends StatefulWidget {
  const ClinicalProgressDashboard({Key? key}) : super(key: key);

  @override
  State<ClinicalProgressDashboard> createState() =>
      _ClinicalProgressDashboardState();
}

class _ClinicalProgressDashboardState extends State<ClinicalProgressDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AICoachingService _aiCoachingService;

  bool _isLoading = false;
  Map<String, dynamic> _clinicalData = {};
  List<Map<String, dynamic>> _recentAssessments = [];
  Map<String, double> _currentScores = {
    'anxiety': 0.0,
    'depression': 0.0,
    'confidence': 0.0,
    'performance': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _aiCoachingService = AICoachingService();
    _loadClinicalData();
  }

  Future<void> _loadClinicalData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate loading clinical data
      await Future.delayed(Duration(milliseconds: 500));

      setState(() {
        _clinicalData = {
          'lastAssessment': DateTime.now().subtract(Duration(days: 2)),
          'totalSessions': 24,
          'improvementTrend': 'positive',
          'riskLevel': 'low',
          'nextRecommendation': 'Continue current intervention protocol',
        };

        _recentAssessments = [
          {
            'date': DateTime.now().subtract(Duration(days: 2)),
            'type': 'GAD-7',
            'score': 8,
            'severity': 'Mild',
            'change': -2,
          },
          {
            'date': DateTime.now().subtract(Duration(days: 7)),
            'type': 'PHQ-9',
            'score': 6,
            'severity': 'Mild',
            'change': -3,
          },
          {
            'date': DateTime.now().subtract(Duration(days: 14)),
            'type': 'DASS-21',
            'score': 12,
            'severity': 'Normal',
            'change': -5,
          },
        ];

        _currentScores = {
          'anxiety': 32.0,
          'depression': 28.0,
          'confidence': 78.0,
          'performance': 82.0,
        };
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load clinical data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _loadClinicalData,
        ),
      ),
    );
  }

  Future<void> _generateClinicalReport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reportData = await _aiCoachingService.generateRideInsights(
        rideData: _clinicalData,
        emotionalState: 'improving',
        performanceMetrics: _currentScores,
      );

      if (mounted) {
        Navigator.pushNamed(
          context,
          '/clinical-report',
          arguments: {
            'reportData': reportData,
            'assessments': _recentAssessments,
            'scores': _currentScores,
          },
        );
      }
    } catch (e) {
      _showErrorSnackBar('Failed to generate clinical report: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Clinical Progress Dashboard',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
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
            onPressed: _generateClinicalReport,
            icon: CustomIconWidget(
              iconName: 'assessment',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
            tooltip: 'Generate Clinical Report',
          ),
          IconButton(
            onPressed: _loadClinicalData,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
            tooltip: 'Refresh Data',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'trending_up',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              text: 'Analytics',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'psychology',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              text: 'Interventions',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'book',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              text: 'Resources',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'flag',
                size: 5.w,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              text: 'Goals',
            ),
          ],
          labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: AppTheme.lightTheme.colorScheme.secondary,
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading clinical data...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Clinical Overview Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
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
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildOverviewMetric(
                          'Current Status',
                          _clinicalData['improvementTrend'] == 'positive'
                              ? 'Improving'
                              : 'Stable',
                          Icons.trending_up,
                          Colors.green,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildOverviewMetric(
                          'Risk Level',
                          _clinicalData['riskLevel'] ?? 'Low',
                          Icons.security,
                          _getRiskColor(_clinicalData['riskLevel']),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildOverviewMetric(
                          'Sessions',
                          '${_clinicalData['totalSessions'] ?? 0}',
                          Icons.event_note,
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Analytics Tab
                      SingleChildScrollView(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          children: [
                            ProgressAnalyticsWidget(
                              scores: _currentScores,
                              assessments: _recentAssessments,
                            ),
                            SizedBox(height: 3.h),
                            OutcomeMeasuresWidget(
                              currentScores: _currentScores,
                              historicalData: _recentAssessments,
                            ),
                            SizedBox(height: 3.h),
                            RiskMonitoringWidget(
                              riskLevel: _clinicalData['riskLevel'] ?? 'low',
                              lastAssessment: _clinicalData['lastAssessment'],
                              recommendations: [
                                _clinicalData['nextRecommendation'] ??
                                    'Continue monitoring'
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Interventions Tab
                      SingleChildScrollView(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          children: [
                            ClinicalMetricsWidget(
                              currentScores: _currentScores,
                              onScoreUpdate: (String metric, double score) {
                                setState(() {
                                  _currentScores[metric] = score;
                                });
                              },
                            ),
                            SizedBox(height: 3.h),
                            InterventionTrackingWidget(
                              activeInterventions: [
                                {
                                  'name': 'Cognitive Behavioral Therapy',
                                  'type': 'CBT',
                                  'duration': 12,
                                  'progress': 75.0,
                                  'effectiveness': 'high',
                                },
                                {
                                  'name': 'Mindfulness-Based Stress Reduction',
                                  'type': 'MBSR',
                                  'duration': 8,
                                  'progress': 60.0,
                                  'effectiveness': 'medium',
                                },
                              ],
                              onInterventionSelected: (intervention) {
                                // Handle intervention selection
                              },
                            ),
                          ],
                        ),
                      ),

                      // Resources Tab
                      SingleChildScrollView(
                        padding: EdgeInsets.all(4.w),
                        child: BookIntegrationWidget(
                          currentProgress: _currentScores,
                          relevantTopics: [
                            'Anxiety Management in Equestrian Sports',
                            'Building Confidence Through Progressive Exposure',
                            'The Mind-Body Connection in Riding',
                            'Overcoming Performance Anxiety',
                          ],
                          onTopicSelected: (String topic) {
                            // Navigate to book content
                          },
                        ),
                      ),

                      // Goals Tab
                      SingleChildScrollView(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          children: [
                            GoalTrackingWidget(
                              goals: [
                                {
                                  'id': '1',
                                  'title': 'Reduce Pre-Competition Anxiety',
                                  'type': 'SMART',
                                  'target': 'Decrease GAD-7 score to below 5',
                                  'progress': 65.0,
                                  'deadline':
                                      DateTime.now().add(Duration(days: 30)),
                                  'milestones': [
                                    'Week 1: Learn breathing techniques',
                                    'Week 2: Practice visualization'
                                  ],
                                },
                                {
                                  'id': '2',
                                  'title': 'Improve Riding Confidence',
                                  'type': 'SMART',
                                  'target':
                                      'Achieve 85% confidence rating in self-assessments',
                                  'progress': 45.0,
                                  'deadline':
                                      DateTime.now().add(Duration(days: 60)),
                                  'milestones': [
                                    'Complete 10 successful training sessions',
                                    'Participate in local show'
                                  ],
                                },
                              ],
                              onGoalUpdate: (String goalId, double progress) {
                                // Handle goal progress update
                              },
                            ),
                            SizedBox(height: 3.h),
                            ClinicalReportWidget(
                              lastReport: _clinicalData['lastAssessment'],
                              onGenerateReport: _generateClinicalReport,
                              onShareReport: () {
                                // Handle report sharing
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildOverviewMetric(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String? riskLevel) {
    switch (riskLevel?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
      case 'moderate':
        return Colors.orange;
      case 'low':
      default:
        return Colors.green;
    }
  }
}
