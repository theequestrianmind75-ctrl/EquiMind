import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class FeedbackFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController feedbackController;
  final TextEditingController titleController;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const FeedbackFormWidget({
    Key? key,
    required this.formKey,
    required this.feedbackController,
    required this.titleController,
    required this.onSubmit,
    required this.isSubmitting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick feedback buttons
            Text(
              'Quick Feedback',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEmojiButton('😊', 'Great', Colors.green),
                _buildEmojiButton('😐', 'Okay', Colors.orange),
                _buildEmojiButton('😞', 'Poor', Colors.red),
                _buildEmojiButton('🐛', 'Bug', Colors.purple),
              ],
            ),

            SizedBox(height: 4.h),

            // Detailed form fields
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Feedback Title',
                hintText: 'Brief description of your feedback',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),

            SizedBox(height: 3.h),

            TextFormField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Detailed Feedback',
                hintText: 'Please describe your experience...',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Icon(Icons.message),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please provide detailed feedback';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String emoji, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
