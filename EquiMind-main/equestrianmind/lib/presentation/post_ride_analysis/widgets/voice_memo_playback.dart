import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceMemoPlayback extends StatefulWidget {
  final List<Map<String, dynamic>> voiceMemos;

  const VoiceMemoPlayback({
    Key? key,
    required this.voiceMemos,
  }) : super(key: key);

  @override
  State<VoiceMemoPlayback> createState() => _VoiceMemoPlaybackState();
}

class _VoiceMemoPlaybackState extends State<VoiceMemoPlayback> {
  int? currentlyPlaying;
  bool isPlaying = false;
  double playbackPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.voiceMemos.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
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
                'Pre-Ride Voice Memos',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.voiceMemos.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final memo = widget.voiceMemos[index];
              final isCurrentlyPlaying = currentlyPlaying == index && isPlaying;

              return _buildVoiceMemoItem(memo, index, isCurrentlyPlaying);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceMemoItem(
      Map<String, dynamic> memo, int index, bool isCurrentlyPlaying) {
    final duration = memo['duration'] as String? ?? '0:00';
    final timestamp = memo['timestamp'] as String? ?? 'Unknown time';
    final title = memo['title'] as String? ?? 'Voice Memo ${index + 1}';

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isCurrentlyPlaying
            ? AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentlyPlaying
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      timestamp,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                duration,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              GestureDetector(
                onTap: () => _togglePlayback(index),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isCurrentlyPlaying
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: isCurrentlyPlaying ? 'pause' : 'play_arrow',
                    color: isCurrentlyPlaying
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 16),
                      ),
                      child: Slider(
                        value:
                            currentlyPlaying == index ? playbackPosition : 0.0,
                        onChanged: currentlyPlaying == index
                            ? (value) {
                                setState(() {
                                  playbackPosition = value;
                                });
                              }
                            : null,
                        activeColor: AppTheme.lightTheme.colorScheme.primary,
                        inactiveColor: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(
                              playbackPosition * _parseDuration(duration)),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          duration,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.w),
              PopupMenuButton<String>(
                icon: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                onSelected: (value) => _handleMenuAction(value, index),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'share',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text('Share'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'delete',
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (memo['transcription'] != null) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'text_fields',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Transcription',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    memo['transcription'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _togglePlayback(int index) {
    setState(() {
      if (currentlyPlaying == index && isPlaying) {
        isPlaying = false;
      } else {
        currentlyPlaying = index;
        isPlaying = true;
        playbackPosition = 0.0;
      }
    });

    // Simulate playback progress
    if (isPlaying) {
      _simulatePlayback();
    }
  }

  void _simulatePlayback() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (isPlaying && mounted) {
        setState(() {
          playbackPosition += 0.01;
          if (playbackPosition >= 1.0) {
            playbackPosition = 0.0;
            isPlaying = false;
            currentlyPlaying = null;
          }
        });
        if (isPlaying) {
          _simulatePlayback();
        }
      }
    });
  }

  void _handleMenuAction(String action, int index) {
    switch (action) {
      case 'share':
        // Handle sharing voice memo
        break;
      case 'delete':
        // Handle deleting voice memo
        break;
    }
  }

  double _parseDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return (minutes * 60 + seconds).toDouble();
    }
    return 0.0;
  }

  String _formatTime(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
