import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class AttachmentHandlerWidget extends StatelessWidget {
  final List<String> attachments;
  final Function(String) onAddAttachment;
  final Function(int) onRemoveAttachment;

  const AttachmentHandlerWidget({
    Key? key,
    required this.attachments,
    required this.onAddAttachment,
    required this.onRemoveAttachment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attachments',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            Text(
              '${attachments.length}/5',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Attachment Options
        Row(
          children: [
            Expanded(
              child: _buildAttachmentOption(
                context,
                icon: Icons.image,
                label: 'Image',
                onTap: () => _handleImageAttachment(),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildAttachmentOption(
                context,
                icon: Icons.videocam,
                label: 'Video',
                onTap: () => _handleVideoAttachment(),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildAttachmentOption(
                context,
                icon: Icons.mic,
                label: 'Audio',
                onTap: () => _handleAudioAttachment(),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildAttachmentOption(
                context,
                icon: Icons.insert_drive_file,
                label: 'File',
                onTap: () => _handleFileAttachment(),
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Existing Attachments List
        if (attachments.isNotEmpty) ...[
          Text(
            'Attached Files',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          ...attachments.asMap().entries.map((entry) {
            final index = entry.key;
            final attachment = entry.value;
            return _buildAttachmentItem(context, attachment, index);
          }).toList(),
        ],

        // Instructions
        if (attachments.isEmpty) ...[
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.attach_file,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Add screenshots, crash logs, screen recordings, or other files to help us understand the issue better.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.lightTheme.dividerColor,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentItem(
      BuildContext context, String attachment, int index) {
    final fileType = _getFileType(attachment);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getFileTypeColor(fileType).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getFileTypeIcon(fileType),
              color: _getFileTypeColor(fileType),
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _getFileSize(attachment),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => onRemoveAttachment(index),
            icon: Icon(
              Icons.close,
              color: AppTheme.lightTheme.colorScheme.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _handleImageAttachment() {
    HapticFeedback.selectionClick();
    onAddAttachment('Image_${DateTime.now().millisecondsSinceEpoch}.png');
  }

  void _handleVideoAttachment() {
    HapticFeedback.selectionClick();
    onAddAttachment('Video_${DateTime.now().millisecondsSinceEpoch}.mp4');
  }

  void _handleAudioAttachment() {
    HapticFeedback.selectionClick();
    onAddAttachment('Audio_${DateTime.now().millisecondsSinceEpoch}.m4a');
  }

  void _handleFileAttachment() {
    HapticFeedback.selectionClick();
    onAddAttachment('Document_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'png':
      case 'jpg':
      case 'jpeg':
        return 'image';
      case 'mp4':
      case 'mov':
        return 'video';
      case 'm4a':
      case 'wav':
      case 'mp3':
        return 'audio';
      default:
        return 'file';
    }
  }

  IconData _getFileTypeIcon(String fileType) {
    switch (fileType) {
      case 'image':
        return Icons.image;
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.audiotrack;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileTypeColor(String fileType) {
    switch (fileType) {
      case 'image':
        return Colors.green;
      case 'video':
        return Colors.blue;
      case 'audio':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getFileSize(String fileName) {
    // Mock file sizes for demonstration
    final random = fileName.hashCode % 1000 + 100;
    if (random < 500) {
      return '${random}KB';
    } else {
      return '${(random / 100).toStringAsFixed(1)}MB';
    }
  }
}
