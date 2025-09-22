import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';
import 'package:record/record.dart';
import 'package:sensors_plus/sensors_plus.dart';

import './openai_client.dart';
import './openai_service.dart';

enum EmotionState { calm, anxious, excited, frustrated, confident, unknown }

class BiometricData {
  final double heartRate;
  final double stressLevel;
  final double arousalLevel;
  final double movementIntensity;
  final DateTime timestamp;

  BiometricData({
    required this.heartRate,
    required this.stressLevel,
    required this.arousalLevel,
    required this.movementIntensity,
    required this.timestamp,
  });
}

class EmotionReading {
  final EmotionState emotion;
  final double confidence;
  final double stressPercentage;
  final double confidenceIndex;
  final String explanation;
  final DateTime timestamp;

  EmotionReading({
    required this.emotion,
    required this.confidence,
    required this.stressPercentage,
    required this.confidenceIndex,
    required this.explanation,
    required this.timestamp,
  });
}

class EmotionDetectionService {
  static final EmotionDetectionService _instance =
      EmotionDetectionService._internal();

  factory EmotionDetectionService() => _instance;

  EmotionDetectionService._internal();

  final OpenAIClient _openAIClient = OpenAIClient(OpenAIService().dio);
  final AudioRecorder _audioRecorder = AudioRecorder();

  // Stream controllers for real-time data
  final _emotionStreamController = StreamController<EmotionReading>.broadcast();
  final _biometricStreamController =
      StreamController<BiometricData>.broadcast();

  // Internal data tracking
  final List<EmotionReading> _emotionHistory = [];
  final List<BiometricData> _biometricHistory = [];

  Timer? _detectionTimer;
  bool _isActive = false;
  bool _hasPermissions = false;

  // Baseline values for personalization
  double _baselineHeartRate = 75.0;
  double _baselineStress = 0.3;
  int _sessionCount = 0;

  // Getters for streams
  Stream<EmotionReading> get emotionStream => _emotionStreamController.stream;
  Stream<BiometricData> get biometricStream =>
      _biometricStreamController.stream;
  List<EmotionReading> get emotionHistory => List.unmodifiable(_emotionHistory);
  bool get isActive => _isActive;

