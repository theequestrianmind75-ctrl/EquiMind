import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sizer/sizer.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

import '../../../services/emotion_detection_service.dart';
import '../../../services/ai_coaching_service.dart';
import '../../../services/openai_client.dart';
import '../../../services/openai_service.dart';

class VoiceFeedbackWidget extends StatefulWidget {
  final EmotionReading? emotion;

  const VoiceFeedbackWidget({
    super.key,
    this.emotion,
  });

  @override
  State<VoiceFeedbackWidget> createState() => _VoiceFeedbackWidgetState();
}

class _VoiceFeedbackWidgetState extends State<VoiceFeedbackWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OpenAIClient _openAIClient = OpenAIClient(OpenAIService().dio);
  final AICoachingService _aiCoachingService = AICoachingService();

  bool _isEnabled = true;
  bool _isGenerating = false;
  bool _isPlaying = false;

  EmotionState? _lastAnnouncedEmotion;
  DateTime? _lastAnnouncementTime;

  String _selectedVoice = 'alloy';
  double _volume = 0.7;
  bool _onlyMajorChanges = true;

  final List<Map<String, String>> _availableVoices = [
    {'id': 'alloy', 'name': 'Alloy (Neutral)'},
    {'id': 'echo', 'name': 'Echo (Male)'},
    {'id': 'fable', 'name': 'Fable (British)'},
    {'id': 'onyx', 'name': 'Onyx (Deep)'},
    {'id': 'nova', 'name': 'Nova (Female)'},
    {'id': 'shimmer', 'name': 'Shimmer (Soft)'},
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.setVolume(_volume);
  }

  @override
  void didUpdateWidget(VoiceFeedbackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.emotion != null &&
        oldWidget.emotion?.emotion != widget.emotion?.emotion) {
      _checkForVoiceFeedback(widget.emotion!);
    }
  }

  void _checkForVoiceFeedback(EmotionReading emotion) {
    if (!_isEnabled || _isGenerating) return;

    final shouldAnnounce = _shouldAnnounceEmotion(emotion);
    if (shouldAnnounce) {
      _generateVoiceFeedback(emotion);
    }
  }

  bool _shouldAnnounceEmotion(EmotionReading emotion) {
    // Don't announce too frequently
    if (_lastAnnouncementTime != null) {
      final timeSinceLastAnnouncement =
          DateTime.now().difference(_lastAnnouncementTime!);
      if (timeSinceLastAnnouncement.inSeconds < 30) return false;
    }

    // Only major changes if setting enabled
    if (_onlyMajorChanges) {
      if (_lastAnnouncedEmotion == null) return true;

      // Announce if emotion changed and confidence is high
      if (_lastAnnouncedEmotion != emotion.emotion &&
          emotion.confidence > 0.7) {
        return true;
      }

      // Announce significant stress increases
      if (emotion.stressPercentage > 75) return true;

      return false;
    }

    // Announce all significant changes
    return emotion.confidence > 0.6;
  }

  Future<void> _generateVoiceFeedback(EmotionReading emotion) async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      // Generate coaching message based on emotion
      final message = await _generateCoachingMessage(emotion);

      // Convert to speech using OpenAI TTS
      final audioFile = await _openAIClient.createSpeech(
        input: message,
        voice: _selectedVoice,
        model: 'tts-1',
        responseFormat: 'mp3',
        speed: 0.9,
      );

      // Play the audio
      await _playAudio(audioFile);

      _lastAnnouncedEmotion = emotion.emotion;
      _lastAnnouncementTime = DateTime.now();
    } catch (e) {
      debugPrint('Voice feedback generation failed: $e');
      // Fallback to preset messages without TTS
      _showTextFeedback(emotion);
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<String> _generateCoachingMessage(EmotionReading emotion) async {
    // Use AI coaching service for personalized messages
    final biometrics = {
      'stress_level': emotion.stressPercentage / 100,
      'confidence_index': emotion.confidenceIndex,
      'emotion_confidence': emotion.confidence,
    };

    final message = await _aiCoachingService.generateRealTimeCoaching(
      currentActivity: 'riding',
      emotionalState: emotion.emotion.name,
      biometrics: biometrics,
    );

    // Ensure message is appropriate for audio (brief and clear)
    if (message.length > 150) {
      return message.substring(0, 147) + '...';
    }

    return message;
  }

  Future<void> _playAudio(File audioFile) async {
    try {
      setState(() {
        _isPlaying = true;
      });

      if (kIsWeb) {
        // For web, we might need different handling
        await _audioPlayer.setFilePath(audioFile.path);
      } else {
        await _audioPlayer.setFilePath(audioFile.path);
      }

      await _audioPlayer.play();

      // Wait for audio to complete
      await _audioPlayer.playerStateStream.firstWhere(
          (state) => state.processingState == ProcessingState.completed);
    } catch (e) {
      debugPrint('Audio playback failed: $e');
    } finally {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _showTextFeedback(EmotionReading emotion) {
    final message = _getFallbackMessage(emotion);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: _getEmotionColor(emotion.emotion),
      ),
    );
  }

  String _getFallbackMessage(EmotionReading emotion) {
    switch (emotion.emotion) {
      case EmotionState.anxious:
        return 'Take a deep breath and focus on your seat. You\'re safe.';
      case EmotionState.frustrated:
        return 'Pause for a moment. Reset your mindset and try again.';
      case EmotionState.excited:
        return 'Great energy! Channel this excitement into focus.';
      case EmotionState.confident:
        return 'Excellent! You\'re in a great state for learning.';
      case EmotionState.calm:
        return 'Perfect balance. Ideal state for focused practice.';
      default:
        return 'Stay present and trust your training.';
    }
  }

  Color _getEmotionColor(EmotionState emotion) {
    switch (emotion) {
      case EmotionState.calm:
        return Colors.green;
      case EmotionState.anxious:
        return Colors.red;
      case EmotionState.excited:
        return Colors.orange;
      case EmotionState.frustrated:
        return Colors.purple;
      case EmotionState.confident:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Future<void> _testVoiceFeedback() async {
    if (widget.emotion == null) return;

    await _generateVoiceFeedback(widget.emotion!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Voice Feedback',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _isEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEnabled = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ],
          ),
          if (_isEnabled) ...[
            SizedBox(height: 2.h),

            // Voice settings
            _buildVoiceSettings(),

            SizedBox(height: 2.h),

            // Feedback options
            _buildFeedbackOptions(),

            SizedBox(height: 2.h),

            // Status and test button
            _buildStatusSection(),
          ] else ...[
            SizedBox(height: 1.h),
            Text(
              'Voice feedback is disabled',
              style: TextStyle(
                color: Colors.white.withAlpha(179),
                fontSize: 10.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVoiceSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Voice Settings',
          style: TextStyle(
            color: Colors.white.withAlpha(230),
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),

        // Voice selection
        DropdownButtonFormField<String>(
          value: _selectedVoice,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withAlpha(26),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          ),
          dropdownColor: Colors.grey[800],
          style: TextStyle(color: Colors.white, fontSize: 9.sp),
          items: _availableVoices.map((voice) {
            return DropdownMenuItem<String>(
              value: voice['id'],
              child: Text(voice['name']!),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedVoice = value;
              });
            }
          },
        ),

        SizedBox(height: 1.h),

        // Volume control
        Row(
          children: [
            Icon(Icons.volume_down, color: Colors.white, size: 16.sp),
            Expanded(
              child: Slider(
                value: _volume,
                onChanged: (value) {
                  setState(() {
                    _volume = value;
                  });
                  _audioPlayer.setVolume(value);
                },
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
              ),
            ),
            Icon(Icons.volume_up, color: Colors.white, size: 16.sp),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedbackOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feedback Options',
          style: TextStyle(
            color: Colors.white.withAlpha(230),
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        CheckboxListTile(
          title: Text(
            'Only major emotional changes',
            style: TextStyle(color: Colors.white, fontSize: 9.sp),
          ),
          subtitle: Text(
            'Reduces frequency of announcements',
            style:
                TextStyle(color: Colors.white.withAlpha(153), fontSize: 8.sp),
          ),
          value: _onlyMajorChanges,
          onChanged: (value) {
            setState(() {
              _onlyMajorChanges = value ?? true;
            });
          },
          activeColor: Colors.blue,
          checkColor: Colors.white,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isGenerating
                  ? 'Generating...'
                  : _isPlaying
                      ? 'Playing...'
                      : 'Ready',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_lastAnnouncementTime != null)
              Text(
                'Last: ${_formatLastAnnouncement()}',
                style: TextStyle(
                  color: Colors.white.withAlpha(153),
                  fontSize: 8.sp,
                ),
              ),
          ],
        ),
        ElevatedButton(
          onPressed: widget.emotion != null && !_isGenerating
              ? _testVoiceFeedback
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          ),
          child: Text(
            'Test',
            style: TextStyle(fontSize: 9.sp),
          ),
        ),
      ],
    );
  }

  String _formatLastAnnouncement() {
    if (_lastAnnouncementTime == null) return '';

    final diff = DateTime.now().difference(_lastAnnouncementTime!);
    if (diff.inMinutes < 1) {
      return '${diff.inSeconds}s ago';
    } else {
      return '${diff.inMinutes}m ago';
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
