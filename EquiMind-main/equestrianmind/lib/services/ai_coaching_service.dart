import 'dart:convert';
import 'dart:io';
import './openai_client.dart';
import './openai_service.dart';

class AICoachingService {
  static final AICoachingService _instance = AICoachingService._internal();
  late final OpenAIClient _openAIClient;

  factory AICoachingService() {
    return _instance;
  }

  AICoachingService._internal() {
    final openAIService = OpenAIService();
    _openAIClient = OpenAIClient(openAIService.dio);
  }

  /// Generates AI insights for post-ride analysis
  Future<List<Map<String, dynamic>>> generateRideInsights({
    required Map<String, dynamic> rideData,
    required String emotionalState,
    required Map<String, dynamic> performanceMetrics,
  }) async {
    try {
      final prompt = _buildRideAnalysisPrompt(
          rideData, emotionalState, performanceMetrics);

      final messages = [
        Message(
            role: 'system',
            content:
                '''You are an expert equestrian sports psychologist and AI coach specializing in rider performance analysis. 
        Generate comprehensive insights in JSON format with categories: emotion, performance, technique, confidence, and horse_behavior. 
        Each insight should have: title, category, summary, and recommendations (array of strings).
        Return exactly 3-5 insights in valid JSON array format.'''),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.7, 'max_tokens': 1500},
      );

      // Parse the JSON response
      final insights = _parseInsightsFromResponse(response.text);
      return insights;
    } catch (e) {
      // Return fallback insights if API fails
      return _getFallbackInsights();
    }
  }

  /// Generates real-time coaching advice during rides
  Future<String> generateRealTimeCoaching({
    required String currentActivity,
    required String emotionalState,
    required Map<String, dynamic> biometrics,
    String? specificConcern,
  }) async {
    try {
      final prompt = '''
      Current Activity: $currentActivity
      Rider Emotional State: $emotionalState
      Biometrics: ${biometrics.toString()}
      ${specificConcern != null ? 'Specific Concern: $specificConcern' : ''}
      
      Provide brief, encouraging real-time coaching advice (2-3 sentences max).
      Focus on immediate actionable guidance for emotional regulation and performance.
      ''';

      final messages = [
        Message(
            role: 'system',
            content:
                '''You are a supportive AI equestrian coach providing real-time guidance. 
        Keep responses brief, encouraging, and immediately actionable. Focus on breathing, posture, and mental state.'''),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o-mini',
        options: {'temperature': 0.8, 'max_tokens': 200},
      );

      return response.text.trim();
    } catch (e) {
      return "Take a deep breath and focus on your posture. You're doing great - trust your training and stay present in this moment.";
    }
  }

  /// Analyzes uploaded images for technique feedback
  Future<String> analyzeRidingTechnique({
    required String imageUrl,
    String? specificFocus,
  }) async {
    try {
      final prompt = specificFocus != null
          ? 'Analyze this riding position focusing on: $specificFocus. Provide constructive feedback on technique, posture, and areas for improvement.'
          : 'Analyze this riding position and provide constructive feedback on overall technique, posture, seat, hands, and leg position.';

      final response = await _openAIClient.generateTextFromImage(
        imageUrl: imageUrl,
        promptText: prompt,
        model: 'gpt-4o',
        options: {'temperature': 0.6, 'max_tokens': 800},
      );

      return response.text;
    } catch (e) {
      return "Unable to analyze the image at this time. Please ensure good lighting and a clear view of your riding position.";
    }
  }

  /// Generates personalized pre-ride preparation exercises
  Future<List<Map<String, dynamic>>> generatePreRideExercises({
    required String emotionalState,
    required String rideType,
    required int availableMinutes,
  }) async {
    try {
      final prompt = '''
      Rider's Current Emotional State: $emotionalState
      Type of Ride: $rideType
      Available Time: $availableMinutes minutes
      
      Generate 3-4 personalized preparation exercises in JSON format.
      Each exercise should have: name, description, duration (minutes), category, and instructions (array of steps).
      Categories: breathing, visualization, physical_warmup, mental_preparation.
      ''';

      final messages = [
        Message(
            role: 'system',
            content:
                '''You are an expert in equestrian sports psychology and physical preparation. 
        Generate personalized pre-ride exercises in valid JSON array format tailored to the rider's current state and needs.'''),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.7, 'max_tokens': 1200},
      );

      return _parseExercisesFromResponse(response.text);
    } catch (e) {
      return _getFallbackExercises(emotionalState, availableMinutes);
    }
  }

  /// Transcribes voice memos using Whisper
  Future<String> transcribeVoiceMemo(String audioFilePath) async {
    try {
      final audioFile = File(audioFilePath);
      final transcription = await _openAIClient.transcribeAudio(
        audioFile: audioFile,
        model: 'whisper-1',
      );
      return transcription.text;
    } catch (e) {
      return "Unable to transcribe audio. Please try recording again.";
    }
  }

  String _buildRideAnalysisPrompt(
    Map<String, dynamic> rideData,
    String emotionalState,
    Map<String, dynamic> performanceMetrics,
  ) {
    return '''
    Ride Session Analysis:
    - Session Type: ${rideData['sessionType'] ?? 'Unknown'}
    - Duration: ${rideData['duration'] ?? 'Unknown'}
    - Date: ${rideData['date'] ?? 'Unknown'}
    
    Rider's Emotional State: $emotionalState
    
    Performance Metrics:
    ${performanceMetrics.entries.map((e) => '- ${e.key}: ${e.value}').join('\n')}
    
    Please analyze this riding session and provide insights covering emotional regulation, 
    performance optimization, technical improvements, confidence building, and horse behavior observations.
    ''';
  }

  List<Map<String, dynamic>> _parseInsightsFromResponse(String response) {
    try {
      // Clean the response to extract JSON
      String jsonString = response.trim();
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }

      final List<dynamic> parsed = jsonDecode(jsonString);
      return parsed.cast<Map<String, dynamic>>();
    } catch (e) {
      return _getFallbackInsights();
    }
  }

  List<Map<String, dynamic>> _parseExercisesFromResponse(String response) {
    try {
      String jsonString = response.trim();
      if (jsonString.startsWith('```json')) {
        jsonString = jsonString.substring(7);
      }
      if (jsonString.endsWith('```')) {
        jsonString = jsonString.substring(0, jsonString.length - 3);
      }

      final List<dynamic> parsed = jsonDecode(jsonString);
      return parsed.cast<Map<String, dynamic>>();
    } catch (e) {
      return _getFallbackExercises("neutral", 10);
    }
  }

  List<Map<String, dynamic>> _getFallbackInsights() {
    return [
      {
        "title": "Emotional Awareness",
        "category": "emotion",
        "summary":
            "Your emotional state significantly impacts your riding performance. Focus on developing emotional awareness.",
        "recommendations": [
          "Practice mindfulness breathing before mounting",
          "Use positive self-talk during challenging moments",
          "Develop a pre-ride emotional check-in routine"
        ]
      },
      {
        "title": "Performance Optimization",
        "category": "performance",
        "summary":
            "Consistent practice and focused attention lead to improved riding performance.",
        "recommendations": [
          "Set specific, achievable goals for each session",
          "Focus on one technical aspect at a time",
          "Record progress to track improvements over time"
        ]
      }
    ];
  }

  List<Map<String, dynamic>> _getFallbackExercises(
      String emotionalState, int availableMinutes) {
    return [
      {
        "name": "Centering Breath",
        "description":
            "A grounding breathing exercise to center your mind and body",
        "duration": 3,
        "category": "breathing",
        "instructions": [
          "Sit comfortably with feet flat on the ground",
          "Inhale slowly for 4 counts through your nose",
          "Hold your breath for 4 counts",
          "Exhale slowly for 6 counts through your mouth",
          "Repeat 5-8 times"
        ]
      },
      {
        "name": "Successful Ride Visualization",
        "description":
            "Mental rehearsal of a confident, successful riding experience",
        "duration": 5,
        "category": "visualization",
        "instructions": [
          "Close your eyes and relax your body",
          "Visualize yourself mounting confidently",
          "See yourself riding with perfect balance and control",
          "Imagine your horse responding beautifully to your aids",
          "Feel the satisfaction of a successful session"
        ]
      }
    ];
  }
}