  /// Initialize the emotion detection service
  Future<bool> initialize() async {
    try {
      _hasPermissions = await _requestPermissions();
      if (_hasPermissions) {
        await _loadPersonalBaseline();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Emotion Detection Service initialization failed: $e');
      return false;
    }
  }

  /// Start real-time emotion detection
  Future<void> startDetection() async {
    if (!_hasPermissions || _isActive) return;

    _isActive = true;
    _emotionHistory.clear();
    _biometricHistory.clear();

    // Start biometric monitoring
    _startBiometricMonitoring();

    // Start periodic emotion analysis (every 10 seconds)
    _detectionTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _performEmotionAnalysis();
    });
  }

  /// Stop emotion detection
  void stopDetection() {
    _isActive = false;
    _detectionTimer?.cancel();
    _detectionTimer = null;
    _saveSessionData();
  }

  /// Request necessary permissions
  Future<bool> _requestPermissions() async {
    try {
      if (!kIsWeb) {
        // Request Health permissions
        final healthTypes = [
          HealthDataType.HEART_RATE,
          HealthDataType.HEART_RATE_VARIABILITY_SDNN,
        ];

        final requested = await Health().requestAuthorization(healthTypes);

        // Request audio recording permission
        final audioPermission = await _audioRecorder.hasPermission();

        return requested && audioPermission;
      }
      return true; // Web permissions handled by browser
    } catch (e) {
      debugPrint('Permission request failed: $e');
      return false;
    }
  }

  /// Start continuous biometric monitoring
  void _startBiometricMonitoring() {
    // Monitor accelerometer for movement patterns
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (!_isActive) return;

      final intensity =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      _processBiometricData(movementIntensity: intensity);
    });

    // Monitor health data periodically
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isActive) {
        timer.cancel();
        return;
      }
      _fetchHealthData();
    });
  }

  /// Fetch health data from device
  Future<void> _fetchHealthData() async {
    if (kIsWeb) {
      // Simulate biometric data for web
      _processBiometricData(
        heartRate: _baselineHeartRate + Random().nextDouble() * 20 - 10,
        stressIndicator: Random().nextDouble(),
      );
      return;
    }

    try {
      final now = DateTime.now();
      final earlier = now.subtract(const Duration(minutes: 1));

      // Fetch heart rate
      final heartRateData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: earlier,
        endTime: now,
      );

      double? heartRate;
      if (heartRateData.isNotEmpty) {
        heartRate = (heartRateData.last.value as num).toDouble();
      }

      // Fetch HRV for stress indication
      final hrvData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE_VARIABILITY_SDNN],
        startTime: earlier,
        endTime: now,
      );

      double? stressIndicator;
      if (hrvData.isNotEmpty) {
        final hrv = (hrvData.last.value as num).toDouble();
        stressIndicator = 1.0 - (hrv / 50.0).clamp(0.0, 1.0);
      }

      _processBiometricData(
        heartRate: heartRate,
        stressIndicator: stressIndicator,
      );
    } catch (e) {
      debugPrint('Health data fetch failed: $e');
    }
  }

  /// Process incoming biometric data
  void _processBiometricData({
    double? heartRate,
    double? stressIndicator,
    double? movementIntensity,
  }) {
    final data = BiometricData(
      heartRate: heartRate ??
          _biometricHistory.lastOrNull?.heartRate ??
          _baselineHeartRate,
      stressLevel: stressIndicator ??
          _biometricHistory.lastOrNull?.stressLevel ??
          _baselineStress,
      arousalLevel: _calculateArousalLevel(heartRate, movementIntensity),
      movementIntensity: movementIntensity ??
          _biometricHistory.lastOrNull?.movementIntensity ??
          0.0,
      timestamp: DateTime.now(),
    );

    _biometricHistory.add(data);
    if (_biometricHistory.length > 360) {
      // Keep 30 minutes of data
      _biometricHistory.removeAt(0);
    }

    _biometricStreamController.add(data);
  }

  /// Calculate arousal level from biometric inputs
  double _calculateArousalLevel(double? heartRate, double? movement) {
    final hr = heartRate ?? _baselineHeartRate;
    final hrArousal = (hr - _baselineHeartRate) / _baselineHeartRate;
    final movementArousal = (movement ?? 0.0) / 10.0;

    return (hrArousal * 0.7 + movementArousal * 0.3).clamp(0.0, 1.0);
  }

  /// Perform AI-powered emotion analysis
  Future<void> _performEmotionAnalysis() async {
    if (_biometricHistory.length < 3) return;

    try {
      final recentData = _biometricHistory.length >= 6 
          ? _biometricHistory.sublist(_biometricHistory.length - 6)
          : _biometricHistory;
      final biometricSummary = _createBiometricSummary(recentData);

      // Create prompt for OpenAI emotion analysis
      final prompt = '''
Analyze the following biometric data from an equestrian rider and determine their current emotional state:

Biometric Summary:
- Average Heart Rate: ${biometricSummary['avgHeartRate']}
- Heart Rate Variability: ${biometricSummary['hrVariability']}
- Stress Level (0-1): ${biometricSummary['avgStress']}
- Movement Intensity: ${biometricSummary['avgMovement']}
- Arousal Level (0-1): ${biometricSummary['avgArousal']}

Recent Trend: ${biometricSummary['trend']}

Baseline Comparison:
- Baseline Heart Rate: $_baselineHeartRate
- Sessions Completed: $_sessionCount

Please respond with a JSON object containing:
{
  "emotion": "calm|anxious|excited|frustrated|confident",
  "confidence": 0.85,
  "stressPercentage": 35,
  "confidenceIndex": 0.72,
  "explanation": "Brief explanation of the emotional state based on biometric patterns"
}
''';

      final messages = [
        Message(
            role: 'system',
            content:
                '''You are an expert in equestrian sports psychology and biometric analysis. 
          Analyze rider biometric data to determine emotional states during riding sessions. 
          Focus on patterns that indicate calm, anxious, excited, frustrated, or confident states.
          Consider the context of horseback riding where elevated heart rate might be normal.
          Respond only with valid JSON format.'''),
        Message(role: 'user', content: prompt),
      ];

      final response = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o-mini',
        options: {'temperature': 0.3, 'max_tokens': 300},
      );

      final emotion = _parseEmotionResponse(response.text);
      _emotionHistory.add(emotion);

      if (_emotionHistory.length > 180) {
        // Keep 30 minutes of emotion data
        _emotionHistory.removeAt(0);
      }

      _emotionStreamController.add(emotion);

      // Send haptic feedback for significant changes
      _checkForEmotionalShifts(emotion);
    } catch (e) {
      debugPrint('Emotion analysis failed: $e');
      // Fallback to basic emotion detection
      _performBasicEmotionAnalysis();
    }
  }

  /// Create biometric summary for AI analysis
  Map<String, dynamic> _createBiometricSummary(List<BiometricData> data) {
    final heartRates = data.map((d) => d.heartRate).toList();
    final stressLevels = data.map((d) => d.stressLevel).toList();
    final movements = data.map((d) => d.movementIntensity).toList();
    final arousals = data.map((d) => d.arousalLevel).toList();

    return {
      'avgHeartRate': heartRates.reduce((a, b) => a + b) / heartRates.length,
      'hrVariability': _calculateVariability(heartRates),
      'avgStress': stressLevels.reduce((a, b) => a + b) / stressLevels.length,
      'avgMovement': movements.reduce((a, b) => a + b) / movements.length,
      'avgArousal': arousals.reduce((a, b) => a + b) / arousals.length,
      'trend': _analyzeTrend(stressLevels),
    };
  }

  /// Calculate heart rate variability
  double _calculateVariability(List<double> values) {
    if (values.length < 2) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance =
        values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) /
            values.length;
    return sqrt(variance);
  }

  /// Analyze trend in data
  String _analyzeTrend(List<double> values) {
    if (values.length < 3) return 'stable';

    final first =
        values.sublist(0, values.length ~/ 2).reduce((a, b) => a + b) /
            (values.length ~/ 2);
    final second = values.sublist(values.length ~/ 2).reduce((a, b) => a + b) /
        (values.length - values.length ~/ 2);

    if (second > first + 0.1) return 'increasing';
    if (second < first - 0.1) return 'decreasing';
    return 'stable';
  }

  /// Parse emotion response from OpenAI
  EmotionReading _parseEmotionResponse(String response) {
    try {
      final jsonString =
          response.replaceAll('```json', '').replaceAll('```', '').trim();
      final Map<String, dynamic> data = Map<String, dynamic>.from(
          (jsonString.startsWith('{') ? jsonString : '{}') as dynamic);

      return EmotionReading(
        emotion: _parseEmotionState(data['emotion'] ?? 'unknown'),
        confidence: (data['confidence'] ?? 0.5).toDouble(),
        stressPercentage: (data['stressPercentage'] ?? 50.0).toDouble(),
        confidenceIndex: (data['confidenceIndex'] ?? 0.5).toDouble(),
        explanation: data['explanation'] ??
            'Emotion detected based on biometric patterns',
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Failed to parse emotion response: $e');
      return _createFallbackEmotion();
    }
  }

  /// Parse emotion state from string
  EmotionState _parseEmotionState(String emotionString) {
    switch (emotionString.toLowerCase()) {
      case 'calm':
        return EmotionState.calm;
      case 'anxious':
        return EmotionState.anxious;
      case 'excited':
        return EmotionState.excited;
      case 'frustrated':
        return EmotionState.frustrated;
      case 'confident':
        return EmotionState.confident;
      default:
        return EmotionState.unknown;
    }
  }

  /// Perform basic emotion analysis without AI
  void _performBasicEmotionAnalysis() {
    if (_biometricHistory.isEmpty) return;

    final recent = _biometricHistory.last;
    final stressLevel = recent.stressLevel;
    final heartRate = recent.heartRate;
    final arousal = recent.arousalLevel;

    EmotionState emotion;
    double confidence = 0.6;

    if (stressLevel > 0.7 && heartRate > _baselineHeartRate + 15) {
      emotion = EmotionState.anxious;
      confidence = 0.7;
    } else if (arousal > 0.6 && stressLevel < 0.4) {
      emotion = EmotionState.excited;
      confidence = 0.65;
    } else if (stressLevel > 0.6 && arousal < 0.3) {
      emotion = EmotionState.frustrated;
      confidence = 0.6;
    } else if (stressLevel < 0.3 && heartRate < _baselineHeartRate + 10) {
      emotion = EmotionState.calm;
      confidence = 0.75;
    } else {
      emotion = EmotionState.confident;
      confidence = 0.5;
    }

    final reading = EmotionReading(
      emotion: emotion,
      confidence: confidence,
      stressPercentage: (stressLevel * 100).round().toDouble(),
      confidenceIndex: 1.0 - stressLevel,
      explanation: 'Basic biometric analysis indicates ${emotion.name} state',
      timestamp: DateTime.now(),
    );

    _emotionHistory.add(reading);
    _emotionStreamController.add(reading);
  }

  /// Create fallback emotion when analysis fails
  EmotionReading _createFallbackEmotion() {
    return EmotionReading(
      emotion: EmotionState.calm,
      confidence: 0.3,
      stressPercentage: 50.0,
      confidenceIndex: 0.5,
      explanation: 'Unable to determine emotion - displaying neutral state',
      timestamp: DateTime.now(),
    );
  }

  /// Check for significant emotional shifts and provide haptic feedback
  void _checkForEmotionalShifts(EmotionReading current) {
    if (_emotionHistory.length < 2) return;

    final previous = _emotionHistory[_emotionHistory.length - 2];

    // Check for significant stress increase
    if (current.stressPercentage > previous.stressPercentage + 20) {
      _triggerHapticFeedback();
    }

    // Check for emotion state change
    if (current.emotion != previous.emotion && current.confidence > 0.7) {
      _triggerHapticFeedback();
    }
  }

  /// Trigger haptic feedback
  void _triggerHapticFeedback() {
    if (!kIsWeb) {
      HapticFeedback.lightImpact();
    }
  }

  /// Load personal baseline from storage
  Future<void> _loadPersonalBaseline() async {
    // In a real implementation, this would load from shared preferences
    // For now, use defaults that adapt over time
    _sessionCount = 0;
  }

  /// Save session data for future baseline adjustment
  void _saveSessionData() {
    if (_biometricHistory.isNotEmpty) {
      final avgHeartRate =
          _biometricHistory.map((d) => d.heartRate).reduce((a, b) => a + b) /
              _biometricHistory.length;

      // Gradually adjust baseline (simple learning)
      _baselineHeartRate = (_baselineHeartRate * 0.9) + (avgHeartRate * 0.1);
      _sessionCount++;
    }
  }

  /// Get current emotion state
  EmotionReading? get currentEmotion => _emotionHistory.lastOrNull;

  /// Get emotions from last N minutes
  List<EmotionReading> getEmotionHistory(int minutes) {
    final cutoff = DateTime.now().subtract(Duration(minutes: minutes));
    return _emotionHistory.where((e) => e.timestamp.isAfter(cutoff)).toList();
  }

  /// Dispose of the service
  void dispose() {
    stopDetection();
    _emotionStreamController.close();
    _biometricStreamController.close();
  }
}

extension<T> on List<T> {
  T? get lastOrNull => isEmpty ? null : last;
}