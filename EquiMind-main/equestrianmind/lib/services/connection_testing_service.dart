import 'dart:math';

import './ai_coaching_service.dart';

class ConnectionTestingService {
  static final ConnectionTestingService _instance =
      ConnectionTestingService._internal();
  final AICoachingService _aiCoachingService = AICoachingService();

  factory ConnectionTestingService() {
    return _instance;
  }

  ConnectionTestingService._internal();

  /// Predefined test scenarios for rider-horse connection
  List<Map<String, dynamic>> getTestScenarios() {
    return [
      // Positive Connection Scenarios
      {
        'id': 'perfect_harmony',
        'name': 'Perfect Harmony',
        'description':
            'Ideal rider-horse connection with mutual trust and understanding',
        'riderEmotion': 8.0,
        'horseMood': 'Calm',
        'horseEnergy': 'Moderate',
        'connectionStrength': 0.95,
        'bonding': 'Excellent',
        'notes':
            'Horse responds immediately to subtle cues. Perfect synchronization.',
        'expectedInsights': [
          'Strong emotional bond',
          'Excellent communication',
          'Peak performance potential'
        ]
      },

      // Challenging Scenarios
      {
        'id': 'anxious_rider_nervous_horse',
        'name': 'Anxious Rider + Nervous Horse',
        'description': 'Both rider and horse are experiencing anxiety',
        'riderEmotion': 3.0,
        'horseMood': 'Anxious',
        'horseEnergy': 'High',
        'connectionStrength': 0.25,
        'bonding': 'Strained',
        'notes':
            'Horse is picking up on rider tension. Reactive to environment.',
        'expectedInsights': [
          'Emotional regulation needed',
          'Grounding exercises recommended',
          'Trust building required'
        ]
      },

      {
        'id': 'confident_rider_resistant_horse',
        'name': 'Confident Rider + Resistant Horse',
        'description':
            'Confident rider working with a resistant or stubborn horse',
        'riderEmotion': 7.5,
        'horseMood': 'Alert',
        'horseEnergy': 'High',
        'connectionStrength': 0.45,
        'bonding': 'Developing',
        'notes':
            'Horse testing boundaries. Rider maintaining calm assertiveness.',
        'expectedInsights': [
          'Patience required',
          'Consistent boundaries',
          'Trust building in progress'
        ]
      },

      // Emotional Variability Scenarios
      {
        'id': 'fluctuating_emotions',
        'name': 'Fluctuating Emotional States',
        'description':
            'Testing how connection changes with varying emotional states',
        'riderEmotion': 5.5,
        'horseMood': 'Playful',
        'horseEnergy': 'Moderate',
        'connectionStrength': 0.65,
        'bonding': 'Good',
        'notes':
            'Rider emotions varying throughout session. Horse responding to changes.',
        'expectedInsights': [
          'Emotional consistency',
          'Adaptability training',
          'Communication awareness'
        ]
      },

      // New Partnership Scenarios
      {
        'id': 'new_partnership',
        'name': 'New Partnership',
        'description': 'First rides together - building initial connection',
        'riderEmotion': 6.0,
        'horseMood': 'Alert',
        'horseEnergy': 'Moderate',
        'connectionStrength': 0.35,
        'bonding': 'Beginning',
        'notes': 'Getting to know each other. Horse cautiously responsive.',
        'expectedInsights': [
          'Patience in building trust',
          'Consistent routine',
          'Positive reinforcement'
        ]
      },

      // Recovery Scenarios
      {
        'id': 'post_incident_recovery',
        'name': 'Post-Incident Recovery',
        'description': 'Rebuilding confidence after a challenging experience',
        'riderEmotion': 4.5,
        'horseMood': 'Nervous',
        'horseEnergy': 'Low',
        'connectionStrength': 0.30,
        'bonding': 'Rebuilding',
        'notes':
            'Both recovering from previous difficult experience. Cautious approach.',
        'expectedInsights': [
          'Gradual exposure',
          'Confidence rebuilding',
          'Trust restoration'
        ]
      },

      // Peak Performance Scenarios
      {
        'id': 'competition_ready',
        'name': 'Competition Ready',
        'description': 'High-performance partnership in competitive settings',
        'riderEmotion': 9.0,
        'horseMood': 'Focused',
        'horseEnergy': 'High',
        'connectionStrength': 0.90,
        'bonding': 'Elite',
        'notes': 'Peak performance state. Horse and rider in complete sync.',
        'expectedInsights': [
          'Maintain peak state',
          'Performance optimization',
          'Competition strategies'
        ]
      }
    ];
  }

