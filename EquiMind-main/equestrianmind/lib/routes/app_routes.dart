import 'package:flutter/material.dart';

import '../presentation/ai_coaching_settings/ai_coaching_settings.dart';
import '../presentation/assessment_questionnaire/assessment_questionnaire_screen.dart';
import '../presentation/clinical_assessment_hub/clinical_assessment_hub.dart';
import '../presentation/clinical_progress_dashboard/clinical_progress_dashboard.dart';
import '../presentation/connection_testing/connection_testing_screen.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/during_ride_coaching/during_ride_coaching.dart';
import '../presentation/feature_testing_suite/feature_testing_suite.dart';
import '../presentation/feedback_collection_hub/feedback_collection_hub.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/post_ride_analysis/post_ride_analysis.dart';
import '../presentation/pre_ride_preparation/pre_ride_preparation.dart';
import '../presentation/real_time_emotion_detection/real_time_emotion_detection.dart';
import '../presentation/testing_dashboard/testing_dashboard.dart';
import '../presentation/therapeutic_intervention_library/therapeutic_intervention_library.dart';

class AppRoutes {
  static const String initialRoute = '/initialRoute';
  static const String splashScreen = '/splashScreen';
  static const String loginScreen = '/loginScreen';
  static const String dashboardHome = '/dashboardHome';
  static const String preRidePreparation = '/preRidePreparation';
  static const String duringRideCoaching = '/duringRideCoaching';
  static const String postRideAnalysis = '/postRideAnalysis';
  static const String aiCoachingSettings = '/aiCoachingSettings';
  static const String connectionTesting = '/connectionTesting';
  static const String testingDashboard = '/testingDashboard';
  static const String featureTestingSuite = '/featureTestingSuite';
  static const String feedbackCollectionHub = '/feedback-collection-hub';
  static const String realTimeEmotionDetection = '/real-time-emotion-detection';
  static const String clinicalAssessmentHub = '/clinical-assessment-hub';
  static const String therapeuticInterventionLibrary =
      '/therapeutic-intervention-library';
  static const String clinicalProgressDashboard =
      '/clinical-progress-dashboard';
  static const String assessmentQuestionnaire = '/assessment-questionnaire';

  static Map<String, WidgetBuilder> get routes {
    return {
      initialRoute: (context) => const LoginScreen(),
      splashScreen: (context) => const LoginScreen(),
      loginScreen: (context) => const LoginScreen(),
      dashboardHome: (context) => const DashboardHome(),
      preRidePreparation: (context) => const PreRidePreparation(),
      duringRideCoaching: (context) => const DuringRideCoaching(),
      postRideAnalysis: (context) => const PostRideAnalysis(),
      aiCoachingSettings: (context) => const AiCoachingSettings(),
      connectionTesting: (context) => const ConnectionTestingScreen(),
      testingDashboard: (context) => const TestingDashboard(),
      featureTestingSuite: (context) => const FeatureTestingSuite(),
      feedbackCollectionHub: (context) => const FeedbackCollectionHub(),
      realTimeEmotionDetection: (context) => const RealTimeEmotionDetection(),
      clinicalAssessmentHub: (context) => const ClinicalAssessmentHub(),
      therapeuticInterventionLibrary: (context) =>
          const TherapeuticInterventionLibrary(),
      clinicalProgressDashboard: (context) => const ClinicalProgressDashboard(),
      assessmentQuestionnaire: (context) =>
          const AssessmentQuestionnaireScreen(),
    };
  }
}
