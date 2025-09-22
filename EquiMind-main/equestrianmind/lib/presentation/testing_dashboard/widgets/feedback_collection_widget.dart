import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeedbackCollectionWidget extends StatefulWidget {
  const FeedbackCollectionWidget({Key? key}) : super(key: key);

  @override
  State<FeedbackCollectionWidget> createState() =>
      _FeedbackCollectionWidgetState();
}

class _FeedbackCollectionWidgetState extends State<FeedbackCollectionWidget> {
  bool _isRecording = false;
  bool _hasScreenshot = false;
  final TextEditingController _bugReportController = TextEditingController();

  @override
  void dispose() {
    _bugReportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
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
                iconName: 'feedback',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Feedback Collection',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildFeedbackButton(
                  'Screenshot',
                  _hasScreenshot
                      ? 'Captured'
                      : 'Capture screen with annotations',
                  'photo_camera',
                  _hasScreenshot
                      ? AppTheme.successLight
                      : AppTheme.lightTheme.primaryColor,
                  () => _captureScreenshot(),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildFeedbackButton(
                  'Screen Recording',
                  _isRecording ? 'Recording...' : 'Record screen interactions',
                  _isRecording ? 'stop' : 'videocam',
                  _isRecording
                      ? AppTheme.errorLight
                      : AppTheme.lightTheme.primaryColor,
                  () => _toggleRecording(),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Bug Report',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _bugReportController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  'Describe the issue, steps to reproduce, expected vs actual behavior...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'auto_fix_high',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Device info will be automatically attached',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _saveDraft(),
                  icon: CustomIconWidget(
                    iconName: 'save',
                    size: 16,
                  ),
                  label: Text('Save Draft'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _bugReportController.text.isEmpty
                      ? null
                      : () => _submitBugReport(),
                  icon: CustomIconWidget(
                    iconName: 'send',
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text('Submit Report'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackButton(
    String title,
    String description,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _captureScreenshot() {
    setState(() {
      _hasScreenshot = !_hasScreenshot;
    });

    if (_hasScreenshot) {
      // Simulate screenshot capture with annotation tools
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Screenshot Captured'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'image',
                        size: 48,
                        color: Colors.grey[500]!,
                      ),
                      SizedBox(height: 1.h),
                      Text('Screenshot Preview'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: CustomIconWidget(iconName: 'edit', size: 16),
                    label: Text('Annotate'),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: CustomIconWidget(iconName: 'crop', size: 16),
                    label: Text('Crop'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _hasScreenshot = false);
                      Navigator.pop(context);
                    },
                    icon: CustomIconWidget(iconName: 'delete', size: 16),
                    label: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Done'),
            ),
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot captured with annotation tools')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot removed')),
      );
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isRecording
            ? 'Screen recording started'
            : 'Screen recording stopped'),
      ),
    );
  }

  void _saveDraft() {
    if (_bugReportController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a bug report description')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bug report draft saved locally')),
    );
  }

  void _submitBugReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submit Bug Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your report includes:'),
            SizedBox(height: 1.h),
            _buildReportItem('Bug description', true),
            _buildReportItem('Screenshot', _hasScreenshot),
            _buildReportItem('Screen recording', _isRecording),
            _buildReportItem('Device information', true),
            _buildReportItem('App version & logs', true),
            SizedBox(height: 2.h),
            Text(
              'This will be sent to the development team for review.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processSubmission();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String item, bool included) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: included ? 'check_circle' : 'radio_button_unchecked',
            color: included ? AppTheme.successLight : Colors.grey,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(item),
        ],
      ),
    );
  }

  void _processSubmission() {
    // Clear form
    _bugReportController.clear();
    setState(() {
      _hasScreenshot = false;
      _isRecording = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bug report submitted successfully'),
        action: SnackBarAction(
          label: 'Track',
          onPressed: () {},
        ),
      ),
    );
  }
}
