import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class ScreenshotAnnotationWidget extends StatefulWidget {
  final Function(String) onScreenshotTaken;

  const ScreenshotAnnotationWidget({
    Key? key,
    required this.onScreenshotTaken,
  }) : super(key: key);

  @override
  State<ScreenshotAnnotationWidget> createState() =>
      _ScreenshotAnnotationWidgetState();
}

class _ScreenshotAnnotationWidgetState
    extends State<ScreenshotAnnotationWidget> {
  bool _isCapturing = false;
  String? _currentScreenshot;

  Future<void> _takeScreenshot() async {
    setState(() => _isCapturing = true);

    try {
      // Simulate screenshot capture delay
      await Future.delayed(Duration(seconds: 1));

      // In a real implementation, this would capture the actual screen
      _currentScreenshot =
          'Screenshot_${DateTime.now().millisecondsSinceEpoch}.png';

      HapticFeedback.lightImpact();
      widget.onScreenshotTaken(_currentScreenshot!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Screenshot captured successfully'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to capture screenshot'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screenshot capture section
          Text(
            'Capture Screenshot',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isCapturing ? null : _takeScreenshot,
                  icon: _isCapturing
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        )
                      : Icon(Icons.camera_alt),
                  label:
                      Text(_isCapturing ? 'Capturing...' : 'Take Screenshot'),
                ),
              ),
              SizedBox(width: 3.w),
              ElevatedButton.icon(
                onPressed: () {
                  // Simulate gallery selection
                  widget.onScreenshotTaken(
                      'Gallery_Image_${DateTime.now().millisecondsSinceEpoch}.png');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Image selected from gallery'),
                      backgroundColor: AppTheme.successLight,
                    ),
                  );
                },
                icon: Icon(Icons.photo_library),
                label: Text('Gallery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Annotation tools
          if (_currentScreenshot != null) ...[
            Text(
              'Annotation Tools',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAnnotationTool(Icons.edit, 'Draw', Colors.blue),
                      _buildAnnotationTool(
                          Icons.text_fields, 'Text', Colors.green),
                      _buildAnnotationTool(
                          Icons.arrow_forward, 'Arrow', Colors.red),
                      _buildAnnotationTool(
                          Icons.highlight, 'Highlight', Colors.yellow),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Mock screenshot preview
                  Container(
                    width: double.infinity,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Screenshot Preview',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Tap to annotate',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 4.h),

          // Instructions
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Take a screenshot to capture the current issue, then use annotation tools to highlight specific areas or add explanatory text.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnotationTool(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