  /// Generate realistic horse behavior data for testing
  Map<String, dynamic> generateTestHorseBehaviorData(
      Map<String, dynamic> scenario) {
    final random = Random();

    return {
      'observedBehaviors': _generateBehaviors(scenario, random),
      'riderCorrelations': _generateCorrelations(scenario, random),
      'recommendations': _generateRecommendations(scenario),
      'connectionStrength': scenario['connectionStrength'],
      'sessionDuration': '45 minutes',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  List<Map<String, dynamic>> _generateBehaviors(
      Map<String, dynamic> scenario, Random random) {
    final behaviors = <Map<String, dynamic>>[];
    final horseMood = scenario['horseMood'] as String;
    final horseEnergy = scenario['horseEnergy'] as String;

    // Add mood-based behaviors
    switch (horseMood.toLowerCase()) {
      case 'calm':
        behaviors.addAll([
          {'name': 'Relaxed ears', 'type': 'calm', 'frequency': 'Consistent'},
          {
            'name': 'Steady breathing',
            'type': 'calm',
            'frequency': 'Continuous'
          },
          {
            'name': 'Soft eye expression',
            'type': 'calm',
            'frequency': 'Consistent'
          },
        ]);
        break;
      case 'anxious':
        behaviors.addAll([
          {'name': 'Ear swiveling', 'type': 'nervous', 'frequency': 'Frequent'},
          {'name': 'Muscle tension', 'type': 'nervous', 'frequency': 'Ongoing'},
          {
            'name': 'Shortened stride',
            'type': 'nervous',
            'frequency': 'Occasional'
          },
        ]);
        break;
      case 'alert':
        behaviors.addAll([
          {'name': 'Forward ears', 'type': 'alert', 'frequency': 'Consistent'},
          {
            'name': 'Quick responses',
            'type': 'responsive',
            'frequency': 'Frequent'
          },
          {
            'name': 'Environmental scanning',
            'type': 'alert',
            'frequency': 'Regular'
          },
        ]);
        break;
      case 'playful':
        behaviors.addAll([
          {
            'name': 'Head tossing',
            'type': 'responsive',
            'frequency': 'Occasional'
          },
          {
            'name': 'Spring in step',
            'type': 'responsive',
            'frequency': 'Frequent'
          },
          {'name': 'Mouth play', 'type': 'calm', 'frequency': 'Regular'},
        ]);
        break;
      case 'focused':
        behaviors.addAll([
          {
            'name': 'Intense concentration',
            'type': 'alert',
            'frequency': 'Consistent'
          },
          {
            'name': 'Immediate response to aids',
            'type': 'responsive',
            'frequency': 'Consistent'
          },
          {'name': 'Balanced movement', 'type': 'calm', 'frequency': 'Ongoing'},
        ]);
        break;
    }

    // Add energy-based behaviors
    if (horseEnergy == 'High' || horseEnergy == 'Very High') {
      behaviors.add({
        'name': 'Increased pace',
        'type': 'responsive',
        'frequency': 'Frequent'
      });
      behaviors.add({
        'name': 'Quick transitions',
        'type': 'responsive',
        'frequency': 'Regular'
      });
    } else if (horseEnergy == 'Low') {
      behaviors.add({
        'name': 'Slower responses',
        'type': 'calm',
        'frequency': 'Occasional'
      });
      behaviors.add({
        'name': 'Needs encouragement',
        'type': 'resistant',
        'frequency': 'Regular'
      });
    }

    return behaviors;
  }

  List<Map<String, dynamic>> _generateCorrelations(
      Map<String, dynamic> scenario, Random random) {
    final connectionStrength = scenario['connectionStrength'] as double;
    final correlations = <Map<String, dynamic>>[];

    // Generate correlations based on connection strength
    if (connectionStrength > 0.7) {
      correlations.addAll([
        {
          'description':
              'Rider\'s emotional state directly influences horse\'s relaxation',
          'strength': 0.85 + (random.nextDouble() * 0.1),
          'type': 'positive'
        },
        {
          'description':
              'Horse responds faster when rider uses consistent aids',
          'strength': 0.90 + (random.nextDouble() * 0.05),
          'type': 'positive'
        },
      ]);
    } else if (connectionStrength > 0.4) {
      correlations.addAll([
        {
          'description': 'Horse tension increases with rider anxiety',
          'strength': 0.65 + (random.nextDouble() * 0.15),
          'type': 'negative'
        },
        {
          'description': 'Positive reinforcement improves horse cooperation',
          'strength': 0.70 + (random.nextDouble() * 0.1),
          'type': 'positive'
        },
      ]);
    } else {
      correlations.addAll([
        {
          'description': 'Miscommunication leads to confused responses',
          'strength': 0.45 + (random.nextDouble() * 0.2),
          'type': 'negative'
        },
        {
          'description': 'Trust building requires consistent approach',
          'strength': 0.35 + (random.nextDouble() * 0.15),
          'type': 'developmental'
        },
      ]);
    }

    return correlations;
  }

  List<Map<String, dynamic>> _generateRecommendations(
      Map<String, dynamic> scenario) {
    final recommendations = <Map<String, dynamic>>[];
    final connectionStrength = scenario['connectionStrength'] as double;
    final bonding = scenario['bonding'] as String;
    final horseMood = scenario['horseMood'] as String;

    // Connection-specific recommendations
    if (connectionStrength < 0.4) {
      recommendations.addAll([
        {
          'title': 'Trust Building Exercises',
          'description':
              'Implement daily groundwork sessions focusing on mutual respect and clear communication.',
          'priority': 'high'
        },
        {
          'title': 'Consistent Routine',
          'description':
              'Establish predictable patterns in your interactions to build horse confidence.',
          'priority': 'high'
        },
      ]);
    } else if (connectionStrength < 0.7) {
      recommendations.addAll([
        {
          'title': 'Emotional Regulation',
          'description':
              'Practice mindfulness techniques to maintain emotional balance during rides.',
          'priority': 'medium'
        },
        {
          'title': 'Progressive Training',
          'description':
              'Gradually increase challenge level to build confidence together.',
          'priority': 'medium'
        },
      ]);
    } else {
      recommendations.addAll([
        {
          'title': 'Performance Optimization',
          'description':
              'Fine-tune communication for competitive or advanced training goals.',
          'priority': 'low'
        },
        {
          'title': 'Maintain Excellence',
          'description':
              'Continue current practices while monitoring for any changes in dynamic.',
          'priority': 'low'
        },
      ]);
    }

    // Mood-specific recommendations
    if (horseMood == 'Anxious' || horseMood == 'Nervous') {
      recommendations.add({
        'title': 'Calming Protocol',
        'description':
            'Implement specific calming techniques including deep breathing and slower movements.',
        'priority': 'high'
      });
    }

    return recommendations;
  }

  /// Simulate a testing session with a specific scenario
  Future<Map<String, dynamic>> simulateTestingSession(
      Map<String, dynamic> scenario) async {
    // Generate realistic test data
    final horseBehaviorData = generateTestHorseBehaviorData(scenario);

    // Simulate AI coaching insights
    final rideData = {
      'sessionType': 'Testing Session',
      'duration': '45 minutes',
      'date': DateTime.now().toIso8601String(),
      'scenario': scenario['name'],
    };

    final performanceMetrics = {
      'balance_score': _generateScoreFromEmotion(scenario['riderEmotion']),
      'communication_clarity': scenario['connectionStrength'] * 100,
      'horse_responsiveness': _generateResponsivenessScore(scenario),
      'overall_harmony': scenario['connectionStrength'] * 100,
    };

    try {
      final insights = await _aiCoachingService.generateRideInsights(
        rideData: rideData,
        emotionalState: _getEmotionalStateFromScore(scenario['riderEmotion']),
        performanceMetrics: performanceMetrics,
      );

      return {
        'scenario': scenario,
        'horseBehaviorData': horseBehaviorData,
        'performanceMetrics': performanceMetrics,
        'aiInsights': insights,
        'testResults': {
          'connectionScore': scenario['connectionStrength'],
          'improvementAreas': _identifyImprovementAreas(scenario),
          'strengths': _identifyStrengths(scenario),
        }
      };
    } catch (e) {
      return {
        'scenario': scenario,
        'horseBehaviorData': horseBehaviorData,
        'performanceMetrics': performanceMetrics,
        'aiInsights': _getFallbackInsights(scenario),
        'testResults': {
          'connectionScore': scenario['connectionStrength'],
          'improvementAreas': _identifyImprovementAreas(scenario),
          'strengths': _identifyStrengths(scenario),
        }
      };
    }
  }

  double _generateScoreFromEmotion(double emotion) {
    // Convert 1-10 emotion scale to performance score
    return ((emotion - 1) / 9) * 100;
  }

  double _generateResponsivenessScore(Map<String, dynamic> scenario) {
    final horseMood = scenario['horseMood'] as String;
    final horseEnergy = scenario['horseEnergy'] as String;
    final connectionStrength = scenario['connectionStrength'] as double;

    double baseScore = connectionStrength * 100;

    // Adjust based on horse mood
    switch (horseMood.toLowerCase()) {
      case 'focused':
        baseScore += 10;
        break;
      case 'anxious':
        baseScore -= 15;
        break;
      case 'alert':
        baseScore += 5;
        break;
      case 'playful':
        baseScore += 0;
        break;
    }

    return baseScore.clamp(0, 100);
  }

  String _getEmotionalStateFromScore(double score) {
    if (score >= 8) return 'Confident and Focused';
    if (score >= 6) return 'Calm and Centered';
    if (score >= 4) return 'Slightly Nervous';
    return 'Anxious';
  }

  List<String> _identifyImprovementAreas(Map<String, dynamic> scenario) {
    final areas = <String>[];
    final connectionStrength = scenario['connectionStrength'] as double;
    final riderEmotion = scenario['riderEmotion'] as double;
    final horseMood = scenario['horseMood'] as String;

    if (connectionStrength < 0.5) areas.add('Connection Building');
    if (riderEmotion < 5) areas.add('Emotional Regulation');
    if (horseMood == 'Anxious') areas.add('Horse Confidence');
    if (scenario['bonding'] == 'Strained') areas.add('Trust Development');

    return areas;
  }

  List<String> _identifyStrengths(Map<String, dynamic> scenario) {
    final strengths = <String>[];
    final connectionStrength = scenario['connectionStrength'] as double;
    final riderEmotion = scenario['riderEmotion'] as double;
    final bonding = scenario['bonding'] as String;

    if (connectionStrength > 0.7) strengths.add('Strong Connection');
    if (riderEmotion > 7) strengths.add('Emotional Stability');
    if (bonding == 'Excellent' || bonding == 'Elite')
      strengths.add('Trust and Bonding');
    if (scenario['horseMood'] == 'Focused') strengths.add('Horse Engagement');

    return strengths;
  }

  List<Map<String, dynamic>> _getFallbackInsights(
      Map<String, dynamic> scenario) {
    return [
      {
        'title': 'Connection Analysis',
        'category': 'connection',
        'summary':
            'Based on the test scenario "${scenario['name']}", focus on ${scenario['bonding'].toLowerCase()} connection building.',
        'recommendations': [
          'Practice consistent communication',
          'Build trust through groundwork',
          'Monitor emotional responses'
        ]
      }
    ];
  }
}
