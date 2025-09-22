import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/screenshot_annotation_widget.dart';
import './widgets/context_display_widget.dart';
import './widgets/attachment_handler_widget.dart';

class FeedbackCollectionHub extends StatefulWidget {
  const FeedbackCollectionHub({Key? key}) : super(key: key);

  @override
  State<FeedbackCollectionHub> createState() => _FeedbackCollectionHubState();
}

class _FeedbackCollectionHubState extends State<FeedbackCollectionHub>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();

  // Form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  // Rating states
  double _usabilityRating = 5.0;
  double _performanceRating = 5.0;
  double _featureSatisfaction = 5.0;

  // Bug severity and category
  String _selectedSeverity = 'Medium';
  String _selectedCategory = 'UI/UX Issues';

  // Screen context
  String _currentScreen = 'Login Screen';
  String _sessionInfo = 'Session ID: EQM-20240118-001';

  // Submission state
  bool _isSubmitting = false;
  List<String> _attachments = [];

  final List<String> _severityLevels = ['Low', 'Medium', 'High', 'Critical'];
  final List<String> _categories = [
    'UI/UX Issues',
    'Performance Problems',
    'Feature Requests',
    'Critical Bugs'
  ];

  final Map<String, Color> _severityColors = {
    'Low': Colors.green,
    'Medium': Colors.orange,
    'High': Colors.red,
    'Critical': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getCurrentScreenContext();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _feedbackController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _getCurrentScreenContext() {
    // Get current screen context from route arguments if available
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _currentScreen = args['currentScreen'] ?? 'Unknown Screen';
      _sessionInfo = args['sessionInfo'] ??
          'Session ID: EQM-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Simulate submission delay
      await Future.delayed(Duration(seconds: 3));

      // Generate ticket number
      final ticketNumber = 'EQM-FB-${DateTime.now().millisecondsSinceEpoch}';

      // Trigger success haptic feedback
      HapticFeedback.lightImpact();

      // Show success dialog
      _showSuccessDialog(ticketNumber);
    } catch (e) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit feedback. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog(String ticketNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppTheme.successLight,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Feedback Submitted'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thank you for your feedback! Your submission has been received.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ticket Number: $ticketNumber',
                    style: AppTheme.dataTextStyle(
                        isLight: true, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Estimated Response: 24-48 hours',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _addAttachment(String fileName) {
    setState(() {
      _attachments.add(fileName);
    });
    HapticFeedback.selectionClick();
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Feedback Collection Hub'),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: 2.0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          indicatorColor: AppTheme.accentLight,
          tabs: [
            Tab(text: 'Feedback'),
            Tab(text: 'Screenshots'),
            Tab(text: 'Context'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Feedback Form Tab
          _buildFeedbackForm(),

          // Screenshot Annotation Tab
          _buildScreenshotTab(),

          // Context Display Tab
          _buildContextTab(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitFeedback,
            child: _isSubmitting
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  )
                : Text('Submit Feedback'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feedback Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Feedback Title',
                hintText: 'Brief description of your feedback',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a title for your feedback';
                }
                return null;
              },
            ),

            SizedBox(height: 3.h),

            // Rating Sliders
            Text(
              'Rate Your Experience',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),

            _buildRatingSlider(
              'Usability',
              _usabilityRating,
              (value) => setState(() => _usabilityRating = value),
            ),

            _buildRatingSlider(
              'Performance',
              _performanceRating,
              (value) => setState(() => _performanceRating = value),
            ),

            _buildRatingSlider(
              'Feature Satisfaction',
              _featureSatisfaction,
              (value) => setState(() => _featureSatisfaction = value),
            ),

            SizedBox(height: 3.h),

            // Bug Category and Severity
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategory = value!);
                    },
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSeverity,
                    decoration: InputDecoration(
                      labelText: 'Severity',
                      prefixIcon: Icon(Icons.priority_high),
                    ),
                    items: _severityLevels.map((severity) {
                      return DropdownMenuItem(
                        value: severity,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _severityColors[severity],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(severity),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedSeverity = value!);
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Detailed Feedback
            TextFormField(
              controller: _feedbackController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Detailed Feedback',
                hintText:
                    'Please describe your issue, suggestion, or feedback in detail...',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: Icon(Icons.message),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please provide detailed feedback';
                }
                if (value!.length < 10) {
                  return 'Please provide more detailed feedback (minimum 10 characters)';
                }
                return null;
              },
            ),

            SizedBox(height: 3.h),

            // Attachments Section
            AttachmentHandlerWidget(
              attachments: _attachments,
              onAddAttachment: _addAttachment,
              onRemoveAttachment: _removeAttachment,
            ),

            SizedBox(height: 10.h), // Space for bottom button
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSlider(
      String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.lightTheme.textTheme.bodyMedium),
            Text(
              value.toStringAsFixed(1),
              style: AppTheme.dataTextStyle(
                  isLight: true, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 1.0,
          max: 10.0,
          divisions: 90,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Poor', style: AppTheme.lightTheme.textTheme.bodySmall),
            Text('Excellent', style: AppTheme.lightTheme.textTheme.bodySmall),
          ],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildScreenshotTab() {
    return ScreenshotAnnotationWidget(
      onScreenshotTaken: (screenshot) {
        _addAttachment('Screenshot ${_attachments.length + 1}');
      },
    );
  }

  Widget _buildContextTab() {
    return ContextDisplayWidget(
      currentScreen: _currentScreen,
      sessionInfo: _sessionInfo,
    );
  }
}
