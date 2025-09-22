import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badges_widget.dart';
import './widgets/ai_insights_section.dart';
import './widgets/emotion_timeline_widget.dart';
import './widgets/horse_behavior_analysis.dart';
import './widgets/performance_metrics_widget.dart';
import './widgets/ride_summary_card.dart';
import './widgets/voice_memo_playback.dart';

class PostRideAnalysis extends StatefulWidget {
  const PostRideAnalysis({Key? key}) : super(key: key);

  @override
  State<PostRideAnalysis> createState() => _PostRideAnalysisState();
}

class _PostRideAnalysisState extends State<PostRideAnalysis>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Updated ride data for AI analysis
  final Map<String, dynamic> rideData = {
    "sessionType": "Dressage Training",
    "date": "2025-08-18T14:30:00.000Z",
    "duration": "45 minutes",
    "difficulty": "Intermediate",
    "weather": "Partly Cloudy, 24°C",
    "location": "Main Arena",
  };

  final String emotionalState = "confident";

  // Enhanced performance metrics for AI analysis
  final Map<String, dynamic> performanceMetrics = {
    "overall_score": 8.5,
    "confidence_level": 92,
    "seat_stability": 85,
    "hand_position": 78,
    "leg_position": 88,
    "breathing_consistency": 94,
    "heart_rate_avg": 110,
    "stress_level": 3.2,
    "focus_duration": 38,
  };

  final List<Map<String, dynamic>> achievements = [
    {
      "id": 1,
      "title": "Consistent Breathing",
      "description": "Maintained steady breathing throughout the session",
      "iconName": "air",
      "color": "blue",
      "isNew": true,
    },
    {
      "id": 2,
      "title": "Improved Seat",
      "description": "20% improvement in seat stability",
      "iconName": "trending_up",
      "color": "green",
      "isNew": true,
    },
    {
      "id": 3,
      "title": "Confidence Boost",
      "description": "Highest confidence level this month",
      "iconName": "psychology",
      "color": "purple",
      "isNew": false,
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            title: Text('Post-Ride Analysis'),
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            elevation: 0,
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    // Share analysis functionality
                  },
                  icon: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24)),
            ],
            bottom: TabBar(controller: _tabController, tabs: [
              Tab(text: 'Summary'),
              Tab(text: 'AI Insights'),
              Tab(text: 'Performance'),
              Tab(text: 'Progress'),
            ])),
        body: TabBarView(controller: _tabController, children: [
          // Summary Tab
          SingleChildScrollView(
              child: Column(children: [
            RideSummaryCard(rideData: rideData),
            AchievementBadgesWidget(achievements: achievements),
            VoiceMemoPlayback(voiceMemos: []),
            SizedBox(height: 10.h),
          ])),
          // AI Insights Tab - Updated to use new AI-powered widget
          SingleChildScrollView(
              child: Column(children: [
            AiInsightsSection(
                rideData: rideData,
                emotionalState: emotionalState,
                performanceMetrics: performanceMetrics),
            SizedBox(height: 10.h),
          ])),
          // Performance Tab
          SingleChildScrollView(
              child: Column(children: [
            PerformanceMetricsWidget(performanceData: performanceMetrics),
            EmotionTimelineWidget(emotionData: []),
            SizedBox(height: 10.h),
          ])),
          // Progress Tab
          SingleChildScrollView(
              child: Column(children: [
            HorseBehaviorAnalysis(behaviorData: {}),
            SizedBox(height: 10.h),
          ])),
        ]),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, '/during-ride-coaching');
            },
            icon: CustomIconWidget(
                iconName: 'play_arrow',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 24),
            label: Text('Start New Session',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onTertiary,
                    fontWeight: FontWeight.w600))));
  }
}