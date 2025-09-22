import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_coaching_tools_widget.dart';
import './widgets/greeting_header.dart';
import './widgets/quick_start_card.dart';
import './widgets/recent_activity_card.dart';
import './widgets/upcoming_sessions_card.dart';
import './widgets/weather_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock data
  final String riderName = "Sarah Johnson";
  final String emotionalState = "confident";

  final Map<String, dynamic> lastRideData = {
    "sessionType": "Dressage Training",
    "date": "Today, 2:30 PM",
    "duration": "45 min",
    "performance": "8.5/10",
    "confidence": "92%",
    "aiInsight":
        "Excellent improvement in seat stability during transitions. Your breathing patterns were consistent throughout the session. Focus on maintaining soft hands during collection work.",
  };

  final List<Map<String, dynamic>> upcomingSessions = [
    {
      "id": 1,
      "title": "Jump Training Session",
      "description": "Focus on grid work and combination jumps",
      "type": "training",
      "time": "10:00 AM",
      "duration": "60 min",
      "scheduledFor": "2025-08-18T10:00:00.000Z",
    },
    {
      "id": 2,
      "title": "Mental Preparation Coaching",
      "description": "Pre-competition anxiety management",
      "type": "coaching",
      "time": "3:00 PM",
      "duration": "45 min",
      "scheduledFor": "2025-08-19T15:00:00.000Z",
    },
    {
      "id": 3,
      "title": "Performance Assessment",
      "description": "Monthly progress evaluation",
      "type": "assessment",
      "time": "11:00 AM",
      "duration": "90 min",
      "scheduledFor": "2025-08-20T11:00:00.000Z",
    },
  ];

  Map<String, dynamic>? weatherData = {
    "temperature": 24,
    "condition": "Partly Cloudy",
    "humidity": 68,
    "windSpeed": 12,
    "visibility": 15,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      weatherData = {
        "temperature": 26,
        "condition": "Sunny",
        "humidity": 62,
        "windSpeed": 8,
        "visibility": 18,
      };
    });
  }

  void _handleEmergencySupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Emergency Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Immediate anxiety management tools:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildEmergencyOption('Breathing Exercise', 'air', () {
              Navigator.pop(context);
              _startBreathingExercise();
            }),
            _buildEmergencyOption('Grounding Technique', 'psychology', () {
              Navigator.pop(context);
              _startGroundingTechnique();
            }),
            _buildEmergencyOption('Call Support', 'phone', () {
              Navigator.pop(context);
              _callSupport();
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyOption(
      String title, String iconName, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _startBreathingExercise() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting 4-7-8 breathing exercise...'),
        action: SnackBarAction(
          label: 'Begin',
          onPressed: () {},
        ),
      ),
    );
  }

  void _startGroundingTechnique() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting 5-4-3-2-1 grounding technique...'),
        action: SnackBarAction(
          label: 'Begin',
          onPressed: () {},
        ),
      ),
    );
  }

  void _callSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting to support team...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _startSession() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Start New Session',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildSessionOption(
              'Pre-Ride Preparation',
              'Emotional regulation and mental preparation',
              'psychology',
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.preRidePreparation);
              },
            ),
            _buildSessionOption(
              'During Ride Coaching',
              'Real-time AI coaching and guidance',
              'headset_mic',
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.duringRideCoaching);
              },
            ),
            _buildSessionOption(
              'Post-Ride Analysis',
              'Performance review and insights',
              'analytics',
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.postRideAnalysis);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionOption(
    String title,
    String description,
    String iconName,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
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
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
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
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'home',
                      color: _tabController.index == 0
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Home',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'psychology',
                      color: _tabController.index == 1
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Coaching',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'trending_up',
                      color: _tabController.index == 2
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Progress',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'person',
                      color: _tabController.index == 3
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Profile',
                  ),
                ],
                onTap: (index) {
                  setState(() {});
                },
              ),
            ),
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Home Tab
                  RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _handleRefresh,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          GreetingHeader(
                            riderName: riderName,
                            emotionalState: emotionalState,
                            onEmergencyPressed: _handleEmergencySupport,
                            onProfilePressed: () {
                              _tabController.animateTo(3);
                            },
                          ),
                          QuickStartCard(),
                          RecentActivityCard(
                            lastRideData: lastRideData,
                            onViewDetailsPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.postRideAnalysis);
                            },
                            onSharePressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sharing progress...')),
                              );
                            },
                            onAddNotesPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Opening notes...')),
                              );
                            },
                            onRepeatPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Starting repeat session...')),
                              );
                            },
                          ),
                          UpcomingSessionsCard(
                            upcomingSessions: upcomingSessions,
                            onSessionTap: (session) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Opening ${(session['title'] as String?) ?? 'session'}...'),
                                ),
                              );
                            },
                            onDeleteSession: (session) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Session deleted'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            },
                          ),
                          WeatherWidget(
                            weatherData: weatherData,
                            onRefresh: () {
                              setState(() {
                                weatherData = null;
                              });
                              Future.delayed(Duration(seconds: 2), () {
                                setState(() {
                                  weatherData = {
                                    "temperature": 22,
                                    "condition": "Clear",
                                    "humidity": 55,
                                    "windSpeed": 5,
                                    "visibility": 20,
                                  };
                                });
                              });
                            },
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                  // Coaching Tab
                  AICoachingToolsWidget(),
                  // Progress Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'trending_up',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Progress',
                          style: AppTheme.lightTheme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Track your riding journey',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profile Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Profile',
                          style: AppTheme.lightTheme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Manage your account',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _startSession,
              icon: CustomIconWidget(
                iconName: 'play_arrow',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 24,
              ),
              label: Text(
                'Start Session',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}
