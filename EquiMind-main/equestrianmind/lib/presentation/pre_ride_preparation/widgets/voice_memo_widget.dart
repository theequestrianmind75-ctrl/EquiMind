import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/ai_coaching_service.dart';

class VoiceMemoWidget extends StatefulWidget {
  final Function(String)? onMemoSaved;

  const VoiceMemoWidget({
    Key? key,
    this.onMemoSaved,
  }) : super(key: key);

  @override
  State<VoiceMemoWidget> createState() => _VoiceMemoWidgetState();
}

class _VoiceMemoWidgetState extends State<VoiceMemoWidget>
    with TickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  final AICoachingService _aiService = AICoachingService();

  bool isRecording = false;
  bool isPlaying = false;
  bool isProcessing = false;
  File? currentRecording;
  String? transcription;
  Duration? recordingDuration;
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> voiceMemos = [
    {
      "id": 1,
      "title": "Pre-ride goals",
      "content": "Focus on keeping hands soft during transitions",
      "timestamp": "2025-08-18T09:30:00.000Z",
      "duration": "0:32",
      "hasTranscription": true,
    },
    {
      "id": 2,
      "title": "Anxiety note",
      "content": "Feeling nervous about jumping today",
      "timestamp": "2025-08-18T09:15:00.000Z",
      "duration": "0:45",
      "hasTranscription": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _requestPermissions();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await _recorder.hasPermission();
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final audioPath =
            '${tempDir.path}/voice_memo_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _recorder.start(const RecordConfig(), path: audioPath);

        setState(() {
          isRecording = true;
          currentRecording = null;
          transcription = null;
        });

        _pulseController.repeat(reverse: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Microphone permission required')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start recording')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      _pulseController.stop();

      if (path != null) {
        setState(() {
          isRecording = false;
          currentRecording = File(path);
          isProcessing = true;
        });

        // Get recording duration
        await _player.setFilePath(path);
        final duration = _player.duration;

        setState(() {
          recordingDuration = duration;
        });

        // Transcribe the audio using OpenAI Whisper
        await _transcribeRecording(path);
      }
    } catch (e) {
      setState(() {
        isRecording = false;
        isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save recording')),
      );
    }
  }

  Future<void> _transcribeRecording(String audioPath) async {
    try {
      setState(() {
        isProcessing = true;
      });

      final transcribedText = await _aiService.transcribeVoiceMemo(audioPath);

      setState(() {
        transcription = transcribedText;
        isProcessing = false;
      });
    } catch (e) {
      setState(() {
        transcription = "Transcription unavailable";
        isProcessing = false;
      });
    }
  }

  Future<void> _playRecording() async {
    if (currentRecording == null) return;

    try {
      if (isPlaying) {
        await _player.stop();
        setState(() {
          isPlaying = false;
        });
      } else {
        await _player.setFilePath(currentRecording!.path);
        await _player.play();
        setState(() {
          isPlaying = true;
        });

        _player.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() {
              isPlaying = false;
            });
          }
        });
      }
    } catch (e) {
      setState(() {
        isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play recording')),
      );
    }
  }

  void _saveCurrentMemo() {
    if (currentRecording == null || transcription == null) return;

    final newMemo = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "title": _generateMemoTitle(transcription!),
      "content": transcription!,
      "timestamp": DateTime.now().toIso8601String(),
      "duration": _formatDuration(recordingDuration ?? Duration.zero),
      "hasTranscription": true,
      "audioPath": currentRecording!.path,
    };

    setState(() {
      voiceMemos.insert(0, newMemo);
      currentRecording = null;
      transcription = null;
      recordingDuration = null;
    });

    widget.onMemoSaved?.call(transcription!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Voice memo saved')),
    );
  }

  String _generateMemoTitle(String content) {
    if (content.length <= 30) return content;
    return '${content.substring(0, 30)}...';
  }

  void _discardCurrentMemo() {
    setState(() {
      currentRecording?.delete();
      currentRecording = null;
      transcription = null;
      recordingDuration = null;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'mic',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Voice Memos',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                '${voiceMemos.length} memos',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Current Recording Section
          if (isRecording || currentRecording != null) ...[
            Container(
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: isRecording
                    ? AppTheme.lightTheme.colorScheme.errorContainer
                    : AppTheme.lightTheme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: isRecording
                    ? Border.all(
                        color: AppTheme.lightTheme.colorScheme.error,
                        width: 2,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isRecording
                                  ? Colors.red.withValues(
                                      alpha:
                                          0.5 + (_pulseController.value * 0.5))
                                  : AppTheme.lightTheme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        isRecording
                            ? 'Recording...'
                            : currentRecording != null
                                ? 'Recording Complete'
                                : 'No Recording',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: isRecording
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (recordingDuration != null) ...[
                        Spacer(),
                        Text(
                          _formatDuration(recordingDuration!),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (isProcessing) ...[
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Transcribing with AI...',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (transcription != null && !isProcessing) ...[
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'transcription',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'AI Transcription',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            transcription!,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: currentRecording != null
                                ? _playRecording
                                : null,
                            icon: CustomIconWidget(
                              iconName: isPlaying ? 'pause' : 'play_arrow',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 18,
                            ),
                            label: Text(isPlaying ? 'Pause' : 'Play'),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: _discardCurrentMemo,
                            icon: CustomIconWidget(
                              iconName: 'delete',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 18,
                            ),
                            label: Text('Discard'),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _saveCurrentMemo,
                            icon: CustomIconWidget(
                              iconName: 'save',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 18,
                            ),
                            label: Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Recording Button
          Center(
            child: GestureDetector(
              onTap: _toggleRecording,
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: isRecording
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isRecording
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.primaryColor)
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: isRecording ? 'stop' : 'mic',
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Saved Memos List
          if (voiceMemos.isNotEmpty) ...[
            Text(
              'Saved Memos',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: voiceMemos.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final memo = voiceMemos[index];
                return Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              memo['title'] as String? ?? 'Untitled',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            memo['duration'] as String? ?? '0:00',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        memo['content'] as String? ?? 'No content',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
