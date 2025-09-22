import 'dart:convert';
import './openai_client.dart';
import './openai_service.dart';

/// Therapeutic Intervention Service delivering professional-grade psychological interventions
/// integrated with specialized equestrian psychology book content and evidence-based protocols
class TherapeuticInterventionService {
  static final TherapeuticInterventionService _instance =
      TherapeuticInterventionService._internal();
  late final OpenAIClient _openAIClient;

  factory TherapeuticInterventionService() {
    return _instance;
  }

  TherapeuticInterventionService._internal() {
    final openAIService = OpenAIService();
    _openAIClient = OpenAIClient(openAIService.dio);
  }

  /// Generates personalized CBT intervention protocols for equestrian-specific concerns
  Future<Map<String, dynamic>> generateCBTIntervention({
    required String targetConcern,
    required Map<String, dynamic> assessmentResults,
    required String riderLevel,
    required List<String> specificTriggers,
  }) async {
    try {
      final prompt = '''
      Target Concern: $targetConcern
      Assessment Results: ${assessmentResults.toString()}
      Rider Experience Level: $riderLevel
      Specific Triggers: ${specificTriggers.join(', ')}
      
      Create a comprehensive CBT intervention protocol specifically designed for equestrian contexts.
      Include thought records, behavioral experiments, exposure hierarchy, and riding-specific applications.
      Integrate relevant book chapters and case studies for evidence-based guidance.
      ''';

      final messages = [
        Message(
          role: 'system',
          content:
              '''You are a clinical psychologist specializing in CBT and equestrian sports psychology.
          Generate detailed CBT protocols in JSON format with: thoughtRecords, behavioralExperiments, 
          exposureHierarchy, ridingApplications, bookIntegration, progressTracking, sessionPlan.''',
        ),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.4, 'max_tokens': 2500},
      );

      return _parseInterventionResponse(response.text);
    } catch (e) {
      return _getFallbackCBTProtocol(targetConcern);
    }
  }

  /// Creates mindfulness-based interventions for riding situations
  Future<Map<String, dynamic>> generateMindfulnessIntervention({
    required String ridingContext,
    required String emotionalState,
    required int sessionDuration,
    required bool includeAudioGuidance,
  }) async {
    try {
      final prompt = '''
      Riding Context: $ridingContext
      Current Emotional State: $emotionalState
      Available Session Time: $sessionDuration minutes
      Audio Guidance Requested: $includeAudioGuidance
      
      Create a comprehensive mindfulness intervention designed for equestrian applications.
      Include body awareness, breath work, present-moment awareness, and horse-human connection exercises.
      Provide step-by-step protocols with timing and specific instructions for riding contexts.
      ''';

      final messages = [
        Message(
          role: 'system',
          content:
              '''You are a mindfulness-based therapist with expertise in equestrian sports psychology.
          Generate detailed mindfulness protocols in JSON format with: exercises, timing, instructions,
          ridingApplications, progressMarkers, adaptations, bookReferences.''',
        ),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.3, 'max_tokens': 2000},
      );

      // Generate audio guidance if requested
      if (includeAudioGuidance) {
        return await _addAudioGuidance(
            _parseInterventionResponse(response.text));
      }

      return _parseInterventionResponse(response.text);
    } catch (e) {
      return _getFallbackMindfulnessProtocol();
    }
  }

  /// Develops exposure therapy protocols for riding-specific fears
  Future<Map<String, dynamic>> generateExposureTherapyProtocol({
    required String specificFear,
    required String fearIntensity,
    required Map<String, dynamic> avoidanceBehaviors,
    required String safetyResources,
  }) async {
    try {
      final prompt = '''
      Specific Fear: $specificFear
      Fear Intensity Level: $fearIntensity
      Avoidance Behaviors: ${avoidanceBehaviors.toString()}
      Available Safety Resources: $safetyResources
      
      Design a systematic exposure therapy protocol for equestrian fears using evidence-based gradual exposure principles.
      Create a detailed hierarchy from least to most anxiety-provoking situations with specific riding scenarios.
      Include safety protocols, grounding techniques, and progress measurement tools.
      ''';

      final messages = [
        Message(
          role: 'system',
          content:
              '''You are a clinical psychologist specializing in exposure therapy and equestrian psychology.
          Generate systematic exposure protocols in JSON format with: exposureHierarchy, safetyProtocols,
          groundingTechniques, progressMeasures, sessionStructure, ridingProgression, supportStrategies.''',
        ),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.2, 'max_tokens': 2200},
      );

      return _parseInterventionResponse(response.text);
    } catch (e) {
      return _getFallbackExposureProtocol();
    }
  }

  /// Creates equine-assisted intervention protocols
  Future<Map<String, dynamic>> generateEquineAssistedIntervention({
    required String therapeuticGoals,
    required String horseTemperament,
    required String riderExperience,
    required String environmentalFactors,
  }) async {
    try {
      final prompt = '''
      Therapeutic Goals: $therapeuticGoals
      Horse Temperament: $horseTemperament
      Rider Experience: $riderExperience
      Environmental Factors: $environmentalFactors
      
      Design a comprehensive equine-assisted intervention protocol that leverages the therapeutic
      relationship between horse and human. Include ground work exercises, mounted activities,
      relationship building techniques, and emotional regulation through horse interaction.
      ''';

      final messages = [
        Message(
          role: 'system',
          content:
              '''You are an equine-assisted therapist with clinical psychology expertise.
          Generate therapeutic protocols in JSON format with: groundworkExercises, mountedActivities,
          relationshipBuilding, emotionalRegulation, progressIndicators, safetyConsiderations, bookIntegration.''',
        ),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.4, 'max_tokens': 2300},
      );

      return _parseInterventionResponse(response.text);
    } catch (e) {
      return _getFallbackEquineAssistedProtocol();
    }
  }

  /// Generates professional consultation recommendations for complex cases
  Future<Map<String, dynamic>> generateProfessionalConsultation({
    required String complexityFactors,
    required Map<String, dynamic> interventionHistory,
    required String urgencyLevel,
  }) async {
    try {
      final prompt = '''
      Complexity Factors: $complexityFactors
      Intervention History: ${interventionHistory.toString()}
      Urgency Level: $urgencyLevel
      
      Provide comprehensive professional consultation recommendations including:
      - Specialized referral suggestions
      - Advanced intervention modifications
      - Risk assessment considerations  
      - Collaborative care planning
      - Timeline for professional review
      ''';

      final messages = [
        Message(
          role: 'system',
          content:
              '''You are a clinical supervisor providing professional consultation recommendations.
          Generate consultation guidance in JSON format with: referralRecommendations, interventionModifications,
          riskConsiderations, collaborativePlanning, reviewTimeline, specialistContacts.''',
        ),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.2, 'max_tokens': 1500},
      );

      return _parseInterventionResponse(response.text);
    } catch (e) {
      return _getFallbackConsultationGuidance();
    }
  }

  /// Adds audio guidance to intervention protocols using OpenAI TTS
  Future<Map<String, dynamic>> _addAudioGuidance(
      Map<String, dynamic> intervention) async {
    try {
      // Extract key instruction text for audio generation
      final instructions = intervention['instructions'] as List<dynamic>? ?? [];
      final audioScript = instructions.join('. ') +
          '. Take your time with each step. Remember to breathe deeply and stay present with your horse.';

      final audioFile = await _openAIClient.createSpeech(
        input: audioScript,
        model: 'tts-1',
        voice: 'alloy',
        responseFormat: 'mp3',
      );

      intervention['audioGuidance'] = {
        'available': true,
        'filePath': audioFile.path,
        'duration': _estimateAudioDuration(audioScript),
        'voice': 'professional_female'
      };

      return intervention;
    } catch (e) {
      intervention['audioGuidance'] = {
        'available': false,
        'error': 'Audio generation temporarily unavailable'
      };
      return intervention;
    }
  }

  int _estimateAudioDuration(String text) {
    // Rough estimation: average speaking rate is ~150 words per minute
    final wordCount = text.split(' ').length;
    return ((wordCount / 150) * 60).ceil();
  }

  Map<String, dynamic> _parseInterventionResponse(String response) {
    try {
      String jsonString = response.trim();
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }
      return jsonDecode(jsonString);
    } catch (e) {
      return _getFallbackCBTProtocol("anxiety");
    }
  }

  Map<String, dynamic> _getFallbackCBTProtocol(String concern) {
    return {
      "thoughtRecords": [
        {
          "situation": "Pre-ride anxiety",
          "thoughts": "What if I fall off?",
          "emotions": "Fear, anxiety",
          "behaviors": "Avoidance, tension",
          "evidence": "I have fallen before and recovered",
          "reframe": "I am prepared and capable of handling challenges"
        }
      ],
      "behavioralExperiments": [
        {
          "hypothesis": "Gradual exposure reduces anxiety",
          "experiment": "Spend 5 minutes daily with horse without riding",
          "prediction": "Anxiety will decrease over time",
          "outcome": "To be measured"
        }
      ],
      "exposureHierarchy": [
        "Ground work with horse (anxiety level 1-2)",
        "Grooming and tacking (anxiety level 3-4)",
        "Mounting assistance (anxiety level 5-6)",
        "Walk with instructor (anxiety level 7-8)",
        "Independent riding (anxiety level 9-10)"
      ],
      "ridingApplications": [
        "Use breathing techniques before mounting",
        "Practice positive self-talk during rides",
        "Implement progressive muscle relaxation"
      ],
      "bookIntegration": {
        "chapter": "Chapter 6: Cognitive Restructuring for Riders",
        "exercises": "Thought record worksheets pages 145-150"
      },
      "progressTracking": {
        "method": "Daily anxiety ratings 1-10",
        "frequency": "Before and after each interaction",
        "goals": "Reduce baseline anxiety by 30% in 4 weeks"
      }
    };
  }

  Map<String, dynamic> _getFallbackMindfulnessProtocol() {
    return {
      "exercises": [
        {
          "name": "Centered Breathing with Horse",
          "duration": 5,
          "instructions": [
            "Stand beside your horse in a safe position",
            "Match your breathing to your horse's rhythm",
            "Notice the rise and fall of your horse's sides",
            "Feel your feet connected to the ground",
            "Allow thoughts to pass without judgment"
          ]
        }
      ],
      "timing": [
        "5 minutes ground preparation",
        "10 minutes mindful grooming",
        "15 minutes mounted mindfulness"
      ],
      "ridingApplications": [
        "Mindful mounting sequence",
        "Breath awareness during transitions",
        "Present-moment focus during challenging movements"
      ],
      "progressMarkers": [
        "Decreased pre-ride anxiety",
        "Improved focus during rides",
        "Enhanced horse-rider connection"
      ],
      "bookReferences": [
        "Chapter 8: Mindfulness for Equestrians",
        "Guided meditation scripts pages 201-215"
      ]
    };
  }

  Map<String, dynamic> _getFallbackExposureProtocol() {
    return {
      "exposureHierarchy": [
        {
          "level": 1,
          "activity": "Watch other riders from safe distance",
          "duration": "10 minutes daily",
          "anxietyTarget": "2-3/10"
        },
        {
          "level": 5,
          "activity": "Ground work with calm horse",
          "duration": "15 minutes",
          "anxietyTarget": "4-5/10"
        },
        {
          "level": 10,
          "activity": "Independent riding session",
          "duration": "30 minutes",
          "anxietyTarget": "6-7/10 (manageable)"
        }
      ],
      "safetyProtocols": [
        "Always work with experienced instructor",
        "Use appropriate safety equipment",
        "Have grounding techniques readily available"
      ],
      "groundingTechniques": [
        "5-4-3-2-1 sensory technique",
        "Progressive muscle relaxation",
        "Box breathing (4-4-4-4 pattern)"
      ],
      "progressMeasures": [
        "Subjective anxiety ratings",
        "Time spent in exposure situation",
        "Behavioral approach test scores"
      ]
    };
  }

  Map<String, dynamic> _getFallbackEquineAssistedProtocol() {
    return {
      "groundworkExercises": [
        {
          "name": "Trust Building Circle",
          "description": "Leading horse in calm, consistent circles",
          "therapeuticGoal": "Build confidence and trust",
          "duration": "10 minutes",
          "progressIndicators": [
            "Horse responds calmly",
            "Rider feels more confident"
          ]
        }
      ],
      "mountedActivities": [
        {
          "name": "Mindful Walk",
          "description": "Slow, meditative walk with focus on connection",
          "therapeuticGoal": "Present-moment awareness and bonding",
          "duration": "15 minutes"
        }
      ],
      "relationshipBuilding": [
        "Daily grooming rituals",
        "Feeding time mindfulness",
        "Non-verbal communication practice"
      ],
      "emotionalRegulation": [
        "Horse as emotional mirror exercise",
        "Breathing synchronization practice",
        "Energy awareness training"
      ]
    };
  }

  Map<String, dynamic> _getFallbackConsultationGuidance() {
    return {
      "referralRecommendations": [
        "Licensed clinical psychologist specializing in sports psychology",
        "Trauma-informed equine-assisted therapist",
        "Anxiety disorders specialist with CBT expertise"
      ],
      "interventionModifications": [
        "Reduce session intensity if overwhelming",
        "Add additional safety measures",
        "Include support person in sessions"
      ],
      "riskConsiderations": [
        "Monitor for increasing avoidance behaviors",
        "Assess for trauma history impact",
        "Evaluate medication consultation needs"
      ],
      "collaborativePlanning": [
        "Weekly check-ins with supervising clinician",
        "Monthly progress review meetings",
        "Quarterly comprehensive assessment updates"
      ],
      "reviewTimeline":
          "Professional consultation recommended within 2 weeks if no improvement noted"
    };
  }
}
