import 'dart:convert';
import './openai_client.dart';
import './openai_service.dart';

/// Clinical Assessment Service providing evidence-based psychological evaluation tools
/// specifically designed for equestrian mental health with professional-grade scoring
class ClinicalAssessmentService {
  static final ClinicalAssessmentService _instance =
      ClinicalAssessmentService._internal();
  late final OpenAIClient _openAIClient;

  factory ClinicalAssessmentService() {
    return _instance;
  }

  ClinicalAssessmentService._internal() {
    final openAIService = OpenAIService();
    _openAIClient = OpenAIClient(openAIService.dio);
  }

  /// Generates professional clinical interpretation of assessment results
  Future<Map<String, dynamic>> generateClinicalInterpretation({
    required String assessmentType,
    required Map<String, dynamic> scores,
    required List<Map<String, dynamic>> responses,
    required String bookContext,
  }) async {
    try {
      final prompt =
          _buildClinicalPrompt(assessmentType, scores, responses, bookContext);

      final messages = [
        Message(
          role: 'system',
          content:
              '''You are a licensed clinical psychologist specializing in equestrian sports psychology. 
          Generate comprehensive clinical interpretations with evidence-based recommendations.
          Include severity level, clinical significance, therapeutic interventions, and specific book chapter references.
          Format response as JSON with: interpretation, severity, clinicalSignificance, interventions, bookReferences, riskFlags.''',
        ),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.3, 'max_tokens': 2000},
      );

      return _parseClinicalResponse(response.text);
    } catch (e) {
      return _getFallbackInterpretation(assessmentType, scores);
    }
  }

  /// Analyzes assessment trends over time with clinical insights
  Future<Map<String, dynamic>> analyzeTrendData({
    required String assessmentType,
    required List<Map<String, dynamic>> historicalScores,
    required String timeframe,
  }) async {
    try {
      final prompt = '''
      Assessment Type: $assessmentType
      Historical Scores (${historicalScores.length} assessments over $timeframe):
      ${historicalScores.map((score) => 'Date: ${score['date']}, Scores: ${score['scores']}').join('\n')}
      
      Analyze the clinical trends, identify patterns, and provide professional insights on:
      - Symptom progression or improvement
      - Clinical significance of changes
      - Risk factors or protective factors emerging
      - Recommended therapeutic adjustments
      ''';

      final messages = [
        Message(
          role: 'system',
          content:
              '''You are a clinical psychologist analyzing longitudinal assessment data.
          Provide evidence-based trend analysis in JSON format with: trendDirection, clinicalChanges, 
          riskAssessment, recommendations, therapeuticAdjustments.''',
        ),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.2, 'max_tokens': 1500},
      );

      return _parseTrendResponse(response.text);
    } catch (e) {
      return _getFallbackTrendAnalysis();
    }
  }

  /// Generates crisis intervention protocols based on concerning scores
  Future<Map<String, dynamic>> generateCrisisProtocol({
    required Map<String, dynamic> assessmentScores,
    required String assessmentType,
  }) async {
    try {
      final prompt = '''
      URGENT: High-risk assessment scores detected
      Assessment: $assessmentType
      Concerning Scores: ${assessmentScores.toString()}
      
      Generate immediate crisis intervention protocol including:
      - Risk level assessment (LOW/MODERATE/HIGH/CRISIS)
      - Immediate safety measures
      - Professional referral recommendations
      - Emergency contact protocols
      - Follow-up scheduling recommendations
      ''';

      final messages = [
        Message(
          role: 'system',
          content:
              '''You are a crisis intervention specialist providing immediate clinical protocols.
          Response must be in JSON format with: riskLevel, immediateMeasures, referrals, emergency, followUp.
          Prioritize client safety above all else.''',
        ),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.1, 'max_tokens': 1000},
      );

      return _parseCrisisResponse(response.text);
    } catch (e) {
      return _getFallbackCrisisProtocol();
    }
  }

  /// Generates personalized therapeutic recommendations based on book content
  Future<List<Map<String, dynamic>>> generateBookIntegrationRecommendations({
    required String assessmentType,
    required Map<String, dynamic> scores,
    required String specificConcerns,
  }) async {
    try {
      final prompt = '''
      Assessment Results: $assessmentType
      Scores: ${scores.toString()}
      Specific Concerns: $specificConcerns
      
      Based on evidence-based equestrian psychology principles, generate personalized recommendations
      integrating relevant book chapters, case studies, and therapeutic exercises specifically designed
      for equestrian mental health. Include practical applications for riding situations.
      ''';

      final messages = [
        Message(
          role: 'system',
          content:
              '''You are an expert in equestrian sports psychology and clinical intervention.
          Generate specific book-based recommendations in JSON array format.
          Each recommendation: title, bookChapter, caseStudy, exercises, ridingApplications, timeframe.''',
        ),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o',
        options: {'temperature': 0.4, 'max_tokens': 1800},
      );

      return _parseBookRecommendations(response.text);
    } catch (e) {
      return _getFallbackBookRecommendations(assessmentType);
    }
  }

  String _buildClinicalPrompt(
    String assessmentType,
    Map<String, dynamic> scores,
    List<Map<String, dynamic>> responses,
    String bookContext,
  ) {
    return '''
    Clinical Assessment: $assessmentType
    Assessment Scores: ${scores.toString()}
    Individual Responses: ${responses.length} items completed
    Book Integration Context: $bookContext
    
    Provide comprehensive clinical interpretation including:
    1. Clinical severity and diagnostic considerations
    2. Evidence-based interpretation of scores
    3. Specific therapeutic interventions recommended
    4. Relevant book chapters and exercises
    5. Risk assessment and safety considerations
    6. Treatment planning recommendations
    ''';
  }

  Map<String, dynamic> _parseClinicalResponse(String response) {
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
      return _getFallbackInterpretation("GAD-7", {"total": 8});
    }
  }

  Map<String, dynamic> _parseTrendResponse(String response) {
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
      return _getFallbackTrendAnalysis();
    }
  }

  Map<String, dynamic> _parseCrisisResponse(String response) {
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
      return _getFallbackCrisisProtocol();
    }
  }

  List<Map<String, dynamic>> _parseBookRecommendations(String response) {
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
      return _getFallbackBookRecommendations("GAD-7");
    }
  }

  Map<String, dynamic> _getFallbackInterpretation(
      String assessmentType, Map<String, dynamic> scores) {
    return {
      "interpretation":
          "Assessment completed successfully. Professional interpretation requires clinical review.",
      "severity": "REQUIRES_REVIEW",
      "clinicalSignificance":
          "Scores indicate need for professional clinical assessment and personalized intervention planning.",
      "interventions": [
        "Consult with licensed mental health professional",
        "Implement evidence-based therapeutic techniques",
        "Monitor symptoms regularly with validated assessments"
      ],
      "bookReferences": [
        "Chapter 3: Understanding Equestrian Anxiety",
        "Chapter 7: Evidence-Based Interventions for Riders"
      ],
      "riskFlags": []
    };
  }

  Map<String, dynamic> _getFallbackTrendAnalysis() {
    return {
      "trendDirection": "STABLE",
      "clinicalChanges":
          "Assessment data requires professional analysis for trend interpretation.",
      "riskAssessment": "REQUIRES_CLINICAL_REVIEW",
      "recommendations": [
        "Continue regular assessment monitoring",
        "Schedule clinical consultation for trend analysis",
        "Maintain consistent therapeutic interventions"
      ],
      "therapeuticAdjustments": ["Review current intervention effectiveness"]
    };
  }

  Map<String, dynamic> _getFallbackCrisisProtocol() {
    return {
      "riskLevel": "REQUIRES_IMMEDIATE_ASSESSMENT",
      "immediateMeasures": [
        "Contact mental health crisis line: 988",
        "Ensure personal safety and avoid isolation",
        "Reach out to trusted support person immediately"
      ],
      "referrals": [
        "Emergency mental health services",
        "Licensed clinical psychologist specializing in sports psychology"
      ],
      "emergency":
          "If experiencing thoughts of self-harm, call 911 or go to nearest emergency room",
      "followUp": "Schedule professional assessment within 24-48 hours"
    };
  }

  List<Map<String, dynamic>> _getFallbackBookRecommendations(
      String assessmentType) {
    return [
      {
        "title": "Foundational Emotional Regulation",
        "bookChapter": "Chapter 4: Building Emotional Awareness in Riding",
        "caseStudy": "Case Study 2: Sarah's Journey from Anxiety to Confidence",
        "exercises": [
          "Daily emotional check-in protocol",
          "Pre-ride centering technique",
          "Progressive muscle relaxation for riders"
        ],
        "ridingApplications": [
          "Use breathing techniques while mounting",
          "Practice emotional regulation during challenging exercises",
          "Implement mindfulness during transitions"
        ],
        "timeframe": "2-4 weeks for initial skill development"
      }
    ];
  }
}
